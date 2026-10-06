class Kvmwatch < Formula
  desc "Keep a single-display layout sane when a KVM switches a monitor away"
  homepage "https://github.com/fmenezes/kvmwatch"
  url "https://github.com/fmenezes/kvmwatch/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "0e62748dacd6ef96bf14f128de078794d732026a016d7f36128e93395839be8c"
  license "MIT"
  head "https://github.com/fmenezes/kvmwatch.git", branch: "main"

  depends_on xcode: :build
  depends_on macos: :ventura

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/kvmwatch"
  end

  service do
    run [opt_bin/"kvmwatch"]
    log_path var/"log/kvmwatch.log"
    error_log_path var/"log/kvmwatch.log"
  end

  def caveats
    <<~EOS
      Configure your monitor before starting the service (it will not run until
      monitorVid/monitorPid are set):
        kvmwatch --detect
        kvmwatch --set monitorVid=0xVVVV --set monitorPid=0xPPPP

      Then start it:
        brew services start fmenezes/tap/kvmwatch
    EOS
  end

  test do
    assert_match "displayCount=", shell_output("#{bin}/kvmwatch --status")
  end
end
