#!/bin/bash

# Colors
RED='[1;31m'
DARK_RED='[0;31m'
WHITE='[1;37m'
NC='[0m'

clear

logo() {
    clear
    echo -e "${RED}"
    echo " █████╗ ██████╗ ██████╗ ██╗   ██╗██╗     ██╗      █████╗ "
    echo "██╔══██╗██╔══██╗██╔══██╗██║   ██║██║     ██║     ██╔══██╗"
    echo "███████║██████╔╝██║  ██║██║   ██║██║     ██║     ███████║"
    echo "██╔══██║██╔══██╗██║  ██║██║   ██║██║     ██║     ██╔══██║"
    echo "██║  ██║██████╔╝██████╔╝╚██████╔╝███████╗███████╗██║  ██║"
    echo "╚═╝  ╚═╝╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝"
    echo -e "${NC}"

    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}            WINDOWS INSTALLER SCRIPT${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${WHITE}[${RED}1${WHITE}] ${RED}Install Windows 11${NC}"
    echo -e "${WHITE}[${RED}2${WHITE}] ${RED}Install Windows 10${NC}"
    echo -e "${WHITE}[${RED}3${WHITE}] ${RED}Exit${NC}"
    echo ""
}

install_win11() {
    clear
    echo -e "${RED}Installing Windows 11...${NC}"

    sudo apt update -y
    sudo apt install curl wget -y

    mkdir -p ~/windows11
    cd ~/windows11 || exit

    wget -O win11.sh https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/vm/windows11-vm.sh

    chmod +x win11.sh

    bash win11.sh
}

install_win10() {
    clear
    echo -e "${RED}Installing Windows 10...${NC}"

    sudo apt update -y
    sudo apt install curl wget -y

    mkdir -p ~/windows10
    cd ~/windows10 || exit

    wget -O win10.sh https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/vm/windows10-vm.sh

    chmod +x win10.sh

    bash win10.sh
}

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
            echo -e "${RED}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${DARK_RED}Invalid Option!${NC}"
            sleep 2
            ;;
    esac

done
