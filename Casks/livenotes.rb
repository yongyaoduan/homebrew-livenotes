cask "livenotes" do
  version "0.1.2"
  sha256 "839db45429ca4aab6d553d4e9277e8515bce898d3ea90af993a5104be9761499"

  url "https://github.com/yongyaoduan/LiveNotes/releases/download/v0.1.2/LiveNotes-0.1.2.zip"
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
