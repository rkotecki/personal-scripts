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
PROD_KNIFE='knife.rb'
DEV_KNIFE='kinfe_dev.rb'
CHEF_DIR="/opt/chef"
SUPERMARKET='https://supermarket.chef.io'

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

################################################################################
# Set numbers function to pull numbers from servers
################################################################################
numbers()
{
  PROD_CBOOK_NUM=`knife cookbook list -c $KNIFE_DIR/$PROD_KNIFE | wc -l`
  PROD_NODE_NUM=`knife node list -c $KNIFE_DIR/$PROD_KNIFE | wc -l`
  DEV_CBOOK_NUM=`knife cookbook list -c $KNIFE_DIR/$DEV_KNIFE | wc -l`
  DEV_NODE_NUM=`knife coobkook list -c $KNIFE_DIR/$DEV_KNIFE | wc -l`
  SPRMRT_NUM=`knife cookbook site list -m $SUPERMARKET -w -c $KNIFE_DIR/$PROD_KNIFE | wc -l`

  echo " "
  echo "Number of cookbooks on DEVELOPMENT Chef server:            $DEV_CBOOK_NUM"
  echo "Number of cookbooks on PRODUCTION Chef server:             $PROD_CBOOK_NUM"
  echo "Number of cookbook on Chef Supermarket:                    $SPRMRT_NUM"
  echo "Number of nodes registered to DEVELOPMENT Chef server:     $DEV_NODE_NUM"
  echo "Number of nodes registered to PRODUCTION Chef server:      $PROD_NODE_NUM"
}

################################################################################
# Set cookbooks function to get the updated cookbooks since last run
################################################################################
cookbooks()
{
  CHEF_LOGS=$CHEF_DIR/logs
  DT=`date '+%Y%m%d%H%M%S'`

  NEWEST_PROD=`ls -t1 $CHEF_LOGS/prod* | head -n 1`
  NEWEST_DEV=`ls -t1 $CHEF_LOGS/dev* | head -n 1`

  knife cookbook list -c $KNIFE_DIR/$PROD_KNIFE | awk '{print $1}' >> $CHEF_LOGS/prod_$DT.txt
  knife cookbook list -c $KNIFE_DIR/$DEV_KNIFE | awk '{print $1}' >> $CHEF_LOGS/dev_$DT.txt

  diff $NEWEST_PROD $CHEF_LOGS/prod_$DT.txt | awk '{print $1}' > $CHEF_LOGS/prod_new.txt
  diff $NEWEST_DEV $CHEF_LOGS/dev_$DT.txt | awk '{print $1}' > $CHEF_LOGS/dev_new.txt

  sed -i '/^$/d' $CHEF_LOGS/prod_new.txt
  sed -i '/^$/d' $CHEF_LOGS/dev_new.txt

  NEW_PROD=`cat $CHEF_LOGS/prod_new.txt | wc -l`
  NEW_DEV=`cat $CHEF_LOGS/dev_new.txt | wc -l`

  echo " "
  echo "$NEW_PROD New PRODUCTION cookbooks:"
  cat $CHEF_LOGS/prod_new.txt
  echo " "
  echo "$NEW_DEV New DEVELOPMENT cookbooks:"
  cat $CHEF_LOGS/dev_new.txt
  echo " "

  rm -f $CHEF_LOGS/prod_new.txt
  rm -f $CHEF_LOGS/dev_new.txt
}

################################################################################
# Set version menu to display version and contributors
################################################################################
version()
{
  echo " "
  echo "chefStats $VERSION"
  echo " "
  echo "Written by Ryan Kotecki"
}

################################################################################
# parse falgs to do the proper functions
################################################################################
if (( $# < 1 )); then
  numbers
  cookbooks
  exit 0
else
  while :; do
    case $1 in
      -h|-\?|--help)
        helpMenu
        exit 0
      ;;
      -a|--all)
        numbers
        cookbooks
        exit 0
      ;;
      -c|--cookbooks)
        cookbooks
        exit 0
      ;;
      -n|--numbers)
        numbers
        exit 0
      ;;
      -v|--version)
        version
        exit 0
      ;;
      *)
        echo "That is not a valid option"
        echo " "
        helpMenu
        exit 1
      ;;
    esac
    shift
  done
fi