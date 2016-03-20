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
#
# -------------------------------------------------------
# Script:

# Download atom editor
download_atom(){
  echo "--- Downloading atom editor ---"
  echo "-------------------------------"
  wget https://atom.io/download/deb -O atom_editor.deb
}

# Install atom from the downloaded file
install_atom(){
  echo "--- Installing atom editor ---"
  echo "------------------------------"
  sudo dpkg -i atom_editor.deb
}

# Remove the downloaded file
remove_file(){
  echo "--- Removing the downloaded file ---"
  echo "------------------------------------"
  rm atom_editor.deb
}

# Navigate to atom directory
go_to_atom_dir(){
  cd ~/.atom
}

# Download the conf files from git
download_conf_files(){
  echo "--- Downloading the conf files ---"
  echo "----------------------------------"
  git clone https://github.com/miroslavvidovic/atom-configuration
}

# Replace the default conf files
replace_conf_files(){
  cp atom-configuration/* .
}

# Install plugins using the built in atom package manager
# Plugins are stored in an array and for each element in
# the array run the install command
# TODO: Add  UI themes and colorschemes to the installation
# TODO: Move plugin list to a file
install_plugins(){
  echo "--- Installing plugins/packages ---"
  echo "-----------------------------------"
  plugins=( autoclose-html color-picker emmet file-icons git-log git-plus git-status highlight-selected linter minimap todo-show )
  for plugin in ${plugins[@]}; do
    apm install $plugin
  done
}

main_program(){
  download_atom
  install_atom
  remove_file
  go_to_atom_dir
  download_conf_files
  replace_conf_files
  install_plugins
}

main_program

exit 0
