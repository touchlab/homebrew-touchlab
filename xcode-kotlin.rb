class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin.git", tag: "v0.2.2"
  license "Apache-2.0"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "cli"
  depends_on "java" => :build
  depends_on :xcode => :build

  def install
    ohai "Deciding which architecture to build"
    arch = `uname -m`.strip

    case arch
    when "arm64"
      build_task = "linkReleaseExecutableMacosArm64"
      build_dir = "macosArm64"
    when "x86_64"
      build_task = "linkReleaseExecutableMacosX64"
      build_dir = "macosX64"
    else
      odie "Unsupported macOS architecture #{arch}."
    end
    ohai "Building executable for #{arch}"
    build_status = run_shell "./gradlew --no-daemon #{build_task} preparePlugin"
    odie "Build FAILED" unless build_status.success?
    bin.install "build/bin/#{build_dir}/releaseExecutable/xcode-kotlin.kexe" => "xcode-kotlin"
    share.install Dir["build/share/*"]
  end

  test do
    run_shell "xcode-kotlin info"
  end

  def run_shell(command)
    Open3.popen3(command) do |stdin, stdout, stderr, thread|
      Thread.new do
        until (line = stdout.gets).nil?
          $stdout.puts(line)
        end
      end
      Thread.new do
        until (line = stderr.gets).nil?
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
