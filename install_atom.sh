#!/bin/bash

# -------------------------------------------------------
# Info:
# 	Miroslav Vidovic
# 	install_atom.sh
# 	20.03.2016.-15:20:30
# -------------------------------------------------------
# Description:
#   Script to manage atom editor installation and plugin
#   downloading.
# Usage:
#   bash install_atom.sh
# -------------------------------------------------------
# Script:

separator(){
  echo "-----------------------------------------------------------------------"
  echo ""
}

# Download atom editor
download_atom(){
  echo "--- Downloading atom editor ---"
  separator
  wget https://atom.io/download/deb -O atom_editor.deb
}

# Install atom from the downloaded file
install_atom(){
  echo "--- Installing atom editor ---"
  separator
  sudo dpkg -i atom_editor.deb
}

# Remove the downloaded file
remove_file(){
  echo "--- Removing the downloaded file ---"
  separator
  rm atom_editor.deb
}

# Copy conf files to atom directory
copy_conf_files(){
  echo "--- Setting up conf files ---"
  separator
  cp config.cson keymap.cson snippets.cson styles.less ~/.atom
}

# Install plugins from text file
install_plugins_from_file(){
  echo "--- Installing plugins/packages ---"
  separator
cat plugins_file.txt | while read plugin
do
  apm install $plugin
done
}

main_function(){
  download_atom
  install_atom
  remove_file
  copy_conf_files
  install_plugins_from_file
}

main_function

exit 0
