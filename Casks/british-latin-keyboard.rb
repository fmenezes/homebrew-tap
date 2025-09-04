cask "british-latin-keyboard" do
  version "v2.0.1"
  sha256 "ebf6a50d8b2f848634c5d245ca64c411b31df972802d4ca962a76bc653568fcf"

  url "https://github.com/fmenezes/british-macos-custom-keyboard-layout/releases/download/#{version}/British.Latin.pkg"
  name "british_latin_keyboard"
  desc "This is a custom en-gb keyboard layout to allow typing Latin chars"
  homepage "https://github.com/fmenezes/british-macos-custom-keyboard-layout"

  pkg "British.Latin.pkg"

  uninstall pkgutil: "org.sil.ukelele.keyboardlayout.british(latin)"
end
