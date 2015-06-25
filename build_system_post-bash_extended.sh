#!/bin/bash
# build_system_post-bash_extended.sh
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
set +h
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin
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

#-------------------------------------------------#
# BEGIN - EXTENDED SYSTEM PACKAGE BUILD FUNCTIONS #
#-------------------------------------------------#

BUILD_BC () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding bc-1.06.95...\e[0m"
    sleep 3
    printf "\n\n"

    ################
    ## Bc-1.06.95 ##
    ## ========== ##
    ################

    tar xf bc-1.06.95.src.tar.gz &&
    cd bc-1.06.95/
    patch -Np1 -i ../bc-1.06.95-memory_leak-1.patch
    ./configure --prefix=/usr           \
                --with-readline         \
                --mandir=/usr/share/man \
                --infodir=/usr/share/info &&
    make &&
    echo "quit" | ./bc/bc -l Test/checklib.b >> /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/bc_mkck_log_"$TIMESTAMP"
    make install &&
    cd ..
    rm -rf bc-1.06.95/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mbc-1.06.95 completed...\e[0m"
    sleep 2

}

BUILD_LIBTOOL () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding libtool-2.4.6...\e[0m"
    sleep 3
    printf "\n\n"

    ###################
    ## Libtool-2.4.6 ##
    ## ============= ##
    ###################

    tar xf libtool-2.4.6.src.tar.gz &&
    cd libtool-2.4.6/
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/libtool-mkck-log_"$TIMESTAMP"
    make install &&
    cd ..
    rm -rf libtool-2.4.6/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mlibtool-2.4.6 completed...\e[0m"
    sleep 2

}

BUILD_GDBM () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding gdbm-1.11...\e[0m"
    sleep 3
    printf "\n\n"

    ###############
    ## GDBM-1.11 ##
    ## ========= ##
    ###############

    tar xf gdbm-1.11.src.tar.gz &&
    cd gdbm-1.11/
    ./configure --prefix=/usr --enable-libgdbm-compat &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/gdbm-mkck-log_"$TIMESTAMP"
    make install &&
    cd ..
    rm -rf gdbm-1.11/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mgdbm-1.11 completed...\e[0m"
    sleep 2

}



#-----------------------------------------------#
# END - EXTENDED SYSTEM PACKAGE BUILD FUNCTIONS #
#-----------------------------------------------#

############################
##------------------------##
## END - SCRIPT FUNCTIONS ##
##------------------------##
############################

#########################
##---------------------##
## BEGIN - CORE SCRIPT ##
##---------------------##
#########################

echo -e "    \e[1m\e[32mNew shell launch with completed system bash binary successful..."
DIVIDER
echo -e "    \e[1m\e[32mContinuing build..."
SPACER
sleep 3

# Remove executable from /root/.bash_profile
echo \# > /root/.bash_profile

# Tidy up bash-4.3.30 build
cd /sources
rm -rf bash-4.3.30

BUILD_BC
BUILD_LIBTOOL
BUILD_GDBM


#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################

exit 0
