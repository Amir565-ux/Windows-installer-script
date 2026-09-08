#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to display the header
display_header() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo -e "║${WHITE}${BOLD}     ██████╗  ██████╗ ██████╗ ██╗███╗   ██╗ ██████╗     ${CYAN}║"
    echo -e "║${WHITE}${BOLD}    ██╔════╝ ██╔═══██╗██╔══██╗██║████╗  ██║██╔════╝     ${CYAN}║"
    echo -e "║${WHITE}${BOLD}    ██║      ██║   ██║██║  ██║██║██╔██╗ ██║██║  ███╗    ${CYAN}║"
    echo -e "║${WHITE}${BOLD}    ██║      ██║   ██║██║  ██║██║██║╚██╗██║██║   ██║    ${CYAN}║"
    echo -e "║${WHITE}${BOLD}    ╚██████╗ ╚██████╔╝██████╔╝██║██║ ╚████║╚██████╔╝    ${CYAN}║"
    echo -e "║${WHITE}${BOLD}     ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝     ${CYAN}║"
    echo -e "║${WHITE}${BOLD}                                                            ${CYAN}║"
    echo -e "║${WHITE}${BOLD}    ██████╗  ██████╗ ██╗   ██╗███████╗                   ${CYAN}║"
    echo -e "║${WHITE}${BOLD}    ██╔══██╗██╔═══██╗╚██╗ ██╔╝╚══███╔╝                   ${CYAN}║"
    echo -e "║${WHITE}${BOLD}    ██████╔╝██║   ██║ ╚████╔╝   ███╔╝                    ${CYAN}║"
    echo -e "║${WHITE}${BOLD}    ██╔══██╗██║   ██║  ╚██╔╝   ███╔╝                     ${CYAN}║"
    echo -e "║${WHITE}${BOLD}    ██████╔╝╚██████╔╝   ██║   ███████╗                   ${CYAN}║"
    echo -e "║${WHITE}${BOLD}    ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝                   ${CYAN}║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}${BOLD}              ✦ SUBSCRIBE TO CODINGBOYZ ✦${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Function to check cloudflared installation
check_cloudflared() {
    if ! command -v cloudflared &> /dev/null; then
        echo -e "${RED}[✗] Cloudflared is not installed!${NC}"
        echo -e "${YELLOW}[!] Please install it first (Option 1)${NC}"
        return 1
    fi
    return 0
}

# Function to install Cloudflare
install_cloudflare() {
    clear
    echo -e "${YELLOW}${BOLD}[+] Installing Cloudflare (cloudflared)...${NC}"
    echo ""
    
    if command -v cloudflared &> /dev/null; then
        echo -e "${GREEN}[✓] Cloudflared is already installed!${NC}"
        cloudflared --version
        echo ""
        read -p "Press Enter to continue..."
        return
    fi
    
    # Detect architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            ARCH="amd64"
            ;;
        aarch64)
            ARCH="arm64"
            ;;
        *)
            echo -e "${RED}[✗] Unsupported architecture: $ARCH${NC}"
            read -p "Press Enter to continue..."
            return
            ;;
    esac
    
    echo -e "${CYAN}[*] Detected architecture: $ARCH${NC}"
    echo -e "${CYAN}[*] Downloading cloudflared...${NC}"
    
    # Download latest version
    curl -L --output cloudflared "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH}"
    
    # Make executable
    chmod +x cloudflared
    
    # Move to /usr/local/bin
    sudo mv cloudflared /usr/local/bin/
    
    if command -v cloudflared &> /dev/null; then
        echo -e "${GREEN}[✓] Cloudflared installed successfully!${NC}"
        cloudflared --version
    else
        echo -e "${RED}[✗] Installation failed${NC}"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to setup Zero Trust Tunnel
