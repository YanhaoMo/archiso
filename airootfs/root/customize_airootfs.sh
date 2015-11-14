#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
sed -i 's/#\(zh_CN\.UTF-8\)/\1/' /etc/locale.gen
sed -i 's/#\(zh_TW\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc --utc

#cp -aT /etc/skel/ /root/
#chmod 700 /root

groupadd archiso
useradd -m -g archiso archiso

usermod -s /usr/bin/zsh archiso
usermod -s /usr/bin/zsh root
echo "archiso:lalala" | chpasswd
echo "root:toor" | chpasswd

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target

rm -rvf /usr/share/fcitx/skin/classic
rm -rvf /usr/share/fcitx/skin/dark

updatedb
