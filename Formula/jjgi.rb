class Jjgi < Formula
  desc "A linter/formatter wrapper for jj fix"
  homepage "https://github.com/shihanng/jjgi"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shihanng/jjgi/releases/download/v0.4.0/jjgi-aarch64-apple-darwin.tar.xz"
      sha256 "7b67e51138edfc95618d461e816d5b106a80997ed6f82b8d09ba39484ff2f27d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shihanng/jjgi/releases/download/v0.4.0/jjgi-x86_64-apple-darwin.tar.xz"
      sha256 "427ebf4a4c10d332af01a0bdb5c6a1a98b2cf43be711e95f1e0774a34b1e3f41"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shihanng/jjgi/releases/download/v0.4.0/jjgi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ec1093e61d8deaefaa1ba41e8640888e5239fd287ffd7d557058a30d6b03a13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shihanng/jjgi/releases/download/v0.4.0/jjgi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7fde565c6f80a94a7cc53820cf3ae6fc1bc81ace30eedf7279215321a6a9042b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "jjgi" if OS.mac? && Hardware::CPU.arm?
    bin.install "jjgi" if OS.mac? && Hardware::CPU.intel?
    bin.install "jjgi" if OS.linux? && Hardware::CPU.arm?
    bin.install "jjgi" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
