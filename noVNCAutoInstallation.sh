#!/bin/bash
#added kill function
#run as:
#./SCRIPTNAME.sh k
#to kill these spawned processes 
#
#if you want to to be able to position your windows interactively:
#sudo apt-get -y install blackbox
#add this to the end of runvnc()
#blackbox -display :1 >/dev/null &>/devnull &
#or
#sudo apt-get install -y flwm
#DISPLAY=:1 flwm
function runvnc() {
    function check_this() {
      this=$1
      if ! [ -x "$(command -v $this)" ]; then
        echo 'Error: '$this' needs to be installed.' >&2
        install="$install $this"
      fi
    }

    install=""

    check_this xterm
    check_this x11vnc
    check_this git
    if ! [ -x "$(command -v pip)" ]; then
      echo 'Error: pip needs to be installed.' >&2
      install="$install python-pip"
    fi
    if ! [ -x "$(command -v Xvfb)" ]; then
      echo 'Error: xvfb needs to be installed.' >&2
      install="$install xvfb"
    fi
    if [ $( python -c 'import pkgutil; print(1 if pkgutil.find_loader("numpy") else 0)' ) ]
    then
       echo 'you have numpy installed, good.' >&2
    else
      echo 'Error: numpy needs to be installed.' >&2
      install="$install python-numpy"
    fi


    if [ -z "$install" ] #if the string is empty
    then
      echo "dependencies met"
    else
      sudo apt-get -y install $install #get the goods
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
    if [ -d "noVNC/utils/websockify" ] #packaged version novnc ships has issues
    then
      rm -R  noVNC/utils/websockify/
    fi

    nohup Xvfb :1 -screen 0 800x600x16 +extension RANDR >/dev/null 2>&1 &
    sleep 1
    nohup x11vnc -forever -display :1 >/dev/null 2>&1 &
    sleep 1
    nohup bash ~/noVNC/utils/launch.sh --vnc localhost:5900  >/dev/null 2>&1 & #also pretty straightforward
    sleep 1
    DISPLAY=:1 xterm +sb -bg black -fg white -geometry 132x46 &  #some nice settings for 800x600
    #you can change the line above to whatever x11 program you want, prepend DISPLAY=:1 to it and you're good to go
    echo "------------------"
    echo "please go to this webpage: "
    echo $( hostname -I | sed -e 's/[[:space:]]*$//' )":6080/vnc.html"
    echo "------------------"
    exit 1
}

function killer() {
    echo "killing all vnc stuff"
    kill $( pidof x11vnc ) 2&> /dev/null
    kill $( pidof Xvfb ) 2&> /dev/null
    kill $( pidof xterm ) 2&> /dev/null
    killall websockify 2&> /dev/null
    kill -9 `ps aux | grep 'basename "$0"' | awk '{print $2}'` 2&> /dev/null
    exit 1
}

case "$1" in
    k) killer
    ;;
    *) runvnc
    ;;
esac
