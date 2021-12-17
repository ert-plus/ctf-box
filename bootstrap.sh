#!/usr/bin/env bash

pacman -Syu --noconfirm
pacman -S --noconfirm \
       $(tr "\n" " " < /vagrant/base)

sudo systemctl enable gdm
sudo systemctl start gdm

cd /opt
sudo git clone https://aur.archlinux.org/yay.git
sudo chown -R vagrant:vagrant yay
cd yay
makepkg -si

if [[ -f "/vagrant/hostname" ]]
then
    sudo cp /vagrant/hostname /etc/hostname
fi


if [[ -f "/vagrant/.creds" ]]
then
    USER=$(awk -F ':' '{print $1}' /vagrant/.creds)
    PASS=$(awk -F ':' '{print $2}' /vagrant/.creds)
    useradd -m -s /bin/zsh $USER
    echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER
    echo "$USER:$PASS" | chpasswd
    # overwrite vagrant password
    (echo -n vagrant: && head -c 48 /dev/urandom | base64) | sudo chpasswd
else
    USER=vagrant
fi

chmod +x "/vagrant/user-setup.sh"
su $USER -c "/vagrant/user-setup.sh"

# pretty gross
yay -S --noconfirm \
       $(tr "\n" " " < /vagrant/extra)
