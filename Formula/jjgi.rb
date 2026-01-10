class Jjgi < Formula
  desc "A linter/formatter wrapper for jj fix"
  homepage "https://github.com/shihanng/jjgi"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shihanng/jjgi/releases/download/v0.2.0/jjgi-aarch64-apple-darwin.tar.xz"
      sha256 "2aaf516beabe354c57067a1877250c3117754793f413f33e60b1bf67deadb16a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shihanng/jjgi/releases/download/v0.2.0/jjgi-x86_64-apple-darwin.tar.xz"
      sha256 "723285a5d6e59f64acc71f6c1d2b1ab4cf41c05de85dfe1a7a896dd4f8d0bee2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shihanng/jjgi/releases/download/v0.2.0/jjgi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a8e54ddb2780cd08e6a0eb83d4877b2c45e46e45e1f25683d6bc5f94c8ef3b18"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shihanng/jjgi/releases/download/v0.2.0/jjgi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e8da3608c06d3a4efeef8a76231e2be4533354dea7fe7a9f344d76a95395a305"
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
