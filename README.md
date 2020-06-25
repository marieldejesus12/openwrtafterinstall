## openWRTAfterInstall

#### Script de pós instalação do OpenWRT.

**Este script é capaz de:**
 - Configurar [EXTROOT](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration)
 - Configurar [SWAP](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration#devices_32_mb_ram) no [EXTROOT](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration)
 - Instalar pacotes de tradução pt-br da [Luci](https://openwrt.org/docs/guide-user/luci/start)
 - Instalar [Adblock](https://github.com/openwrt/packages/tree/master/net/adblock/files)
 - Instalar [banIP](https://github.com/openwrt/packages/tree/master/net/banip/files)
 - Instalar [HD-Idle](https://openwrt.org/docs/guide-user/storage/hd-idle)
 - Instalar [SQM Scripts](https://openwrt.org/docs/guide-user/network/traffic-shaping/sqm)
 - Instalar [Transmission](https://transmissionbt.com/)
 - Instalar os scripts do [YouTube BlockList](https://gitlab.com/marieldejesus12/youtube-listblock)

**Uso:**

Baixe o script e execute o mesmo com `sh openWRTAfterInstall.sh`

Por exemplo
```bash
wget https://gitlab.com/marieldejesus12/openwrtafterinstall/-/raw/master/openWRTAfterInstall.sh -O /tmp/openWRTAfterInstall.sh && sh /tmp/openWRTAfterInstall.sh
```
