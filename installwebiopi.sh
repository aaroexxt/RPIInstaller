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

echo "Step 1/5: Downloading WebIOPi files...";

echo "Step 2/5: Extracting from archive...";
tar xvzf WebIOPi-x.y.z.tar.gz

echo "Step 3/5: Downloading patch file...";

echo "Step 4/5: Installing WebIOPi...";

echo "Step 5/5: Setting webiopi boot options...";

echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
echo "This installation of WebIOPi is finished. Thanks for using my script!";
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
trap : 0