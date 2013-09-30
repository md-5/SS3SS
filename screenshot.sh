#!/bin/sh

BUCKET="au.files.md-5.net/s"
URL_BASE="http://files.md-5.net/s"
FILE_DIR="$HOME/Pictures/Screenshots"
###############################################################################
###############################################################################
###############################################################################

while true
do
	FILE_NAME="$(cat /dev/urandom | tr -c -d '[:alnum:]' | head -c 4).png"
	FILE_PATH="$FILE_DIR/$FILE_NAME"
	if [ ! -f "$FILE_PATH" ]; then break; fi
done

mkdir -p "$FILE_DIR"
gnome-screenshot -a -f "$FILE_PATH"

if [ -f "$FILE_PATH" ]
then
	s3cmd sync "$FILE_DIR/" "s3://$BUCKET/"
	UPLOAD_URL="$URL_BASE/$FILE_NAME"
	echo -n "$UPLOAD_URL" | xsel -b -i
	notify-send Screenshot "$UPLOAD_URL copied to clipboard" -i "$FILE_PATH" -t 1000
fi
