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
    echo -e "Select the partition to build \e[1m\e[34mInterGen\e[37mOS \e[0min:"
    printf "\n"

    # Create build partition selection list
    lsblk | grep part | cut -d 'd' -f 2- | sed -e 's/^/sd/' | awk '{printf "%- 13s %s\n", $1"  "$4, $6" "$7;}' > partitions
    sed = partitions | sed 'N;s/\n/\t/' > partitionlist && sed -i 's/^/#/g' partitionlist
    DIVIDER
    cat partitionlist
    DIVIDER
    echo -en "\e[1m\e[32m[ \e[37menter selection \e[32m]\e[0m: "
    read PARTITION_CHOICE

    # Read target partition from build partition selection
    TARGET_PARTITION="$(grep -m 1 \#"$PARTITION_CHOICE" partitionlist | awk '{print $2}')"
    printf "\n\n"

    # Confirm target build partition
    echo -en "    Build \e[1m\e[34mInterGEN\e[37mOS \e[0min \e[1m\e[32m$TARGET_PARTITION\e[0m, correct \e[1m\e[37m(y/N)\e[0m? "
    read TARGET_CONFIRMATION
    printf "\n\n"
    if [ "$TARGET_CONFIRMATION" = "Y" ] || [ "$TARGET_CONFIRMATION" = "y" ] || [ "$TARGET_CONFIRMATION" = "Yes" ] || [ "$TARGET_CONFIRMATION" = "yes" ]; then
        sleep 1
        SETUP_BUILD
    else
        echo -e "   \e[1m\e[31mBuild cancelled by user\e[0m"
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
    echo -e "\e[32m\e[1mSetting up build directory mount...\e[0m"
    printf "\n\n"
    mkdir -pv "$IGos"
    mount -v -t ext4 /dev/"$TARGET_PARTITION" "$IGos"
    printf "\n\n"
    sleep 3
    echo -e "\e[32m\e[1mBuild directory mount setup complete\e[0m"
    sleep 2

    # Set variables into host system user and root accounts
    clear
    HEADER
    echo -en "\e[32m\e[1mPlease enter your system username\e[0m: "
    read USER
    printf "\n"
    echo -e "\e[32m\e[1mAdding environment variables to bash initialization files...\e[0m"
    sleep 1
    printf "\n\n"
    echo "export IGos=/mnt/igos" >> /home/"$USER"/.bashrc
    echo "export IGos=/mnt/igos" >> /root/.bashrc
    echo "export IGosPart=/dev/$TARGET_PARTITION" >> /home/"$USER"/.bash_profile
    echo "export IGosPart=/dev/$TARGET_PARTITION" >> /root/.bash_profile
    printf "\n\n"
    sleep 3
    echo -e "\e[32m\e[1mVariable additions complete\e[0m"
    sleep 2

    # Set up source directory
    clear
    HEADER
    echo -e "\e[32m\e[1mCreating sources directory...\e[0m"
    printf "\n\n"
    mkdir -v "$IGos"/sources
    chmod -v a+wt "$IGos"/sources
    printf "\n\n"
    sleep 3
    echo -e "\e[32m\e[1mSource directory creation complete\e[0m"
    sleep 2

    # Download source packages
    clear
    HEADER
    echo -e "\e[32m\e[1mFetching sources... \e[0m(this will take a minute...)"
    printf "\n\n"
    wget -q https://github.com/InterGenOS/sources_003/archive/master.zip -P "$IGos"
    printf "\n"
    sleep 3
    echo -e "\e[32m\e[1mSource retrieval complete...\e[0m"
    sleep 2

    # Move source packages into place
    clear
    HEADER
    echo -e "\e[32m\e[1mPreparing sources for compilation...\e[0m"
    sleep 1
    printf "\n\n"
    cd "$IGos"
    unzip master.zip 2>&1 &&
    rm master.zip
    mv sources_003-master/* "$IGos"/sources &&
    rm -rf sources_003-master
    rm "$IGos"/sources/README.md
    mkdir -v "$IGos"/tools
    ln -sv "$IGos"/tools /
    printf "\n\n"
    sleep 3
    echo -e "\e[32m\e[1mSource preparation complete\e[0m"
    sleep 2

    # Create build system user
    clear
    HEADER
    echo -e "\e[32m\e[1mCreating user '\e[1m\e[37migos\e[0m' with password '\e[1m\e[33mintergenos\e[0m'\e[1m\e[32m...\e[0m"
    printf "\n\n"
    groupadd igos
    useradd -s /bin/bash -g igos -m -k /dev/null igos
    echo "igos:intergenos" | chpasswd
    printf "\n\n"
    sleep 3
    echo -e "\e[32m\e[1mUser creation complete\e[0m"
    sleep 2

    # Assign build directory ownership to build system user
    clear
    HEADER
    echo -e "\e[32m\e[1mAssigning tools' and sources' ownership to user '\e[1m\e[37migos\e[1m\e[32m'...\e[0m"
    printf "\n\n"
    chown -v igos "$IGos"/tools
    chown -v igos "$IGos"/sources
    printf "\n\n"
    sleep 3
    echo -e "\e[32m\e[1mDirectory ownership assingment complete\e[0m"
    sleep 2

    # Setup igos shell for 'build_temporary_system.sh'
    clear
    HEADER
    echo -e "\e[32m\e[1mPreparing shell variables for user '\e[1m\e[37migos\e[1m\e[32m'...\e[0m"
    printf "\n\n"

    # Download temporary system build script, assign ownerships to build user
    wget -q https://raw.githubusercontent.com/InterGenOS/build_003/master/build_temporary_system.sh -P "$IGos"
    wget -q https://raw.githubusercontent.com/InterGenOS/build_003/master/clean_environment.sh -P "$IGos"
    wget -q https://raw.githubusercontent.com/InterGenOS/build_003/master/enter_chroot.sh -P "$IGos"
    wget -q https://raw.githubusercontent.com/InterGenOS/build_003/master/build_system.sh -P "$IGos"
    wget -q https://raw.githubusercontent.com/InterGenOS/build_003/master/home.igos.bash_profile -P "$IGos"
    wget -q https://raw.githubusercontent.com/InterGenOS/build_003/master/home.igos.bashrc -P "$IGos"
    chown -v igos "$IGos"/build_temporary_system.sh "$IGos"/clean_environment.sh "$IGos"/enter_chroot.sh "$IGos"/build_system.sh
    chmod +x "$IGos"/build_temporary_system.sh "$IGos"/clean_environment.sh "$IGos"/enter_chroot.sh "$IGos"/build_system.sh

    # Copy current grub.cfg for alteration upon build completion
    cp /boot/grub/grub.cfg "$IGos"/grub.cfg

    # Sets build user bash.profile
    mv home.igos.bash_profile /home/igos/.bash_profile

    # Sets build user .bashrc
    mv home.igos.bashrc /home/igos/.bashrc

    # Sets bash file ownership
    chown -v igos:users /home/igos/.bashrc /home/igos/.bash_profile

    printf "\n\n"
    sleep 3
    echo -e "\e[32m\e[1mShell variable preparation complete\e[0m"
    sleep 2

}

SETUP_CHROOT () {

    clear
    HEADER
    echo -e "\e[32m\e[1mChanging temporary tools direcotry ownership...\e[0m"
    printf "\n"
    chown -R root:root "$IGos"/tools
    sleep 1
    printf "\n"
    sleep 3
    echo -e "\e[32m\e[1mTemp tools directory ownership change comlete\e[0m"
    sleep 2

    clear
    HEADER
    echo -e "\e[32m\e[1mPreparing Virtual Kernel File Systems...\e[0m"
    printf "\n"
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
    printf "\n\n"
    sleep 3
    echo -e "\e[32m\e[1mVirtual kernel file preparation complete\e[0m"
    printf "\n\n\n"
    echo -e "     \e[1m\e[4m\e[34mEntering chroot environment...\e[0m"
    printf "\n"
    sleep 2

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
    printf "\n\n"
    echo -e "\e[1m\e[5m\e[31m--------\e[0m"
    echo -e "\e[1m\e[5m\e[31mWARNING!\e[0m"
    echo -e "\e[1m\e[5m\e[31m--------\e[0m"
    printf "\n\n"
    echo -e "\e[1m\e[37mInterGenOS must be built as \e[1m\e[31mroot\e[0m"
    printf "\n\n"
    echo -e "\e[1m\e[32m(Exiting now...)\e[0m"
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

mkdir -pv /var/log/InterGenOS/BuildLogs/Temp_Sys_Buildlogs
chmod 777 /var/log/InterGenOS /var/log/InterGenOS/BuildLogs /var/log/InterGenOS/BuildLogs/Temp_Sys_Buildlogs

GET_PARTITION 2>&1 | tee build_log
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' build_log
mv build_log /var/log/InterGenOS/BuildLogs/Temp_Sys_Buildlogs/setup_log_"$TIMESTAMP"

# Build temporary system in separate shell as the build user
cd "$IGos"
sudo -u igos ./clean_environment.sh &&
printf "\n\n\n"

SETUP_CHROOT 2>&1 | tee chroot_log
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' chroot_log
mv chroot_log /var/log/InterGenOS/BuildLogs/chroot_log_"$TIMESTAMP"

cd "$IGos"
sudo -u root ./enter_chroot.sh 2>&1 | tee sys_build_log &&
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' sys_build_log
mv sys_build_log /var/log/InterGenOS/BuildLogs/sys_build_log_"$TIMESTAMP"
printf "\n\n\n"

#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################
