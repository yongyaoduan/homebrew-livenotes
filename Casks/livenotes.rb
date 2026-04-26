cask "livenotes" do
  version "0.1.0"
  sha256 "8f58530dd830848b92d02da07ab198bc2acb3715ca4e75eadff570e42087683c"

  url "https://github.com/yongyaoduan/LiveNotes/releases/download/v0.1.0/LiveNotes-0.1.0.zip"
  name "LiveNotes"
  desc "Local live recording, transcription, translation, and topic notes"
  homepage "https://github.com/yongyaoduan/LiveNotes"

  depends_on macos: ">= :sonoma"

  app "LiveNotes.app"

  postflight do
    artifact_root = File.expand_path("~/Library/Application Support/LiveNotes/LiveNotesArtifacts")
    artifacts = [
      ["https://huggingface.co/mlx-community/whisper-medium-mlx/resolve/7fc08c4eac4c316526498f147dfdee6f6303f975/config.json", "models/whisper-medium/config.json"],
      ["https://huggingface.co/mlx-community/whisper-medium-mlx/resolve/7fc08c4eac4c316526498f147dfdee6f6303f975/weights.npz", "models/whisper-medium/weights.npz"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/config.json", "models/qwen3-4b/config.json"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/added_tokens.json", "models/qwen3-4b/added_tokens.json"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/merges.txt", "models/qwen3-4b/merges.txt"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/tokenizer.json", "models/qwen3-4b/tokenizer.json"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/tokenizer_config.json", "models/qwen3-4b/tokenizer_config.json"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/special_tokens_map.json", "models/qwen3-4b/special_tokens_map.json"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/vocab.json", "models/qwen3-4b/vocab.json"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/model.safetensors", "models/qwen3-4b/model.safetensors"],
      ["https://huggingface.co/mlx-community/Qwen3-4B-4bit/resolve/4dcb3d101c2a062e5c1d4bb173588c54ea6c4d25/model.safetensors.index.json", "models/qwen3-4b/model.safetensors.index.json"],
      ["https://huggingface.co/mlx-community/Qwen3-1.7B-4bit/resolve/3b1b1768f8f8cf8351c712464f906e86c2b8269e/config.json", "models/qwen3-1.7b/config.json"],
      ["https://huggingface.co/mlx-community/Qwen3-1.7B-4bit/resolve/3b1b1768f8f8cf8351c712464f906e86c2b8269e/added_tokens.json", "models/qwen3-1.7b/added_tokens.json"],
      ["https://huggingface.co/mlx-community/Qwen3-1.7B-4bit/resolve/3b1b1768f8f8cf8351c712464f906e86c2b8269e/merges.txt", "models/qwen3-1.7b/merges.txt"],
      ["https://huggingface.co/mlx-community/Qwen3-1.7B-4bit/resolve/3b1b1768f8f8cf8351c712464f906e86c2b8269e/tokenizer.json", "models/qwen3-1.7b/tokenizer.json"],
      ["https://huggingface.co/mlx-community/Qwen3-1.7B-4bit/resolve/3b1b1768f8f8cf8351c712464f906e86c2b8269e/tokenizer_config.json", "models/qwen3-1.7b/tokenizer_config.json"],
      ["https://huggingface.co/mlx-community/Qwen3-1.7B-4bit/resolve/3b1b1768f8f8cf8351c712464f906e86c2b8269e/special_tokens_map.json", "models/qwen3-1.7b/special_tokens_map.json"],
      ["https://huggingface.co/mlx-community/Qwen3-1.7B-4bit/resolve/3b1b1768f8f8cf8351c712464f906e86c2b8269e/vocab.json", "models/qwen3-1.7b/vocab.json"],
      ["https://huggingface.co/mlx-community/Qwen3-1.7B-4bit/resolve/3b1b1768f8f8cf8351c712464f906e86c2b8269e/model.safetensors", "models/qwen3-1.7b/model.safetensors"],
      ["https://huggingface.co/mlx-community/Qwen3-1.7B-4bit/resolve/3b1b1768f8f8cf8351c712464f906e86c2b8269e/model.safetensors.index.json", "models/qwen3-1.7b/model.safetensors.index.json"],
    ]

    artifacts.each do |remote_url, relative_path|
      output_path = File.join(artifact_root, relative_path)
      next if File.exist?(output_path) && File.size(output_path).positive?

      system_command "/bin/mkdir", args: ["-p", File.dirname(output_path)]
      system_command "/usr/bin/curl",
                     args: [
                       "--fail",
                       "--location",
                       "--retry", "5",
                       "--retry-delay", "5",
                       "--continue-at", "-",
                       "--output", output_path,
                       remote_url,
                     ]
    end
  end

  uninstall quit: "app.livenotes.mac"

  zap trash: [
    "~/Library/Application Support/LiveNotes",
    "~/Library/Preferences/app.livenotes.mac.plist",
  ]
end
