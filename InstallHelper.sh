# Image your disk drive with Macrium Reflect

# Currently these commands are intended to be copy and pasted into the Konsole

sudo steamos-readonly disable

# I use SteamOS in X11 Desktop Mode as I need to be able to seamlessly remote into my machine without the Wayland remote connection panic attacks preventing me from connecting
sudo steamos-session-select plasma-x11-persistent

sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --populate holo
sudo pacman -Syyu --needed base-devel linux-neptune-616-headers

# It's been found that this one package NEEDS TO BE RE/INSTALLED AFTER "base-devel linux-neptune-616-headers" otherwise the nVidia driver won't see it along with "linux-neptune-616-headers" for some odd reason
sudo pacman -Syyu --needed glibc

# This version of the driver - that needs to be downloaded from nVidias website - has been tested to work without complaint on both a 2080 SUPER and a 4060 Ti
sudo chmod +x ./NVIDIA-Linux-x86_64-595.71.05.run

sudo ./NVIDIA-Linux-x86_64-595.71.05.run  --glvnd-egl-config-path=/usr/share/glvnd/egl_vendor.d

sudo mkinitcpio -P

# Possible commands to get the nVidia GPU and driver to work with Gamescope but I have not tested this
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service

# Reboot your computer
