class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin.git", :tag => "v0.2.2"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "cli"
  license "Apache-2.0"
  depends_on :xcode
  depends_on "java" => :build

  def install
    ohai "Deciding which architecture to build"
    arch = `uname -m`.strip

    case arch
    when 'arm64'
      buildTask = 'linkReleaseExecutableMacosArm64'
      buildDir = 'macosArm64'
    when 'x86_64'
      buildTask = 'linkReleaseExecutableMacosX64'
      buildDir = 'macosX64'
    else
      odie "Unsupported macOS architecture #{arch}."
    end
    ohai "Building executable for #{arch}"
    buildStatus = runShell "./gradlew --no-daemon #{buildTask}"
    odie "Build FAILED" unless buildStatus.success?
    bin.install "build/bin/#{buildDir}/releaseExecutable/xcode-kotlin.kexe" => 'xcode-kotlin'
    share.install Dir["data/*"]
  end

  test do
    runShell "xcode-kotlin info"
  end

  def runShell(command)
    Open3.popen3(command) do |stdin, stdout, stderr, thread|
      Thread.new do
        until (line = stdout.gets).nil? do
          $stdout.puts(line)
        end
      end
      Thread.new do
        until (line = stderr.gets).nil? do
          $stderr.puts(line)
        end
      end
      Thread.new do
        stdin.puts $stdin.gets while thread.alive?
      end
      thread.join

      thread.value
    end
  end
end
