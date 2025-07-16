class Alltz < Formula
  desc "🌍 Terminal-based timezone viewer for developers and remote teams"
  homepage "https://github.com/abradburne/alltz"
  version "0.1.0"
  license "MIT"

  # Primary installation method: precompiled binaries
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/abradburne/alltz/releases/download/v0.1.0/alltz-aarch64-apple-darwin.tar.gz"
      sha256 "ebc5bcf71a34fe97710b53d3c7406791da0c44aeacd3065e8940d3fc8b583209" # aarch64
    else
      url "https://github.com/abradburne/alltz/releases/download/v0.1.0/alltz-x86_64-apple-darwin.tar.gz"
      sha256 "ba80ae7efca3161734de6f3166eabd008a535fcb206b4c3dece1eacd47226438" # x86_64
    end
  end

  on_linux do
    url "https://github.com/abradburne/alltz/releases/download/v0.1.0/alltz-x86_64-apple-darwin.tar.gz"
    sha256 "PLACEHOLDER_LINUX_HASH" # linux
  end

  # Alternative: build from source (requires Rust toolchain)
  head do
    url "https://github.com/abradburne/alltz.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      # Build from source
      system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    else
      # Install precompiled binary
      bin.install "alltz"
    end
  end

  test do
    assert_match "alltz 0.1.0", shell_output("#{bin}/alltz --version")

    # Test CLI commands
    assert_match "Available Timezones", shell_output("#{bin}/alltz list")
    assert_match "Current time", shell_output("#{bin}/alltz time London")
  end
end