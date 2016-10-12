#!/bin/sh

name="TV-Speakers"
user="username123"
passwd="password123"
bitrate="320"
device="sysdefault"

export CONNECT_DIR="/storage/spotifyConnect/spotify-connect-web"

## Configure sound card
. /etc/os-release

activate_card() {
  if [ -e "/proc/asound/$1" ]
  then
    return
  fi
  if [ "$LIBREELEC_ARCH" == "RPi2.arm" -a "$1" == "ALSA" ]
  then
    dtparam audio=on
    sleep 1
  else
    echo "Do not know how to activate card $1 on $LIBREELEC_ARCH"
    exit
  fi
}

if [ ! "$(cat /proc/asound/pcm 2> /dev/null)" ]
then
  if [ "$LIBREELEC_ARCH" == "RPi2.arm" ]
  then
    activate_card "ALSA"
  else
    echo "Do not how how to activate an audio interface on $LIBREELEC_ARCH"
    ko="ko"
  fi
fi

if [ "$ko" ]
then
  exit
fi

## Enable AUX audio output
amixer cset numid=3 1 # Remove this to use HDMI
amixer set PCM 100%

## Run Spotify Connect
cd $CONNECT_DIR
./spotify-connect-web --name $name --username $user --password $passwd --bitrate $bitrate --playback_device $device --dbrange 30