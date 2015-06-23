#!/bin/bash
# setup.sh
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

# Sets a start-point timestamp
TIMESTAMP="$(date +"%m-%d-%Y_%T")"

# Regex check for numbers as choices
export NUMBER_CHECK='^[0-9]+$'

# Sets build mount point
export IGos=/mnt/igos

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

# Colors trailing text Red
RED () {
    tput setaf 1
}

# Colors trailing text Green
GREEN () {
    tput setaf 2
}

# Colors trailing text Yellow
YELLOW () {
    tput setaf 3
}

# Colors trailing text Blue
BLUE () {
    tput setaf 4
}

# Prints any color in bold
BOLD () {
    tput bold
}

# Clears any preceding text color declarations - including bold
WHITE () {
    tput sgr0
}

# Simple divider
DIVIDER () {
    printf "\n"
    BOLD
    GREEN
    echo "-----------------------------------------------------------"
    printf "\n"
    WHITE
}

# Creates uniform look during script execution when called after any clear command
HEADER () {
    echo
    BOLD
    BLUE
    echo "____________________________________________________________________________"
    printf "\n"
    printf "    InterGen"
    WHITE
    BOLD
    printf "OS"
    WHITE
    GREEN
    printf " build"
    WHITE
    echo ".003"
    BOLD
    BLUE
    echo "____________________________________________________________________________"
    WHITE
    printf "\n\n"
}

# Clears $ amount of lines when called
CLEARLINE () {
# To use, set CLINES=<$#> before function if you need to clear more than 1 line
    if [ -z "$CLINES" ]; then
        tput cuu 1 && tput el
    else
        tput cuu "$CLINES" && tput el
        unset CLINES
    fi
}

#--------------------------------#
# END - DISPLAY LAYOUT FUNCTIONS #
#--------------------------------#

GET_PARTITION () {
    clear
    HEADER
    sleep 1
    printf "Select the partition to build "
    BOLD
    BLUE
    printf "InterGen"
    WHITE
    BOLD
    printf "OS"
    WHITE
    echo " in: "
    printf "\n"

    # Create build partition selection list
    lsblk | grep part | cut -d 'd' -f 2- | sed -e 's/^/sd/' | awk '{printf "%- 13s %s\n", $1"  "$4, $6" "$7;}' > partitions
    sed = partitions | sed 'N;s/\n/\t/' > partitionlist && sed -i 's/^/#/g' partitionlist
    DIVIDER
    cat partitionlist
    DIVIDER
    BOLD
    GREEN
    printf "["
    WHITE
    BOLD
    printf "enter selection"
    BOLD
    GREEN
    printf "]"
    WHITE
    echo -n ": "
    read PARTITION_CHOICE

    # Read target partition from build partition selection
    TARGET_PARTITION="$(grep -m 1 \#"$PARTITION_CHOICE" partitionlist | awk '{print $2}')"
    printf "\n\n"

    # Confirm target build partition
    printf "   Build "
    BOLD
    BLUE
    printf "InterGen"
    WHITE
    BOLD
    printf "OS"
    WHITE
    printf " in %s" "$TARGET_PARTITION"
    printf ", correct "
    BOLD
    printf "(y/N)"
    WHITE
    echo -n "? "
    read TARGET_CONFIRMATION
    printf "\n\n"
    if [ "$TARGET_CONFIRMATION" = "Y" ] || [ "$TARGET_CONFIRMATION" = "y" ] || [ "$TARGET_CONFIRMATION" = "Yes" ] || [ "$TARGET_CONFIRMATION" = "yes" ]; then
        sleep 1
        SETUP_BUILD
    else
        BOLD
        RED
        echo "   Build cancelled by user"
        WHITE
        printf "\n\n"
        echo "    (exiting...)"
        printf "\n\n\n"
        exit 1
    fi
}

