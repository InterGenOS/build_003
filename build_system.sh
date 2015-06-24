#!/tools/bin/bash
# build_system.sh
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

set +h
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin
export PATH

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

#----------------------------------------#
# BEGIN - SYSTEM PACKAGE BUILD FUNCTIONS #
#----------------------------------------#

CONFIRM_CHROOT () {

    clear
    HEADER
    echo -e "\e[1m\e[32mSuccessfully entered chroot environment\e[0m"
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mContinuing build...\e[0m"
    sleep 2


}

CREATE_DIRECTORIES () {

    clear
    HEADER
    echo -e "\e[1m\e[32mCreating system directories...\e[0m"
    printf "\n\n"
    sleep 3
    mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
    mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
    install -dv -m 0750 /root
    install -dv -m 1777 /tmp /var/tmp
    mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
    mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
    mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}
    mkdir -v  /usr/libexec
    mkdir -pv /usr/{,local/}share/man/man{1..8}
    case $(uname -m) in
        x86_64) ln -sv lib /lib64
                ln -sv lib /usr/lib64
                ln -sv lib /usr/local/lib64 ;;
    esac
    mkdir -v /var/{log,mail,spool}
    ln -sv /run /var/run
    ln -sv /run/lock /var/lock
    mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}
    printf "\n\n"
    sleep 2
    echo -e "\e[1m\e[32mSystem directories created successfully\e[0m"
    sleep 3

}

CREATE_FILES_AND_SYMLINKS () {

    clear
    HEADER
    echo -e "\e[1m\e[32mCreating essential files and symlinks...\e[0m"
    sleep 3
    printf "\n\n"
    ln -sv /tools/bin/{bash,cat,echo,pwd,stty} /bin
    ln -sv /tools/bin/perl /usr/bin
    ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
    ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib
    sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
    ln -sv bash /bin/sh
    ln -sv /proc/self/mounts /etc/mtab
    printf "\n\n"
    sleep 2
    echo -e "\e[1m\e[32mSystem files and symlinks created successfully\e[0m"
    sleep 3

}

SETUP_LOGGING () {

    clear
    HEADER
    echo -e "\e[1m\e[32mCreating log directories...\e[0m"
    sleep 3
    printf "\n"
    SPACER
    touch /var/log/{btmp,lastlog,wtmp}
    chgrp -v utmp /var/log/lastlog
    chmod -v 664  /var/log/lastlog
    chmod -v 600  /var/log/btmp
    mkdir -pv /var/log/InterGenOS/BuildLogs/Sys_Buildlogs
    printf "\n\n"
    sleep 2
    echo -e "\e[1m\e[32mLog directories created successfully\e[0m"
    sleep 3

}

