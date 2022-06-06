#!/bin/bash

SDC=https://archive.org/download/stardict_collections/archives-english/en-head

install() {
  echo "Making $SHORT directory"
  mkdir -p ~/.pop-dictionary/dictionaries/"$SHORT"

  echo "Downloading $SHORT dictionary..."
  cd ~/.pop-dictionary/dictionaries/"$SHORT" &&
    wget $SDC/"$FILE" &&
    tar -xzvf "$FILE"

  echo "Installing icon $ICON"
  cp icons/"$ICON" ~/.pop-dictionary/dictionaries/"$SHORT"/
}

# Clone repo

git clone https://github.com/canadaduane/pop-dictionary.git ~/.pop-dictionary

# Install GoldenDict

flatpak install flathub org.goldendict.GoldenDict

# Install the Pop!_OS launcher

mkdir -p ~/.local/share/pop-launcher/plugins/
cp -r launcher-plugin-define/ ~/.local/share/pop-launcher/plugins/define
chmod +x ~/.local/share/pop-launcher/plugins/define/define

# American Heritage

FILE=American_Heritage_Dictionary_4th_Ed.tar.gz
SHORT=amerher
ICON=American_Heritage_Dictionary_4th_Ed.jpg
install

# Collins Thesaurus

FILE=Collins_Thesaurus.tar.gz
SHORT=collins
ICON=Collins_Thesaurus.png
install

# Oxford

FILE=Oxford_Advanced_Learner_s_Dictionary.tar.gz
SHORT=oxford
ICON=Oxford_Advanced_Learner_s_Dictionary.png
install

# WordNet

FILE=WordNet_3.tar.gz
SHORT=wordnet
ICON=WordNet_3.png
install

# Create new config for GoldenDict
cp ~/.pop-dictionary/goldendict-config ~/.var/app/org.goldendict.GoldenDict/.goldendict/config
