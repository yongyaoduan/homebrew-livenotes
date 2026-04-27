cask "livenotes" do
  version "0.1.0"
  sha256 "4bcab683aff11cdcc027f42538fb6ca49df29355d7c64ffc4e0831f990828206"

  url "https://github.com/yongyaoduan/LiveNotes/releases/download/v0.1.0/LiveNotes-0.1.0.zip"
  name "LiveNotes"
  desc "Local live recording, transcription, translation, and topic notes"
  homepage "https://github.com/yongyaoduan/LiveNotes"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"
  depends_on formula: "python@3.12"

  app "LiveNotes.app"

  postflight do
    require "digest"

    support_root = ENV.fetch("LIVENOTES_SUPPORT_ROOT", File.expand_path("~/Library/Application Support/LiveNotes"))
    artifact_root = File.join(support_root, "LiveNotesArtifacts")
    runtime_root = File.join(support_root, "Runtime")
    runtime_python = File.join(runtime_root, "bin/python3")
    homebrew_prefix = ENV.fetch("HOMEBREW_PREFIX", "/opt/homebrew")
    python_candidates = [
      "#{homebrew_prefix}/bin/python3.12",
      "/opt/homebrew/bin/python3.12",
      "/usr/local/bin/python3.12",
    ].select { |path| File.executable?(path) }
    raise "Python 3.12 is required to install the LiveNotes local runtime" if python_candidates.empty?
    runtime_packages = [
      "pip==25.0.1",
      "mlx==0.31.1",
      "mlx-lm==0.31.2",
      "mlx-whisper==0.4.3",
      "huggingface_hub==1.9.1",
    ]

    unless File.executable?(runtime_python)
      system_command "/bin/rm", args: ["-rf", runtime_root]
      system_command python_candidates.first, args: ["-m", "venv", runtime_root]
    end
    system_command runtime_python,
                   args: ["-m", "pip", "install", "--upgrade"] + runtime_packages

    artifacts = [
      ["https://huggingface.co/mlx-community/whisper-large-v3-turbo/resolve/a4aaeec0636e6fef84abdcbe3544cb2bf7e9f6fb/config.json", "models/whisper-large-v3-turbo/config.json", 268, "b34fc29e4e11e0a25e812775dd67f4dd16fc2c8eb43d28ae25ff7d660ecb6379"],
      ["https://huggingface.co/mlx-community/whisper-large-v3-turbo/resolve/a4aaeec0636e6fef84abdcbe3544cb2bf7e9f6fb/weights.safetensors", "models/whisper-large-v3-turbo/weights.safetensors", 1613977612, "951ed3fc1203e6a62467abb2144a96ce7eafca8fa77e3704fdb8635ff3e7f8a6"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/config.json", "models/qwen3-4b/config.json", 937, "b5efdcf3b0035a3638e7228dad4d85f5c4a23f156eb7cdb0b44c8366a5d34d9b"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/added_tokens.json", "models/qwen3-4b/added_tokens.json", 707, "c0284b582e14987fbd3d5a2cb2bd139084371ed9acbae488829a1c900833c680"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/merges.txt", "models/qwen3-4b/merges.txt", 1671853, "8831e4f1a044471340f7c0a83d7bd71306a5b867e95fd870f74d0c5308a904d5"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/tokenizer.json", "models/qwen3-4b/tokenizer.json", 11422654, "aeb13307a71acd8fe81861d94ad54ab689df773318809eed3cbe794b4492dae4"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/tokenizer_config.json", "models/qwen3-4b/tokenizer_config.json", 9706, "253153d0738ceb4c668d2eff957714dd2bea0b56de772a9fdccd96cbf517e6a0"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/special_tokens_map.json", "models/qwen3-4b/special_tokens_map.json", 613, "76862e765266b85aa9459767e33cbaf13970f327a0e88d1c65846c2ddd3a1ecd"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/vocab.json", "models/qwen3-4b/vocab.json", 2776833, "ca10d7e9fb3ed18575dd1e277a2579c16d108e32f27439684afa0e10b1440910"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/model.safetensors", "models/qwen3-4b/model.safetensors", 2263022529, "e240c0bdc0ebb0681bf0da0f98d9719fd6ebe269a3633f81542c13e81345651d"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/model.safetensors.index.json", "models/qwen3-4b/model.safetensors.index.json", 63924, "f7825defe5865d179c3b593173d37056be5f202dcb7153985cf74e75ecf1628b"],
    ]

    artifacts.each do |remote_url, relative_path, expected_size, expected_sha|
      output_path = File.join(artifact_root, relative_path)
      if File.exist?(output_path) && File.size(output_path) == expected_size
        next if expected_sha.empty? || Digest::SHA256.file(output_path).hexdigest == expected_sha
      end

      system_command "/bin/mkdir", args: ["-p", File.dirname(output_path)]
      temporary_path = "#{output_path}.download"
      curl_bin = ENV.fetch("LIVENOTES_CURL_BIN", "/usr/bin/curl")
      system_command curl_bin,
                     args: [
                       "--fail",
                       "--location",
                       "--retry", "5",
                       "--retry-delay", "5",
                       "--continue-at", "-",
                       "--output", temporary_path,
                       remote_url,
                     ]
      if File.size(temporary_path) != expected_size
        raise "Downloaded #{relative_path} has size #{File.size(temporary_path)}, expected #{expected_size}"
      end
      if !expected_sha.empty? && Digest::SHA256.file(temporary_path).hexdigest != expected_sha
        raise "Downloaded #{relative_path} failed sha256 verification"
      end
      File.rename(temporary_path, output_path)
    end
  end

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
