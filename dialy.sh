#!/bin/sh

echo "Note Title"
read TITLE
NOTE_NUM=0770
NEXT_NOTE_NUM=`expr "${NOTE_NUM}" + 1`
DATE=$(date +%Y/%m/%d)
NOTE_TITLE="${NOTE_NUM} ${TITLE} (${DATE})"
gsed_dialy() {
  gsed -i "${1}" ~/bin/dialy.sh
}

# create new note
geeknote create --notebook "04_Diary" --title "${NOTE_TITLE}" --content " "

# Add NOTE_NUM
gsed_dialy '5d'
gsed_dialy "5i\NOTE_NUM=0"${NEXT_NOTE_NUM}""

# edit note content
geeknote edit --note "${NOTE_TITLE}" --content "WRITE"
