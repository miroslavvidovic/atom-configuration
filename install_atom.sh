#!/bin/bash

# -------------------------------------------------------
# Info:
# 	Miroslav Vidovic
# 	install_atom.sh
# 	20.03.2016.-15:20:30
# -------------------------------------------------------
# Description:
#   Script to manage atom editor installation. Script can
#   be used to download and install atom editor and the
#   selected plugins for fedora and ubuntu. Script can also
#   just install or update the selected atom editor packages.
# Usage:
#   bash install_atom.sh --action
# -------------------------------------------------------
# Script:

# Specified action
action=$1
# File containing the names of the selected pacakges that
# I use with every atom installation
plugins_file=plugins_file.txt

# Separator line
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

# Check the plugins that are allready installed in atom editor
check_installed_plugins(){
  # temp file
  tmp_installed_plugins=$(mktemp)
  # write plugin names to temp file but skitp the readme file
  ls ~/.atom/packages | grep -v README.md > $tmp_installed_plugins
  # read temp file - not needed for now
  #cat $tmp_file1 | while read plugin
  #do
  #  echo $plugin
  #done
}

# Sort the plugins file for comparison
sort_plugins_file(){
  tmp_selected_plugins=$(mktemp)
  cat $plugins_file | sort > $tmp_selected_plugins
}

# Compare list of installed packages and a list of selected packages
# (plugins_list.txt)
diff_installed_and_listed(){
  tmp_to_be_installed=$(mktemp)
  # comm command is used with flags -13:
  # -3 suppress lines that appear in both files
  # -1 suppress lines that are unique to file 1
  comm -13 $tmp_installed_plugins $tmp_selected_plugins > $tmp_to_be_installed
}

# Install plugins from a text file
# If a plugin name starts with # that means that the plugin is currently disabled
# and the script won't install the plugin. For total removal just delete the
# plugin from the list.
install_plugins_from_file(){
  echo "--- Installing plugins/packages ---"
  separator
cat $plugins_file | while read plugin
do
  if [[ $plugin == \#* ]] ; then
    echo "Skiping: "
    echo $plugin
  else
    echo "Installing: "
    echo $plugin
    apm install $plugin --verbose
  fi
done
}

update_plugins(){
  echo "--- Updating plugins/packages ---"
  separator
    apm update $plugin --verbose
}

# If action is not set (is empty) set action to some string so the
# comparisons in main won't show any errors when comparing values with none
check_action(){
  if [ -z $action ]; then
    action="empty_command"
  fi
}

main_function(){
  check_action
  # Check if ubuntu os for install command
  if [ $action = "--install-on-ubuntu" ]; then
    download_atom_ubuntu
    install_atom_ubuntu
    remove_file_ubuntu
    copy_conf_files
    install_plugins_from_file
  # Check if fedora os for install command
  elif [ $action = "--install-on-fedora" ]; then
    download_atom_fedora
    install_atom_fedora
    remove_file_fedora
    copy_conf_files
    install_plugins_from_file
  # Install plugins command checks which plugins are installed and then
  # installes only those plugins in the plugins_file that are not already
  #  installed.
  elif [ $action = "--install-plugins" ]; then
   check_installed_plugins
   sort_plugins_file
   diff_installed_and_listed
   plugins_file=$tmp_to_be_installed
   install_plugins_from_file
  elif [ $action = "--update-plugins" ]; then
    update_plugins
  else
    echo "Unknown command."
    echo "Try --help for more options."
  fi
}

main_function

exit 0
