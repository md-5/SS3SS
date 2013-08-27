#!/bin/sh

BUCKET="au.files.md-5.net"
FILE_DIR="$HOME/Pictures/Screenshots"
###############################################################################
###############################################################################
###############################################################################
FILE_NAME="$(cat /dev/urandom | tr -c -d '[:alnum:]' | head -c 5).png"
FILE_PATH="$FILE_DIR/$FILE_NAME"

mkdir -p "$FILE_DIR"
gnome-screenshot -a -f "$FILE_PATH"

if [ -f "$FILE_PATH" ]
then
	s3cmd sync "$FILE_DIR/" "s3://$BUCKET"
	UPLOAD_URL="http://$BUCKET/$FILE_NAME"
	echo "$UPLOAD_URL" | xsel -b -i
	notify-send Screenshot "$UPLOAD_URL copied to clipboard" -i "$FILE_PATH" -t 1000
fi