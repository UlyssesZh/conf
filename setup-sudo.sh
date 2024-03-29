#!/usr/bin/sh

# Enable color in pacman
sudo sed -i 's/^\#Color$/Color/' /etc/pacman.conf

# Ignore lid switch
sudo sed -i 's/^\#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf

https_proxy_temp=$https_proxy
if [ $CHINA != "" ]; then
	export https_proxy=
fi

# Install pacman packages
pacman -Syu
pacman --needed --noconfirm -S base-devel make git gcc net-tools python3 ruby ranger vi nano
pacman --needed --noconfirm -S imagemagick ffmpeg vim zsh tmux nodejs npm go kotlin
pacman --needed --noconfirm -S cargo wtf thefuck clang irssi wget curl perl rpmextract
pacman --needed --noconfirm -S openconnect squid avahi tar xz iputils maxima axel texlive-most
pacman --needed --noconfirm -S gist fd locate unzip man openssh nginx biber lshw usbutils
pacman --needed --noconfirm -S tree python-pip cuda htop texlive-lang neofetch bluez
pacman --needed --noconfirm -S bluez-utils nvidia fzf gnupg openssl texlive-bibtexextra
pacman --needed --noconfirm -S the_silver_searcher cloc multitail texlive-fontsextra
pacman --needed --noconfirm -S jupyter-notebook python-pytorch python-pandas

# Fix tlmgr
sed -i 's?\$Master = "\$Master/../..";?$Master = "$Master/../../..";?' /usr/share/texmf-dist/scripts/texlive/tlmgr.pl

# Enable some services
systemctl enable --now squid avahi-daemon bluetooth fstrim.timer

export https_proxy=$https_proxy_temp
