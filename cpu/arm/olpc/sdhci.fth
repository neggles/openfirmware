purpose: OLPC SDHCI (Secure Digital Host Controller Interface) configuration

fload ${BP}/cpu/arm/mmp2/sdhci.fth

dev /sd
   : olpc-card-inserted?  ( -- flag )
      base-addr h# d428.0000 =  if  d# 31 gpio-pin@ 0=  else  true  then
   ;
   ' olpc-card-inserted? to card-inserted?

[ifdef] olpc-cl4
also forth definitions
: isolate-mmc3-pins  ( gpio# #gpios -- )
   bounds  do
      i af@ 7 invert and 1 or  i af!
      i gpio-dir-out  i gpio-clr
   loop
;
: connect-mmc3-pins  ( gpio# #gpios -- )
   bounds  do
      i af@ 7 invert and 2 or  i af!
   loop
;
: isolate-emmc  ( -- )
   d# 108 4 isolate-mmc3-pins
   d# 161 4 isolate-mmc3-pins
   d# 145 2 isolate-mmc3-pins
;
: connect-emmc  ( -- )
   d# 108 4 connect-mmc3-pins
   d# 161 4 connect-mmc3-pins
   d# 145 2 connect-mmc3-pins
;
previous definitions
[then]

   \ Base-addr:power_GPIO - 1:35, 2:34, 3:33
   : gpio-power-on  ( -- )
      sdhci-card-power-on
[ifdef] en-emmc-pwr-gpio#
      base-addr h# d428.1000 =  if
         [ifdef] connect-emmc  connect-emmc  [then]
         en-emmc-pwr-gpio# gpio-clr
      then
[then]
[ifdef] en-wlan-pwr-gpio#
      base-addr h# d428.0800 =  if  en-wlan-pwr-gpio# gpio-set  then
[then]
[ifdef] sd-pwroff-gpio#
      base-addr h# d428.0000 =  if  sd-pwroff-gpio# gpio-clr  then
[then]
   ;
   ' gpio-power-on to card-power-on

   : gpio-power-off  ( -- )
[ifdef] en-emmc-pwr-gpio#
      base-addr h# d428.1000 =  if
         en-emmc-pwr-gpio# gpio-set
         [ifdef] isolate-emmc isolate-emmc  [then]
      then
[then]
[ifdef] en-wlan-pwr-gpio#
      base-addr h# d428.0800 =  if  en-wlan-pwr-gpio# gpio-clr  then
[then]
[ifdef] sd-pwroff-gpio#
      base-addr h# d428.0000 =  if  sd-pwroff-gpio# gpio-set  then
[then]
      sdhci-card-power-off
   ;
   ' gpio-power-off to card-power-off
device-end

dev /sdhci@d4280000  \ MMC1 - External SD
   d# 50000000 " max-frequency" integer-property
   d#  4 " bus-width" integer-property
   d# 31 " mrvl,clk-delay-cycles" integer-property
   d# 40 " post-power-on-delay-ms" integer-property

   encode-null " no-1-8-v" property

   new-device
      fload ${BP}/dev/mmc/sdhci/sdmmc.fth
      fload ${BP}/dev/mmc/sdhci/selftest.fth
      " external" " slot-name" string-property
   finish-device
device-end

dev /sdhci@d4280800  \ MMC2 - WLAN
   d# 50000000 " max-frequency" integer-property
   d#  4 " bus-width" integer-property
   d# 31 " mrvl,clk-delay-cycles" integer-property
   d# 40 " post-power-on-delay-ms" integer-property

   encode-null " keep-power-in-suspend" property
   encode-null " wakeup-source" property
   encode-null " no-1-8-v" property
   encode-null " non-removable" property

   new-device
      fload ${BP}/dev/mmc/sdhci/mv8686/loadpkg.fth
      fload ${BP}/dev/mmc/sdhci/mv8686/bluetooth-pkg.fth
   finish-device
device-end

dev /sdhci@d4281000  \ MMC3 - Internal eMMC
   d# 50000000 " max-frequency" integer-property
   d# 8 " bus-width" integer-property
   d# 15 " mrvl,clk-delay-cycles" integer-property
   d# 40 " post-power-on-delay-ms" integer-property

   encode-null " no-1-8-v" property
   encode-null " non-removable" property

   : write-protected?  false  ;
   new-device
      fload ${BP}/dev/mmc/sdhci/sdmmc.fth
      fload ${BP}/dev/mmc/sdhci/selftest.fth
      " emmc" " slot-name" string-property
   finish-device
device-end

dev /sdhci@d4281800 \ MMC4 (not used)
   " disabled" " status" string-property
device-end

[ifdef] mmp3
dev /sdhci@d4217000 \ MMC5 - internal micro-SD
   d# 50000000 " max-frequency" integer-property
   d#  4 " bus-width" integer-property
   d# 15 " mrvl,clk-delay-cycles" integer-property
   d# 40 " post-power-on-delay-ms" integer-property

   \ The media is considered non-removable (at run-time) since the slot is
   \ only accessible on the motherboard, the heatspreader must be removed to
   \ access it, and it's unpopulated on production boards. `broken-cd` would be
   \ more accurate, but would waste power.
   encode-null " no-1-8-v" property
   encode-null " non-removable" property

   : write-protected?  false  ;
   new-device
      fload ${BP}/dev/mmc/sdhci/sdmmc.fth
      fload ${BP}/dev/mmc/sdhci/selftest.fth
      " internal" " slot-name" string-property
   finish-device
device-end
[then]

\ mmc0 is the internal storage device, which may depend on BOOT_DEV_SEL, so its
\ devalias is set in platform-dependent code

\ The WLAN device is always mmc1
devalias mmc1 /sd/sdhci@d4280800

stand-init: SDHC clocks
   h# 400 h# 54 pmua!    \ Master SDH clock divisor
;
