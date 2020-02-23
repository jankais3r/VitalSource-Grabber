#!/bin/bash

if [ $# -eq 0 ]; then
	echo "You did not provide the book's IBAN. Rerun the script again like this:"
	echo "./watermark.sh 9781000710899"
	exit 1
else
	DIR=$HOME"/Downloads/"$1
fi

if [ -d "$DIR" ]; then
	cd "$DIR"
	mkdir raw
	mkdir clean
	
	mv *.png ./raw
	cd raw
	
	echo "Removing watermarks"
	for f in *.png
	do
		convert $f -fuzz 8% -fill white -opaque "#e6e6e6" ../clean/$f
	done
	
	cd ..
	cp -R clean numbered
	cd numbered
	
	echo "Numbering pages"
	for f in *.png
	do
		mogrify -fill black -undercolor white -pointsize 10 -gravity South -annotate +10+10 %t $f
	done
else
	echo "Directory $DIR does not exist."
	exit 1
fi