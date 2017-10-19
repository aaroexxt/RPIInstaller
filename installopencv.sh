#!/bin/bash
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
echo "Welcome to the OpenCV automated installer script V2, by Aaron Becker.";
echo "Commands originally from: https://www.pyimagesearch.com/2016/04/18/install-guide-raspberry-pi-3-raspbian-jessie-opencv-3/";
echo "This script will download, compile, and install OpenCV.";
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
py3=false;
pypkg="";
while true; do
    read -p "Do you want to use Python 2.7 or Python 3.4 to install OpenCV (answer 3 or 2 to select)? " ans;
    case $ans in
        [3]* ) py3="true"; echo "Python 3 selected."; pypkg=$(ls -l /usr/local/lib/python3.4/site-packages/); break;;
        [2]* ) py3="false"; echo "Python 2.7 selected."; pypkg=$(ls -l /usr/local/lib/python2.7/site-packages/); break;;
        * ) echo "Please answer a 3 or 2.";;
    esac
done
while true; do
    read -p "OpenCV takes a lot of space on the SD card. Do you want to remove WolframEngine to free up 700mb? It can be easily reinstalled later by using the command: sudo apt-get install wolfram-engine. (This is mostly for people with smaller SD cards.) " ans;
    case $ans in
        [Yy]* ) echo "WolframEngine will be removed."; sudo apt-get purge wolfram-engine; break;;
        [Nn]* ) echo "WolframEngine will not be removed."; break;;
        * ) echo "Please answer yes or no (or just y or n).";;
    esac
done
echo "Step: 1/12: Installing packages...";
sudo apt-get update;
sudo apt-get upgrade;
sudo apt-get install -y build-essential cmake pkg-config libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libgtk2.0-dev libatlas-base-dev gfortran python2.7-dev python3-dev;
echo "Installed packages for opencv successfully.";
cd ~;
echo "Step 2/12: Downloading opencv installer file...";
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.3.0.zip; unzip opencv.zip; echo "Downloaded & unzipped opencv.zip.";
cd ~;
echo "Step 3/12: Downloading opencv plugins installer file...";
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.3.0.zip; unzip opencv_contrib.zip;
echo "Downloaded & unzipped opencvcontrib.zip";
cd ~;
echo "Step 4/12: Installing pip...";
wget https://bootstrap.pypa.io/get-pip.py;
sudo python get-pip.py;
echo "Installed pip.";
echo "Step 5/12: Installing python virtual environment...";
sudo pip install virtualenv virtualenvwrapper;
sudo rm -rf ~/.cache/pip;
echo "Installed virtualenv and virtualenvwrapper";
echo "Step 6/12: Configuring python virtual environment...";
echo -e "\n# virtualenv and virtualenvwrapper" >> ~/.profile;
echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.profile;
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.profile;
source ~/.profile;
echo "Added virtualenv and vitualenvwrapper to bash profile.";
echo "Step 7/12: Creating python virtual environment..."
if [ "$py3" = "true" ] ; then
    echo "Python 3 virtual environment selected."; sudo mkvirtualenv cv -p python3;
else
    echo "Python 2.7 virtual environment selected."; sudo mkvirtualenv cv -p python2;
fi
echo "Created virtual python environment cv successfully. If you ever log out, please re-enter the virtual envionment using 'source ~/.profile; workon cv;'.";
echo "Step 8/12: Installing numpy (this might take a while)..."
pip install numpy;
echo "Installed numpy successfully.";
echo "Step 9/12: Setting up build of opencv...";
workon cv; cd ~/opencv-3.3.0/;
mkdir build;
cd build;
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.1.0/modules \
    -D BUILD_EXAMPLES=ON ..;
echo "Successfully set up build of opencv.";
echo "Step 10/12: Compiling opencv (this might take 1hr+ so be patient!)...";
make -j4;
echo "Successfully compiled OpenCV!";
echo "Step 11/12: Installing opencv from compiled scripts..."
sudo make install;
sudo ldconfig;
echo "Successfully installed OpenCV!";
echo "Step 12/12: Sym-linking opencv bindings into cv environment...";
$newpypkg="0";
if [ "$py3" = "true" ]; then
    cd /usr/local/lib/python3.4/site-packages/; sudo mv cv2.cpython-34m.so cv2.so; newpypkg=$(ls -l /usr/local/lib/python3.4/site-packages/); echo "Success sym-linking bindings for python 3";
else
    cd ~/.virtualenvs/cv/lib/python2.7/site-packages/; ln -s /usr/local/lib/python2.7/site-packages/cv2.so cv2.so; newpypkg=$(ls -l /usr/local/lib/python2.7/site-packages/); echo "Success sym-linking bindings for python 2.7";
fi
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
echo "Installer finished!";
echo "Check for successful install of OpenCV (second 'total number' should be greater than first 'total number'):";
echo $pypkg $newpypkg;
echo "This installation of OpenCV is finished. Thanks for using my script!";
echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-";
trap : 0