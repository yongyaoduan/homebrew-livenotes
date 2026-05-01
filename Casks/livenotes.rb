cask "livenotes" do
  version "0.1.1"
  sha256 "3c1d69cbb509e18787ede375b846079a72891a46482384f2ba409864a8022af0"

  url "https://github.com/yongyaoduan/LiveNotes/releases/download/v0.1.1/LiveNotes-0.1.1.zip"
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
