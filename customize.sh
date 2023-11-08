#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: eSirPlayground
# Youtube Channel: https://goo.gl/fvkdwm 
#=================================================
#1. Modify default IP
# sed -i 's/192.168.1.1/192.168.5.1/g' openwrt/package/base-files/files/bin/config_generate

sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=6.1/g' openwrt/target/linux/x86/Makefile

#2. Clear the login password
 sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' openwrt/package/lean/default-settings/files/zzz-default-settings
echo '
#!/bin/sh

# lang
uci set luci.main.lang=en
uci commit luci

# timezone
uci set system.@system[0].timezone="WIB-7"
uci set system.@system[0].zonename="Asia/Jakarta"
uci commit

# zram-swap
uci set system.@system[0].zram_priority=100

# ntp server
uci -q delete system.ntp.server
uci add_list system.ntp.server="0.id.pool.ntp.org"
uci add_list system.ntp.server="1.id.pool.ntp.org"
uci add_list system.ntp.server="2.id.pool.ntp.org"
uci add_list system.ntp.server="3.id.pool.ntp.org"
uci commit system && service sysntpd reload

# uhttpd
uci set uhttpd.main.rfc1918_filter=0
uci set uhttpd.main.redirect_https=0
uci commit uhttpd && service uhttpd reload

exit 0
' > openwrt/package/lean/default-settings/files/zzz-default-settings

#3. Replace with JerryKuKu’s Argon
#rm openwrt/package/lean/luci-theme-argon -rf

