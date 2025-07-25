#!/bin/bash

pkgname=$1

useradd builder -m
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chmod -R a+rw .

# Enable the cloudflare mirror
# sed -i '1i Server = https://cloudflaremirrors.com/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist

# Enable the multilib repository
cat << EOM >> /etc/pacman.conf
[multilib]
Include = /etc/pacman.d/mirrorlist
[archlinuxcn]
Server = https://repo.archlinuxcn.org/\$arch
Server = https://mirrors.xtom.us/archlinuxcn/\$arch
Server = https://mirrors.xtom.jp/archlinuxcn/\$arch
Server = https://mirrors.xtom.hk/archlinuxcn/\$arch
Server = https://mirrors.xtom.nl/archlinuxcn/\$arch
Server = https://mirrors.xtom.de/archlinuxcn/\$arch
Server = https://mirrors.xtom.ee/archlinuxcn/\$arch
Server = https://mirrors.xtom.au/archlinuxcn/\$arch
Server = https://mirrors.ocf.berkeley.edu/archlinuxcn/\$arch
Server = https://archlinux.ccns.ncku.edu.tw/archlinuxcn/\$arch
EOM

pacman-key --lsign-key "farseerfc@archlinux.org"
pacman -Sy --noconfirm && pacman -S --noconfirm archlinuxcn-keyring
pacman -Syu --noconfirm paru
if [ ! -z "$INPUT_PREINSTALLPKGS" ]; then
    pacman -Syu --noconfirm "$INPUT_PREINSTALLPKGS"
fi

sudo --set-home -u builder paru -S --noconfirm --builddir=./ "$pkgname"
cd "./$pkgname" || exit 1

# Compress pkg.tar to pkg.tar.zst
# Recursively find all *.pkg.tar files
find . -type f -name "*.pkg.tar" | while read -r file; do
    # Define the target compressed file path
    target="${file}.zst"

    # Check if the target already exists
    if [[ -f "$target" ]]; then
        echo "Skipping: $target already exists."
    else
        echo "Compressing: $file -> $target"
        zstd -q --rm -o "$target" "$file"
    fi
done

python3 ../build-aur-action/encode_name.py
