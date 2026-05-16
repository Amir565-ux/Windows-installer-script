#!/bin/bash

# =========================
# ABDULLAH WINDOWS INSTALLER
# =========================

# Colors
RED='\033[1;31m'
DARK_RED='\033[0;31m'
WHITE='\033[1;37m'
NC='\033[0m'

# Clear Screen
clear

# Logo Function
logo() {
    clear

    echo -e "${RED}"
    echo " █████╗ ██████╗ ██████╗ ██╗   ██╗██╗     ██╗      █████╗ ██╗  ██╗"
    echo "██╔══██╗██╔══██╗██╔══██╗██║   ██║██║     ██║     ██╔══██╗██║  ██║"
    echo "███████║██████╔╝██║  ██║██║   ██║██║     ██║     ███████║███████║"
    echo "██╔══██║██╔══██╗██║  ██║██║   ██║██║     ██║     ██╔══██║██╔══██║"
    echo "██║  ██║██████╔╝██████╔╝╚██████╔╝███████╗███████╗██║  ██║██║  ██║"
    echo "╚═╝  ╚═╝╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝"
    echo -e "${WHITE}                     ABDULLAH${NC}"
    echo -e "${NC}"

    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}          WINDOWS INSTALLER SCRIPT${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    echo -e "${WHITE}[${RED}1${WHITE}] ${RED}Install Windows 11${NC}"
    echo -e "${WHITE}[${RED}2${WHITE}] ${RED}Install Windows 10${NC}"
    echo -e "${WHITE}[${RED}3${WHITE}] ${RED}System Information${NC}"
    echo -e "${WHITE}[${RED}4${WHITE}] ${RED}Exit${NC}"
    echo ""
}

# Windows 11 Installer
install_win11() {
    clear
    echo -e "${RED}Installing Windows 11...${NC}"
    echo ""

    sudo apt update -y
    sudo apt install curl wget -y

    mkdir -p ~/windows11
    cd ~/windows11 || exit

    wget -O win11.sh https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/vm/windows11-vm.sh

    chmod +x win11.sh

    bash win11.sh
}

# Windows 10 Installer
install_win10() {
    clear
    echo -e "${RED}Installing Windows 10...${NC}"
    echo ""

    sudo apt update -y
    sudo apt install curl wget -y

    mkdir -p ~/windows10
    cd ~/windows10 || exit

    wget -O win10.sh https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/vm/windows10-vm.sh

    chmod +x win10.sh

    bash win10.sh
}

# System Info
system_info() {
    clear

    echo -e "${WHITE}━━━━━━━━ SYSTEM INFORMATION ━━━━━━━━${NC}"
    echo ""

    echo -e "${RED}Hostname:${NC} $(hostname)"
    echo -e "${RED}Kernel:${NC} $(uname -r)"
    echo -e "${RED}RAM Usage:${NC}"
    free -h

    echo ""
    echo -e "${RED}Disk Usage:${NC}"
    df -h /

    echo ""
    read -p "Press Enter to return..."
}

# Main Loop
while true; do
    logo

    read -p "Select Option: " option

    case $option in
        1)
            install_win11
            ;;
        2)
            install_win10
            ;;
        3)
            system_info
            ;;
        4)
            echo -e "${RED}Goodbye Abdullah!${NC}"
            exit 0
            ;;
        *)
            echo -e "${DARK_RED}Invalid Option!${NC}"
            sleep 2
            ;;
    esac

done
