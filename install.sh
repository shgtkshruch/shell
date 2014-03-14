#!/bin/bash
#
# install some packages

### geeknote
### https://github.com/VitaliyRodnenko/geeknote

# Download the repository.
git clone git://github.com/VitaliyRodnenko/geeknote.git

cd geeknote

# Installation
sudo python setup.py install



### Dropbox-Uploader
### https://github.com/andreafabrizi/Dropbox-Uploader

# Download the repository.
git clone https://github.com/andreafabrizi/Dropbox-Uploader/

cd Dropbox-Uploader

# Then give the execution permission to the script and run it
chmod +x dropbox_uploader.sh
mv ~/bin
# ./dropbox_uploader.sh



### bash_completion

# hub
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
mv /usr/local/etc/bash_completion.d/
