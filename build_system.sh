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
    ../glibc-2.21/configure --prefix=/usr \
        --disable-profile                 \
        --enable-kernel=2.6.32            \
        --enable-obsolete-rpc &&
    make &&
    make check 2>&1 | tee glibc_mkck_log
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
    tar -xf ../tzdata2015a.src.tar.gz
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
    mv glibc_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/glibc_mkck_log_"$TIMESTAMP"
    sleep 3
    echo -e "\e[1m\e[32mglibc-2.21 completed...\e[0m"
    sleep 2

}

TOOLCHAIN_TEST1A () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #1A\e[0m"
    printf "\n\n"
    sleep 3
    mv -v /tools/bin/{ld,ld-old}
    mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
    mv -v /tools/bin/{ld-new,ld}
    ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld
    gcc -dumpspecs | sed -e 's@/tools@@g'                   \
        -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
        -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
        `dirname $(gcc --print-libgcc-file-name)`/specs
    echo 'main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log
    Expected_TEST1A="Requestingprograminterpreter/lib64/ld-linux-x86-64.so.2"
    Actual_TEST1A="$(readelf -l a.out | grep ': /lib' | sed -e 's/://g' -e 's/\[//g' -e 's/\]//g' | awk '{print $1$2$3$4}')"
    if [ "$Expected_TEST1A" != "$Actual_TEST1A" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 1A FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 1A \e[1m\e[32mpassed, preparing TEST 2A...\e[0m"
        printf "\n\n"
        sleep 3
    fi

}

TOOLCHAIN_TEST2A () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #2A\e[0m"
    printf "\n\n"
    sleep 3
    Expected_TEST2A="$(cat tlchn_TEST2A.txt)"
    Actual_TEST2A="$(grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log)"
    if [ "$Expected_TEST2A" != "$Actual_TEST2A" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 2A FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 2A \e[1m\e[32mpassed, preparing TEST 3A...\e[0m"
        printf "\n\n"
        sleep 3
    fi
    rm tlchn_TEST2A.txt
}

TOOLCHAIN_TEST3A () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #3A\e[0m"
    printf "\n\n"
    sleep 3
    Expected_TEST3A="/usr/include"
    Actual_TEST3A="$(grep -B1 '^ /usr/include' dummy.log | grep usr | awk '{print $1}')"
    if [ "$Expected_TEST3A" != "$Actual_TEST3A" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 3A FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 3A \e[1m\e[32mpassed, preparing TEST 4A...\e[0m"
        printf "\n\n"
        sleep 3
    fi

}

TOOLCHAIN_TEST4A () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #4A\e[0m"
    printf "\n\n"
    sleep 3
    Expected_TEST4A="$(cat tlchn_TEST4A.txt)"
    Actual_TEST4A="$(grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g')"
    if [ "$Expected_TEST4A" != "$Actual_TEST4A" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 4A FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 4A \e[1m\e[32mpassed, preparing TEST 5A...\e[0m"
        printf "\n\n"
        sleep 3
    fi
    rm tlchn_TEST4A.txt

}

TOOLCHAIN_TEST5A () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #5A\e[0m"
    printf "\n\n"
    sleep 3
    Expected_TEST5A="succeeded"
    Actual_TEST5A="$(grep "/lib.*/libc.so.6 " dummy.log | awk '{print $5}')"
    if [ "$Expected_TEST5A" != "$Actual_TEST5A" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 5A FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 5A \e[1m\e[32mpassed, preparing TEST 6A...\e[0m"
        printf "\n\n"
        sleep 3
    fi

}

TOOLCHAIN_TEST6A () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #6A\e[0m"
    printf "\n\n"
    sleep 3
    Expected_TEST6A="found ld-linux-x86-64.so.2 at /lib64/ld-linux-x86-64.so.2"
    Actual_TEST6A="$(grep found dummy.log)"
    if [ "$Expected_TEST6A" != "$Actual_TEST6A" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 6A FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 6A \e[1m\e[32mpassed, continuing build...\e[0m"
        printf "\n\n"
        sleep 3
    fi
    rm -v dummy.c a.out dummy.log
    cd ..
    rm -rf glibc-2.21 glibc-build/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mToolchain Adjustment Testing completed...\e[0m"
    sleep 2

}

BUILD_ZLIB () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding glibc-2.21...\e[0m"
    sleep 3
    printf "\n\n"

    ################
    ## Zlib-1.2.8 ##
    ## ========== ##
    ################

    tar xf zlib-1.2.8.src.tar.gz &&
    cd zlib-1.2.8
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee zlib-mkck-log
    make install &&
    mv -v /usr/lib/libz.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
    mv zlib_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/glibc_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf zlib-1.2.8
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mzlib-1.2.8 completed...\e[0m"
    sleep 2

}

BUILD_FILE () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding file-5.22...\e[0m"
    sleep 3
    printf "\n\n"

    ###############
    ## File-5.22 ##
    ## ========= ##
    ###############

    tar xf file-5.22.src.tar.gz &&
    cd file-5.22
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee file-mkck-log
    make install &&
    mv file_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/file_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf file-5.22
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mfile-5.22 completed...\e[0m"
    sleep 2

}

BUILD_BINUTILS () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding file-5.22...\e[0m"
    sleep 3
    printf "\n\n"

    ###################
    ## Binutils-2.25 ##
    ## ============= ##
    ###################

    tar xf binutils-2.25.src.tar.gz &&
    mkdir -v binutils-build
    cd binutils-build
    ../binutils-2.25/configure --prefix=/usr \
        --enable-shared                      \
        --disable-werror &&
    make tooldir=/usr &&
    make -k check 2>&1 | tee binutils-mkck-log
    make tooldir=/usr install &&
    mv binutils_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/binutils_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf binutils-2.25 binutils-build/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mbinutils-2.25 completed...\e[0m"
    sleep 2

}

BUILD_GMP () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding gmp-6.0.0a...\e[0m"
    sleep 3
    printf "\n\n"

    ################
    ## GMP-6.0.0a ##
    ## ========== ##
    ################

    tar xf gmp-6.0.0a.src.tar.gz &&
    cd gmp-6.0.0a
    ./configure --prefix=/usr \
        --enable-cxx          \
        --docdir=/usr/share/doc/gmp-6.0.0a &&
    make &&
    make html &&
    make check 2>&1 | tee gmp-check-logA
    awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-logB
    cat gmp-check-logA >> gmp-mkck-log
    cat gmp-check-logB >> gmp-mkck-log
    make install &&
    make install-html &&
    mv gmp_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/gmp_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf gmp-6.0.0a
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mgmp-6.0.0a completed...\e[0m"
    sleep 2

}

BUILD_MPFR () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding mpfr-3.1.2...\e[0m"
    sleep 3
    printf "\n\n"

    ################
    ## MPFR-3.1.2 ##
    ## ========== ##
    ################

    tar xf mpfr-3.1.2.src.tar.gz &&
    cd mpfr-3.1.2
    patch -Np1 -i ../mpfr-3.1.2-upstream_fixes-3.patch &&
    ./configure --prefix=/usr \
        --enable-thread-safe  \
        --docdir=/usr/share/doc/mpfr-3.1.2 &&
    make &&
    make html &&
    make check 2>&1 | tee mpfr-mkck-log
    make install &&
    make install-html &&
    mv mpfr_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/mpfr_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf mpfr-3.1.2
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mmpfr-3.1.2 completed...\e[0m"
    sleep 2

}

BUILD_MPC () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding mpc-1.0.2...\e[0m"
    sleep 3
    printf "\n\n"

    ###############
    ## MPC-1.0.2 ##
    ## ========= ##
    ###############

    tar xf mpc-1.0.2.src.tar.gz &&
    cd mpc-1.0.2
    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/mpc-1.0.2 &&
    make &&
    make html &&
    make check 2>&1 | tee mpc-mkck-log
    make install &&
    make install-html &&
    mv mpc_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/mpc_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf mpc-1.0.2
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mmpc-1.0.2 completed...\e[0m"
    sleep 2

}

BUILD_GCC () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding mpc-1.0.2...\e[0m"
    sleep 3
    printf "\n\n"

    ###############
    ## GCC-4.9.2 ##
    ## ========= ##
    ###############

    tar xf gcc-4.9.2.src.tar.gz &&
    mkdir -v gcc-build
    cd gcc-build
    SED=sed                      \
    ../gcc-4.9.2/configure       \
        --prefix=/usr            \
        --enable-languages=c,c++ \
        --disable-multilib       \
        --disable-bootstrap      \
        --with-system-zlib &&
    make &&
    ulimit -s 32768
    make -k check 2>&1 | tee gcc-mkck-logA
    ../gcc-4.9.2/contrib/test_summary | grep -A7 Summ >> gcc-mkck-logB
    cat gcc-mkck-logA >> gcc-mkck-log
    cat gcc-mkck-logB >> gcc-mkck-log
    make install &&
    ln -sv ../usr/bin/cpp /lib
    ln -sv gcc /usr/bin/cc
    install -v -dm755 /usr/lib/bfd-plugins &&
    ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/4.9.2/liblto_plugin.so /usr/lib/bfd-plugins/
    printf "\n\n"
    mv gcc_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/gcc_mkck_log_"$TIMESTAMP"
    sleep 3
    echo -e "\e[1m\e[32mgcc-4.9.2 completed...\e[0m"
    sleep 2

}

TOOLCHAIN_TEST1B () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #1B\e[0m"
    printf "\n\n"
    sleep 3
    echo 'main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log
    Expected_TEST1B="Requestingprograminterpreter/lib64/ld-linux-x86-64.so.2"
    Actual_TEST1B="$(readelf -l a.out | grep ': /lib' | sed s/://g | cut -d '[' -f 2 | cut -d ']' -f 1 | awk '{print $1$2$3$4}')"
    if [ "$Expected_TEST1B" != "$Actual_TEST1B" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 1B FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 1B \e[1m\e[32mpassed, preparing TEST 2B...\e[0m"
        printf "\n\n"
        sleep 3
    fi

}

TOOLCHAIN_TEST2B () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #2B\e[0m"
    printf "\n\n"
    sleep 3
    Expected_TEST2B="$(cat tlchn_TEST2B.txt)"
    Actual_TEST2B="$(grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log)"
    if [ "$Expected_TEST2B" != "$Actual_TEST2B" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 2B FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 2B \e[1m\e[32mpassed, preparing TEST 3B...\e[0m"
        printf "\n\n"
        sleep 3
    fi
    rm tlchn_TEST2B.txt

}

TOOLCHAIN_TEST3B () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #3B\e[0m"
    printf "\n\n"
    sleep 3
    Expected_TEST3B="$(cat tlchn_TEST3B.txt)"
    Actual_TEST3B="$(grep -B4 '^ /usr/include' dummy.log)"
    if [ "$Expected_TEST3B" != "$Actual_TEST3B" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 3B FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 3B \e[1m\e[32mpassed, preparing TEST 4B...\e[0m"
        printf "\n\n"
        sleep 3
    fi
    rm tlchn_TEST3B.txt

}

TOOLCHAIN_TEST4B () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #4B\e[0m"
    printf "\n\n"
    sleep 3
    Expected_TEST4B="$(cat tlchn_TEST4B.txt)"
    Actual_TEST4B="$(grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g')"
    if [ "$Expected_TEST4B" != "$Actual_TEST4B" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 4B FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 4B \e[1m\e[32mpassed, preparing TEST 5B...\e[0m"
        printf "\n\n"
        sleep 3
    fi
    rm tlchn_TEST4B.txt

}

TOOLCHAIN_TEST5B () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #5B\e[0m"
    printf "\n\n"
    sleep 3
    Expected_TEST5B="$(cat tlchn_TEST5B.txt)"
    Actual_TEST5B="$(grep "/lib.*/libc.so.6 " dummy.log)"
    if [ "$Expected_TEST5B" != "$Actual_TEST5B" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 5B FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 5B \e[1m\e[32mpassed, preparing TEST 6B...\e[0m"
        printf "\n\n"
        sleep 3
    fi
    rm tlchn_TEST5B.txt

}

TOOLCHAIN_TEST6B () {

    clear
    HEADER
    echo -e "\e[1m\e[32mAdjusting the toolchain\e[0m"
    printf "\n\n"
    echo -e "       \e[1m\e[4m\e[34mTEST #6B\e[0m"
    printf "\n\n"
    sleep 3
    Expected_TEST6B="$(cat tlchn_TEST6B.txt)"
    Actual_TEST6B="$(grep found dummy.log)"
    if [ "$Expected_TEST6B" != "$Actual_TEST6B" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!TOOLCHAIN ADJUSTMENT TEST 6B FAILED!!!!!\e[0m"
        printf "\n"
        echo -e "\e[1m\e[32mHalting build, check your work.\e[0m"
        sleep 5
        printf "\n\n"
        exit 1
    else
        echo -e "\e[1m\e32mToolchain Adjustment \e[1m\e[34mTEST 6B \e[1m\e[32mpassed, continuing build...\e[0m"
        printf "\n\n"
        sleep 3
    fi
    rm tlchn_TEST6B.txt
    rm -v dummy.c a.out dummy.log
    mkdir -pv /usr/share/gdb/auto-load/usr/lib
    mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
    cd ..
    rm -rf gcc-build/ gcc-4.9.2
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mToolchain Adjustment Testing completed...\e[0m"
    sleep 2

}

BUILD_BZIP2 () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding bzip2-1.0.6...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Bzip2-1.0.6 ##
    ## =========== ##
    #################

    tar xf bzip2-1.0.6.src.tar.gz &&
    cd bzip2-1.0.6
    patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch
    sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
    sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
    make -f Makefile-libbz2_so &&
    make clean &&
    make &&
    make PREFIX=/usr install
    cp -v bzip2-shared /bin/bzip2 &&
    cp -av libbz2.so* /lib &&
    ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
    rm -v /usr/bin/{bunzip2,bzcat,bzip2} &&
    ln -sv bzip2 /bin/bunzip2
    ln -sv bzip2 /bin/bzcat
    cd ..
    rm -rf bzip2-1.0.6
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mbzip2-1.0.6 completed...\e[0m"
    sleep 2

}

BUILD_PKG-CONFIG () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding pkg-config-0.28...\e[0m"
    sleep 3
    printf "\n\n"

    #####################
    ## Pkg-config-0.28 ##
    ## =============== ##
    #####################

    tar xf pkg-config-0.28.src.tar.gz &&
    cd pkg-config-0.28
    ./configure --prefix=/usr \
        --with-internal-glib  \
        --disable-host-tool   \
        --docdir=/usr/share/doc/pkg-config-0.28 &&
    make &&
    make -k check 2>&1 | tee pkg-config_mkck_log
    make install &&
    mv pkf-config_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/pkg-config_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf pkg-config-0.28
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mpkg-config-0.28 completed...\e[0m"
    sleep 2

}

BUILD_NCURSES () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding ncurses-5.9...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Ncurses-5.9 ##
    ## =========== ##
    #################

    tar xf ncurses-5.9.src.tar.gz &&
    cd ncurses-5.9
    ./configure --prefix=/usr           \
                --mandir=/usr/share/man \
                --with-shared           \
                --without-debug         \
                --enable-pc-files       \
                --enable-widec &&
    make &&
    make install &&
    mv -v /usr/lib/libncursesw.so.5* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so
    for lib in ncurses form panel menu; do
        rm -vf                    /usr/lib/lib${lib}.so
        echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
        ln -sfv lib${lib}w.a      /usr/lib/lib${lib}.a
        ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
    done
    ln -sfv libncurses++w.a /usr/lib/libncurses++.a
    rm -vf                     /usr/lib/libcursesw.so
    echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
    ln -sfv libncurses.so      /usr/lib/libcurses.so
    ln -sfv libncursesw.a      /usr/lib/libcursesw.a
    ln -sfv libncurses.a       /usr/lib/libcurses.a
    mkdir -v       /usr/share/doc/ncurses-5.9
    cp -v -R doc/* /usr/share/doc/ncurses-5.9
    make distclean &&
    ./configure --prefix=/usr    \
                --with-shared    \
                --without-normal \
                --without-debug  \
                --without-cxx-binding &&
    make sources libs &&
    cp -av lib/lib*.so.5* /usr/lib
    cd ..
    rm -rf ncurses-5.9
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mncurses-5.9 completed...\e[0m"
    sleep 2

}

BUILD_ATTR () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding attr-2.4.47...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Attr 2.4.47 ##
    ## =========== ##
    #################

    tar xf attr-2.4.47.src.tar.gz &&
    cd attr-2.4.47
    sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
    sed -i -e "/SUBDIRS/s|man2||" man/Makefile
    ./configure --prefix=/usr &&
    make
    make -j1 test root-tests 2>&1 | tee attr-mkck-log
    make install install-dev install-lib &&
    chmod -v 755 /usr/lib/libattr.so
    mv -v /usr/lib/libattr.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
    mv attr_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/attr_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf attr-2.4.47
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mattr-2.4.47 completed...\e[0m"
    sleep 2

}

BUILD_ACL () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding acl-2.2.52...\e[0m"
    sleep 3
    printf "\n\n"

    ################
    ## Acl-2.2.52 ##
    ## ========== ##
    ################

    tar xf acl-2.2.52.src.tar.gz &&
    cd acl-2.2.52
    sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
    sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
    sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
        libacl/__acl_to_any_text.c
    ./configure --prefix=/usr --libexecdir=/usr/lib &&
    make &&
    make install install-dev install-lib &&
    chmod -v 755 /usr/lib/libacl.so
    mv -v /usr/lib/libacl.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
    cd ..
    rm -rf acl-2.2.52
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32macl-2.2.52 completed...\e[0m"
    sleep 2

}

BUILD_LIBCAP () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding libcap-2.24...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Libcap-2.24 ##
    ## =========== ##
    #################

    tar xf libcap-2.24.src.tar.gz &&
    cd libcap-2.24
    make &&
    make RAISE_SETFCAP=no prefix=/usr install &&
    chmod -v 755 /usr/lib/libcap.so
    mv -v /usr/lib/libcap.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
    cd ..
    rm -rf libcap-2.24
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mlibcap-2.24 completed...\e[0m"
    sleep 2

}

BUILD_SED () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding sed-4.2.2...\e[0m"
    sleep 3
    printf "\n\n"

    ###############
    ## Sed-4.2.2 ##
    ## ========= ##
    ###############

    tar xf sed-4.2.2.src.tar.gz &&
    cd sed-4.2.2
    ./configure --prefix=/usr \
        --bindir=/bin         \
        --htmldir=/usr/share/doc/sed-4.2.2
    make &&
    make html &&
    make -k check 2>&1 | tee sed-mkck-log
    make install &&
    make -C doc install-html &&
    mv sed_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/sed_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf sed-4.2.2
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32msed-4.2.2 completed...\e[0m"
    sleep 2

}

BUILD_CRACKLIB () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding cracklig-2.9.1...\e[0m"
    sleep 3
    printf "\n\n"

    ####################
    ## cracklib-2.9.1 ##
    ## ============== ##
    ####################

    tar xf cracklib-2.9.1.src.tar.gz &&
    cd cracklib-2.9.1
    ./configure --prefix=/usr                     \
        --with-default-dict=/lib/cracklib/pw_dict \
        --disable-static &&
    make &&
    make install &&
    mv -v /usr/lib/libcrack.so.* /lib &&
    ln -sfv ../../lib/$(readlink /usr/lib/libcrack.so) /usr/lib/libcrack.so
    install -v -m644 -D    ../cracklib-words-20080507.gz           \
                             /usr/share/dict/cracklib-words.gz     &&
    gunzip -v                /usr/share/dict/cracklib-words.gz     &&
    ln -v -sf cracklib-words /usr/share/dict/words                 &&
    echo $(hostname) >>      /usr/share/dict/cracklib-extra-words  &&
    install -v -m755 -d      /lib/cracklib                         &&
    create-cracklib-dict     /usr/share/dict/cracklib-words        \
                             /usr/share/dict/cracklib-extra-words &&
    cd ..
    rm -rf cracklib-2.9.1
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mcracklib-2.9.1 completed...\e[0m"
    sleep 2

}

BUILD_SHADOW () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding shadow-4.2.1...\e[0m"
    sleep 3
    printf "\n\n"

    ##################
    ## Shadow-4.2.1 ##
    ## ============ ##
    ##################

    tar xf shadow-4.2.1.src.tar.gz &&
    cd shadow-4.2.1
    sed -i 's/groups$(EXEEXT) //' src/Makefile.in
    find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \; &&
    sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
           -e 's@/var/spool/mail@/var/mail@' etc/login.defs
    sed -i 's@DICTPATH.*@DICTPATH\t/lib/cracklib/pw_dict@' etc/login.defs
    sed -i 's/1000/999/' etc/useradd
    ./configure --sysconfdir=/etc       \
        --with-group-name-max-length=32 \
        --with-libcrack &&
    make &&
    make install &&
    mv -v /usr/bin/passwd /bin
    pwconv &&
    grpconv &&
    sed -i 's/yes/no/' /etc/default/useradd
    echo "root:intergenos" | chpasswd &&
    cd ..
    rm -rf shadow-4.2.1
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mshadow-4.2.1 completed...\e[0m"
    sleep 2

}

BUILD_PSMISC () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding psmisc-22.21...\e[0m"
    sleep 3
    printf "\n\n"

    ##################
    ## Psmisc-22.21 ##
    ## ============ ##
    ##################

    tar xf psmisc-22.21.src.tar.gz
    cd psmisc-22.21
    ./configure --prefix=/usr &&
    make &&
    make install &&
    mv -v /usr/bin/fuser   /bin
    mv -v /usr/bin/killall /bin
    cd ..
    rm -rf psmisc-22.21
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mpsmisc-22.21 completed...\e[0m"
    sleep 2

}

BUILD_PROCPS-NG () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding procps-ng-3.3.10...\e[0m"
    sleep 3
    printf "\n\n"

    ######################
    ## Procps-ng-3.3.10 ##
    ## ================ ##
    ######################

    tar xf procps-ng-3.3.10.src.tar.gz &&
    cd procps-ng-3.3.10
    ./configure --prefix=/usr                            \
                --exec-prefix=                           \
                --libdir=/usr/lib                        \
                --docdir=/usr/share/doc/procps-ng-3.3.10 \
                --disable-static                         \
                --disable-kill &&
    make &&
    sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
    make check 2>&1 | tee procps-ng-mkck-log
    make install &&
    mv -v /usr/bin/pidof /bin
    mv -v /usr/lib/libprocps.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so
    mv procps-ng_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/procps-ng_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf procps-ng-3.3.10
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mprocps-ng-3.3.10 completed...\e[0m"
    sleep 2

}

BUILD_E2FSPROGS () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding e2fsprogs-1.42.12...\e[0m"
    sleep 3
    printf "\n\n"

    #######################
    ## E2fsprogs-1.42.12 ##
    ## ================= ##
    #######################

    tar xf e2fsprogs-1.42.12.src.tar.gz &&
    cd e2fsprogs-1.42.12
    sed -e '/int.*old_desc_blocks/s/int/blk64_t/' \
        -e '/if (old_desc_blocks/s/super->s_first_meta_bg/desc_blocks/' \
        -i lib/ext2fs/closefs.c &&
    mkdir -v build
    cd build
    LIBS=-L/tools/lib                    \
    CFLAGS=-I/tools/include              \
    PKG_CONFIG_PATH=/tools/lib/pkgconfig \
    ../configure --prefix=/usr           \
                 --bindir=/bin           \
                 --with-root-prefix=""   \
                 --enable-elf-shlibs     \
                 --disable-libblkid      \
                 --disable-libuuid       \
                 --disable-uuidd         \
                 --disable-fsck &&
    make &&
    ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib
    make LD_LIBRARY_PATH=/tools/lib check 2>&1 | tee e2fsprogs-mkck-log
    make install &&
    make install-libs &&
    chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a &&
    gunzip -v /usr/share/info/libext2fs.info.gz
    install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info &&
    mv e2fsprogs_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/e2fsprogs_mkck_log_"$TIMESTAMP"
    cd ../..
    rm -rf e2fsprogs-1.42.12
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32me2fsprogs-1.42.12 completed...\e[0m"
    sleep 2

}

BUILD_COREUTILS () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding coreutils-8.23...\e[0m"
    sleep 3
    printf "\n\n"

    ####################
    ## Coreutils-8.23 ##
    ## ============== ##
    ####################

    tar xf coreutils-8.23.src.tar.gz &&
    cd coreutils-8.23
    patch -Np1 -i ../coreutils-8.23-i18n-1.patch
    touch Makefile.in
    FORCE_UNSAFE_CONFIGURE=1 ./configure \
                --prefix=/usr            \
                --enable-no-install-program=kill,uptime &&
    make &&
    make NON_ROOT_USERNAME=nobody check-root 2>&1 | tee coreutils-mkck-log
    make install &&
    mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
    mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
    mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
    mv -v /usr/bin/chroot /usr/sbin
    mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
    sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
    mv -v /usr/bin/{head,sleep,nice,test,[} /bin
    mv coreutils_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/coreutils_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf coreutils-8.23
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mcoreutils-8.23 completed...\e[0m"
    sleep 2

}

BUILD_IANA-ETC () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding iana-etc-2.30...\e[0m"
    sleep 3
    printf "\n\n"

    ###################
    ## Iana-Etc-2.30 ##
    ## ============= ##
    ###################

    tar xf iana-etc-2.30.src.tar.gz &&
    cd iana-etc-2.30
    make &&
    make install &&
    cd ..
    rm -rf iana-etc-2.30
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32miana-etc-2.30 completed...\e[0m"
    sleep 2

}

BUILD_M4 () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding m4-1.4.17...\e[0m"
    sleep 3
    printf "\n\n"

    ###############
    ## M4-1.4.17 ##
    ## ========= ##
    ###############

    tar xf m4-1.4.17.src.tar.gz &&
    cd m4-1.4.17
    ./configure --prefix=/usr &&
    make &&
    make check 2>&1 | tee m4-mkck-log
    make install &&
    mv m4_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/m4_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf m4-1.4.17
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mm4-1.4.17 completed...\e[0m"
    sleep 2

}

BUILD_FLEX () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding flex-2.5.39...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Flex-2.5.39 ##
    ## =========== ##
    #################

    tar xf flex-2.5.39.src.tar.gz &&
    cd flex-2.5.39/
    sed -i -e '/test-bison/d' tests/Makefile.in
    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/flex-2.5.39 &&
    make &&
    make check 2>&1 | tee flex-mkck-log
    make install &&
    ln -sv flex /usr/bin/lex
    mv flex_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/flex_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf flex-2.5.39/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mflex-2.5.39 completed...\e[0m"
    sleep 2

}

BUILD_BISON () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding bison-3.0.4...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Bison-3.0.4 ##
    ## =========== ##
    #################

    tar xf bison-3.0.4.src.tar.gz &&
    cd bison-3.0.4/
    ./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4 &&
    make &&
    make check 2>&1 | tee bison-mkck-log
    make install &&
    mv bison_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/bison_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf bison-3.0.4/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mbison-3.0.4 completed...\e[0m"
    sleep 2

}

BUILD_GREP () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding grep-2.21...\e[0m"
    sleep 3
    printf "\n\n"

    ###############
    ## Grep-2.21 ##
    ## ========= ##
    ###############

    tar xf grep-2.21.src.tar.gz &&
    cd grep-2.21/
    sed -i -e '/tp++/a  if (ep <= tp) break;' src/kwset.c
    ./configure --prefix=/usr \
        --bindir=/bin &&
    make &&
    make check 2>&1 | tee grep-mkck-log
    make install &&
    mv grep_mkck_log /var/log/InterGenOS/BuildLogs/Sys_Buildlogs/grep_mkck_log_"$TIMESTAMP"
    cd ..
    rm -rf grep-2.21/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mgrep-2.21 completed...\e[0m"
    sleep 2

}

BUILD_READLINE () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding readline-6.3...\e[0m"
    sleep 3
    printf "\n\n"

    ##################
    ## Readline-6.3 ##
    ## ============ ##
    ##################

    tar xf readline-6.3.src.tar.gz &&
    cd readline-6.3/
    patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch &&
    sed -i '/MV.*old/d' Makefile.in
    sed -i '/{OLDSUFF}/c:' support/shlib-install
    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/readline-6.3 &&
    make SHLIB_LIBS=-lncurses &&
    make SHLIB_LIBS=-lncurses install &&
    mv -v /usr/lib/lib{readline,history}.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
    ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
    cd ..
    rm -rf readline-6.3/
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mreadline-6.3 completed...\e[0m"
    sleep 2

}

BUILD_BASH () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding bash-4.3.30...\e[0m"
    sleep 3
    printf "\n\n"

    #################
    ## Bash-4.3.30 ##
    ## =========== ##
    #################

    tar xf bash-4.3.30.src.tar.gz &&
    cd bash-4.3.30/
    patch -Np1 -i ../bash-4.3.30-upstream_fixes-1.patch &&
    ./configure --prefix=/usr                       \
                --bindir=/bin                       \
                --docdir=/usr/share/doc/bash-4.3.30 \
                --without-bash-malloc               \
                --with-installed-readline &&
    make &&
    chown -Rv nobody .
    su nobody -s /bin/bash -c "PATH=$PATH make tests" 2>&1 | tee bash_mkck_log
    make install &&
    printf "\n\n"
    echo -e "    \e[1m\e[32mSystem Bash Binary installation complete\e[0m"
    printf "\n"
    echo -e "    \e[1m\e[32mPreparing to launch new shell with completed system bash binary..."
    sleep 3
    exec /bin/bash --login +h

}















#--------------------------------------#
# END - SYSTEM PACKAGE BUILD FUNCTIONS #
#--------------------------------------#

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
TOOLCHAIN_TEST1A

cat > tlchn_TEST2A.txt << "TEST2AData"
/usr/lib/../lib64/crt1.o succeeded
/usr/lib/../lib64/crti.o succeeded
/usr/lib/../lib64/crtn.o succeeded
TEST2AData

TOOLCHAIN_TEST2A
TOOLCHAIN_TEST3A

cat > tlchn_TEST4A.txt << "TEST4AData"
SEARCH_DIR("=/tools/x86_64-unknown-linux-gnu/lib64")
SEARCH_DIR("/usr/lib")
SEARCH_DIR("/lib")
SEARCH_DIR("=/tools/x86_64-unknown-linux-gnu/lib");
TEST4AData

TOOLCHAIN_TEST4A
TOOLCHAIN_TEST5A
TOOLCHAIN_TEST6A
BUILD_ZLIB
BUILD_FILE
BUILD_BINUTILS
BUILD_GMP
BUILD_MPFR
BUILD_MPC
BUILD_GCC
TOOLCHAIN_TEST1B

cat > tlchn_TEST2B.txt << "TEST2BData"
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.2/../../../../lib64/crt1.o succeeded
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.2/../../../../lib64/crti.o succeeded
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.2/../../../../lib64/crtn.o succeeded
TEST2BData

TOOLCHAIN_TEST2B

cat > tlchn_TEST3B.txt << "TEST3BData"
#include <...> search starts here:
 /usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.2/include
 /usr/local/include
 /usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.2/include-fixed
 /usr/include
TEST3BData

TOOLCHAIN_TEST3B

cat > tlchn_TEST4B.txt << "TEST4BData"
SEARCH_DIR("/usr/x86_64-unknown-linux-gnu/lib64")
SEARCH_DIR("/usr/local/lib64")
SEARCH_DIR("/lib64")
SEARCH_DIR("/usr/lib64")
SEARCH_DIR("/usr/x86_64-unknown-linux-gnu/lib")
SEARCH_DIR("/usr/local/lib")
SEARCH_DIR("/lib")
SEARCH_DIR("/usr/lib");
TEST4BData

TOOLCHAIN_TEST4B

cat > tlchn_TEST5B.txt << "TEST5BData"
attempt to open /lib64/libc.so.6 succeeded
TEST5BData

TOOLCHAIN_TEST5B

cat > tlchn_TEST6B.txt << "TEST6BData"
found ld-linux-x86-64.so.2 at /lib64/ld-linux-x86-64.so.2
TEST6BData

TOOLCHAIN_TEST6B
BUILD_BZIP2
BUILD_PKG-CONFIG
BUILD_NCURSES
BUILD_ATTR
BUILD_ACL
BUILD_LIBCAP
BUILD_SED
BUILD_CRACKLIB
BUILD_SHADOW
BUILD_PSMISC
BUILD_PROCPS-NG
BUILD_E2FSPROGS
BUILD_COREUTILS
BUILD_IANA-ETC
BUILD_M4
BUILD_FLEX
BUILD_BISON
BUILD_GREP
BUILD_READLINE

cat > /root/.bash_profile << "AddExecutable"
/bin/bash /./build_system_post-bash_extended.sh
AddExecutable

BUILD_BASH




SPACER
echo -e "\e[1m\e[4m\e[32mWORKING AS EXPECTED\e[0m"
SPACER
sleep 5

printf "\n\n\n"

#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################

exit 0
