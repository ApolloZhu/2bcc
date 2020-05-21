# bcc

Abstraction of the bilibili closed caption (bcc) format.

## Deprecation Notice

Migrated to https://github.com/Apollonyan/subtitle

本项目已迁移至 https://github.com/Apollonyan/subtitle

---

## Swift Package Manager

```swift
.package(url: "https://github.com/Apollonyan/bcc.git", from: "1.0.1")
```

---

# 2bcc

A tool to convert srt (subrip) files to bcc files.

## Install

1. Make sure you have Swift installed. Follow the official [installation guide](https://swift.org/download/).
    1. You may choose to download [Xcode from the Mac App Store](https://itunes.apple.com/app/xcode/id497799835) if you have macOS. 
    2. If you have Windows, get [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about), then follow the official guide.
2. Run the following commands in Terminal or other command line interface applications:

```sh
git clone https://github.com/Apollonyan/bcc.git
cd bcc
```

## Usage

```sh
swift run 2bcc path_to_your_actual_file.srt
```

In most cases, you can just drag and drop your file after the word `2bcc` to supply its path.