setup_zero_trust_tunnel() {
    clear
    echo -e "${YELLOW}${BOLD}[+] Setting up Cloudflare Zero Trust Tunnel${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if ! check_cloudflared; then
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${CYAN}[*] Step 1: Login to Cloudflare Zero Trust${NC}"
    echo -e "${YELLOW}[!] A browser window will open. Login and select your domain.${NC}"
    echo -e "${YELLOW}[!] If no browser, copy the URL and open it manually.${NC}"
    echo ""
    read -p "Press Enter to start login..."
    
    cloudflared tunnel login
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}[✗] Login failed!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo ""
    echo -e "${GREEN}[✓] Login successful!${NC}"
    echo ""
    echo -e "${CYAN}[*] Step 2: Create a Tunnel${NC}"
    echo -e "${CYAN}[*] Enter a name for your tunnel (e.g., my-tunnel):${NC} "
    read tunnel_name
    
    if [ -z "$tunnel_name" ]; then
        tunnel_name="my-tunnel"
    fi
    
    echo -e "${CYAN}[*] Creating tunnel: $tunnel_name${NC}"
    cloudflared tunnel create $tunnel_name
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}[✗] Tunnel creation failed!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${GREEN}[✓] Tunnel created successfully!${NC}"
    
    # Get tunnel ID
    tunnel_id=$(cloudflared tunnel list | grep $tunnel_name | awk '{print $1}')
    echo -e "${CYAN}[*] Tunnel ID: $tunnel_id${NC}"
    echo ""
    
    echo -e "${CYAN}[*] Step 3: Configure the Tunnel${NC}"
    echo -e "${CYAN}[*] Enter your domain (e.g., example.com):${NC} "
    read domain
    
    if [ -z "$domain" ]; then
        echo -e "${RED}[✗] Domain cannot be empty!${NC}"
        echo -e "${YELLOW}[!] You can add domain later manually${NC}"
        domain="example.com"
    fi
    
    echo -e "${CYAN}[*] Enter local service (e.g., http://localhost:8080):${NC} "
    read service
    
    if [ -z "$service" ]; then
        service="http://localhost:8080"
    fi
    
    # Create config directory
    mkdir -p ~/.cloudflared
    
    # Create config file
    echo -e "${CYAN}[*] Creating configuration file...${NC}"
    cat > ~/.cloudflared/config.yml << EOF
tunnel: $tunnel_id
credentials-file: /root/.cloudflared/$tunnel_id.json

ingress:
  - hostname: $domain
    service: $service
  - hostname: www.$domain
    service: $service
  - service: http_status:404
EOF
    
    echo -e "${GREEN}[✓] Configuration created at ~/.cloudflared/config.yml${NC}"
    echo ""
    
    echo -e "${CYAN}[*] Step 4: Configure DNS Records${NC}"
    echo -e "${CYAN}[*] Routing DNS for $domain...${NC}"
    
    cloudflared tunnel route dns $tunnel_name $domain
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓] Domain routed successfully!${NC}"
    else
        echo -e "${YELLOW}[!] DNS routing failed. Please add CNAME manually:${NC}"
        echo -e "${WHITE}    $domain → $tunnel_id.cfargotunnel.com${NC}"
    fi
    
    # Add www subdomain
    cloudflared tunnel route dns $tunnel_name www.$domain
    echo ""
    
    echo -e "${CYAN}[*] Step 5: Run the Tunnel${NC}"
    echo -e "${YELLOW}[!] Choose how to run the tunnel:${NC}"
    echo -e "  ${GREEN}[1]${NC} As a system service (recommended)"
    echo -e "  ${GREEN}[2]${NC} Run manually in background"
    echo -e "  ${GREEN}[3]${NC} Just show me the command"
    echo ""
    read -p "Select option [1-3]: " run_option
    
    case $run_option in
        1)
            echo -e "${CYAN}[*] Installing as system service...${NC}"
            sudo cloudflared service install
            sudo systemctl start cloudflared
            sudo systemctl enable cloudflared
            echo -e "${GREEN}[✓] Service installed and started!${NC}"
            echo -e "${CYAN}[*] Check status: sudo systemctl status cloudflared${NC}"
            ;;
        2)
            echo -e "${CYAN}[*] Running tunnel in background...${NC}"
            nohup cloudflared tunnel run $tunnel_name > /dev/null 2>&1 &
            echo -e "${GREEN}[✓] Tunnel running in background!${NC}"
            ;;
        3)
            echo -e "${CYAN}[*] Run this command manually:${NC}"
            echo -e "${WHITE}    cloudflared tunnel run $tunnel_name${NC}"
            ;;
        *)
            echo -e "${RED}[✗] Invalid option!${NC}"
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}[✓] Zero Trust Tunnel Setup Complete!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}[*] Your site will be accessible at: https://$domain${NC}"
    echo -e "${CYAN}[*] Tunnel Name: $tunnel_name${NC}"
    echo -e "${CYAN}[*] Tunnel ID: $tunnel_id${NC}"
    echo -e "${CYAN}[*] Config: ~/.cloudflared/config.yml${NC}"
    echo ""
    echo -e "${YELLOW}[!] Important Notes:${NC}"
    echo -e "  1. Make sure your local service is running on $service"
    echo -e "  2. DNS propagation may take a few minutes"
    echo -e "  3. Check logs: sudo journalctl -u cloudflared -f"
    echo ""
    read -p "Press Enter to continue..."
}

