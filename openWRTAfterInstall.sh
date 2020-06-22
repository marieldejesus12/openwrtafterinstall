#!/usr/bin/env ash

function echoTitle() {
  clear
  echo -e "\033[01;31m###\033[00;37m"
  echo -e "\033[01;31m###### openWRTAfterInstall - $1\033[00;37m"
  echo -e "\033[01;31m###\033[00;37m"
}

function echov(){
  echo ""
  echo -e "\033[01;32m$1\033[00;37m"
}

function question() {
  read answer
  answer=$(echo "$answer" | tr 'A-Z' 'a-z')
}

function menu() {
  echoTitle "Menu Principal"
  echov "Opções:"
  echo "1 - Instalar pacotes"
  echo "2 - Instalar Scripts de Bloqueio do Youtube + Adblock"
  echo ""
  echo "0 - Sair do script"
  echov "Digite o número da opção desejada:"
  question
  case $answer in
    1 )
      install;;
    2 )
      youblock;;
    0 )
      echov "Saindo do script..."
      sleep 2
      exit;;
    * )
      echov "Opção inválida, tente novamente..."
      sleep 2
      menu;;
  esac
}

function install() {
  echoTitle "Instalador de Pacotes"
  echov "Pacotes disponíveis para instalação:"
  echo "1 - Instalar pacotes de tradução pt-br da Luci"
  echo "2 - Instalar Adblock"
  echo "3 - Instalar Banip"
  echo "4 - Instalar HD-Idle"
  echo "5 - Instalar SQM Scripts"
  echo "6 - Instalar Transmission"
  echo ""
  echo "0 - Voltar ao menu anterior"
  echov "Digite os números das opções desejadas separados por espaço:"
  question
  if [[ "$(echo $answer | grep 0 )" != "" ]]; then
    sleep 1
    menu
  fi
  proginstall=""
  if [[ "$(echo $answer | grep 1 )" != "" ]]; then
    proginstall="$proginstall luci-i18n-base-pt-br luci-i18n-firewall-pt-br luci-i18n-opkg-pt-br"
  fi
  if [[ "$(echo $answer | grep 2 )" != "" ]]; then
    proginstall="$proginstall luci-i18n-adblock-pt-br"
  fi
  if [[ "$(echo $answer | grep 3 )" != "" ]]; then
    proginstall="$proginstall luci-i18n-banip-pt-br"
  fi
  if [[ "$(echo $answer | grep 4 )" != "" ]]; then
    proginstall="$proginstall luci-i18n-hd-idle-pt-br"
  fi
  if [[ "$(echo $answer | grep 5 )" != "" ]]; then
    proginstall="$proginstall luci-app-sqm"
  fi
  if [[ "$(echo $answer | grep 6 )" != "" ]]; then
    proginstall="$proginstall luci-i18n-transmission-pt-br transmission-daemon-mbedtls transmission-remote-mbedtls transmission-web transmission-cli-mbedtls"
  fi
  echov "Atualizando lista de pacotes..."
  opkg update > /dev/null 2>&1
  echov "Atualizando todos os pacotes instalados..."
  opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade > /dev/null 2>&1
  echov "Instalando pacotes selecionados..."
  opkg install $proginstall > /dev/null 2>&1
  echov "Programas instalados com êxito..."
  sleep 2
  menu
}

function youblock() {
  echoTitle "Instalador do Script de Bloqueio do Youtube + Adblock"
  echov "Opções para instalação:"
  echo "1 - Instalar somente script da lista do Adblock"
  echo "2 - Instalar somente script de coleta de urls"
  echo "3 - Instalar os dois scripts [Adblock + Coleta]"
  echo ""
  echo "0 - Voltar ao menu anterior"
  echov "Digite a opção desejada:"
  question
  case $answer in
    1 )
      if [[ ! -e /etc/init.d/adblock ]]; then
        echov "Adblock não instalado, instalando..."
        echov "Atualizando lista de pacotes..."
        opkg update > /dev/null 2>&1
        echov "Instalando o Adblock agora..."
        opkg install luci-i18n-adblock-pt-br > /dev/null 2>&1
      fi
      echov "Instalando script da lista do Adblock..."
      wget https://gitlab.com/marieldejesus12/youtube-pihole-adblock/-/raw/master/openwrt_adblock.sh -O /tmp/openwrt_adblock.sh > /dev/null 2>&1 && ash /tmp/openwrt_adblock.sh install && echov "Instalação do script de listas Adblock concluída..." || echov "Algo deu errado, por favor tente novamente..."
      sleep 3
      youblock;;
    2 )
      echov "Instalando script de coleta de urls..."
      wget https://gitlab.com/marieldejesus12/youtube-pihole-adblock/-/raw/master/openwrt_collect.sh -O /tmp/openwrt_collect.sh > /dev/null 2>&1 && ash /tmp/openwrt_collect.sh install && echov "Instalação do script de coleta de urls concluída..." || echov "Algo deu errado, por favor tente novamente..."
      sleep 3
      youblock;;
    3 )
      if [[ ! -e /etc/init.d/adblock ]]; then
        echov "Adblock não instalado, instalando..."
        echov "Atualizando lista de pacotes..."
        opkg update > /dev/null 2>&1
        echov "Instalando o Adblock agora..."
        opkg install luci-i18n-adblock-pt-br > /dev/null 2>&1
      fi
      echov "Instalando script da lista do Adblock..."
      wget https://gitlab.com/marieldejesus12/youtube-pihole-adblock/-/raw/master/openwrt_adblock.sh -O /tmp/openwrt_adblock.sh > /dev/null 2>&1 && ash /tmp/openwrt_adblock.sh install && echov "Instalação do script de listas Adblock concluída..." || echov "Algo deu errado, por favor tente novamente..."
      sleep 3
      echov "Instalando script de coleta de urls..."
      wget https://gitlab.com/marieldejesus12/youtube-pihole-adblock/-/raw/master/openwrt_collect.sh -O /tmp/openwrt_collect.sh > /dev/null 2>&1 && ash /tmp/openwrt_collect.sh install && echov "Instalação do script de coleta de urls concluída..." || echov "Algo deu errado, por favor tente novamente..."
      sleep 3
      menu;;
    0 )
      sleep 1
      menu;;
    * )
      echov "Opção inválida, tente novamente..."
      sleep 2
      youblock;;
  esac
}

