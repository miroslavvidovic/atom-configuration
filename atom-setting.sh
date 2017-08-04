#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Info:
#   author:    Miroslav Vidovic
#   file:      atom-settings.sh
#   created:   20.03.2016.-15:20:30
#   revision:  04.08.2017.
#   version:   1.1
# -----------------------------------------------------------------------------
# Requirements:
#
# Description:
#   Manage atom editor plugins and configuration.
# Usage:
#   atom_settings.sh
# -----------------------------------------------------------------------------
# Script:

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

# @param $1 - text file containing the list of plugins
install_plugins_from_list(){
  echo "--- Installing plugins/packages ---"
  separator
  while read plugin
  do
    if [[ $plugin == \#* ]] ; then
      echo "Skipping: "
      echo "$plugin"
    elif [[ $plugin == \$* ]]; then
      continue
    else
      echo "Installing: "
      echo "$plugin"
      apm install "$plugin"
    fi
  done < "$1"
}

# Get the difference between installed and listed packages and store them
# in a temp text file
diff_installed_and_listed_plugins(){
  # Get the list of installed plugins
  tmp_installed_plugins=$(mktemp)
  # write plugin names to temp file but skip the readme file
  ls ~/.atom/packages -I README.md > "$tmp_installed_plugins"

  # Sort the plugins file for comparison
  tmp_selected_plugins=$(mktemp)
  < "$plugins_list" sort > "$tmp_selected_plugins"

  # Compare list of installed packages and a list of selected packages
  # (plugins_list.txt)
  tmp_to_be_installed=$(mktemp)
  # comm command is used with flags -13:
  # -3 suppress lines that appear in both files
  # -1 suppress lines that are unique to file 1
  comm -13 "$tmp_installed_plugins" "$tmp_selected_plugins" > "$tmp_to_be_installed"
}

main(){
  # File containing the names of the selected packages that
  # I use with every atom installation
  plugins_list=plugins_file.txt

  copy_conf_files

  # install only those packages listed in the txt file but not
  # already installed
  diff_installed_and_listed_plugins
  install_plugins_from_list "$tmp_to_be_installed"
}

main

exit 0
