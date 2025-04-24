
dev /sdhci@d4280000  \ MMC1 - External SD
   d# 50000000 " max-frequency" integer-property

   \ Active low
   sd-cd-gpio# 1 " cd-gpios" gpio-property

   \ MMP3
   encode-null " wp-inverted" property
   : write-protected?  ( -- flag )  write-protected? 0=  ;
device-end

dev /
   new-device  \ eMMC power regulator
      " regulator-3v3-emmc" device-name
      " regulator-fixed" +compatible
      " vdd-emmc" " regulator-name" string-property
      d# 3300000 " regulator-min-microvolt" integer-property
      d# 3300000 " regulator-max-microvolt" integer-property
      en-emmc-pwr-gpio# 1 " gpio" gpio-property
   finish-device

   new-device  \ SDIO WiFi power regulator
      " regulator-3v3-wlan" device-name
      " regulator-fixed" +compatible
      " vdd-wlan" " regulator-name" string-property
      d# 3300000 " regulator-min-microvolt" integer-property
      d# 3300000 " regulator-max-microvolt" integer-property
      encode-null " enable-active-high" property
      en-wlan-pwr-gpio# 0 " gpio" gpio-property
      d# 10000 " startup-delay-us" integer-property
   finish-device

   new-device   \ SDIO WiFi power sequencer
      " pwrseq-wlan" device-name
      " mmc-pwrseq-simple" +compatible
      wlan-reset-gpio# 1 " reset-gpios" gpio-property
      d# 300 " post-power-on-delay-ms" integer-property
   finish-device
device-end


dev /sdhci@d4280800  \ MMC2 - WLAN
   \ encode-null " cap-power-off-card" property
   " /regulator-3v3-wlan" encode-phandle " vmmc-supply" property
   " /regulator-3v3-wlan" encode-phandle " vqmmc-supply" property
   " /pwrseq-wlan" encode-phandle " mmc-pwrseq" property
device-end

\ 88W8787 WLAN+BG reg property fixes
dev /sdhci@d4280800/sdio
   d# 0 " #size-cells" integer-property
device-end

dev /sdhci@d4280800/sdio/wlan@1
   " marvell,sd8787" +compatible
   d# 1 " reg" integer-property
device-end
dev /sdhci@d4280800/sdio/bluetooth@2
   " marvell,sd8787-bt" +compatible
   d# 2 " reg" integer-property
device-end


dev /sdhci@d4281000  \ MMC3 - Internal eMMC
   " /regulator-3v3-emmc" encode-phandle " vmmc-supply" property
   encode-null " cap-mmc-highspeed" property
device-end


dev /sdhci@d4217000 \ MMC5 - internal micro-SD (eMMC alternative)
device-end

\ mmc1 is set in common code, always to the WLAN device
devalias mmc2    /sd/sdhci@d4280000       \ External SD

devalias ext     /sd/sdhci@d4280000/disk
\ MMC2 @d4280800 is WLAN
devalias emmc    /sd/sdhci@d4281000/disk
\ Nothing on channel 4
devalias int-sd  /sd/sdhci@d4217000/disk

stand-init:
   \ The BOOT_DEV_SEL strap lets you choose either eMMC or microSD, both internal,
   \ as the primary boot device.
   boot-dev-sel-gpio# gpio-pin@  if
      " int"  " /sd/sdhci@d4281000/disk" $devalias  \ eMMC
      " mmc0" " /sd/sdhci@d4281000" $devalias  \ eMMC is primary storage
      " mmc3" " /sd/sdhci@d4217000" $devalias  \ Micro-SD is auxiliary device
   else
      " int"  " /sd/sdhci@d4217000/disk" $devalias  \ micro-SD
      " mmc0" " /sd/sdhci@d4217000" $devalias  \ Micro-SD is primary storage
      " mmc3" " /sd/sdhci@d4281000" $devalias  \ eMMC is auxiliary storage
   then
;
