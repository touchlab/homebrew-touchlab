class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin.git", :tag => "0.2.2"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "main"
  license "Apache-2.0"
  keg_only "There is no command to call after installed."

  def install
    require 'open3'
    require 'fileutils'

    status = Open3.popen3("./setup.sh") do |stdin, stdout, stderr, thread|
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

    if status.success?
      ignoreFilePath = File.join(Dir.pwd, ".success")
      File.new(ignoreFilePath, 'w').close
      prefix.install ".success"
    else
      odie "Couldn't install xcode-kotlin plugin!"
    end
  end

  test do
    # Nothing to test so far.
    system "true"
  end
end
