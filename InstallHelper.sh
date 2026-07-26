# Image your disk drive with Macrium Reflect, always make a backup of your boot drive before hand!!! This is not a suggestion either, Do It!!! Now!!! Right Now!!!

# Currently these commands are intended to be copy and pasted into the Konsole

# Tell your SteamOS to unlock the root partition so the helping packages and the nVidia driver can be installed
sudo steamos-readonly disable

# I use SteamOS in X11 Desktop Mode as I need to be able to seamlessly remote into my machine without the Wayland remote connection panic attacks preventing me from connecting
sudo steamos-session-select plasma-x11-persistent

# Initialize the Arch Package Manager Key File
sudo pacman-key --init

# Fetch and populate the Arch Package Manager Key File with the Arch Linux and Valve SteamOS Holo key
sudo pacman-key --populate archlinux holo

# Use the Arch Linux Package Manager to download the minimal developer tools and the referenced Linux headers for your specific build of the custom SteamOS kernel
sudo pacman -Syyu --needed base-devel linux-neptune-616-headers

# It's been found that this one package NEEDS TO BE RE/INSTALLED AFTER "base-devel linux-neptune-616-headers" otherwise the nVidia driver won't see it along with "linux-neptune-616-headers" for some odd reason
sudo pacman -Syyu --needed glibc

# Download the Linux x86_64 (64 bit) nVidia driver (in this case: https://us.download.nvidia.com/XFree86/Linux-x86_64/595.71.05/NVIDIA-Linux-x86_64-595.71.05.run ) for your specific GPU from nVidias website (YES. I KNOW. It goes against what everyone says about installing the one that comes with the distro but this does work and it is up to date)
# This version of the driver - that needs to be downloaded from nVidias website - has been tested to work without complaint on both a 2080 SUPER and a 4060 Ti
sudo chmod +x ./NVIDIA-Linux-x86_64-595.71.05.run

# The installer needs to be ran in sudo (Super User) and it needs this path to be provided or an odd error message will appear during install, without it it will still install but I don't want to take risks
sudo ./NVIDIA-Linux-x86_64-595.71.05.run  --glvnd-egl-config-path=/usr/share/glvnd/egl_vendor.d

# Rebuild the 'Initial RAM filesystem Copy In Copy Out' (initramfs)
sudo mkinitcpio -P

# Possible commands to get the nVidia GPU and driver to work with Gamescope but I have not tested this
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service

# Reboot your computer by going to the Application Launcher and Restart and Restart, once you returned to your desktop, check that it says what your nVidia GPU is in the About this System under Graphics Processor and it may have a discrete tag next to it
sudo pacman -R linux-neptune-616-headers pahole m4 autoconf automake bison debugedit fakeroot flex libmpc libisl gcc groff make patch pkgconf texinfo base-devel
