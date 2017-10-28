#!/bin/bash
clear;
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
echo "Welcome to the RPIInstaller automated installer script V1, by Aaron Becker.";
echo "This script will install all other scripts and packages necessary to run RPIInstaller in full.";
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

MAXSCRIPTTIME=86400;

set -e -u;

if [[ $(id -u) -ne 0 ]]
  then echo "Sorry, but it appears that you didn't run this script as root. Please run it as a root user!";
  exit 1;
fi
trap 'abort' 0;

START=$(date +%s);
elapsedseconds=0;
installall="false";
dir="";
hdirallow="true";
while true; do
    echo ""; read -p "What directory do you want the installer files to be located in? (Defaults to /home/pi if nothing entered): " ans;
    if [ "$ans" = "" ] || [ "$ans" = " " ]; then
        if [ "$hdirallow" = "true" ]; then
            echo "Default directory selected. Testing default directory (just in case)...";
            if [ -d "/home/pi" ]; then
                echo "Directory /home/pi is valid.";
                dir="/home/pi/";
                break;
            else
                echo "The default directory (/home/pi) is not a valid directory. Please enter a valid directory.";
                hdirallow="false";
            fi
        else
            echo "The default directory is not valid. Please enter a valid directory.";
        fi
    else
        echo "Testing directory: $ans...";
        if [ -d "$ans" ]; then
            echo "Directory '$ans' invalid. Please try again.";
        else
            echo "Directory '$ans' does exist!"; 
            dir=$ans;
            break;
        fi
    fi
done
dir=${dir%/}; #remove trailing slash
while true; do
    echo ""; read -p "Do you want to run all install scripts automatically? " ans;
    case $ans in
        [Yy]* ) echo "Automatic package install selected."; installall="true"; break;;
        [Nn]* ) echo "Manual package install selected."; installall="false"; break;;
        * ) echo "Please answer yes or no (or just y or n).";;
    esac
done
echo "Step 1/5: Installing required packages...";
sudo apt-get install -y git;
#old package cmd which doesnt exist;
echo "Packages installed successfully.";
echo "Step 2/5: Downloading Installer files...";
cd $dir;
if ! [ -d "RPIInstaller" ]; then
    echo "RPIInstaller directory doesn't exist. Downloading fresh...";
    sudo git clone https://github.com/aaroexxt/RPIInstaller.git;
else
    while true; do
    read -p "RPIInstaller directory already exists. Would you like to replace it with a new copy? " ans;
    case $ans in
        [Yy]* ) echo "Downloading new copy..."; sudo rm -r "RPIInstaller"; sudo git clone https://github.com/aahaxor/RPIInstaller.git; break;;
        [Nn]* ) echo "Not downloading new copy. This may cause issues if there is scripts that you don't want run in the folder.";  break;;
        * ) echo "Please answer yes or no (or just y or n).";;
    esac
done
cd RPIInstaller;
echo "Installer files downloaded successfully.";
if [ "$installall" = "true" ]; then
    shopt -s nullglob;
    filesdir="${dir}/RPIInstaller/*";
    echo "Running files from directory $filesdir";
    for file in $filesdir
    do
        echo "File running: $file";
        if ! [ "$file" = "install.sh" ]; then
            sudo bash "$file";
            #sh -c '(sleep $MAXSCRIPTTIME; kill "$$" || echo "WARNING: No process found with number $$") & exec sleep 1'
        fi
    done
    shopt -u nullglob;
    echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
    echo "All installer scripts have been run successfully.";
else
    echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
    echo "Your machine is now ready to run all installer scripts. If you are not currently in the directory where the RPIInstaller folder is located, navigate there. Then, run the script that you would like to use, using sudo bash ./filenamehere.sh. (Without period at end) Thank you for using RPIInstaller!";
fi
END=$(date +%s);
echo -n "Time: ";
echo $((END-START)) | awk '{print int($1/3600)"h:"int($1/60)"m:"int($1%60)"s"}';
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
trap : 0