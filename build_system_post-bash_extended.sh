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
    cd /sources
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
    cd /sources
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
    cd /sources
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
    cd /sources
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
    cd /sources
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
    cd /sources
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
    cd /sources
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
    cd /sources
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

    tar xf automake-1.15.src.tar.gz &&
    cd automake-1.15/
    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/automake-1.15 &&
    make &&
    sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh
    make -j4 check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/automake-mkck-log_"$TIMESTAMP"
    make install &&
    cd /sources
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
    cd /sources
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
    cd /sources
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
    cd /sources
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
    cd /sources
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
    cd /sources
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

    tar xf gperf-3.0.4.src.tar.gz &&
    cd gperf-3.0.4/
    ./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.0.4 &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/gperf-mkck-log_"$TIMESTAMP"
    make install &&
    cd /sources
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
    cd /sources
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
    cd /sources
    rm -rf xz-5.2.0/
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
    cd /sources
    rm -rf grub-2.02~beta2/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mgrub-2.0.2~beta2 completed...\e[0m"
    sleep 2

}

BUILD_LESS () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding less-458...\e[0m"
    sleep 3
    printf "\n\n"

    ##############
    ## Less-458 ##
    ## ======== ##
    ##############

    tar xf less-458.src.tar.gz &&
    cd less-458/
    ./configure --prefix=/usr \
        --sysconfdir=/etc &&
    make &&
    make install &&
    cd /sources
    rm -rf less-458/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mless-458 completed...\e[0m"
    sleep 2

}

BUILD_GZIP () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding gzip-1.6...\e[0m"
    sleep 3
    printf "\n\n"

    ##############
    ## Gzip-1.6 ##
    ## ======== ##
    ##############

    tar xf gzip-1.6.src.tar.gz &&
    cd gzip-1.6/
    ./configure --prefix=/usr \
        --bindir=/bin &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/gzip-mkck-log_"$TIMESTAMP"
    make install &&
    mv -v /bin/{gzexe,uncompress,zcmp,zdiff,zegrep} /usr/bin
    mv -v /bin/{zfgrep,zforce,zgrep,zless,zmore,znew} /usr/bin
    cd /sources
    rm -rf gzip-1.6/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mgzip-1.6 completed...\e[0m"
    sleep 2

}

BUILD_IPROUTE2 () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding iproute2-3.19.0...\e[0m"
    sleep 3
    printf "\n\n"

    #####################
    ## IPRoute2-3.19.0 ##
    ## =============== ##
    #####################

    tar xf iproute2-3.19.0.src.tar.gz &&
    cd iproute2-3.19.0/
    sed -i '/^TARGETS/s@arpd@@g' misc/Makefile
    sed -i /ARPD/d Makefile
    sed -i 's/arpd.8//' man/man8/Makefile
    make &&
    make DOCDIR=/usr/share/doc/iproute2-3.19.0 install &&
    cd /sources
    rm -rf iproute2-3.19.0/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32miproute2-3.19.0 completed...\e[0m"
    sleep 2

}

BUILD_KBD () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding kbd-2.0.2...\e[0m"
    sleep 3
    printf "\n\n"

    ###############
    ## Kbd-2.0.2 ##
    ## ========= ##
    ###############

    tar xf kbd-2.0.2.src.tar.gz &&
    cd kbd-2.0.2/
    patch -Np1 -i ../kbd-2.0.2-backspace-1.patch &&
    sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
    sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
    PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/kbd-mkck-log_"$TIMESTAMP"
    make install &&
    cd /sources
    rm -rf kbd-2.0.2/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mkbd-2.0.2 completed...\e[0m"
    sleep 2

}

BUILD_KMOD () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding kmod-19...\e[0m"
    sleep 3
    printf "\n\n"

    #############
    ## Kmod-19 ##
    ## ======= ##
    #############

    tar xf kmod-19.src.tar.gz &&
    cd kmod-19/
    ./configure --prefix=/usr          \
                --bindir=/bin          \
                --sysconfdir=/etc      \
                --with-rootlibdir=/lib \
                --with-xz              \
                --with-zlib &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/kmod-mkck-log_"$TIMESTAMP"
    make install &&
    for target_mod in depmod insmod lsmod modinfo modprobe rmmod; do
      ln -sv ../bin/kmod /sbin/$target_mod
    done
    ln -sv kmod /bin/lsmod
    cd /sources
    rm -rf kmod-19/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mkmod-19 completed...\e[0m"
    sleep 2

}

BUILD_LIBPIPELINE () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding libpipeline-1.4.0...\e[0m"
    sleep 3
    printf "\n\n"

    #######################
    ## Libpipeline-1.4.0 ##
    ## ================= ##
    #######################

    tar xf libpipeline-1.4.0.src.tar.gz &&
    cd libpipeline-1.4.0/
    PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/libpipeline-mkck-log_"$TIMESTAMP"
    make install &&
    cd /sources
    rm -rf libpipeline-1.4.0/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mlibpipeline-1.4.0 completed...\e[0m"
    sleep 2

}

BUILD_MAKE () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding make-4.1...\e[0m"
    sleep 3
    printf "\n\n"

    ##############
    ## Make-4.1 ##
    ## ======== ##
    ##############

    tar xf make-4.1.src.tar.gz &&
    cd make-4.1/
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/make-mkck-log_"$TIMESTAMP"
    make install &&
    cd /sources
    rm -rf make-4.1/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mmake-4.1 completed...\e[0m"
    sleep 2

}

BUILD_PATCH () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding patch-2.7.4...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Patch-2.7.4 ##
    ## =========== ##
    #################

    tar xf patch-2.7.4.src.tar.gz &&
    cd patch-2.7.4/
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/patch-mkck-log_"$TIMESTAMP"
    make install &&
    cd /sources
    rm -rf patch-2.7.4/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mpatch-2.7.4 completed...\e[0m"
    sleep 2

}

BUILD_SYSTEMD () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding systemd-219...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Systemd-219 ##
    ## =========== ##
    #################

    tar xf systemd-219.src.tar.gz &&
    cd systemd-219/
    mv ../config.cache .
    sed -i "s:blkid/::" $(grep -rl "blkid/blkid.h")
    patch -Np1 -i ../systemd-219-compat-1.patch
    sed -i "s:test/udev-test.pl ::g" Makefile.in
    ./configure --prefix=/usr                                           \
                --sysconfdir=/etc                                       \
                --localstatedir=/var                                    \
                --config-cache                                          \
                --with-rootprefix=                                      \
                --with-rootlibdir=/lib                                  \
                --enable-split-usr                                      \
                --disable-gudev                                         \
                --disable-firstboot                                     \
                --disable-ldconfig                                      \
                --disable-sysusers                                      \
                --without-python                                        \
                --docdir=/usr/share/doc/systemd-219                     \
                --with-dbuspolicydir=/etc/dbus-1/system.d               \
                --with-dbussessionservicedir=/usr/share/dbus-1/services \
                --with-dbussystemservicedir=/usr/share/dbus-1/system-services &&
    make LIBRARY_PATH=/tools/lib &&
    make LD_LIBRARY_PATH=/tools/lib install
    mv -v /usr/lib/libnss_{myhostname,mymachines,resolve}.so.2 /lib &&
    rm -rfv /usr/lib/rpm &&
    for system_tool in runlevel reboot shutdown poweroff halt telinit; do
         ln -sfv ../bin/systemctl /sbin/${system_tool}
    done
    ln -sfv ../lib/systemd/systemd /sbin/init
    sed -i "s:0775 root lock:0755 root root:g" /usr/lib/tmpfiles.d/legacy.conf
    sed -i "/pam.d/d" /usr/lib/tmpfiles.d/etc.conf
    systemd-machine-id-setup &&
    sed -i "s:minix:ext4:g" src/test/test-path-util.c
    make LD_LIBRARY_PATH=/tools/lib -k check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/systemd-mkck-log_"$TIMESTAMP"
    cd /sources
    rm -rf systemd-219/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32msystemd-219 completed...\e[0m"
    sleep 2

}

BUILD_D-BUS () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding d-bus-1.8.16...\e[0m"
    sleep 3
    printf "\n\n"

    ##################
    ## D-Bus-1.8.16 ##
    ## ============ ##
    ##################

    tar xf dbus-1.8.16.src.tar.gz &&
    cd dbus-1.8.16/
    ./configure --prefix=/usr                       \
                --sysconfdir=/etc                   \
                --localstatedir=/var                \
                --docdir=/usr/share/doc/dbus-1.8.16 \
                --with-console-auth-dir=/run/console &&
    make &&
    make install &&
    mv -v /usr/lib/libdbus-1.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so
    ln -sfv /etc/machine-id /var/lib/dbus
    cd /sources
    rm -rf dbus-1.8.16/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32md-bus-1.8.16 completed...\e[0m"
    sleep 2

}

BUILD_UTIL-LINUX () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding util-linux-2.26...\e[0m"
    sleep 3
    printf "\n\n"

    #####################
    ## Util-linux-2.26 ##
    ## =============== ##
    #####################

    tar xf util-linux-2.26.src.tar.gz &&
    cd util-linux-2.26/
    mkdir -pv /var/lib/hwclock
    ./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
                --docdir=/usr/share/doc/util-linux-2.26 \
                --disable-chfn-chsh  \
                --disable-login      \
                --disable-nologin    \
                --disable-su         \
                --disable-setpriv    \
                --disable-runuser    \
                --disable-pylibmount \
                --without-python &&
    make &&
    chown -Rv nobody .
    su nobody -s /bin/bash -c "PATH=$PATH make -k check" 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/util-linux-mkck-log_"$TIMESTAMP"
    make install &&
    cd /sources
    rm -rf util-linux-2.26/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mutil-linux-2.26 completed...\e[0m"
    sleep 2

}

BUILD_MAN-DB () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding man-db-2.7.1...\e[0m"
    sleep 3
    printf "\n\n"

    ##################
    ## Man-DB-2.7.1 ##
    ## ============ ##
    ##################

    tar xf man-db-2.7.1.src.tar.gz &&
    cd man-db-2.7.1/
    ./configure --prefix=/usr                        \
                --docdir=/usr/share/doc/man-db-2.7.1 \
                --sysconfdir=/etc                    \
                --disable-setuid                     \
                --with-browser=/usr/bin/lynx         \
                --with-vgrind=/usr/bin/vgrind        \
                --with-grap=/usr/bin/grap &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/man-db-mkck-log_"$TIMESTAMP"
    make install &&
    sed -i "s:man root:root root:g" /usr/lib/tmpfiles.d/man-db.conf
    cd /sources
    rm -rf man-db-2.7.1/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mman-db-2.7.1 completed...\e[0m"
    sleep 2

}

BUILD_TAR () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding tar-1.28...\e[0m"
    sleep 3
    printf "\n\n"

    ##############
    ## Tar-1.28 ##
    ## ======== ##
    ##############

    tar xf tar-1.28.src.tar.gz &&
    cd tar-1.28/
    FORCE_UNSAFE_CONFIGURE=1  \
    ./configure --prefix=/usr \
                --bindir=/bin &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/man-db-mkck-log_"$TIMESTAMP"
    make install &&
    make -C doc install-html docdir=/usr/share/doc/tar-1.28 &&
    cd /sources
    rm -rf tar-1.28/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mtar-1.28 completed...\e[0m"
    sleep 2

}

BUILD_TEXINFO () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding texinfo-5.2...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Texinfo-5.2 ##
    ## =========== ##
    #################

    tar xf texinfo-5.2.src.tar.gz &&
    cd texinfo-5.2/
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/texinfo-mkck-log_"$TIMESTAMP"
    make install &&
    make TEXMF=/usr/share/texmf install-tex &&
    cd /sources
    rm -rf texinfo-5.2/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mtexinfo-5.2 completed...\e[0m"
    sleep 2

}

BUILD_VIM () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding vim-7.4...\e[0m"
    sleep 3
    printf "\n\n"

    #############
    ## Vim-7.4 ##
    ## ======= ##
    #############

    tar xf vim-7.4.src.tar.gz &&
    cd vim-7.4/
    echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
    ./configure --prefix=/usr &&
    make &&
    make -j1 test > /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/vim-mkck-log_"$TIMESTAMP" &&
    make install &&
    ln -sv vim /usr/bin/vi
    for L in  /usr/share/man/{,*/}man1/vim.1; do
        ln -sv vim.1 $(dirname $L)/vi.1
    done
    ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4
    cd /sources
    rm -rf vim-7.4/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mvim-7.4 completed...\e[0m"
    sleep 2

}

BUILD_NANO () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding nano-2.3.6...\e[0m"
    sleep 3
    printf "\n\n"

    ################
    ## Nano-2.3.6 ##
    ## ========== ##
    ################

    tar xf nano-2.3.6.src.tar.gz &&
    cd nano-2.3.6/
    ./configure --prefix=/usr     \
                --sysconfdir=/etc \
                --enable-utf8     \
                --enable-nanorc   \
                --docdir=/usr/share/doc/nano-2.3.6 &&
    make &&
    make install &&
    install -v -m644 doc/nanorc.sample /etc &&
    install -v -m644 doc/texinfo/nano.html /usr/share/doc/nano-2.3.6 &&
    cd /sources
    rm -rf nano-2.3.6/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mnano-2.3.6 completed...\e[0m"
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

echo -e "    \e[1m\e[32mNew shell launched successfully..."
DIVIDER
echo -e "    \e[1m\e[32mCleaning up bash-4.3.30 source files..."
SPACER
sleep 3

# Remove executable from /root/.bash_profile
echo \# > /root/.bash_profile

# Tidy up bash-4.3.30 build
cd /sources
rm -rf bash-4.3.30
printf "\n"
sleep 3
echo -e "    \e[1m\e[32mContinuing build..."
sleep 3

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
BUILD_LESS
BUILD_GZIP
BUILD_IPROUTE2
BUILD_KBD
BUILD_KMOD
BUILD_LIBPIPELINE
BUILD_MAKE
BUILD_PATCH

cat > config.cache << "Systemd_config"
KILL=/bin/kill
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include/blkid"
HAVE_LIBMOUNT=1
MOUNT_LIBS="-lmount"
MOUNT_CFLAGS="-I/tools/include/libmount"
cc_cv_CFLAGS__flto=no
Systemd_config

BUILD_SYSTEMD
BUILD_D-BUS
BUILD_UTIL-LINUX
BUILD_MAN-DB
BUILD_TAR
BUILD_TEXINFO
BUILD_VIM

cat > /etc/vimrc << "EndOfVimConfig"
" Begin /etc/vimrc
set nocompatible
set backspace=2
syntax on
if (&term == "iterm") || (&term == "putty")
  set background=dark
endif
" End /etc/vimrc
EndOfVimConfig

BUILD_NANO

DIVIDER
echo -e "    \e[1m\e[32mCompleted System Package Builds..."
DIVIDER
sleep 3
echo -e "    \e[1m\e[32mReturning to root shell..."
SPACER
sleep 3

#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################

exit
