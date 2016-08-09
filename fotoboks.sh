#!/bin/bash

#set -e
export MODE="KLAR"
export TMP_FOLDER=/home/pi/fotoboks/bilder
export GODKJ_FOLDER=/home/pi/fotoboks/bilder/godkjent/

export APP_BASEPATH="localhost:8080/static"
gpio mode 1 up
gpio mode 4 up
gpio mode 5 up
cd $TMP_FOLDER
firefox $APP_BASEPATH/klar.html &
while true 
do
        pkill gvfsd-gphoto2
	if [ "$MODE" == "KLAR" ]; then
 		BLAA=$(gpio read 1)
		if [ $BLAA -eq 0 ]; then
			firefox $APP_BASEPATH/knips.html
			sleep 3
			export MODE="KNIPS"
		fi
	fi
	if [ "$MODE" == "KNIPS" ]; then
		firefox $APP_BASEPATH/vent.html
		gphoto2 --capture-image-and-download
		filnavn=$(ls -1tr | tail -1)
		
		firefox $APP_BASEPATH/godkjenning.html
		export MODE="GODKJENN"
	fi
	if [ "$MODE" == "GODKJENN" ]; then
 		GRONN=$(gpio read 4)
 		ROED=$(gpio read 5)
		if [ $ROED -eq 0 ]; then
			echo "Avvist"
			rm $filnavn
			filnavn=""
			firefox $APP_BASEPATH/avvist.html
			sleep 3
			firefox $APP_BASEPATH/klar.html
			export MODE="KLAR"
		fi
		if [ $GRONN -eq 0 ]; then
  			echo "Godkjent"
			mv $filnavn $GODKJ_FOLDER
			filnavn=""
			firefox $APP_BASEPATH/godkjent.html
			sleep 3
			firefox $APP_BASEPATH/klar.html
			export MODE="KLAR"
		fi
	fi
done
