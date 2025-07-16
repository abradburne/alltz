class Alltz < Formula
  desc "🌍 Terminal-based timezone viewer for developers and remote teams"
  homepage "https://github.com/abradburne/alltz"
  version "0.1.0"
  license "MIT"

  # Primary installation method: precompiled binaries
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/abradburne/alltz/releases/download/v0.1.0/alltz-aarch64-apple-darwin.tar.gz"
      sha256 "e1e22c64b4d2ca26291e1b34d279378274fed7c6a91e25c5bd2db7801cc6b6d5" # aarch64
    else
      url "https://github.com/abradburne/alltz/releases/download/v0.1.0/alltz-x86_64-apple-darwin.tar.gz"
      sha256 "8856ec60f14f4996409411526001075391c00baa6d26e6b942c7f2eb1bc3a7b3" # x86_64
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