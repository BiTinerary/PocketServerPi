#!/bin/bash
# All credits to my boy over at https://github.com/MitchRatquest
# Install all missing dependencies, install noVNC. Which gives you SSH access of desktop, CLI, etc.. in a browser.
# https://github.com/novnc/noVNC
# !!CAUTION!! This could take upwards of an hour to install if numpy needs to be compiled !!
# (which is the case when running Armbian on NanoPiNeoAir)
# gather the berries
#
install=""
if ! [ -x "$(command -v xterm)" ]; then
  echo 'Error: xterm needs to be installed.' >&2
  install="$install xterm"
fi
if ! [ -x "$(command -v Xvfb)" ]; then
  echo 'Error: xvfb needs to be installed.' >&2
  install="$install xvfb"
fi
if ! [ -x "$(command -v pip)" ]; then
  echo 'Error: pip needs to be installed.' >&2
  install="$install python-pip"
fi
if ! [ -x "$(command -v x11vnc)" ]; then
  echo 'Error: x11vnc needs to be installed.' >&2
  install="$install x11vnc"
fi
if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git needs to be installed.' >&2
  install="$install git"
fi
if ! [ -x "$(command -v screen)" ]; then
  echo 'Error: git needs to be installed.' >&2
  install="$install screen"
fi
if [ $( python -c 'import pkgutil; print(1 if pkgutil.find_loader("numpy") else 0)' ) == 0 ]
then
   echo 'Error: numpy needs to be installed.' >&2
   install="$install python-numpy"
fi

if [ -z $install ] #if the string is empty
then
        echo "dependencies met"
else
        sudo apt-get update && sudo apt-get -y install $install #get the goods
fi

if ! [ -x "$(command -v websockify)" ]; then
  echo 'Error: websockify needs to be installed.' >&2
  sudo pip install websockify
fi

cd ~
if [ ! -d "noVNC" ] #if directory doesn't exist
then
  git clone https://github.com/novnc/noVNC.git
fi


#Xvfb :1 -screen 0 800x600x16
screen -dmS yams Xvfb :1 -screen 0 800x600x16 +extension RANDR #for running luakit or anything requiring randr
sleep 1 &
screen -dmS x11 x11vnc -forever -display :1  & #simple
sleep 1 &
screen -dmS novnc bash ~/noVNC/utils/launch.sh --vnc localhost:5900 & #also pretty straightforward
DISPLAY=:1 xterm +sb -bg black -fg white -geometry 132x46 & #some nice settings for 800x600
echo "------------------"
echo "please go to this webpage: " 
echo $( hostname -I | sed -e 's/[[:space:]]*$//' )":6080/vnc.html"
echo "------------------"
###############
#NOTES
#if you want to stop this: killall screen

#DISPLAY=:1 xterm & #set env to display so it actually outputs
#DISPLAY=:1 luakit
