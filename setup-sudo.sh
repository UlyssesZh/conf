#!/usr/bin/sh
pacman -Syu
pacman -S make git gcc net-tools python3 ruby ranger imagemagick ffmpeg vim zsh tmux nodejs npm go kotlin cargo wtf thefuck clang irssi wget curl perl rpmextract openconnect squid avahi tar xz iputils maxima axel gist fd locate unzip man openssh openssh-client nginx tree python-pip cuda htop texlive-full neofetch bluez bluez-utils pulseaudio-bluetooth nvidia nvidia-settings lib32-nvidia-utils fzf pulseaudio gnupg openssl
systemctl enable --now squid avahi-daemon bluetooth fstrim.timer
pulseaudio -k
