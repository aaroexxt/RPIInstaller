#!/bin/bash
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
echo "Welcome to the RPIInstaller automated installer script V1, by Aaron Becker.";
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

set -e;

if [[ $(id -u) -ne 0 ]]
  then echo "Sorry, but it appears that you didn't run this script as root. Please run it as a root user!";
  exit 1;
fi
trap 'abort' 0;

installall="false";
while true; do
    read -p "Do you want to run all install scripts automatically? " ans;
    case $ans in
        [Yy]* ) echo "Automatic package install selected."; installall="true"; break;;
        [Nn]* ) echo "Manual package install selected."; installall="false"; break;;
        * ) echo "Please answer a Y or N.";;
    esac
done

echo "Step 1/5: Installing packages...";
sudo apt-get install -y git cmd;
echo "Packages installed successfully.";
echo "Step 2/5: Downloading Installer files...";
sudo git clone https://github.com/aahaxor/RPIInstaller.git;
cd RPIInstaller;
echo "Installer files downloaded successfully.";
if [ "$installall" = "true" ]; then
    for file in /home/pi/RPIInstaller/*
    do
      cmd "$file" >> results.out
    done
    echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
    echo "Your machine is now ready to run all installer scripts.";
    echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
fi
trap : 0