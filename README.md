# nVidia-on-SteamOS
Helps install nVidia Drivers onto SteamOS (Game Mode/Gamescope may or may not work)

This script currently isn't working as the driver used within has some sort of issue working with something in the latest of SteamOS, please use Rich Stokes method

!!! NOTICE !!! I WILL RECOMMEND READING INTO THE SHELL SCRIPTS BEFORE BLINDLY DOWNLOADING AND USING THEM!

Thank you to Rich Stokes on here on GitHub for finding the minimal amount of packages needed to install the nVidia drivers!

Oh! Also! I highly recommend using [Rich Stokes](https://github.com/richstokes) method `https://github.com/richstokes/SteamOS-Nvidia-Drivers` or [Gavin Nugent](https://github.com/28allday) method `https://github.com/28allday/steamos-nvidia-installer` for the nVidia driver for any card that my method does not wish to work with, I personally am struggling to get my old method to work properly with my 4th Gen i7 with a nVidia GTX 1070 FTW card, the driver installer will get most of the way through the install process then fail (this is also why you want to make backups because I flooded my root partition :( much sadness)

`curl -fsSL https://github.com/sierra2600/nVidia-on-SteamOS/raw/refs/heads/main/InstallHelper.sh | sh`
