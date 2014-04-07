#!/bin/sh
#
# Evernote diary

echo "Note Title"
read TITLE
NOTE_NUM=0792
NEXT_NOTE_NUM=`expr "${NOTE_NUM}" + 1`
NOTEBOOK="04_Diary"
DATE=$(date +%Y/%m/%d)
NOTE_TITLE="${NOTE_NUM} ${TITLE} (${DATE})"
gsed_diary() {
  gsed -i "${1}" ~/bin/diary.sh
}

# Create new note
geeknote create --notebook "${NOTEBOOK}" --title "${NOTE_TITLE}" --content " "

# Edit note content
geeknote edit --note "${NOTE_TITLE}" --content "WRITE"

# Add NOTE_NUM
gsed_diary '7d'
gsed_diary "7i\NOTE_NUM=0"${NEXT_NOTE_NUM}""
