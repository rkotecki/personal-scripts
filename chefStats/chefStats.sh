#!/bin/bash
#set -x

################################################################################
# chefStats - v0.1.1 - Ryan kotecki - October 2, 2018
#
# This script will show statistics and changes between the last time it was
# executed
#
################################################################################

################################################################################
# Set some variables to be used throughout the script
################################################################################
VERSION="0.1.1"
KNIFE_DIR="/root/chef-repo/.chef"
CHEF_DIR="/opt/chef"

################################################################################
# Set help menu for users to understand script and flags
################################################################################
helpMenu()
{
  echo "Usage: chefStats [OPTION]"
  echo " "
  echo "By default -a or --all flag is applied"
  echo " "
  echo "Optional flags for specific stats"
  echo "  -a, --all               Display all statistics for Chef servers"
  echo "  -c, --cookbooks         Display new cookbooks from last execution"
  echo "  -n, --numbers           Display Chef server statistics at current time"
  echo "  -v, --version           Display the current version of script"
  echo "  -h, --help              Display this menu and exit"
  echo " "
  echo "Report chefStats bugs to https://github.com/rkotecki/personal-scripts/issues"
}