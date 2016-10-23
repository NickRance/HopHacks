#!/bin/bash

run_tor()
{
if [ ! -f "./tor-browser/Browser/start-tor-browser" ]
  then
    echo "File not found"
    wget https://www.torproject.org/dist/torbrowser/6.5a3-hardened/tor-browser-linux64-6.5a3-hardened_ALL.tar.xz
    tar -xvJf tor-browser-linux64-6.5a3-hardened_ALL.tar.xz
  else
    echo "File found"
fi
./tor-browser/Browser/start-tor-browser "https://lastpass.com/?ac=1" &
clear
draw_header
}

#Deletes all files in downloads newer than when this script was started
delete_files()
{
clear
echo "List of files to be cleaned"
find  ~ -type f  -newer timefile #-delete
while true; do
    read -p "Dump them?(y/n)" yn
    case $yn in
        [Yy]* ) echo "Deleting"; find  ~/Downloads -type f  -newer timefile -delete; break;;
        [Nn]* ) echo "Back to main menu";break;;
        * ) echo "Please answer yes or no.";;
    esac
done
clear
draw_header
}

draw_header()
{
cat logo.txt
echo "Start Time:  $now"
echo -e "1)Start Tor \n2)Scrub the OS\n3)Nuke this comp\n4)Quit" 
}

nuke_comp()
{
root_check
sudo apt-get install gparted
clear
cat bomb.txt
echo -e "\nThis can only be run from a live usb. This will format all hard drives connected to this system."
echo "PROCEEED WITH CAUTION"
echo "==========="
fdisk -l /dev/sda
echo -e "\e[32m \e[40m"
while true; do
    read -p "Enter 'pwn' to delete all of the above partitions:   " choice
    case $choice in
        [pwn]* ) echo "Pwning"; sleep 5s; break;; #Run script
        * ) echo "Back to main menu";break;;
    esac
done

#The below command scrubs the master boot record
#sudo dd if=/dev/zero of=/dev/sda bs=512 count=1 conv=notrunc

#This deletes all the partitions
#sudo shred -v -n1 -z /dev/sda1
#sudo shred -v -n1 -z /dev/sda2
#sudo shred -v -n1 -z /dev/sda3
#sudo shred -v -n1 -z /dev/sda4
#sudo shred -v -n1 -z /dev/sda5
clear
draw_header
}

root_check()
{
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
}

#Main Driver


#creates time file to store when the script starts
touch  timefile
echo -e "\e[32m \e[40m"
now=$(date +"%T")
clear
cat logo.txt
echo "Start Time:  $now"
PS3='Please enter your choice: '
options=("Start Tor" "Scrub the OS" "Nuke this comp" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Start Tor")
            run_tor
            ;;
        "Scrub the OS")
		delete_files
            ;;
        "Nuke this comp")
            nuke_comp
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

