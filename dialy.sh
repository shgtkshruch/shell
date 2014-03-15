#!/bin/sh
#
# Evernote dialy

# Initial setting
echo "Note Title"
read TITLE
NOTEBOOK="04_Dialy"
NOTE_NUM=0771
NEXT_NOTE_NUM=`expr "${NOTE_NUM}" + 1`
DATE=$(date +%Y/%m/%d)
NOTE_TITLE="${NOTE_NUM} ${TITLE} (${DATE})"
gsed_dialy() {
  gsed -i "${1}" ~/bin/dialy.sh
}

# Create new note
geeknote create --notebook "${NOTEBOOK}" --title "${NOTE_TITLE}" --content " "

# Add NOTE_NUM
gsed_dialy '5d'
gsed_dialy "5i\NOTE_NUM=0"${NEXT_NOTE_NUM}""

# Edit note content
geeknote edit --note "${NOTE_TITLE}" --content "WRITE"
