class IntelXed < Formula
  desc "Intel® X86 Encoder Decoder library"
  homepage "https://intelxed.github.io/"
  url "https://github.com/intelxed/xed/archive/refs/tags/v2026.08.23.tar.gz"
  sha256 "205017163019389a149074597c114894b441006e170409e61202900327071594"
  license "Apache-2.0"
  head "https://github.com/intelxed/xed.git", branch: "main"

  depends_on "python@3.11" => :build
  depends_on "mbuild"
  depends_on :macos

  def install
    # Ensure mbuild is available during build by adding it to PYTHONPATH
    ENV.prepend_path "PYTHONPATH", Formula["mbuild"].libexec
    
    # Build the library using mbuild (which is included in the xed source)
    # We need to run mfile.py from the xed directory
    system "python3", "mfile.py", "--shared" if build.with?("shared")
    system "python3", "mfile.py"

    # Install the library and headers
    lib.install "obj/libxed.a"
    lib.install "obj/libxed.so" if build.with?("shared")
    include.install Dir["include/*"]
  end

  test do
    # Basic test to verify the library can be compiled
    (testpath/"test.c").write <<~C
      #include <xed-interface.h>
      int main() {
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "-L#{lib}", "test.c", "-lxed", "-o", "test"
  end
end