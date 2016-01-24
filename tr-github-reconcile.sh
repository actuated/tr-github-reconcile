#!/bin/bash
# tr-github-reconcile.sh
# 1/21/2016 by Ted R (http://github.com/actuated)
# Script to update my github repositories, and to optionally pull any missing ones.
# 1/22/2016 - Removed function previously used to call fnCheckRepo[s] for each repo, replaced with a for loop in fnCheckRepos and varRepoList
# 1/24/2016 - Added two repos

# Variable for the default root directory that contains downloaded tools.
# Change this to your own existing or desired directory.
# You can also use -d [path] to specify or create a directory during script execution.
# The script checks to see if this directory exists, offers to create it if not, and cancels if you choose not to.
# The script will check in this directory for subdirs for each repo, offer to clone them if they are missing, initialize them if .git does not exist, or update they are there and initialized.
varRootDir="/ted/my-scripts/github/"


# Are you a github user who wants to customize this for your own account and repos?
# 1. Change the variable below to use your github account URL (include the trailing /):
varMyGitUrlRoot="https://github.com/actuated/"
# 2. List your repos in this variable, which fnCheckRepos will use in a for loop.
varRepoList="ike-trans nmap-grep pass-survey range-finder smb-anon-shares sslscanalyzer soc-eng-batches tr-github-reconcile user-parse"


varPwd=$(pwd)
varFlagCustomDir="N"
varDateCreated="1/21/2016"
varDateLastMod="1/24/2016"

# Function to show help/usage information
function fnUsage {
  echo
  echo "======[ tr-github-reconcile.sh - Ted R (github: actuated) ]======"
  echo
  echo "Script to let users check for and update any of my github repos."
  echo "Offers to clone any of the listed repos that are not found."
  echo "Offers to git init any repo dir found that does not contain .git."
  echo "Set up for easy personalization for other github users."
  echo
  echo "Created $varDateCreated, last modified $varDateLastMod."
  echo
  echo "============================[ usage ]============================"
  echo
  echo "./tr-github-reconcile.sh [-d path]"
  echo
  echo "-d [path]     -Optionally specify the root folder to check for"
  echo "               all github repositories under."
  echo "              -Default is '$varRootDir'."
  echo "              -Default can also be changed by modifying"
  echo "               varRootDir, near the beginning of the script."
  echo
  exit
}

# Function to check repos listed in varRepoList.
# Offers to clone repo if no directory for it exists in the given root path.
# Checks for .git and does a pull if it exists.
# Offers to git init if .git does not exist.
function fnCheckRepos {

for varThisRepo in $varRepoList; do

  cd "$varRootDir"

  if [ ! -d "$varThisRepo" ]; then
    echo
    varFlagDownloadRepo="N"
    read -p "$varThisRepo does not seem to exist. Clone with git? [Y/N] " varFlagDownloadRepo
    varFlagDownloadRepo=$(echo "$varFlagDownloadRepo" | tr 'a-z' 'A-Z')
    if [ "$varFlagDownloadRepo" = "Y" ]; then
      git clone "$varMyGitUrlRoot$varThisRepo"
    fi
  else
    cd "$varThisRepo"
    if [ -e ".git" ]; then
      echo
      echo "Checking for updates to $varThisRepo..."
      git pull origin master
    else
      echo
      varFlagGitInit="N"
      echo "$varThisRepo exists, but does not appear to be git initialized."
      read -p "Initialize with git? [Y/N] " varFlagGitInit
      varFlagGitInit=$(echo "$varFlagGitInit" | tr 'a-z' 'A-Z')
      if [ "$varFlagGitInit" = "Y" ]; then
        git init
        git remote add origin "$varMyGitUrlRoot$varThisRepo.git"
        git pull origin master
      fi
    fi
  fi

  cd "$varPwd"

done

}

# Function to check the root directory given.
# If -d was used, it errors if no custom root directory was given.
# If no object exists with the (default or given) root directory, offer to create it.
# If the default or given root directory exists as something other than a directory, error.
function fnCheckRootDir {

  if [ "$varFlagCustomDir" = "Y" ] && [ "$varRootDir" = "" ]; then
    echo
    echo "Error: Custom path option (-d) used, but no path was given."
    fnUsage
  fi

  if [ ! -e "$varRootDir" ]; then
    echo
    read -p "$varRootDir does not exist. Create? [Y/N] " varFlagCreateDir
    varFlagCreateDir=$(echo "$varFlagCreateDir" | tr 'a-z' 'A-Z')
    if [ "$varFlagCreateDir" = "Y" ]; then
      mkdir "$varRootDir"
    else
      echo
      echo "Error: $varRootDir did not exist, and user opted not to create."
      fnUsage
    fi
  fi

  if [ ! -d "$varRootDir" ]; then
    echo
    echo "Error: $varRootDir exists, and is not a directory."
    fnUsage
  fi

}

# Check for options.
# -d lets a custom root directory be named.
# -h or any unrecognized parameter shows usage information.
while [ "$1" != "" ]; do
  case $1 in
    -d ) shift
         varRootDir="$1"
         varFlagCustomDir="Y"
         ;;
    -h ) fnUsage
         ;;
    * )  fnUsage
  esac
  shift
done

# Basic script/terminal output.
# Calls fnCheckRootDir to verify the default or given root directory.
# Calls fnCheckRepos.
echo
echo "======[ tr-github-reconcile.sh - Ted R (github: actuated) ]======"
fnCheckRootDir
fnCheckRepos
echo
echo "=============================[ fin ]============================="
echo