if [[ "$(df | grep "/dev/sd" | grep "/overlay")" = "" ]]; then
  echoTitle "Menu EXTROOT"
  echov "Sistema não está em EXTROOT. Deseja configurar EXTROOT? [s/n]"
  question
  if [[ "$answer" = "s" ]]; then
    echov "Atualizando lista de pacotes..."
    opkg update  > /dev/null 2>&1
    echov "Instalando pacotes necessários..."
    opkg install block-mount kmod-fs-ext4 kmod-usb-storage e2fsprogs kmod-usb-ohci kmod-usb-uhci fdisk > /dev/null 2>&1
    echov "Configurando rootfs_data..."
    DEVICE="$(sed -n -e "/\s\/overlay\s.*$/s///p" /etc/mtab)"
    uci -q delete fstab.rwm
    uci set fstab.rwm="mount"
    uci set fstab.rwm.device="${DEVICE}"
    uci set fstab.rwm.target="/rwm"
    uci commit fstab
    sleep 2
    while : ; do
      echov "Detectando dispositivos..."
      sleep 1
      echov "Dispositivos detectados:"
      devices=""
      for i in $(ls /dev/sd[a,b,c]); do
        echo $(basename $i)
        devices="$devices $i"
      done
      echov "Digite o dispotivivo desejado para fazer EXTROOT: [sdX]"
      question
      if [[ "$(echo $devices | grep $answer )" != "" ]]; then
        device=$answer
        break
      else
        echov "Dispositivo inválido, tente novamente..."
      fi
    done
    while : ; do
      echov "Detectando partições..."
      sleep 1
      echov "Partições detectadas:"
      partitions=""
      for i in $(ls /dev/$device[1,2,3,4,5,6,7,8,9,10]); do
        echo $(basename $i)
        partitions="$partitions $i"
      done
      echov "Digite a partição desejada para fazer EXTROOT: [sdXX]"
      question
      if [[ "$(echo $partitions | grep $answer )" != "" ]]; then
        break
      else
        echov "Partição inválida, tente novamente..."
      fi
    done
    part=$answer
    echov "Deseja formatar a partição? [s|n]"
    question
    if [[ "$answer" = "s" ]]; then
      echov "Formatando a partição /dev/$part..."
      mkfs.ext4 /dev/$part
    fi
    echov "Configurando /dev/$part para EXTROOT..."
    DEVICE="/dev/$part"
    eval $(block info "${DEVICE}" | grep -o -e "UUID=\S*")
    uci -q delete fstab.overlay
    uci set fstab.overlay="mount"
    uci set fstab.overlay.uuid="${UUID}"
    uci set fstab.overlay.target="/overlay"
    uci commit fstab
    sleep 2
    echov "Montando EXTROOT..."
    mount /dev/$part /mnt
    sleep 1
    echov "Copiando arquivos para EXTROOT..."
    cp -a -f /overlay/. /mnt
    sleep 1
    echov "Configurando OPKG..."
    sed -i 's|lists_dir ext /var/opkg-lists|lists_dir ext /usr/lib/opkg/lists|' /mnt/usr/lib/opkg/lists
    sleep 1
    echov "Desmontando EXTROOT..."
    umount /mnt
    sleep 1
    echov "Reiniciando o router em 10 segundos..."
    sleep 10
    reboot
  fi
fi

if [[ "$(df | grep "/dev/sd" | grep "/overlay")" != "" ]]; then
  if [[ $(free -m | grep Swap | awk '{print $2}') -eq 0 ]]; then
    echoTitle "Menu SWAP"
    echov "SWAP não detectada. Deseja configurar SWAP? [s/n]"
    question
    if [[ "$answer" = "s" ]]; then
      echov "Digite um tamanho para a SWAP em MB: [ex: 128]"
      question
      dd if=/dev/zero of=/swap bs=1M count=$answer
      mkswap /swap
      uci -q delete fstab.swap
      uci set fstab.swap="swap"
      uci set fstab.swap.device="/swap"
      uci commit fstab
      /etc/init.d/fstab boot
      if [[ "$(grep 'fstab boot' /etc/rc.local)" = "" ]]; then
        sed -i 's|exit 0|/etc/init.d/fstab boot\nexit 0|' /etc/rc.local
      fi
      echov "SWAP configurada com êxito..."
      sleep 3
    fi
  fi
fi

menu
