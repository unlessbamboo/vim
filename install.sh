#!/bin/bash - 
#===============================================================================
#
#          FILE: install.sh
# 
#         USAGE: ./install.sh 
# 
#   DESCRIPTION: 
#           Automated deployment of vim scripts
#           
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: system recommand——ubuntu 14.04
#        AUTHOR: YOUR NAME (unlessbamboo), 
#  ORGANIZATION: 
#       CREATED: 2016年06月07日 22:39
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# import my own function
source ${HOME}/.local/script/shellHeader.sh



#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  powerline_env
#   DESCRIPTION:  install powerline environment
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
powerline_env()
{
    echo ""
}
