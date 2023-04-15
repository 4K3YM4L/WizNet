#!/bin/bash

# Install figlet if not already installed
if ! command -v figlet &> /dev/null
then
    sudo apt-get install -y figlet
fi

# Define an array of color codes
COLORS=("\033[0;31m" "\033[0;32m" "\033[0;33m" "\033[0;34m" "\033[0;35m" "\033[0;36m")

# Define the reset color code
RESET_COLOR="\033[0m"

# Prompt for IP address
read -p "Do you want to use your local IP? (Y/N): " use_local_ip

if [[ $use_local_ip == "Y" || $use_local_ip == "y" ]]; then
  ip=$(hostname -I | awk '{print $1}')
  
else
  read -p "Enter IP address to lookup: " ip
fi


# Loop to perform multiple lookups
while true
do
# Wiznet title in ASCII art
echo -e "\e[1;31m"
cat << "EOF"

'|| '||'  '|'  ||          '|.   '|'           .   
 '|. '|.  .'  ...  ......   |'|   |    ....  .||.  
  ||  ||  |    ||  '  .|'   | '|. |  .|...||  ||   
   ||| |||     ||   .|'     |   |||  ||       ||   
    |   |     .||. ||....| .|.   '|   '|...'  '|.' 

EOF
echo -e "\033[0m"

# Green color for the menu
GREEN='\033[0;32m'
RESET_COLOR='\033[0m'
echo " IP Address: $ip"
echo -e "${GREEN}+========================================+"
echo "| 1.  Dig                                |"
echo "| 2.  Host                               |"
echo "| 3.  Whois                              |"
echo "| 4.  NSLookup                           |"
echo "| 5.  Traceroute                         |"
echo "| 6.  Nmap                               |"
echo "| 7.  Netcat                             |"
echo "| 8.  Tcpdump                            |"
echo "| 9.  Exit                               |"
echo "+========================================+"
    read -p "Enter a number (1-9): " lookup_type

    # Check if user wants to exit
    if [[ "$lookup_type" == "9" ]]
    then
        echo "Exiting..."
        break
    fi

    # Select a random color code from the array
    color=${COLORS[$RANDOM % ${#COLORS[@]}]}

    # Determine the figlet font to use based on the selected lookup type
    case $lookup_type in
        1) figlet -f slant "Dig Lookup"
           echo -e "${color}Performing dig lookup for ${ip}...${RESET_COLOR}"
           dig "$ip"
           ;;
        2) figlet -f slant "Host Lookup"
           echo -e "${color}Performing host lookup for ${ip}...${RESET_COLOR}"
           host "$ip"
           ;;
        3) figlet -f slant "Whois Lookup"
           echo -e "${color}Performing whois lookup for ${ip}...${RESET_COLOR}"
           whois "$ip"
           ;;
        4) figlet -f slant "NSLookup"
           echo -e "${color}Performing nslookup for ${ip}...${RESET_COLOR}"
           nslookup "$ip"
           ;;
        5) figlet -f slant "Traceroute"
           echo -e "${color}Performing traceroute for ${ip}...${RESET_COLOR}"
           traceroute "$ip"
           ;;
        6) figlet -f slant "Nmap"
           echo -e "${color}Performing nmap scan for ${ip}...${RESET_COLOR}"
           read -p "Enter additional options (leave blank for default scan): " nmap_options
           nmap $nmap_options "$ip"
           ;;
        7) figlet -f slant "Netcat"
           echo -e "${color}Performing netcat connection to ${ip}...${RESET_COLOR}"
           read -p "Enter additional options (leave blank for default connection): " nc_options
           nc $nc_options "$ip"
           ;;
        8) figlet -f slant "Tcpdump"
           echo -e "${color}Capturing network traffic for ${ip}...${RESET_COLOR}"
           read -p "Enter additional options (leave blank for default capture): " tcpdump_options
           if [[ -z "$tcpdump_options" ]]
     then
          sudo tcpdump -i eth0
     else
          sudo tcpdump $tcpdump_options -i eth0
   fi
   ;;

   *) echo "Invalid input"
       ;;
esac

echo ""

done
