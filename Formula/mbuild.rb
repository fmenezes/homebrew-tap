class Mbuild < Formula
  desc "Python-based build system used for building XED"
  homepage "https://intelxed.github.io/mbuild/"
  url "https://github.com/intelxed/mbuild/archive/refs/tags/v2026.08.23.tar.gz"
  sha256 "0187d2132b82168e874144111510751764197620400250112507500024111401"
  license "Apache-2.0"

  depends_on "python@3.11" => :build

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