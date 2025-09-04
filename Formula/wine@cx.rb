class WineATCx < Formula
  desc "Wine CrossOver sources build - Windows compatibility layer"
  homepage "https://www.codeweavers.com/crossover"
  url "https://media.codeweavers.com/pub/crossover/source/crossover-sources-25.1.0.tar.gz"
  version "25.1.0"
  sha256 "85458dca285ff29eed9134c0d091a84648208ac2609eeb3baa9c71acd5af106b"

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "mingw-w64" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libunwind"
  depends_on "little-cms2"
  depends_on "molten-vk"
  depends_on "vulkan-headers" => :build
  depends_on "sdl2"

  on_macos do
    depends_on "pcre2"
  end

  def install
    # Create the distversion.h file as per the original script
    (buildpath/"sources/wine/programs/winedbg").mkpath
    distversion_content = <<~EOF
      /* ---------------------------------------------------------------
       *   distversion.c
       *
       * Copyright 2013, CodeWeavers, Inc.
       *
       * Information from DISTVERSION which needs to find
       * its way into the wine tree.
       * --------------------------------------------------------------- */

      #define WINDEBUG_WHAT_HAPPENED_MESSAGE "This can be caused by a problem in the program or a deficiency in Wine."

      #define WINDEBUG_USER_SUGGESTION_MESSAGE "Check the log for any missing native dependencies and install using winetricks"
    EOF

    (buildpath/"sources/wine/programs/winedbg/distversion.h").write(distversion_content)

    # Change to wine directory and configure/build
    cd "sources/wine" do
      system "./configure", "--enable-win64", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      Wine CrossOver has been installed. To use it:

      1. You may need to install additional dependencies with winetricks
      2. Run 'wine64 --version' to verify the installation
      3. Use 'winecfg' to configure Wine settings

      Note: This formula builds Wine from CrossOver sources which may have
      different features compared to standard Wine.

      To install from the fmenezes/tap:
        brew tap fmenezes/tap
        brew install fmenezes/tap/wine@cx
    EOS
  end

  test do
    # Basic test to ensure wine binary was installed
    assert_path_exists bin/"wine64"
    # Test wine version output
    system "#{bin}/wine64", "--version"
  end
end
