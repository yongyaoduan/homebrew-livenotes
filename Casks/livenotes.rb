cask "livenotes" do
  version "0.1.3"
  sha256 "8b16279c8c84f4d9509f57779cbe5a108b1c5838bd8fb0b261d3dbf64b88024f"

  url "https://github.com/yongyaoduan/LiveNotes/releases/download/v0.1.3/LiveNotes-0.1.3.zip"
  name "LiveNotes"
  desc "Local live recording, transcription, translation, and saved transcripts"
  homepage "https://github.com/yongyaoduan/LiveNotes"

  depends_on arch: :arm64
  depends_on macos: ">= :tahoe"

  app "LiveNotes.app"

  caveats <<~EOS
    Preview builds are not Developer ID signed or notarized until Apple Developer Program credentials are configured.
    If macOS blocks launch, open System Settings > Privacy & Security and choose Open Anyway.
  EOS

  uninstall quit:   "app.livenotes.mac",
            delete: [
              "~/Library/Application Support/LiveNotes/LiveNotesArtifacts",
              "~/Library/Application Support/LiveNotes/Runtime",
            ],
            trash:  "~/Library/Preferences/app.livenotes.mac.plist"

  zap trash: [
    "~/Library/Application Support/LiveNotes",
    "~/Library/Preferences/app.livenotes.mac.plist",
  ]
end
