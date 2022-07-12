#!/bin/bash

OSU_PATH=~/.local/share/osu-stable/Songs
SOURCE_PATH=~/Downloads
OIFS=$IFS
IFS=$'\n'

for file in `find $SOURCE_PATH -type f -name "*.osz"`
do
	echo $file
	filename=$(basename "${file}" .osz)
	dir_path=$OSU_PATH/"${filename}"
	mkdir "$dir_path"
	unzip -o "$file" -d "$dir_path"
done

IFS=$OIFS
