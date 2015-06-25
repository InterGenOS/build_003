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

BUILD_EXPAT () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding expat-2.1.0...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Expat-2.1.0 ##
    ## =========== ##
    #################

    tar xf expat-2.1.0.src.tar.gz &&
    cd expat-2.1.0/
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/expat-mkck-log_"$TIMESTAMP"
    make install &&
    cd ..
    rm -rf expat-2.1.0/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mexpat-2.1.0 completed...\e[0m"
    sleep 2

}

BUILD_INETUTILS () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding inetutils-1.9.2...\e[0m"
    sleep 3
    printf "\n\n"

    #####################
    ## Inetutils-1.9.2 ##
    ## =============== ##
    #####################

    tar xf inetutils-1.9.2.src.tar.gz &&
    cd inetutils-1.9.2/
    echo '#define PATH_PROCNET_DEV "/proc/net/dev"' >> ifconfig/system/linux.h
    ./configure --prefix=/usr        \
                --localstatedir=/var \
                --disable-logger     \
                --disable-whois      \
                --disable-servers &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/inetutils-mkck-log_"$TIMESTAMP"
    make install &&
    mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin &&
    mv -v /usr/bin/ifconfig /sbin &&
    cd ..
    rm -rf inetutils-1.9.2/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32minetutils-1.9.2 completed...\e[0m"
    sleep 2

}

BUILD_PERL () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding perl-5.20.2...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Perl-5.20.2 ##
    ## =========== ##
    #################

    tar xf perl-5.20.2.src.tar.gz &&
    cd perl-5.20.2/
    echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
    export BUILD_ZLIB=False
    export BUILD_BZIP2=0
    sh Configure -des -Dprefix=/usr                 \
                      -Dvendorprefix=/usr           \
                      -Dman1dir=/usr/share/man/man1 \
                      -Dman3dir=/usr/share/man/man3 \
                      -Dpager="/usr/bin/less -isR"  \
                      -Duseshrplib &&
    make &&
    make -k test 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/perl-mkck-log_"$TIMESTAMP"
    make install &&
    unset BUILD_ZLIB BUILD_BZIP2
    cd ..
    rm -rf perl-5.20.2/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mperl-5.20.2 completed...\e[0m"
    sleep 2

}

BUILD_XML-PARSER () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding xml-parser-2.44...\e[0m"
    sleep 3
    printf "\n\n"

    ######################
    ## XML::Parser-2.44 ##
    ## ================ ##
    ######################

    tar xf XML-Parser-2.44.src.tar.gz &&
    cd XML-Parser-2.44/
    perl Makefile.PL &&
    make &&
    make test 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/xml_parser-mkck-log_"$TIMESTAMP"
    make install &&
    cd ..
    rm -rf XML-Parser-2.44/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mxml-parser-2.44 completed...\e[0m"
    sleep 2

}

BUILD_AUTOCONF () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding autoconf-2.69...\e[0m"
    sleep 3
    printf "\n\n"

    ###################
    ## Autoconf-2.69 ##
    ## ============= ##
    ###################

    tar xf autoconf-2.69.src.tar.gz &&
    cd autoconf-2.69/
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/autoconf-mkck-log_"$TIMESTAMP"
    make install &&
    cd ..
    rm -rf autoconf-2.69/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mautoconf-2.69 completed...\e[0m"
    sleep 2

}

BUILD_AUTOMAKE () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding automake-1.15...\e[0m"
    sleep 3
    printf "\n\n"

    ###################
    ## Automake-1.15 ##
    ## ============= ##
    ###################

    tar xf automake-1.15.tar.xz &&
    cd automake-1.15/
    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/automake-1.15 &&
    make &&
    sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh
    make -j4 check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/automake-mkck-log_"$TIMESTAMP"
    make install &&
    cd ..
    rm -rf automake-1.15/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mautomake-1.15 completed...\e[0m"
    sleep 2

}

BUILD_DIFFUTILS () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding diffutils-3.3...\e[0m"
    sleep 3
    printf "\n\n"

    ###################
    ## Diffutils-3.3 ##
    ## ============= ##
    ###################

    tar xf diffutils-3.3.src.tar.gz &&
    cd diffutils-3.3/
    sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/diffutils-mkck-log_"$TIMESTAMP"
    make install &&
    cd ..
    rm -rf diffutils-3.3/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mdiffutils-3.3 completed...\e[0m"
    sleep 2

}

BUILD_GAWK () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding gawk-4.1.1...\e[0m"
    sleep 3
    printf "\n\n"

    ################
    ## Gawk-4.1.1 ##
    ## ========== ##
    ################

    tar xf gawk-4.1.1.src.tar.gz &&
    cd gawk-4.1.1/
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/gawk-mkck-log_"$TIMESTAMP"
    make install &&
    cd ..
    rm -rf gawk-4.1.1/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mgawk-4.1.1 completed...\e[0m"
    sleep 2

}

BUILD_FINDUTILS () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding findutils-4.4.2...\e[0m"
    sleep 3
    printf "\n\n"

    #####################
    ## Findutils-4.4.2 ##
    ## =============== ##
    #####################

    tar xf findutils-4.4.2.src.tar.gz &&
    cd findutils-4.4.2/
    ./configure --prefix=/usr --localstatedir=/var/lib/locate &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/findutils-mkck-log_"$TIMESTAMP"
    make install &&
    mv -v /usr/bin/find /bin
    sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
    cd ..
    rm -rf findutils-4.4.2/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mfindutils-4.4.2 completed...\e[0m"
    sleep 2

}

BUILD_GETTEXT () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding gettext-0.19.4...\e[0m"
    sleep 3
    printf "\n\n"

    ####################
    ## Gettext-0.19.4 ##
    ## ============== ##
    ####################

    tar xf gettext-0.19.4.src.tar.gz &&
    cd gettext-0.19.4/
    ./configure --prefix=/usr --docdir=/usr/share/doc/gettext-0.19.4 &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/gettext-mkck-log_"$TIMESTAMP"
    make install &&
    cd ..
    rm -rf gettext-0.19.4/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mgettext-0.19.4 completed...\e[0m"
    sleep 2

}

BUILD_INTLTOOL () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding intltool-0.50.2...\e[0m"
    sleep 3
    printf "\n\n"

    #####################
    ## Intltool-0.50.2 ##
    ## =============== ##
    #####################

    tar xf intltool-0.50.2.src.tar.gz &&
    cd intltool-0.50.2/
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/intltool-mkck-log_"$TIMESTAMP"
    make install &&
    install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.50.2/I18N-HOWTO &&
    cd ..
    rm -rf intltool-0.50.2/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mintltool-0.50.2 completed...\e[0m"
    sleep 2

}

BUILD_GPERF () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding gperf-3.0.4...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Gperf-3.0.4 ##
    ## =========== ##
    #################

    tar xf gperf-3.0.4.tar.gz &&
    cd gperf-3.0.4/
    ./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.0.4 &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/gperf-mkck-log_"$TIMESTAMP"
    make install &&
    cd ..
    rm -rf gperf-3.0.4/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mgperf-3.0.4 completed...\e[0m"
    sleep 2

}

BUILD_GROFF () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding groff-1.22.3...\e[0m"
    sleep 3
    printf "\n\n"

    ##################
    ## Groff-1.22.3 ##
    ## ============ ##
    ##################

    tar xf groff-1.22.3.src.tar.gz &&
    cd groff-1.22.3/
    PAGE=letter ./configure --prefix=/usr &&
    make &&
    make install &&
    cd ..
    rm -rf groff-1.22.3/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mgroff-1.22.3 completed...\e[0m"
    sleep 2

}

BUILD_XZ () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding xz-5.2.0...\e[0m"
    sleep 3
    printf "\n\n"

    ##############
    ## Xz-5.2.0 ##
    ## ======== ##
    ##############

    tar xf xz-5.2.0.src.tar.gz &&
    cd xz-5.2.0/
    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/xz-5.2.0 &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/xz-mkck-log_"$TIMESTAMP"
    make install &&
    mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
    mv -v /usr/lib/liblzma.so.* /lib
    ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
    cd .. && rm -rf xz-5.2.0/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mxz-5.2.0 completed...\e[0m"
    sleep 2

}

BUILD_GRUB () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding grub-2.0.2~beta2...\e[0m"
    sleep 3
    printf "\n\n"

    #####################
    ## GRUB-2.02~beta2 ##
    ## =============== ##
    #####################

    tar xf grub-2.02~beta2.src.tar.gz &&
    cd grub-2.02~beta2/
    ./configure --prefix=/usr          \
                --sbindir=/sbin        \
                --sysconfdir=/etc      \
                --disable-grub-emu-usb \
                --disable-efiemu       \
                --disable-werror &&
    make &&
    make install &&
    cd ..
    rm -rf grub-2.02~beta2/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mgrub-2.0.2~beta2 completed...\e[0m"
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
BUILD_EXPAT
BUILD_INETUTILS
BUILD_PERL
BUILD_XML-PARSER
BUILD_AUTOCONF
BUILD_AUTOMAKE
BUILD_DIFFUTILS
BUILD_GAWK
BUILD_FINDUTILS
BUILD_GETTEXT
BUILD_INTLTOOL
BUILD_GPERF
BUILD_GROFF
BUILD_XZ
BUILD_GRUB





#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################

exit 0