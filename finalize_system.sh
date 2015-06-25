#!/bin/bash
# finalize_system.sh
# -------------------------------------------------------
# InterGenOS: A Linux from Source Project
# build: .003
# URL: http://intergenstudios.com/intergen_os/
# Github: https://github.com/InterGenOS
# ---------------------------------------------------
# InterGenStudios: 6-18-15
# Copyright (c) 2015: Christopher 'InterGen' Cork  InterGenStudios
# URL: https://intergenstudios.com
# --------------------------------
# License: GPL-2.0+
# URL: http://opensource.org/licenses/gpl-license.php
# ---------------------------------------------------
# InterGenOS is free software:
# You may redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software
# Foundation, either version 2 of the License, or (at your discretion)
# any later version.
# ------------------

###########################################
##---------------------------------------##
## BEGIN - INITIAL VARIABLE DECLARATIONS ##
##---------------------------------------##
###########################################

# Set environment variables
PATH=/bin:/usr/bin:/sbin:/usr/sbin
export PATH

# Sets a start-point timestamp
TIMESTAMP="$(date +"%m-%d-%Y_%T")"

#########################################
##-------------------------------------##
## END - INITIAL VARIABLE DECLARATIONS ##
##-------------------------------------##
#########################################

##############################
##--------------------------##
## BEGIN - SCRIPT FUNCTIONS ##
##--------------------------##
##############################

#----------------------------------#
# BEGIN - DISPLAY LAYOUT FUNCTIONS #
#----------------------------------#

# Simple divider
DIVIDER () {

    printf "\n\n"
    echo -e "\e[32m\e[1m-----------------------------------------------------------\e[0m"
    printf "\n\n"

}

# Creates uniform look during script execution when called after any clear command
HEADER () {

    printf "\n"
    echo -e "\e[34m\e[1m____________________________________________________________________________\e[0m"
    printf "\n"
    echo -e "\e[34m\e[1m    InterGen\e[37mOS \e[32mbuild\e[0m.003"
    echo -e "\e[34m\e[1m____________________________________________________________________________\e[0m"
    printf "\n\n\n"

}

# Creates a 15 line gap for easier log review
SPACER () {

    printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

}

#--------------------------------#
# END - DISPLAY LAYOUT FUNCTIONS #
#--------------------------------#

#########################
##---------------------##
## BEGIN - CORE SCRIPT ##
##---------------------##
#########################


# Create systemd network directory and eth.network
mkdir -pv /etc/systemd/network

cat > /etc/systemd/network/10-dhcp-eth0.network << "EOF"
[Match]
Name=eth0

[Network]
DHCP=yes

EOF

#---------------------------------------------------------------------------------------#

# Create udev/rules.d and set MAC
GetMac="$(ip link | grep ether | awk '{print $2}')"

mkdir -pv /etc/udev/rules.d

# Set UDEV rule to rename ethlink to eth0 :)
cat > /etc/udev/rules.d/10-network.rules << "EOF"
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="Mac", NAME="eth0"

EOF

sed -i "s/Mac/$GetMac/" /etc/udev/rules.d/10-network.rules &&

unset GetMac

#---------------------------------------------------------------------------------------#

# softlink resolv.conf
ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf

#---------------------------------------------------------------------------------------#

# set hostname
echo InterGenOS > /etc/hostname

#---------------------------------------------------------------------------------------#

# Create /etc/hosts
cat > /etc/hosts << "EOF"
#
# Begin /etc/hosts: static lookup table for host names
#

#<ip-address>   <hostname.domain.org>   <hostname>
127.0.0.1       localhost.localdomain   localhost
::1             localhost.localdomain   localhost

# End /etc/hosts

EOF

#---------------------------------------------------------------------------------------#

# Create /etc/vconsole.conf
cat > /etc/vconsole.conf << "EOF"
KEYMAP=us
FONT=Lat2-Terminus16

EOF

#---------------------------------------------------------------------------------------#

# Create /etc/locale.conf & set to en_US.UTF-8
cat > /etc/locale.conf << "EOF"
LANG=en_US.UTF-8 LC_CTYPE=en_US

EOF

#---------------------------------------------------------------------------------------#

# Create /etc/inputrc
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Written by Christopher 'InterGen' Cork <chris@intergenstudios.com>
# 4-19-2015

