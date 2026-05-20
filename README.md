# 🌐 NanoKVM-ZeroTier-One Installer

[![Platform: Sipeed NanoKVM](https://img.shields.io/badge/Platform-Sipeed%20NanoKVM-blue)](#)
[![Architecture: RISC-V](https://img.shields.io/badge/Architecture-RISC--V-orange)](#)
[![ZeroTier](https://img.shields.io/badge/ZeroTier-Supported-yellow)](#)

*Read this in other languages: [English](#english) | [Português](#portugues)*

---

<a id="english"></a>
## 🇺🇸 English

Automated ZeroTier installation and update script specifically designed for the **Sipeed NanoKVM** (RISC-V architecture).

Since NanoKVM runs a very minimalist OS, installing ZeroTier directly can lead to missing compiler library errors (like `GLIBCXX`). This script handles everything automatically, including local dependency resolution.

### ✨ Features
* **Dependency Injection:** Automatically resolves and installs missing dynamic libraries (`libc6`, `libstdc++6`) required by recent ZeroTier versions.
* **Safe Updates:** You can run this script to update ZeroTier. It will safely stop the service and overwrite binaries **without** deleting your Node ID/Network Identity.
* **Clean Execution:** Uses isolated temporary folders for extraction to prevent garbage buildup on your device.

### 🚀 Quick Start

Run the following commands on your NanoKVM terminal to download, extract, and install:

```sh
mkdir -p nanokvm-zerotier && cd nanokvm-zerotier
curl -LO [https://github.com/bulfaitelo/nanoKVM-ZeroTier-one/releases/download/latest/nanokvm-zerotier.tar](https://github.com/bulfaitelo/nanoKVM-ZeroTier-one/releases/download/latest/nanokvm-zerotier.tar)
tar xvf nanokvm-zerotier.tar
chmod +x install.sh
./install.sh