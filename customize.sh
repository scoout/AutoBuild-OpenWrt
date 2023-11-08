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
# sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' openwrt/package/lean/default-settings/files/zzz-default-settings

#3. Replace with JerryKuKu’s Argon
#rm openwrt/package/lean/luci-theme-argon -rf

[[ ! -d package/new ]] && mkdir -p package/new
# AutoCore
cp -rf ../immortalwrt/package/emortal/autocore package/new/
cp -rf ../immortalwrt/package/utils/mhz package/utils/
rm -rf feeds/luci/modules/luci-base
cp -rf ../immortalwrt-luci/modules/luci-base feeds/luci/modules
rm -rf feeds/luci/modules/luci-mod-status
cp -rf ../immortalwrt-luci/modules/luci-mod-status feeds/luci/modules/

# automount
cp -rf ../lede/package/lean/automount package/new/
cp -rf ../lede/package/lean/ntfs3-mount package/new/

# cpufreq
cp -rf ../immortalwrt-luci/applications/luci-app-cpufreq package/new/

# FullCone nat for nftables
# patch kernel
#cp -f ../lede/target/linux/generic/hack-5.15/952-add-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-5.15/
#cp -f ../lede/target/linux/generic/hack-6.1/952-add-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-6.1/
# https://github.com/coolsnowwolf/lede/issues/11211
#sed -i 's|CONFIG_WERROR=y|# CONFIG_WERROR is not set|g' target/linux/generic/config-5.15
#sed -i 's|CONFIG_WERROR=y|# CONFIG_WERROR is not set|g' target/linux/generic/config-6.1
curl -sSL https://github.com/coolsnowwolf/lede/files/11473486/952-add-net-conntrack-events-support-multiple-registrant.patch -o target/linux/generic/hack-5.15/952-add-net-conntrack-events-support-multiple-registrant.patch
curl -sSL https://github.com/coolsnowwolf/lede/files/11473487/952-add-net-conntrack-events-support-multiple-registrant.patch -o target/linux/generic/hack-6.1/952-add-net-conntrack-events-support-multiple-registrant.patch
cp -f ../lede/target/linux/generic/hack-5.15/982-add-bcm-fullconenat-support.patch target/linux/generic/hack-5.15/
cp -f ../lede/target/linux/generic/hack-6.1/982-add-bcm-fullconenat-support.patch target/linux/generic/hack-6.1/
# fullconenat-nft
cp -rf ../immortalwrt/package/network/utils/fullconenat-nft package/network/utils/
# libnftnl
rm -rf ./package/libs/libnftnl
cp -rf ../immortalwrt/package/libs/libnftnl package/libs/
# nftables
rm -rf ./package/network/utils/nftables/
cp -rf ../immortalwrt/package/network/utils/nftables package/network/utils/
# firewall4
rm -rf ./package/network/config/firewall4
cp -rf ../immortalwrt/package/network/config/firewall4 package/network/config/
# patch luci
patch -d feeds/luci -p1 -i ../../../patches/fullconenat-luci.patch