SETUP_BUILD () {
    rm partitions partitionlist
    # Mount the build directory
    clear
    HEADER
    BOLD
    GREEN
    echo "Setting up build directory mount..."
    printf "\n\n"
    WHITE
    mkdir -pv "$IGos"
    mount -v -t ext4 /dev/"$TARGET_PARTITION" "$IGos"
    sleep 1

    # Set variables into host system user and root accounts
    clear
    HEADER
    BOLD
    GREEN
    printf "Please enter your system username:"
    WHITE
    echo -n " "
    read USER
    printf "\n"
    BOLD
    GREEN
    echo "Setting .bashrc exports..."
    WHITE
    printf "\n\n"
    echo "export IGos=/mnt/igos" >> /home/"$USER"/.bashrc
    echo "export IGos=/mnt/igos" >> /root/.bashrc
    echo "export IGosPart=/dev/$TARGET_PARTITION" >> /home/"$USER"/.bash_profile
    echo "export IGosPart=/dev/$TARGET_PARTITION" >> /root/.bash_profile

    # Set up source directory
    clear
    HEADER
    BOLD
    GREEN
    echo "Creating sources directory..."
    printf "\n\n"
    WHITE
    mkdir -v "$IGos"/sources
    chmod -v a+wt "$IGos"/sources

    # Download source packages
    clear
    HEADER
    BOLD
    GREEN
    echo "Fetching sources... (this will take a minute)"
    printf "\n\n"
    WHITE
    wget -q https://github.com/InterGenOS/sources_003/archive/master.zip
    printf "\n"
    BOLD
    GREEN
    echo "Source retrieval complete..."
    sleep 2

    # Move source packages into place
    clear
    HEADER
    BOLD
    GREEN
    echo "Moving things into place..."
    sleep 1
    printf "\n\n"
    WHITE
    unzip master.zip 2>&1 &&
    rm master.zip
    mv sources_003-master/* "$IGos"/sources &&
    rm -rf sources_003-master
    rm "$IGos"/sources/README.md
    mkdir -v "$IGos"/tools
    ln -sv "$IGos"/tools /

    # Create build system user
    clear
    HEADER
    BOLD
    GREEN
    echo "Creating user 'igos' with password 'intergenos'..."
    printf "\n\n"
    WHITE
    groupadd igos
    useradd -s /bin/bash -g igos -m -k /dev/null igos
    echo "igos:intergenos" | chpasswd
    sleep 2

    # Assign build directory ownership to build system user
    clear
    HEADER
    BOLD
    GREEN
    echo "Assigning tools' and sources' ownership to user 'igos'..."
    printf "\n\n"
    WHITE
    chown -v igos "$IGos"/tools
    chown -v igos "$IGos"/sources
    sleep 2

    # Setup igos shell for 'build_temporary_system.sh'
    clear
    HEADER
    BOLD
    GREEN
    echo "Preparing shell variables for user 'igos'..."
    printf "\n\n"
    WHITE

    # Download temporary system build script, assign ownerships to build user
    wget -q https://raw.githubusercontent.com/InterGenOS/build_003/master/build_temporary_system.sh -P "$IGos"
    wget -q https://raw.githubusercontent.com/InterGenOS/build_003/master/clean_environment.sh -P "$IGos"
    wget -q https://raw.githubusercontent.com/InterGenOS/build_003/master/enter_chroot.sh -P "$IGos"
    wget -q https://raw.githubusercontent.com/InterGenOS/build_003/master/build_system.sh -P "$IGos"
    chown -v igos "$IGos"/build_temporary_system.sh "$IGos"/clean_environment.sh "$IGos"/enter_chroot.sh "$IGos"/build_system.sh
    chmod +x "$IGos"/build_temporary_system.sh "$IGos"/clean_environment.sh "$IGos"/enter_chroot.sh "$IGos"/build_system.sh

    # Copy current grub.cfg for alteration upon build completion
    cp /boot/grub/grub.cfg "$IGos"/grub.cfg

    # Sets build user bash.profile
    mv tmp.bash_profile /home/igos/.bash_profile

    # Sets build user .bashrc
    mv tmp.bashrc /home/igos/.bashrc
    chown -v igos:users /home/igos/.bashrc /home/igos/.bash_profile
    sleep 2
}

SETUP_CHROOT () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Changing temporary tools direcotry ownership..."
    printf "\n"
    WHITE
    chown -R root:root "$IGos"/tools
    sleep 1
    printf "\n"
    BOLD
    GREEN
    echo "Temp tools directory ownership change comlete"
    sleep 2
    WHITE
    clear
    HEADER
    BOLD
    GREEN
    echo "Preparing Virtual Kernel File Systems..."
    printf "\n"
    WHITE
    mkdir -pv "$IGos"/{dev,proc,sys,run}
    mknod -m 600 "$IGos"/dev/console c 5 1
    mknod -m 666 "$IGos"/dev/null c 1 3
    mount -v --bind /dev "$IGos"/dev
    mount -vt devpts devpts "$IGos"/dev/pts -o gid=5,mode=620
    mount -vt proc proc "$IGos"/proc
    mount -vt sysfs sysfs "$IGos"/sys
    mount -vt tmpfs tmpfs "$IGos"/run
    if [ -h "$IGos"/dev/shm ]; then
      mkdir -pv "$IGos"/$(readlink "$IGos"/dev/shm)
    fi
}

############################
##------------------------##
## END - SCRIPT FUNCTIONS ##
##------------------------##
############################

#############################################
##-----------------------------------------##
## BEGIN - MAKE SURE WE'RE RUNNING AS ROOT ##
##-----------------------------------------##
#############################################

if [ "$(id -u)" != "0" ]; then
    BOLD
    RED
    printf "\n\n"
    echo "--------"
    echo "WARNING!"
    echo "--------"
    echo
    WHITE
    BOLD
    echo "InterGenOS must be built as root"
    printf "\n\n"
    WHITE
    echo "(Exiting now...)"
    printf "\n\n"
    exit 1
fi

###########################################
##---------------------------------------##
## END - MAKE SURE WE'RE RUNNING AS ROOT ##
##---------------------------------------##
###########################################

#########################
##---------------------##
## BEGIN - CORE SCRIPT ##
##---------------------##
#########################

# Sets build user bash.profile
cat > tmp.bash_profile << "igos_bash_profile"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
igos_bash_profile
chown igos:users /home/igos/.bash_profile

# Sets build user .bashrc, sets temporary system build script to launch on shell login
cat > tmp.bashrc << "igos_bashrc"
set +h
umask 022
IGos=/mnt/igos
LC_ALL=POSIX
IGos_TGT=$(uname -m)-igos-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export IGos LC_ALL IGos_TGT PATH
igos_bashrc
chown igos:users /home/igos/.bashrc

mkdir -pv /var/log/InterGenOS/BuildLogs/Temp_Sys_Buildlogs
chmod -r 777 /var/log/InterGenOS/*

GET_PARTITION 2>&1 | tee build_log
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' build_log
mv build_log /var/log/InterGenOS/BuildLogs/Temp_Sys_Buildlogs/setup_log_"$TIMESTAMP"

# Build temporary system in separate shell as the build user
cd "$IGos"
sudo -u igos ./clean_environment.sh
printf "\n\n\n"

SETUP_CHROOT 2>&1 | tee chroot_log
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' chroot_log
mv chroot_log /var/log/InterGenOS/BuildLogs/chroot_log_"$TIMESTAMP"

cd "$IGos"
sudo -u root ./enter_chroot.sh 2>&1 | tee sys_build_log
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' sys_build_log
mv sys_build_log /var/log/InterGenOS/BuildLogs/sys_build_log_"$TIMESTAMP"
printf "\n\n\n"
