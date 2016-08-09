#!/bin/bash

#set -e
export MODE="KLAR"
export TMP_FOLDER=/home/pi/fotoboks/bilder
export GODKJ_FOLDER=/home/pi/fotoboks/bilder/godkjent

export APP_FOLDER=$(realpath $(dirname $0))
gpio omode 1 up
gpio mode 4 up
gpio mode 5 up
cd $TMP_FOLDER
x-www-browser $APP_FOLDER/klar.html &
while true 
do
        pkill gvfsd-gphoto2
	if [ "$MODE" == "KLAR" ]; then
 		BLAA=$(gpio read 1)
		if [ $BLAA -eq 0 ]; then
			x-www-browser $APP_FOLDER/vent.html
			sleep 3
			export MODE="KNIPS"
		fi
	fi
	if [ "$MODE" == "KNIPS" ]; then
		x-www-browser $APP_FOLDER/knips.html
		gphoto2 --capture-image-and-download
		filnavn=$(ls -1tr | tail -1)
		
		x-www-browser $TMP_FOLDER/$filnavn
		export MODE="GODKJENN"
	fi
	if [ "$MODE" == "GODKJENN" ]; then
 		GRONN=$(gpio read 4)
 		ROED=$(gpio read 5)
		if [ $ROED -eq 0 ]; then
			echo "Avvist"
			rm $filnavn
			filnavn=""
			x-www-browser $APP_FOLDER/avvist.html
			sleep 3
			x-www-browser $APP_FOLDER/klar.html
			export MODE="KLAR"
		fi
		if [ $GRONN -eq 0 ]; then
  			echo "Godkjent"
			mv $filnavn $GODKJ_FOLDER
			filnavn=""
			x-www-browser $APP_FOLDER/godkjent.html
			sleep 3
			x-www-browser $APP_FOLDER/klar.html
			export MODE="KLAR"
		fi
	fi
done
