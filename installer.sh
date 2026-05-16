#!/bin/bash

clear

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Header
show_menu() {
    clear
    echo -e "${CYAN}_________________________________________________${NC}"
    echo -e "${GREEN}                Abdullah${NC}"
    echo -e "${CYAN}_________________________________________________${NC}"
    echo ""
    echo -e "${GREEN}________ Windows Installer Script ________${NC}"
    echo ""
    echo "1) Windows 11"
    echo "2) Windows 10"
    echo "3) Exit"
    echo ""
}

install_windows11() {
    echo "Starting Windows 11 installation..."

    sudo apt update -y
    sudo apt install curl wget -y

    mkdir -p ~/windows11
    cd ~/windows11

    wget -O win11.sh https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/vm/windows11-vm.sh

    chmod +x win11.sh

    echo "Running Windows 11 installer..."
    bash win11.sh
}

install_windows10() {
    echo "Starting Windows 10 installation..."

    sudo apt update -y
    sudo apt install curl wget -y

    mkdir -p ~/windows10
    cd ~/windows10

    wget -O win10.sh https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/vm/windows10-vm.sh

    chmod +x win10.sh

    echo "Running Windows 10 installer..."
    bash win10.sh
}

while true; do
    show_menu

    read -p "Select option: " choice

    case $choice in
        1)
            install_windows11
            ;;
        2)
            install_windows10
            ;;
        3)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option!${NC}"
            sleep 2
            ;;
    esac

done