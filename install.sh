#!/bin/bash

SDC=https://archive.org/download/stardict_collections/archives-english/en-head
LOCAL="$HOME/.local/share/pop-dictionary"

install() {
  SHORTDIR="$LOCAL/dictionaries/$SHORT"
  echo "Making $SHORTDIR directory"
  mkdir -p "$SHORTDIR"

  echo "Downloading $SHORT dictionary..."
  cd "$SHORTDIR" &&
    wget -c "$SDC/$FILE" &&
    tar -xzvf "$FILE"

  echo "Installing icon $ICON"
  cp "$LOCAL/icons/$ICON" "$SHORTDIR/"
  
  echo "Removing $FILE tar archive"
  rm "$FILE"
}

# Clone repo
if [ -d "$LOCAL" ]; then
  (
    cd "$LOCAL"
    git pull
  )
else
  git clone https://github.com/canadaduane/pop-dictionary.git "$LOCAL"
fi

# Install GoldenDict
flatpak install --user flathub org.goldendict.GoldenDict
flatpak override org.goldendict.GoldenDict --user --filesystem=xdg-data:ro

# Edit the GoldenDict XML to include pop-dictionary/dictionaries path
# (Keep all other GoldenDict settings untouched)
python3 - <<'EOF'
import xml.etree.ElementTree as ET
import os

home = os.environ["HOME"]
config_file = home + "/.var/app/org.goldendict.GoldenDict/.goldendict/config"
dict_path = home + "/.local/share/pop-dictionary/dictionaries"

tree = ET.parse(config_file)
root = tree.getroot()

# Check if we need to add the ~/.local/share/pop-dictionary/dictionaries path
has_pop_dictionary = False
for path in root.find("paths").findall("path"):
  if path.text == dict_path:
    has_pop_dictionary = True

if has_pop_dictionary:
  print("Pop dictionaries path already in GoldenDict config")
else:
  print("Adding pop dictionaries path to GoldenDict config")

  # Since we need to add it, find the `paths` tag, and add a `path` tag under it
  paths = root.find("paths")
  if paths == None:
    paths = ET.SubElement(root, "paths")
  
  path = ET.SubElement(paths, "path")
  path.text = dict_path
  path.set("recursive", "1")

tree.write(config_file)
EOF


# Install the Pop!_OS launcher plugin
mkdir -p ~/.local/share/pop-launcher/plugins/
cp -r "$LOCAL/launcher-plugin-define/" ~/.local/share/pop-launcher/plugins/define
chmod +x ~/.local/share/pop-launcher/plugins/define/define

## Install English language dictionaries

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

