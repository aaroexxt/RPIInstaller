#!/bin/bash
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
echo "Welcome to the MJPG-Streamer automated installer script V1, by Aaron Becker.";
echo "This script will install MJPG-Streamer on your machine.";
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
startstream="false";
while true; do
    read -p "Do you want to automatically start the stream once finished installing? " ans;
    case $ans in
        [Yy]* ) startstream="true"; echo "Stream will start after the video is finished installing."; break;;
        [Nn]* ) startstream="false"; echo "Stream will not start after video is finished installing."; break;;
        * ) echo "Please answer yes or no (or just y or n).";;
    esac
done
echo "Step 1/2: Installing required packages...";
sudo apt-get update;
sudo apt-get upgrade;
sudo apt-get install -y kmod-video-uvc python-openssl fswebcam mjpg-streamer;
echo "Installed packages successfully.";
echo "Step 2/2: Creating alias 'startmjpg'...";
echo -e "\nalias startmjpg='sudo mjpg_streamer -i \"input_uvc.so -d /dev/video0 -r 640x480 -f 25\" -o \"output_http.so -p 8080 -w /www/webcam\" &'" >> ~/.bash_aliases;
source ~/.bash_aliases;
echo "Created command alias 'startmjpg' successfully.";
if [ "$startstream" = "true" ]; then
    echo "Starting stream.";
    startmjpg;
fi

echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
echo "This installation of MJPG-Streamer is finished. Thanks for using my script!";
echo -e "To enable the server, type:\nstartmjpg\n--or--\nsudo mjpg_streamer -i \"input_uvc.so -d /dev/video0 -r 640x480 -f 25\" -o \"output_http.so -p 8080 -w /www/webcam\" &";
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
trap : 0