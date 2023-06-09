#!/bin/bash
#
#
# Author: Sephley

# ANSI escape Codes (for colored output, -e required on echo)
readonly RED='\033[0;31m'   # Red
readonly GREEN='\u001b[32m' # Green
readonly NC='\033[0m'       # Neutral (White)

# Server download URLs
readonly 1.19.4='https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar'

get_dependencies () {
   # install required packages
   echo -e "${GREEN}\ndownloading required packages...${NC}"
   if [ -f /etc/apt/sources.list ]; then
        apt update
        apt -y install openjdk-17-jre-headless
   elif [-f /etc/yum.conf ]; then
        yum -y install openjdk-17-jre-headless
   elif [-f /etc/pacman.conf ]; then
        pacman -Sy
        pacman -S --noconfirm pacman
        pacman -S --noconfirm openjdk-17-jre-headless
   else
   echo -e "$RED""Your distribution is not supported by this StackScript""$NC"
   exit
   fi

enable_port () {
  sudo ufw enable 25565
}

prepare_workspace () {
  sudo mkdir /srv/minecraft
  
  # see https://mcversions.net/ for other versions
  sudo wget "$1.19.4" -O /srv/minecraft/server.jar
}
