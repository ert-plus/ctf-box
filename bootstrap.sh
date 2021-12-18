#!/usr/bin/env bash

pacman -Syu --noconfirm
pacman -S --noconfirm \
       $(tr "\n" " " < /vagrant/base)

systemctl enable gdm
systemctl start gdm

cd /opt
git clone https://aur.archlinux.org/yay.git
chown -R vagrant:vagrant yay
cd yay
su vagrant -c "makepkg -si --noconfirm"

if [[ -f "/vagrant/hostname" ]]; then
   cp /vagrant/hostname /etc/hostname
fi

if [[ -f "/vagrant/.creds" ]]; then
    USER=$(awk -F ':' '{print $1}' /vagrant/.creds)
    PASS=$(awk -F ':' '{print $2}' /vagrant/.creds)
    useradd -m -s /usr/bin/zsh $USER
    echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER
    echo "$USER:$PASS" | chpasswd
    # overwrite vagrant password
    (echo -n vagrant: && head -c 48 /dev/urandom | base64) | sudo chpasswd
    chown -R $USER:$USER "/vagrant"
else
    USER=vagrant
fi
    
chmod +x "/vagrant/user-setup.sh"
su $USER -c "/vagrant/user-setup.sh"

# pretty gross
su $USER -c 'yay -S --noconfirm \
       $(tr "\n" " " < /vagrant/extra)'
