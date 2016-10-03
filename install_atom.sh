#!/bin/bash

# -------------------------------------------------------
# Info:
# 	Miroslav Vidovic
# 	install_atom.sh
# 	20.03.2016.-15:20:30
# -------------------------------------------------------
# Description:
#   Script to manage atom editor plugins and configuration.
# Usage:
#   bash install_atom.sh
# -------------------------------------------------------
# Script:

# File containing the names of the selected packages that
# I use with every atom installation
PLUGINS_FILE=plugins_file.txt

# Separator line
separator(){
  printf "%0.s-" {1..80}
  printf "\n"
}

# Copy configuration files to atom directory
copy_conf_files(){
  echo "--- Setting up conf files ---"
  separator
  cp -v config.cson keymap.cson snippets.cson styles.less ~/.atom
}

# Install plugins from a text file
# If a plugin name starts with # that means that the plugin is currently disabled
# and the script won't install the plugin. For total removal just delete the
# plugin from the list.
install_plugins_from_file(){
  echo "--- Installing plugins/packages ---"
  separator
  cat $PLUGINS_FILE | while read plugin
  do
    if [[ $plugin == \#* ]] ; then
      echo "Skipping: "
      echo $plugin
    else
      echo "Installing: "
      echo $plugin
      apm install $plugin --verbose
    fi
  done
}

main(){
  copy_conf_files
  install_plugins_from_file
}

main

exit 0
