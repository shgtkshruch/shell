#!/bin/bash
#
# Download slide and create pdf and note

# Variables
echo "Slideshare URL:"
read URL
DATE=$(date +%Y%m%d)
SLIDE_TITLE=`curl "${URL}" | grep \<title\> | gsed 's/\  <title>//' | gsed 's/<\/title>//'`
FOLDER_NAME="${DATE} ${SLIDE_TITLE}"
NOTEBOOK="0302 schoo"

# functions
get_slide(){
  python ~/bin/slideshare-download.py "${URL}"

  # rename_folder
  mv $HOME/slide $HOME/"${FOLDER_NAME}"

  # rename slide image files
  cd $HOME/"${FOLDER_NAME}"
  rename -s - -0 slide-[1-9]-1024.jpg

  # sum image size
  IMAGE_SIZE=`ls -lh | awk '{print $5}' | gsed 's/K//g' | awk '{sum+=$1} END{print sum}'`
}

image_to_pdf(){
  convert *.jpg "${SLIDE_TITLE}".pdf
  wait
  rm *.jpg
}

move_folder(){
  mv $HOME/"${FOLDER_NAME}" $HOME/Documents/schoo
}

create_note(){
  export NOTE_TITILE="${SLIDE_TITLE}"
  geeknote create --title "${NOTE_TITILE}" --content " " --notebook "${NOTEBOOK}" --tags "slide"
}

# start
cd

get_slide
wait

move_folder

if [ "${IMAGE_SIZE}" -gt 8000 ]; then
  open -a Preview.app $HOME/Documents/schoo/"${FOLDER_NAME}"/*.jpg
  echo "${SLIDE_TITLE}" | pbcopy
else
  cd $HOME/Documents/schoo/"${FOLDER_NAME}"
  image_to_pdf
fi

create_note
