#!/bin/bash

# get_slide
cd
echo "Slideshare URL:"
read URL
DATE=$(date +%Y%m%d)
SLIDE_TITLE=`curl "${URL}" | grep \<title\> | gsed 's/\  <title>//' | gsed 's/<\/title>//'`
python ~/bin/slideshare-download.py "${URL}"
wait

# rename_folder
FOLDER_NAME="${DATE} ${SLIDE_TITLE}"
mv ~/slide ~/"${FOLDER_NAME}"

# image_to_pdf
cd ~/"${FOLDER_NAME}"
rename -s - -0 slide-[1-9]-1024.jpg
convert *.jpg "${SLIDE_TITLE}".pdf
wait
rm *.jpg

# move_folder
cd
mv "${FOLDER_NAME}" ~/Documents/schoo

# geeknote
export NOTE_TITILE="${SLIDE_TITLE}"
geeknote create --title "${NOTE_TITILE}" --content " " --notebook "0302 schoo" --tags "slide"

