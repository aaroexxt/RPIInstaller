# RPIInstaller
RPIInstaller is a simple collection of Shell scripts that I use to install a few programs that I use a lot on the Raspberry Pi. This script will allow you to install common utilities like OpenCV, WebIOPi, MJPG-Streamer and much more, without the hassle of using the command line.
# Installation - Command Line
Note: Do not include single quotes (') at the beginning of command when you are entering commands.
SSH into your machine, or open a terminal. Then navigate to the directory that you want the installer file to be located in (I usually use Downloads or Desktop folder. To navigate, use cd /path/to/directory. Then type 'wget https://raw.githubusercontent.com/aaroexxt/RPIInstaller/master/installer.sh' to download the file from github. Finally, use 'sudo bash /path/to/installer.sh' to run the installer file.;
# Installation - Graphical
Note: Do not include single quotes (') at the beginning of command when you are entering commands.
To use, navigate to https://github.com/aaroexxt/RPIInstaller in your browser of choice and simply download the installer.sh file to your machine. Run installer.sh using 'sudo bash /path/to/installer.sh' using your favorite terminal, and it will walk you through the installation.
# Footnotes
By Aaron Becker, 10/28/17. Version: V5! I am working on this, and will add more scripts to use in the future! All scripts tested on RPI B+ running Raspbian Jessie. If you are using NOOBS, the WebIOPi installation will not work :(. Finaly, I hope you enjoy :)
