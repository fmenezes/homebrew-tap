class ClangTidy < Formula
  desc "Linting tools for C, C++ and Obj-C"
  homepage "https://clang.llvm.org/extra/clang-tidy/"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/llvm-14.0.0.src.tar.xz"
    sha256 "4df7ed50b8b7017b90dc22202f6b59e9006a29a9568238c6af28df9c049c7b9b"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/clang-14.0.0.src.tar.xz"
      sha256 "f5d7ffb86ed57f97d7c471d542c4e5685db4b75fb817c4c3f027bfa49e561b9b"
    end

    resource "clang-tools-extra" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/clang-tools-extra-14.0.0.src.tar.xz"
      sha256 "f49de4b4502a6608425338e2d93bbe4529cac0a22f2dc1c119ef175a4e1b5bf0"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  def install
    unless build.head?
      resource("clang").stage do |r|
        (buildpath/"clang").install Pathname("clang-#{r.version}.src").children
      end
      resource("clang-tools-extra").stage do |r|
        (buildpath/"clang-tools-extra").install Pathname("clang-tools-extra-#{r.version}.src").children
      end
      (buildpath/"llvm").install Pathname("llvm-#{version}.src").children
    end

    system "cmake", "-S", buildpath/"llvm", "-B", "build",
                    "-DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-tidy"

    bin.install "build/bin/clang-tidy"
  end

  test do
    ENV.prepend_path "PATH", bin
    assert_match "14", shell_output("clang-tidy --version")
  end
end