# do not bell on tab-completion
set bell-style none

set meta-flag on
set input-meta on
set convert-meta off
set output-meta on

$if mode=emacs

# for linux console and RH/Debian xterm
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[7~": beginning-of-line
"\e[3~": delete-char
"\e[2~": quoted-insert
"\e[5C": forward-word
"\e[5D": backward-word
"\e\e[C": forward-word
"\e\e[D": backward-word
"\e[1;5C": forward-word
"\e[1;5D": backward-word
"\eOc": forward-word
"\eOd": backward-word

# for rxvt
"\e[8~": end-of-line

# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for freebsd console, konsole
"\e[H": beginning-of-line
"\e[F": end-of-line
$endif

# End of /etc/inputrc

EOF

#---------------------------------------------------------------------------------------#

# Create /etc/shells
cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells

EOF

#---------------------------------------------------------------------------------------#

# Disable screen clearing at boot
mkdir -pv /etc/systemd/system/getty@tty1.service.d

cat > /etc/systemd/system/getty@tty1.service.d/noclear.conf << EOF
[Service]
TTYVTDisallocate=no

EOF

#---------------------------------------------------------------------------------------#

# Create /etc/skel and shell files

mkdir /etc/skel

cat > /etc/profile << "EOF"
##############################################################################
####                                                                      ####
####  Begin /etc/profile                                                  ####
####  Written by Christopher 'InterGen' Cork <chris@intergenstudios.com>  ####
####  2/25/15                                                             ####
####                                                                      ####
##############################################################################


#############################################
####                                     ####
####  System wide environment variables  ####
####                                     ####
#############################################


# Setup some environment variables.
export HISTSIZE=9999
export HISTIGNORE="&:[bf]g:exit"

# Set some defaults for graphical systems
export XDG_DATA_DIRS=/usr/share



########################################
####                                ####
####  System wide startup programs  ####
####                                ####
########################################



################################################################################
####                                                                        ####
####  System wide environment variables and startup programs should go in   ####
####  ~/.bash_profile.  System wide environment variables and startup       ####
####  programs are in /etc/profile.  System wide aliases and functions are  ####
####  in /etc/bashrc.                                                       ####
####                                                                        ####
################################################################################



#################################
####                         ####
####  System Wide Functions  ####
####                         ####
##################################################################################
####                                                                          ####
####  Functions to help us manage paths.  Second argument is the name of the  ####
####  path variable to be modified (default: PATH)                            ####
####                                                                          ####
##################################################################################


pathremove () {
        local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
                if [ "$DIR" != "$1" ] ; then
                  NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
                fi
        done
        export $PATHVARIABLE="$NEWPATH"
}

pathprepend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

export -f pathremove pathprepend pathappend


################################
####                        ####
####  Set the initial path  ####
####                        ####
################################


export PATH=/bin:/usr/bin

if [ $EUID -eq 0 ] ; then
        pathappend /sbin:/usr/sbin
        unset HISTFILE
fi


######################################################################
####                                                              ####
####  Initializations- red prompt for root, green one for users,  ####
####  and run any scripts in /etc/profile.d/                      ####
####                                                              ####
######################################################################

RED='\[\e[1;34m\][\[\e[m\] \[\e[1;31m\]\u\[\e[m\]\[\e[1;34m\]@\[\e[m\]\[\e[1;37m\]\h\[\e[m\] \[\e[1;34m\]]\[\e[m\]\[\e[1;34m\][\[\e[m\] \[\e[1;37m\]<\[\e[m\]\[\e[1;32m\]\w\[\e[m\]\[\e[1;37m\]>\[\e[m\] \[\e[1;34m\]]\[\e[m\]\[\e[1;37m\]:\[\e[m\]\[\e[1;37m\]\\$\[\e[m\] '
GREEN='\[\e[1;34m\][\[\e[m\] \[\e[1;32m\]\u\[\e[m\]\[\e[1;34m\]@\[\e[m\]\[\e[1;37m\]\h\[\e[m\] \[\e[1;34m\]]\[\e[m\]\[\e[1;34m\][\[\e[m\] \[\e[1;37m\]<\[\e[m\]\[\e[1;32m\]\w\[\e[m\]\[\e[1;37m\]>\[\e[m\] \[\e[1;34m\]]\[\e[m\]\[\e[1;37m\]:\[\e[m\]\[\e[1;37m\]\\$\[\e[m\] '

if [[ $EUID == 0 ]] ; then
export PS1=$RED
else
export PS1=$GREEN
fi

for script in /etc/profile.d/*.sh ; do
        if [ -r $script ] ; then
                . $script
        fi
done

unset script RED GREEN


############################
####                    ####
####  END /etc/profile  ####
####                    ####
############################

EOF

#---------------------------------------------------------------------------------------#

install --directory --mode=0755 --owner=root --group=root /etc/profile.d

cat > /etc/profile.d/dircolors.sh << "EOF"
# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.
if [ -f "/etc/dircolors" ] ; then
        eval $(dircolors -b /etc/dircolors)

        if [ -f "$HOME/.dircolors" ] ; then
                eval $(dircolors -b $HOME/.dircolors)
        fi
fi
alias ls='ls -a --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=auto'

EOF

#---------------------------------------------------------------------------------------#

cat > /etc/profile.d/extrapaths.sh << "EOF"
if [ -d /usr/local/lib/pkgconfig ] ; then
        pathappend /usr/local/lib/pkgconfig PKG_CONFIG_PATH
fi
if [ -d /usr/local/bin ]; then
        pathprepend /usr/local/bin
fi
if [ -d /usr/local/sbin -a $EUID -eq 0 ]; then
        pathprepend /usr/local/sbin
fi

EOF

#---------------------------------------------------------------------------------------#

cat > /etc/profile.d/readline.sh << "EOF"
# Setup the INPUTRC environment variable.
if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ] ; then
        INPUTRC=/etc/inputrc
fi
export INPUTRC

EOF

#---------------------------------------------------------------------------------------#

cat > /etc/profile.d/umask.sh << "EOF"
# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
  umask 002
else
  umask 022
fi

EOF

#---------------------------------------------------------------------------------------#

cat > /etc/profile.d/i18n.sh << "EOF"
# Begin /etc/profile.d/i18n.sh

unset LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES \
      LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT LC_IDENTIFICATION

if [ -n "$XDG_CONFIG_HOME" ] && [ -r "$XDG_CONFIG_HOME/locale.conf" ]; then
  . "$XDG_CONFIG_HOME/locale.conf"
elif [ -r /etc/locale.conf ]; then
  . /etc/locale.conf
fi

export LANG="${LANG:-C}"
[ -n "$LC_CTYPE" ]          && export LC_CTYPE
[ -n "$LC_NUMERIC" ]        && export LC_NUMERIC
[ -n "$LC_TIME" ]           && export LC_TIME
[ -n "$LC_COLLATE" ]        && export LC_COLLATE
[ -n "$LC_MONETARY" ]       && export LC_MONETARY
[ -n "$LC_MESSAGES" ]       && export LC_MESSAGES
[ -n "$LC_PAPER" ]          && export LC_PAPER
[ -n "$LC_NAME" ]           && export LC_NAME
[ -n "$LC_ADDRESS" ]        && export LC_ADDRESS
[ -n "$LC_TELEPHONE" ]      && export LC_TELEPHONE
[ -n "$LC_MEASUREMENT" ]    && export LC_MEASUREMENT
[ -n "$LC_IDENTIFICATION" ] && export LC_IDENTIFICATION

# End /etc/profile.d/i18n.sh

EOF

#---------------------------------------------------------------------------------------#

cat > /etc/bashrc << "EOF"
##############################################################################
####                                                                      ####
####  Begin /etc/bashrc                                                   ####
####  Written by Christopher 'InterGen' Cork <chris@intergenstudios.com>  ####
####  2/25/15                                                             ####
####                                                                      ####
##############################################################################


###############################
####                       ####
####  System wide aliases  ####
####                       ####
###############################


alias ls='ls -a --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=auto'
export EDITOR=nano
export LC_COLLATE="C"

#################################
####                         ####
####  System wide functions  ####
####                         ####
#################################



################################################################################
####                                                                        ####
####  System wide environment variables and startup programs should go in   ####
####  ~/.bash_profile.  System wide environment variables and startup       ####
####  programs are in /etc/profile.  System wide aliases and functions are  ####
####  in /etc/bashrc.                                                       ####
####                                                                        ####
################################################################################


#############################################################################
####                                                                     ####
####  Provides prompt for non-login shells, specifically shells started  ####
####  in the X environment.                                              ####
####                                                                     ####
#############################################################################

RED='\[\e[1;34m\][\[\e[m\] \[\e[1;31m\]\u\[\e[m\]\[\e[1;34m\]@\[\e[m\]\[\e[1;37m\]\h\[\e[m\] \[\e[1;34m\]]\[\e[m\]\[\e[1;34m\][\[\e[m\] \[\e[1;37m\]<\[\e[m\]\[\e[1;32m\]\w\[\e[m\]\[\e[1;37m\]>\[\e[m\] \[\e[1;34m\]]\[\e[m\]\[\e[1;37m\]:\[\e[m\]\[\e[1;37m\]\\$\[\e[m\] '
GREEN='\[\e[1;34m\][\[\e[m\] \[\e[1;32m\]\u\[\e[m\]\[\e[1;34m\]@\[\e[m\]\[\e[1;37m\]\h\[\e[m\] \[\e[1;34m\]]\[\e[m\]\[\e[1;34m\][\[\e[m\] \[\e[1;37m\]<\[\e[m\]\[\e[1;32m\]\w\[\e[m\]\[\e[1;37m\]>\[\e[m\] \[\e[1;34m\]]\[\e[m\]\[\e[1;37m\]:\[\e[m\]\[\e[1;37m\]\\$\[\e[m\] '

if [[ $EUID == 0 ]] ; then
export PS1=$RED
else
export PS1=$GREEN
fi

unset RED GREEN


###########################
####                   ####
####  End /etc/bashrc  ####
####                   ####
###########################

EOF

#---------------------------------------------------------------------------------------#

cat > ~/.bash_profile << "EOF"
##############################################################################
####                                                                      ####
####  Begin ~/.bash_profile for Root user                                 ####
####  Written by Christopher 'InterGen' Cork <chris@intergenstudios.com>  ####
####  2/25/15                                                             ####
####                                                                      ####
##############################################################################


###########################################
####                                   ####
####  Root user environment variables  ####
####                                   ####
###########################################



######################################
####                              ####
####  Root user startup programs  ####
####                              ####
######################################



#######################################################################
####                                                               ####
####  User aliases should go in their respective ~/.bashrc files.  ####
####  System wide environment variables and startup programs are   ####
####  in /etc/profile.  System wide aliases and functions are in   ####
####  /etc/bashrc.                                                 ####
####                                                               ####
#######################################################################


[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ -d ~/bin ]] && pathprepend ~/bin

# Having . in the PATH is dangerous
#if [ $EUID -gt 99 ]; then
#  pathappend .
#fi

#############################################
####                                     ####
####  END ~/.bash_profile for root user  ####
####                                     ####
#############################################

EOF

#---------------------------------------------------------------------------------------#

cat > ~/.bashrc << "EOF"
##############################################################################
####                                                                      ####
####  Begin ~/.bashrc for Root User                                       ####
####  Written by Christopher 'InterGen' Cork <chris@intergenstudios.com>  ####
####  2/25/15                                                             ####
####                                                                      ####
##############################################################################


#####################################
####                             ####
####  Bash prompt for Root User  ####
####                             ####
##################################################################
####                                                          ####
####  You can set an alternative bash prompt by placing your  ####
####  prompt code in-between the '' below and removing the #  ####
####  before 'export'                                         ####
####                                                          ####
##################################################################

#export PS1=''


###############################
####                       ####
####  Root User Variables  ####
####                       ####
###############################

export EDITOR=nano
export LC_COLLATE="C"

#############################
####                     ####
####  Root User Aliases  ####
####                     ####
#############################

alias ping='ping -c 3'
alias ls='ls -a --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=auto'
alias ll='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'


###############################
####                       ####
####  Root User Functions  ####
####                       ####
###############################



################################################################################
####                                                                        ####
####  Root User environment variables and startup programs should go in     ####
####  ~/.bash_profile.  System wide environment variables and startup       ####
####  programs are in /etc/profile.  System wide aliases and functions are  ####
####  in /etc/bashrc.                                                       ####
####                                                                        ####
################################################################################

if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi



#######################################
####                               ####
####  END ~/.bashrc for Root user  ####
####                               ####
#######################################

EOF

#---------------------------------------------------------------------------------------#

cat > ~/.bash_logout << "EOF"
# Begin ~/.bash_logout
# Written by Christopher 'InterGen' Cork <chris@intergenstudios.com>
# 2/25/15

# Personal items to perform on logout.

# End ~/.bash_logout

EOF

#---------------------------------------------------------------------------------------#

cat > /etc/skel/.bash_profile << "EOF"
##############################################################################
####                                                                      ####
####  Begin ~/.bash_profile for System user                               ####
####  Written by Christopher 'InterGen' Cork <chris@intergenstudios.com>  ####
####  2/25/15                                                             ####
####                                                                      ####
##############################################################################


#############################################
####                                     ####
####  System user environment variables  ####
####                                     ####
#############################################



########################################
####                                ####
####  System user startup programs  ####
####                                ####
########################################



#######################################################################
####                                                               ####
####  User aliases should go in their respective ~/.bashrc files.  ####
####  System wide environment variables and startup programs are   ####
####  in /etc/profile.  System wide aliases and functions are in   ####
####  /etc/bashrc.                                                 ####
####                                                               ####
#######################################################################



[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ -d ~/bin ]] && pathprepend ~/bin

# Having . in the PATH is dangerous
#if [ $EUID -gt 99 ]; then
#  pathappend .
#fi

###############################################
####                                       ####
####  END ~/.bash_profile for System user  ####
####                                       ####
###############################################

EOF

#---------------------------------------------------------------------------------------#

cat > /etc/skel/.bashrc << "EOF"
##############################################################################
####                                                                      ####
####  ~/.bashrc for System User                                           ####
####  Written by Christopher 'InterGen' Cork <chris@intergenstudios.com>  ####
####  2/25/15                                                             ####
####                                                                      ####
##############################################################################

###################################
####                           ####
####  Interactive shell check  ####
####                           ####
###################################

[[ $- != *i* ]] && return


#######################################
####                               ####
####  Bash prompt for System User  ####
####                               ####
##################################################################
####                                                          ####
####  You can set an alternative bash prompt by placing your  ####
####  prompt code in-between the '' below and removing the #  ####
####  before 'export'                                         ####
####                                                          ####
##################################################################

#export PS1=''


#################################
####                         ####
####  System User Variables  ####
####                         ####
#################################

export EDITOR=nano
export LC_COLLATE="C"

###############################
####                       ####
####  System User Aliases  ####
####                       ####
###############################

alias ping='ping -c 3'
alias ls='ls -a --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=auto'
alias ll='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'


#################################
####                         ####
####  System User Functions  ####
####                         ####
#################################



################################################################################
####                                                                        ####
####  System User environment variables and startup programs should go in   ####
####  ~/.bash_profile.  System wide environment variables and startup       ####
####  programs are in /etc/profile.  System wide aliases and functions are  ####
####  in /etc/bashrc.                                                       ####
####                                                                        ####
################################################################################

if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi


#########################################
####                                 ####
####  END ~/.bashrc for system user  ####
####                                 ####
#########################################

EOF

#---------------------------------------------------------------------------------------#

# Setup directory colors
dircolors -p > /etc/dircolors
dircolors -p > /etc/skel/.dircolors

#---------------------------------------------------------------------------------------#

# Setup terminal emulator and console rc files
cat > ~/.vimrc << "EOF"
" Begin .vimrc
set columns=80
set wrapmargin=8
set ruler
set background=dark
set cmdheight=2
" End .vimrc

EOF

cp ~/.vimrc /etc/skel/.vimrc
cp /etc/nanorc ~/.nanorc
cp /etc/nanorc /etc/skel/.nanorc

#---------------------------------------------------------------------------------------#

# Create /etc/issue
touch /etc/issue
clear > /etc/issue
echo "InterGen OS \r (\l)" >> /etc/issue

#---------------------------------------------------------------------------------------#

# Create /etc/fstab
mv /intergenos.fstab /etc/fstab
ROOTMOUNT=$(mount | grep '\/dev\/sd' | awk '{print $1}')
ROOTUUID=$(blkid $ROOTMOUNT | awk '{print $2}' | cut -d '"' -f 2 | cut -d '"' -f 1)
sed -i "s/xxx/$ROOTUUID/" /etc/fstab

#---------------------------------------------------------------------------------------#
