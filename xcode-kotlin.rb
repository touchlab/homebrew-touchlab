class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin.git", :tag => "0.2.2"
  head "https://github.com/touchlab/xcode-kotlin.git"
  license "Apache-2.0"

  def install
    system "./setup.sh"
  end

  test do
    # Nothing to test so far.
    system "true"
  end
end