BUILD_LINUX () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding linux-3.19...\e[0m"
    sleep 3
    printf "\n\n"

    ################
    ## Linux-3.19 ##
    ## ========== ##
    ################

    tar xf linux-3.19.src.tar.gz &&
    cd linux-3.19/
    make mrproper &&
    make INSTALL_HDR_PATH=dest headers_install &&
    find dest/include \( -name .install -o -name ..install.cmd \) -delete &&
    cp -rv dest/include/* /usr/include &&
    cd ..
    # DO NOT REMOVE LINUX SOURCE DIRECTORY - NEEDED FOR ETHERNET DRIVER COMPILATION
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mlinux-3.19 completed...\e[0m"
    sleep 2

}

BUILD_MAN_PAGES () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding man-pages-3.79...\e[0m"
    sleep 3
    printf "\n\n"

    ####################
    ## Man-Pages-3.79 ##
    ## ============== ##
    ####################

    tar xf man-pages-3.79.src.tar.gz &&
    cd man-pages-3.79
    make install &&
    cd .. &&
    rm -rf man-pages-3.79 &&
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mman-pages-3.79 completed...\e[0m"
    sleep 2

}

BUILD_GLIBC () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding glibc-2.21...\e[0m"
    sleep 3
    printf "\n\n"

    ################
    ## Glibc-2.21 ##
    ## ========== ##
    ################

    tar xf glibc-2.21.src.tar.gz &&
    cd glibc-2.21/
    patch -Np1 -i ../glibc-2.21-fhs-1.patch &&
    sed -e '/ia32/s/^/1:/' \
        -e '/SSE2/s/^1://' \
        -i  sysdeps/i386/i686/multiarch/mempcpy_chk.S &&
    mkdir -pv ../glibc-build
    cd ../glibc-build
    ../glibc-2.21/configure    \
        --prefix=/usr          \
        --disable-profile      \
        --enable-kernel=2.6.32 \
        --enable-obsolete-rpc &&
    make &&
    make check 2>&1 | tee glibc_make-check_log
    touch /etc/ld.so.conf
    make install &&
    cp -v ../glibc-2.21/nscd/nscd.conf /etc/nscd.conf
    mkdir -pv /var/cache/nscd
    install -v -Dm644 ../glibc-2.21/nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf &&
    install -v -Dm644 ../glibc-2.21/nscd/nscd.service /lib/systemd/system/nscd.service &&
    mkdir -pv /usr/lib/locale
    localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8 &&
    localedef -i de_DE -f ISO-8859-1 de_DE &&
    localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro &&
    localedef -i de_DE -f UTF-8 de_DE.UTF-8 &&
    localedef -i en_GB -f UTF-8 en_GB.UTF-8 &&
    localedef -i en_HK -f ISO-8859-1 en_HK &&
    localedef -i en_PH -f ISO-8859-1 en_PH &&
    localedef -i en_US -f ISO-8859-1 en_US &&
    localedef -i en_US -f UTF-8 en_US.UTF-8 &&
    localedef -i es_MX -f ISO-8859-1 es_MX &&
    localedef -i fa_IR -f UTF-8 fa_IR &&
    localedef -i fr_FR -f ISO-8859-1 fr_FR &&
    localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro &&
    localedef -i fr_FR -f UTF-8 fr_FR.UTF-8 &&
    localedef -i it_IT -f ISO-8859-1 it_IT &&
    localedef -i it_IT -f UTF-8 it_IT.UTF-8 &&
    localedef -i ja_JP -f EUC-JP ja_JP &&
    localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R &&
    localedef -i ru_RU -f UTF-8 ru_RU.UTF-8 &&
    localedef -i tr_TR -f UTF-8 tr_TR.UTF-8 &&
    localedef -i zh_CN -f GB18030 zh_CN.GB18030 &&
    touch /etc/nsswitch.conf
    echo "# Begin /etc/nsswitch.conf" >> /etc/nsswitch.conf
    echo " " >> /etc/nsswitch.conf
    echo "passwd: files" >> /etc/nsswitch.conf
    echo "group: files" >> /etc/nsswitch.conf
    echo "shadow: files" >> /etc/nsswitch.conf
    echo " " >> /etc/nsswitch.conf
    echo "hosts: files dns myhostname" >> /etc/nsswitch.conf
    echo "networks: files" >> /etc/nsswitch.conf
    echo " " >> /etc/nsswitch.conf
    echo "protocols: files" >> /etc/nsswitch.conf
    echo "services: files" >> /etc/nsswitch.conf
    echo "ethers: files" >> /etc/nsswitch.conf
    echo "rpc: files" >> /etc/nsswitch.conf
    echo " " >> /etc/nsswitch.conf
    echo "# End /etc/nsswitch.conf" >> /etc/nsswitch.conf
    tar -xf ../tzdata2015a.tar.gz
    mv tzdata2015a/* .
    ZONEINFO=/usr/share/zoneinfo
    mkdir -pv $ZONEINFO/{posix,right}
    for tz in etcetera southamerica northamerica europe africa antarctica asia australasia backward pacificnew systemv; do
              zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
              zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
              zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
    done
    cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
    zic -d $ZONEINFO -p America/New_York
    unset ZONEINFO
    ln -sfv /usr/share/zoneinfo/America/Chicago /etc/localtime
    touch /etc/ld.so.conf
    echo "# Begin /etc/ld.so.conf" >> /etc/ld.so.conf
    echo "/usr/local/lib" >> /etc/ld.so.conf
    echo "/opt/lib" >> /etc/ld.so.conf
    echo " "
    echo "# Add an include directory" >> /etc/ld.so.conf
    echo "include /etc/ld.so.conf.d/*.conf" >> /etc/ld.so.conf
    mkdir -pv /etc/ld.so.conf.d
    printf "\n\n"
    mv glibc_make-check_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/glibc_make-check_log
    sleep 3
    echo -e "\e[1m\e[32mglibc-2.21 completed...\e[0m"
    sleep 2

}



#------------------------------------------------#
# END - TEMPORARY SYSTEM PACKAGE BUILD FUNCTIONS #
#------------------------------------------------#

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

CONFIRM_CHROOT
CREATE_DIRECTORIES
CREATE_FILES_AND_SYMLINKS

# Create /etc/passwd
cat > /etc/passwd << "EndOfEtcPasswd"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
systemd-bus-proxy:x:72:72:systemd Bus Proxy:/:/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/bin/false
systemd-network:x:76:76:systemd Network Management:/:/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EndOfEtcPasswd

# Create /etc/group
cat > /etc/group << "EndOfEtcGroup"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
systemd-bus-proxy:x:72:
systemd-journal-gateway:x:73:
systemd-journal-remote:x:74:
systemd-journal-upload:x:75:
systemd-network:x:76:
systemd-resolve:x:77:
systemd-timesync:x:78:
nogroup:x:99:
users:x:999:
EndOfEtcGroup

SETUP_LOGGING

cd /sources

BUILD_LINUX
BUILD_MAN_PAGES
BUILD_GLIBC

SPACER
echo -e "\e[1m\e[32mWORKING AS EXPECTED\e[0m"
SPACER
sleep 5

printf "\n\n\n"
exit 0
