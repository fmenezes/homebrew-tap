class Kvmwatch < Formula
  desc "Keep a single-display layout sane when a KVM switches a monitor away"
  homepage "https://github.com/fmenezes/kvmwatch"
  url "https://github.com/fmenezes/kvmwatch/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "870d538fbca6bb46af0abfb5f91209118118f42b0cb8a1e27589251d615a2bdf"
  license "MIT"
  head "https://github.com/fmenezes/kvmwatch.git", branch: "main"

  depends_on xcode: :build
  depends_on macos: ">= :ventura"

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/kvmwatch"
  end

  service do
    run [opt_bin/"kvmwatch"]
    keep_alive true
    log_path var/"log/kvmwatch.log"
    error_log_path var/"log/kvmwatch.log"
  end

  test do
    assert_match "usbMonitor", shell_output("#{bin}/kvmwatch --status")
  end
end
