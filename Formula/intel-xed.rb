class IntelXed < Formula
  desc "Intel X86 Encoder Decoder library"
  homepage "https://intelxed.github.io/"
  url "https://github.com/intelxed/xed/archive/refs/tags/v2026.08.23.tar.gz"
  sha256 "4638942b38dabb7825e6340c1804c97e732837739dae375a0ad74314ecac1ffa"
  license "Apache-2.0"
  head "https://github.com/intelxed/xed.git", branch: "main"

  depends_on "llvm" => :build
  depends_on "mbuild" => :build
  depends_on "python@3.11" => :build
  depends_on :macos

  def install
    # mfile.py imports mbuild, which is shipped as a separate formula.
    ENV.prepend_path "PYTHONPATH", Formula["mbuild"].libexec

    system "python3", "mfile.py"

    lib.install Dir["obj/libxed*.a"]
    # Public headers plus the headers xed generates during the build.
    (include/"xed").install Dir["include/public/xed/*.h"]
    (include/"xed").install Dir["obj/*.h"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <xed/xed-interface.h>
      int main(void) {
        xed_tables_init();
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "-L#{lib}", "test.c", "-lxed", "-lxed-ild", "-o", "test"
    system "./test"
  end
end
