#!/usr/bin/busybox sh

# === CONFIGURAÇÃO ===
ZT_VERSION="1.16.1"
ZT_DEB_URL="https://download.zerotier.com/debian/bullseye/pool/main/z/zerotier-one/zerotier-one_${ZT_VERSION}_riscv64.deb"
# ====================

ARCH=$(uname -m)
if [ "$ARCH" != "riscv64" ]; then
    echo "This install script will not work on your device."
    exit 0
fi

if [ -x "/etc/init.d/S97zerotier-one" ]; then
    echo "===> Parando o serviço zerotier-one existente (Update mode)..."
    /etc/init.d/S97zerotier-one stop
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

mkdir -p /var/lib/zerotier-one
cp -rn ./var/lib/zerotier-one/* /var/lib/zerotier-one/ 2>/dev/null || true
cd - || exit

echo "===> Installing dependencies in ISOLATED mode..."
# Cria a pasta privada para as dependências do ZeroTier
mkdir -p /opt/zt_libs

if [ -d "libs" ]; then
    cd libs || exit
    rm -rf tmp_extract
    mkdir -p tmp_extract
    
    for deb_file in *.deb; do
        if [ -e "$deb_file" ]; then
            echo "Extraindo para isolamento: $deb_file"
            cp "$deb_file" tmp_extract/
            cd tmp_extract || exit
            ar x "$deb_file" 2>/dev/null && xzcat data.tar.xz 2>/dev/null | tar -xf - 2>/dev/null
            
            # Copia as bibliotecas APENAS para a pasta privada (/opt/zt_libs/)
            if [ -d "./lib" ]; then
                cp -PRf ./lib/* /opt/zt_libs/ 2>/dev/null || true
            fi
            if [ -d "./usr/lib" ]; then
                cp -PRf ./usr/lib/riscv64-linux-gnu/* /opt/zt_libs/ 2>/dev/null || true
                cp -PRf ./usr/lib/* /opt/zt_libs/ 2>/dev/null || true
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

echo "===> Injetando variáveis de ambiente no serviço..."
# Isso diz ao ZeroTier para usar a pasta isolada, sem afetar o resto do KVM!
if ! grep -q "LD_LIBRARY_PATH=/opt/zt_libs" /etc/init.d/S97zerotier-one; then
    sed -i '2i export LD_LIBRARY_PATH=/opt/zt_libs:$LD_LIBRARY_PATH' /etc/init.d/S97zerotier-one
fi

echo "===> Limpando arquivos temporários..."
rm -rf /tmp/zt_install

echo "===> Attempting to start zerotier-one service..."
/etc/init.d/S97zerotier-one start

echo "===> Instalação Concluída! KVM e ZeroTier rodando em harmonia."