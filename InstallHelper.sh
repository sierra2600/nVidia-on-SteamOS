#!/bin/bash
cat <<'EOF'
Image your disk drive with Macrium Reflect, always make a backup of your boot drive before hand!!! This is not a suggestion either, Do It!!! Do It Now!!! Right Now!!!

Currently these commands are intended to be copy and pasted into the Konsole

Tell your SteamOS to unlock the root partition so the helping packages and the nVidia driver can be installed
EOF

# Path: /home/deck/.config/nvidia-update-hook.sh

echo -e "Checking for GPUs"
lspci -nd ::0300 | sed -e 's/.*10de:.*/PASS : nVidia GPU found/' \
			-e 's/.*8086:.*/PASS : Intel Graphics found and natively supported/' \
			-e 's/.*1002:.*/PASS : AMD\/ATI APU\/GPU found and natively supported/' | grep . || exit 1

# Fail check: If nVidia isn't in the output string, abort immediately
echo "$_gpu_report" | grep -q "NVIDIA" || { echo -e "FAIL : nVidia GPU Not found"; exit 1; }

# If the module can be loaded natively, do nothing and continue booting
if modprobe nvidia 2>/dev/null; then
	exit 0
fi

echo -e "INFO : nVidia card found but the driver isn't installed\nDEBUG: Disabling Root readonly"

echo "Do you wish to install the nVidia Driver?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit 1;;
    esac
done

sudo steamos-readonly disable

echo -e "DEBUG: Initialize the Arch Package Manager Key File"
sudo pacman-key --init

echo -e "DEBUG: Fetch and populate the Arch Package Manager Key File with the Arch Linux and Valve SteamOS Holo key"
sudo pacman-key --populate archlinux holo

# Definitions
BUILD_PACKS=(gcc make patch pahole linux-neptune-616-headers)

echo -e "DEBUG: Use the Arch Linux Package Manager to download the minimal developer tools and the referenced Linux headers for your specific build of the custom SteamOS kernel (Thank you to Rich Stokes here on GitHub for finding the minimal amount of packages needed to install the nVidia drivers!)"
sudo pacman -Syy --needed --noconfirm "${BUILD_PACKS[@]}"

echo -e "DEBUG: It's been found that this one package NEEDS TO BE RE/INSTALLED AFTER \"base-devel linux-neptune-616-headers\" otherwise the nVidia driver won't see it along with \"linux-neptune-616-headers\" for some odd reason"
sudo pacman -Syy glibc

# More definitions
DRIVER_VERSION="595.84"
RUN_FILE="/tmp/NVIDIA-Linux-x86_64-${DRIVER_VERSION}.run"

echo -e "DEBUG: Download the Linux x86_64 (64 bit) nVidia driver (in this case: \" https://us.download.nvidia.com/XFree86/Linux-x86_64/595.84/NVIDIA-Linux-x86_64-595.84.run \" ) from nVidias website (YES. I KNOW. It goes against what everyone says about installing the one that comes with the distro but this does work and it is up to date)"
wget -c "https://us.download.nvidia.com/XFree86/Linux-x86_64/${DRIVER_VERSION}/NVIDIA-Linux-x86_64-${DRIVER_VERSION}.run" -O "$RUN_FILE"

echo -e "DEBUG: This version of the driver has been tested to work without complaint on both a 2080 SUPER and a 4060 Ti in X11, let's make it that we can execute it"
chmod +x "$RUN_FILE"

echo -e "DEBUG: The installer needs to be ran in sudo (Super User) and it needs this path to be provided or an odd error message will appear during install, without it it will still install but I don't want to take risks"
sudo "$RUN_FILE" --glvnd-egl-config-path=/usr/share/glvnd/egl_vendor.d

sudo rm -rf "$RUN_FILE"

echo -e "DEBUG: Rebuild the 'Initial RAM Copy In Copy Out filesystem' (initramfs) as for some odd reason when you tell the installer to rebuild, it doesn't"
sudo mkinitcpio -P

echo -e "DEBUG: Reboot your computer by going to the Application Launcher and Restart and Restart, once you returned to your desktop, check that it says what your nVidia GPU is in the About this System under Graphics Processor and it may have a discrete tag next to it"
sudo pacman -R --noconfirm "${BUILD_PACKS[@]}"

echo -e "Possible commands to get the nVidia GPU and driver to work with Gamescope but I have not tested this"
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
