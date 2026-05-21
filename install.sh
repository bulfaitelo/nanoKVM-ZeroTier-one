#!/usr/bin/busybox sh

# === CONFIGURAÇÃO ===
ZT_VERSION="1.14.0"
ZT_DEB_URL="https://download.zerotier.com/debian/bullseye/pool/main/z/zerotier-one/zerotier-one_${ZT_VERSION}_riscv64.deb"
# ====================

ARCH=$(uname -m)
if [ "$ARCH" != "riscv64" ]; then
    echo "This install script will not work on your device."
    echo "It is intended only for riscv architecture while you're running $ARCH architecture."
    exit 0
fi

# Parar o serviço antes de instalar/atualizar
if [ -x "/etc/init.d/S97zerotier-one" ]; then
    echo "===> Parando o serviço zerotier-one existente..."
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

# Mantém a identidade do ZeroTier intacta se já existir (sua rede salva)
mkdir -p /var/lib/zerotier-one
cp -rn ./var/lib/zerotier-one/* /var/lib/zerotier-one/ 2>/dev/null || true

cd - || exit

echo "===> Limpando arquivos temporários..."
rm -rf /tmp/zt_install

echo "===> Attempting to start zerotier-one service..."
/etc/init.d/S97zerotier-one start

echo "===> Instalação concluída! Verifique o status com: zerotier-cli info"