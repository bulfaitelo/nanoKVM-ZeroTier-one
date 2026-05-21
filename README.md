# 🌐 NanoKVM-ZeroTier-One Installer

[![Platform: Sipeed NanoKVM](https://img.shields.io/badge/Platform-Sipeed%20NanoKVM-blue)](#)
[![Architecture: RISC-V](https://img.shields.io/badge/Architecture-RISC--V-orange)](#)
[![ZeroTier](https://img.shields.io/badge/ZeroTier-Supported-yellow)](#)

*Read this in other languages: [English](#english) | [Português](#portugues)*

---
  

<a  id="english"></a>

## 🇺🇸 English

  

Automated ZeroTier installation script specifically designed for the **Sipeed NanoKVM** (RISC-V architecture).

  

Since NanoKVM runs a minimalist OS compiled with older standard libraries (GCC 10), installing recent ZeroTier versions directly leads to critical `GLIBCXX` missing library errors. Furthermore, forcing newer libraries into the system breaks the NanoKVM web and video interface.

  

This installer elegantly solves this by packaging and targeting **ZeroTier v1.8.4**—a meticulously selected version that perfectly matches the NanoKVM's native `libstdc++` environment. It provides a clean, native installation with zero hacks, ensuring your KVM interface remains 100% stable.

  

### ✨ Features

*  **100% Native Compatibility:** No dangerous external dependency injection needed. It runs flawlessly using NanoKVM's native system libraries.

*  **Safe Re-installs:** Preserves your existing `/var/lib/zerotier-one` identity, keeping your Node ID intact.

*  **Error-Proof Execution:** Automatically sanitizes scripts (handles Windows `\r` line-ending issues) to prevent "applet not found" or syntax errors during installation.

  

### 🚀 Quick Start

  

Run the following commands in your NanoKVM terminal to download, extract, and install:


    curl -LO https://github.com/bulfaitelo/nanoKVM-ZeroTier-one/releases/download/latest/nanokvm-zerotier.tar
    
    tar xvf nanokvm-zerotier.tar && cd nanokvm-zerotier
    
    chmod +x install.sh
    
    ./install.sh

  

Once  installed,  check  your  status  and  join  a  network:

    zerotier-cli  info
    
    zerotier-cli  join  <your-network-id>




### 📚  Context  &  Credits

  

Please  find  additional  info,  discussions,  and  context  regarding  this  implementation  in  Sipeed  NanoKVM  Issue  [#79](https://github.com/sipeed/NanoKVM/issues/79).


<a  id="portugues"></a>

## 🇧🇷  Português

  

Script  automatizado  de  instalação  do  ZeroTier  desenhado  especificamente  para  o  Sipeed  NanoKVM (arquitetura RISC-V).

  

Como  o  NanoKVM  roda  um  sistema  operacional  muito  minimalista  compilado  com  bibliotecas  antigas (GCC 10), instalar versões recentes do  ZeroTier  gera  erros  críticos  de  falta  de  biblioteca (GLIBCXX). Por outro lado, forçar a injeção de bibliotecas mais novas no sistema quebra a interface de vídeo e web do  NanoKVM.

  

Este  instalador  resolve  o  problema  de  forma  elegante  ao  utilizar  o  ZeroTier  v1.8.4  —  uma  versão  minuciosamente  selecionada  que  possui  compatibilidade  perfeita  com  o  ambiente  libstdc++  nativo  do  NanoKVM.  O  resultado  é  uma  instalação  limpa,  sem  "gambiarras",  mantendo  a  interface  do  seu  KVM  100%  estável.

### ✨  Diferenciais

  

100%  de  Compatibilidade  Nativa:  Não  requer  injeção  perigosa  de  dependências  externas.  Funciona  perfeitamente  com  as  bibliotecas  originais  do  sistema.

  

Reinstalações  Seguras:  Preserva  sua  identidade  de  rede  existente  em  /var/lib/zerotier-one,  mantendo  seu  Node  ID  intacto.

  

À  Prova  de  Erros:  Higieniza  os  scripts  automaticamente (corrigindo quebras  de  linha  \r  do  Windows) para evitar falhas de sintaxe ("applet not found") durante a instalação.

  

🚀  Como  Instalar

  

Execute  os  comandos  abaixo  no  terminal  do  seu  NanoKVM  para  baixar  o  pacote,  extrair  e  iniciar  a  instalação:


    curl -LO https://github.com/bulfaitelo/nanoKVM-ZeroTier-one/releases/download/latest/nanokvm-zerotier.tar
    
    tar xvf nanokvm-zerotier.tar && cd nanokvm-zerotier
    
    chmod +x install.sh
    
    ./install.sh

  

Após  a  conclusão,  verifique  o  status  e  conecte-se  à  sua  rede:


    zerotier-cli  info
    
    zerotier-cli  join  <id-da-sua-rede>

  

### 📚  Contexto  e  Créditos

  

Para  mais  informações,  discussões  e  contexto  sobre  a  origem  desta  implementação,  consulte  a  Issue  [#79](https://github.com/sipeed/NanoKVM/issues/79) do repositório oficial do NanoKVM.




