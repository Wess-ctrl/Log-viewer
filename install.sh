#!/usr/bin/env bash
#You need to log out after run this script
set -e #If any command fails, the script stops immediatly.

if command -v pacman >/dev/null 2>&1; then
	echo "The Arch distro has been detected, starting the installation..."
	sudo pacman -Sy lm_sensors
elif command -v apt >/dev/null 2>&1; then
	echo "The Debian/Ubuntu distro has been detected, starting the installation..."
	sudo apt update
	sudo apt install -y lm_sensors
elif command -v dnf >/dev/null 2>&1; then
    echo "The Fedora/RHEL distro has been detected, starting the installation..."
    sudo dnf install -y lm_sensors
elif command -v zypper >/dev/null 2>&1; then
    echo "The openSUSE distro has been detected, starting the installation..."
    sudo zypper refresh
    sudo zypper install -y lm_sensors
else
    echo "It hasn't been possible to detect any gestor package compatible"
    echo "You must to install the "lm_sensors" package"
    exit 1
fi

sudo usermod -aG systemd-journal "$USER" 
