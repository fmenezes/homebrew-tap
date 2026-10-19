class Mbuild < Formula
  desc "Python-based build system used for building XED"
  homepage "https://intelxed.github.io/mbuild/"
  url "https://github.com/intelxed/mbuild/archive/refs/tags/v2026.08.23.tar.gz"
  sha256 "1e4c9202488904e6fe4aca888daa937c69daf27cca55bc7a18d5a233309c6667"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/fmenezes/homebrew-tap/releases/download/mbuild-2026.08.23"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7f142a65217dbc60f7737429a80861de058abd503888b5ace3aa2b3c3e58000d"
  end

  depends_on :macos
  depends_on "python@3.11"

  def install
    # Install mbuild to libexec for proper Python module support
    libexec.install Dir["*"]
  end

  test do
    # Test that mbuild is available
    ENV.prepend_path "PYTHONPATH", libexec
    system "python3", "-c", "import mbuild; print('mbuild imported successfully')"
  end
end
