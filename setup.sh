#!/bin/bash
#
#
# Author: Sephley

# ANSI escape Codes (for colored output, -e required on echo)
readonly RED='\033[0;31m'   # Red
readonly GREEN='\u001b[32m' # Green
readonly NC='\033[0m'       # Neutral (White)

# Server download URLs | see https://mcversions.net/ for other versions
readonly v1='https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar' # 1.19.4
readonly v2='https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar' # 1.20.1

get_dependencies () {
   # install required packages
   echo -e "${GREEN}\ndownloading required packages...${NC}"
   if [ -f /etc/apt/sources.list ]; then
        apt update
        apt -y install openjdk-17-jre-headless
        apt -y install screen
   elif [ -f /etc/yum.conf ]; then
        yum -y install openjdk-17-jre-headless
        yum -y install screen
   elif [ -f /etc/pacman.conf ]; then
        pacman -Sy
        pacman -S --noconfirm pacman
        pacman -S --noconfirm openjdk-17-jre-headless
        pacman -S --noconfirm screen
   else
   echo -e "$RED""Your distribution is not supported by this StackScript""$NC"
   exit 0
   fi
}

enable_port () {
  sudo ufw enable 25565
}

prepare_workspace () {
  sudo mkdir /srv/minecraft
  sudo wget "$v1" -O /srv/minecraft/server.jar
  java -Xms2048M -Xmx4096M -jar /srv/minecraft/server.jar nogui
}

enable_eula () {
   rm /srv/minecraft/eula.txt
   touch /srv/minecraft/eula.txt
   sed -i 's/echo=false/echo=true/' /srv/minecraft/eula.txt
}

main () {
   get_dependencies
   enable_port
   prepare_workspace
   enable_eula
}

main
