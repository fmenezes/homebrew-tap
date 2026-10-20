class Remill < Formula
  desc "Library for lifting machine code to LLVM bitcode"
  homepage "https://github.com/lifting-bits/remill"
  url "https://github.com/lifting-bits/remill.git",
      tag:      "v6.0.1",
      revision: "0e324aee8c67a63ec759ef379dcfafa0b3cb1448"
  license "Apache-2.0"
  head "https://github.com/lifting-bits/remill.git", branch: "master"

  bottle do
    root_url "https://github.com/fmenezes/homebrew-tap/releases/download/remill-6.0.1"
    rebuild 1
    sha256 arm64_tahoe: "3a4d751ea69701f96e2c5eb9a07a25aa3af024adb05ae0fd476c3f269d03eed7"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => :build
  depends_on "llvm@17"
  depends_on :macos

  def install
    llvm = formula_opt_prefix("llvm@17")
    deps = buildpath/"deps"

    # Vendored dependencies (XED, gflags, glog, googletest, sleigh) are built
    # into a throwaway prefix and statically linked into remill.
    system "cmake", "-G", "Ninja", "-S", "dependencies", "-B", "deps-build",
           "-DUSE_EXTERNAL_LLVM=ON",
           "-DENABLE_SLEIGH=ON",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_INSTALL_PREFIX=#{deps}",
           "-DCMAKE_PREFIX_PATH=#{llvm}"
    system "cmake", "--build", "deps-build"

    system "cmake", "-G", "Ninja", "-B", "build",
           "-DREMILL_FETCH_SLEIGH=OFF",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_PREFIX_PATH=#{deps}",
           "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # The bundled clang/llvm-link wrappers resolve LLVM dylibs via
    # @loader_path/../lib; link the llvm@17 dylibs they expect into our lib.
    ln_s formula_opt_lib("llvm@17")/"libclang-cpp.dylib", lib
    ln_s formula_opt_lib("llvm@17")/"libLLVM.dylib", lib
  end

  test do
    assert_match "lifted_code",
                 shell_output("#{bin}/remill-lift-17 --arch amd64 --ir_out /dev/stdout --bytes c704ba01000000")
  end
end
