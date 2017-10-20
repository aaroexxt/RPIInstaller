#!/bin/bash
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
echo "Welcome to the WebIOPi automated installer script V1, by Aaron Becker.";
echo "This script will install WebIOPI on your machine.";
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";

abort()
{
    echo >&2 '
***************
*** ABORTED ***
***************
'
    echo "An error occurred :( Exiting..." >&2
    exit 1;
}

set -e -u;

if [[ $(id -u) -ne 0 ]]
  then echo "Sorry, but it appears that you didn't run this script as root. Please run it as a root user!";
  exit 1;
fi
trap 'abort' 0;
echo "Step 1/7: Installing required packages...";
sudo apt-get update;
sudo apt-get upgrade;
sudo apt-get install -y avahi-daemon xdotool weavedconnectd;
echo "Installing packages successful.";
echo "Step 2/7: Creating directories for file storage...";
sudo mkdir /home/pi/webiopi;
cd /home/pi/webiopi;
mkdir python;
mkdir html;
echo "Making directories was successful.";
echo "Step 3/7: Downloading WebIOPi files...";
cd /home/pi;
curl -O WebIOPi-0.7.1.tar.gz https://downloads.sourceforge.net/project/webiopi/WebIOPi-0.7.1.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fwebiopi%2Ffiles%2F&ts=1508385100&use_mirror=astuteinternet;
echo "Step 4/7: Extracting from archive...";
tar xvzf WebIOPi-0.7.1.tar.gz;
echo "Archive extraction successful.";
echo "Step 5/7: Downloading patch file...";
cd WebIOPI-0.7.1;
wget https://raw.githubusercontent.com/doublebind/raspi/master/webiopi-pi2bplus.patch;
sudo patch -p1 -i webiopi-pi2bplus.patch;
echo "Patch of WebIOPi successful.";
echo "Step 6/7: Installing WebIOPi...";
sudo ./setup.sh;
echo "Step 7/7: Setting webiopi boot options and configuring new home directory (/home/pi/webiopi/html)...";
#Add replace line in config for new webiopi home dir
#sudo sed -i 's/.*/insert_new_here/' file.txt
sudo update-rc.d webiopi defaults;
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
echo "This installation of WebIOPi is finished. Thanks for using my script!";
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
trap : 0