# Function to connect VPS with Domain (Quick Setup)
connect_vps_domain() {
    clear
    echo -e "${YELLOW}${BOLD}[+] Quick Connect VPS with Domain${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if ! check_cloudflared; then
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${CYAN}[*] This will guide you through connecting your VPS to a domain${NC}"
    echo -e "${CYAN}[*] using Cloudflare Zero Trust Tunnel${NC}"
    echo ""
    echo -e "${YELLOW}[!] Requirements:${NC}"
    echo -e "  1. Domain added to Cloudflare"
    echo -e "  2. Local service running on VPS"
    echo ""
    read -p "Press Enter to continue..."
    
    # Call the Zero Trust setup
    setup_zero_trust_tunnel
}

# Function to disconnect
disconnect() {
    clear
    echo -e "${YELLOW}${BOLD}[+] Disconnecting Cloudflare Tunnel...${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if ! check_cloudflared; then
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${CYAN}[*] Current tunnels:${NC}"
    cloudflared tunnel list
    echo ""
    
    echo -e "${YELLOW}[!] Options:${NC}"
    echo -e "  ${GREEN}[1]${NC} Stop service only"
    echo -e "  ${GREEN}[2]${NC} Delete a specific tunnel"
    echo -e "  ${GREEN}[3]${NC} Delete all tunnels"
    echo -e "  ${GREEN}[4]${NC} Cancel"
    echo ""
    read -p "Select option [1-4]: " disc_option
    
    case $disc_option in
        1)
            echo -e "${CYAN}[*] Stopping cloudflared service...${NC}"
            sudo systemctl stop cloudflared
            sudo systemctl disable cloudflared
            echo -e "${GREEN}[✓] Service stopped!${NC}"
            ;;
        2)
            echo -e "${CYAN}[*] Enter tunnel name to delete:${NC} "
            read tunnel_name
            if [ ! -z "$tunnel_name" ]; then
                sudo systemctl stop cloudflared
                cloudflared tunnel delete $tunnel_name
                echo -e "${GREEN}[✓] Tunnel '$tunnel_name' deleted!${NC}"
            fi
            ;;
        3)
            echo -e "${YELLOW}[!] This will delete ALL tunnels. Are you sure? (y/n):${NC} "
            read confirm
            if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
                sudo systemctl stop cloudflared
                sudo systemctl disable cloudflared
                for tunnel in $(cloudflared tunnel list | grep -v 'ID' | awk '{print $1}'); do
                    cloudflared tunnel delete $tunnel
                done
                echo -e "${GREEN}[✓] All tunnels deleted!${NC}"
            fi
            ;;
        4)
            return
            ;;
        *)
            echo -e "${RED}[✗] Invalid option!${NC}"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to show tunnel status
show_status() {
    clear
    echo -e "${YELLOW}${BOLD}[+] Tunnel Status${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if ! check_cloudflared; then
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${CYAN}[*] Tunnel List:${NC}"
    cloudflared tunnel list
    echo ""
    
    echo -e "${CYAN}[*] DNS Routes:${NC}"
    for tunnel in $(cloudflared tunnel list | grep -v 'ID' | awk '{print $1}'); do
        cloudflared tunnel route list $tunnel
    done
    echo ""
    
    echo -e "${CYAN}[*] Service Status:${NC}"
    sudo systemctl status cloudflared --no-pager -l | head -20
    echo ""
    
    read -p "Press Enter to continue..."
}

# Main menu function
show_menu() {
    while true; do
        display_header
        echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║${NC}                        ${WHITE}${BOLD}MAIN MENU${NC}                          ${CYAN}║${NC}"
        echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║${NC}                                                            ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC}   ${GREEN}[1]${NC} ${WHITE}Install Cloudflare${NC}                                    ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC}   ${GREEN}[2]${NC} ${WHITE}Setup Zero Trust Tunnel${NC}                               ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC}   ${GREEN}[3]${NC} ${WHITE}Connect VPS with Domain (Quick)${NC}                       ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC}   ${GREEN}[4]${NC} ${WHITE}Show Tunnel Status${NC}                                    ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC}   ${GREEN}[5]${NC} ${WHITE}Disconnect${NC}                                            ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC}   ${GREEN}[6]${NC} ${RED}Exit${NC}                                                 ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC}                                                            ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}${BOLD}[?] Select an option [1-6]:${NC} "
        read option
        
        case $option in
            1)
                install_cloudflare
                ;;
            2)
                setup_zero_trust_tunnel
                ;;
            3)
                connect_vps_domain
                ;;
            4)
                show_status
                ;;
            5)
                disconnect
                ;;
            6)
                clear
                echo -e "${GREEN}${BOLD}"
                echo "======================================================"
                echo "  Thanks for using CodingBoyz Cloudflare Manager!"
                echo "  Don't forget to Subscribe to CodingBoyz!"
                echo "======================================================"
                echo -e "${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[✗] Invalid option! Please select 1-6${NC}"
                sleep 2
                ;;
        esac
    done
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[✗] Please run as root (sudo $0)${NC}"
    exit 1
fi

# Start the script
show_menu
