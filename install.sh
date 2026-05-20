#!/usr/bin/busybox sh

# === CONFIGURAÇÃO ===
# Altere esta variável quando quiser atualizar para uma nova versão
ZT_VERSION="1.16.1"
ZT_DEB_URL="https://download.zerotier.com/debian/bullseye/pool/main/z/zerotier-one/zerotier-one_${ZT_VERSION}_riscv64.deb"
# ====================

# Check for AARCH64 architecture
ARCH=$(uname -m)
if [ "$ARCH" != "riscv64" ]; then
    echo "This install script will not work on your device."
    echo "It is intended only for riscv architecture while you're running $ARCH architecture."
    exit 0
fi

# PARAR O SERVIÇO ANTES DE ATUALIZAR
if [ -x "/etc/init.d/S97zerotier-one" ]; then
    echo "===> Parando o serviço zerotier-one existente (Update mode)..."
    /etc/init.d/S97zerotier-one stop
    # Dá um tempo breve para o processo encerrar
    sleep 2 
fi

echo "===> Installing LSB functions..."
mkdir -p /lib/lsb
cp ./init-functions /lib/lsb/
chmod +x /lib/lsb/init-functions

echo "===> Baixando e extraindo ZeroTier versão ${ZT_VERSION}..."
rm -rf /tmp/zt_install
mkdir -p /tmp/zt_install
cd /tmp/zt_install || exit

curl -sO "$ZT_DEB_URL"
ar x zerotier-one_${ZT_VERSION}_riscv64.deb && xzcat data.tar.xz | tar -xvf -

echo "===> Instalando binários e scripts de inicialização..."
cp -rf ./usr/sbin/* /usr/sbin/
cp -rf ./etc/init.d/zerotier-one /etc/init.d/S97zerotier-one
chmod +x /etc/init.d/S97zerotier-one

# Mantém a identidade do ZeroTier intacta se já existir (para não perder a conexão com a rede no update)
mkdir -p /var/lib/zerotier-one
cp -rn ./var/lib/zerotier-one/* /var/lib/zerotier-one/ 2>/dev/null || true

cd - || exit

echo "===> Installing dependencies from 'libs' directory..."
if [ -d "libs" ]; then
    cd libs || exit
    rm -rf tmp_extract
    mkdir -p tmp_extract
    
    # Loop dinâmico: processa todos os pacotes .deb da pasta libs
    for deb_file in *.deb; do
        if [ -e "$deb_file" ]; then
            echo "Extraindo e instalando dependência: $deb_file"
            cp "$deb_file" tmp_extract/
            cd tmp_extract || exit
            ar x "$deb_file" 2>/dev/null && xzcat data.tar.xz 2>/dev/null | tar -xf - 2>/dev/null
            
            # Copia as bibliotecas preservando os links simbólicos (-P) para dentro de /lib/
            if [ -d "./lib" ]; then
                cp -PRf ./lib/* /lib/ 2>/dev/null || true
            fi
            
            # Dependências como a libstdc++ costumam ficar dentro de /usr/lib/riscv64-linux-gnu/
            if [ -d "./usr/lib" ]; then
                cp -PRf ./usr/lib/riscv64-linux-gnu/* /lib/ 2>/dev/null || true
                cp -PRf ./usr/lib/* /lib/ 2>/dev/null || true
            fi
            
            cd .. || exit
            rm -rf tmp_extract/*
        fi
    done
    cd .. || exit
    rm -rf libs/tmp_extract
else
    echo "Aviso: Diretório 'libs' não encontrado. Pulando etapa de dependências locais."
fi

echo "===> Limpando arquivos temporários..."
rm -rf /tmp/zt_install

echo "===> Attempting to start zerotier-one service..."
/etc/init.d/S97zerotier-one start

echo "===> Instalação/Atualização concluída com sucesso!"