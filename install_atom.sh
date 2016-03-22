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

os_version=$1

separator(){
  printf "%0.s-" {1..80}
  printf "\n"
}

# Download atom editor for ubuntu
download_atom_ubuntu(){
  echo "--- Downloading atom editor DEB file ---"
  separator
  wget https://atom.io/download/deb -O atom_editor.deb
}

# Download atom editor for fedora
download_atom_fedora(){
  echo "--- Downloading atom editor RPM file ---"
  separator
  wget https://atom.io/download/rpm -O atom_editor.rpm
}

# Install atom on ubuntu
install_atom_ubuntu(){
  echo "--- Installing atom editor DEB ---"
  separator
  sudo dpkg -i atom_editor.deb
}

# Install atom on fedora
install_atom_fedora(){
  echo "--- Installing atom editor RPM ---"
  separator
  su -c 'dnf install atom_editor.rpm'
}

# Remove the downloaded deb file
remove_file_ubuntu(){
  echo "--- Removing the downloaded DEB file ---"
  separator
  rm atom_editor.deb
}

# Remove the downloaded rpm file
remove_file_fedora(){
  echo "--- Removing the downloaded RMP file ---"
  separator
  rm atom_editor.rpm
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
  if [ $os_version = "--ubuntu" ]; then
    download_atom_ubuntu
    install_atom_ubuntu
    remove_file_ubuntu
    copy_conf_files
    install_plugins_from_file
  elif [ $os_version = "--fedora" ]; then
    download_atom_fedora
    install_atom_fedora
    remove_file_fedora
    copy_conf_files
    install_plugins_from_file
  else
    echo "Unknown os version."
    echo "Use --ubuntu or --fedora when running the script."
  fi

}

main_function

exit 0
