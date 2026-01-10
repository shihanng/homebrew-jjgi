class Jjgi < Formula
  desc "A linter/formatter wrapper for jj fix"
  homepage "https://github.com/shihanng/jjgi"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shihanng/jjgi/releases/download/v0.3.0/jjgi-aarch64-apple-darwin.tar.xz"
      sha256 "a1943d3c2c2ba9af7cc873a9c488bc6b3eb81d03e562865cfa81fdba95a68435"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shihanng/jjgi/releases/download/v0.3.0/jjgi-x86_64-apple-darwin.tar.xz"
      sha256 "8e4fe9a9278dfa2e00be993a438bb91ad2ba1d795221b7bf0012aeb120972daa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shihanng/jjgi/releases/download/v0.3.0/jjgi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "06fcb7da1d50067c0bed8fdee786f218108b9f4cc575e32c9e621cfc93abcd57"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shihanng/jjgi/releases/download/v0.3.0/jjgi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a63b7b59c7a20f757688abf63526e23e7ed18d956f11b5a564637a1bd1935340"
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
