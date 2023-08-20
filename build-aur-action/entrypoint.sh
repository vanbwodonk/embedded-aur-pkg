#!/bin/bash

pkgname=$1

useradd builder -m
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chmod -R a+rw .

cat << EOM >> /etc/pacman.conf
[archlinuxcn]
Server = https://repo.archlinuxcn.org/x86_64
EOM

pacman-key --init
pacman -Sy --noconfirm && pacman -S --noconfirm archlinuxcn-keyring
pacman -Syu --noconfirm yay
if [ ! -z "$INPUT_PREINSTALLPKGS" ]; then
    pacman -Syu --noconfirm "$INPUT_PREINSTALLPKGS"
fi

sudo --set-home -u builder yay -S --noconfirm --builddir=./ "$pkgname"
cdls() { cd "$@" && ls; }
cdls . || exit 1
#cd "./$pkgname" || exit 1
python3 ../build-aur-action/encode_name.py
