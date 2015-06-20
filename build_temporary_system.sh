#!/bin/bash
# build_temporary_system.sh
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

# Creates a 15 line gap for easier log review
SPACER () {
    printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
}

#--------------------------------#
# END - DISPLAY LAYOUT FUNCTIONS #
#--------------------------------#

#--------------------------------------------------#
# BEGIN - TEMPORARY SYSTEM PACKAGE BUILD FUNCTIONS #
#--------------------------------------------------#

# Rebuilds gcc and linux packages into correct form
SET_GCC_AND_LINUX () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Setting up gcc-4.9.2 and linux-3.19 packages..."
    printf "\n\n"
    WHITE
    tar xf linux-3.19-extras.src.tar.gz && tar xf linux-3.19.src.tar.gz &&
    mv linux-3.19-extras/* linux-3.19/ &&
    rm -rf linux-3.19-extras.src.tar.gz linux-3.19-extras linux-3.19.src.tar.gz &&
    tar zcf linux-3.19.src.tar.gz linux-3.19/ &&
    rm -rf linux-3.19/ &&
    tar xf gcc-4.9.2-extras.src.tar.gz && tar xf gcc-4.9.2.src.tar.gz &&
    mv gcc-4.9.2-extras/testsuite gcc-4.9.2/gcc/ &&
    mv gcc-4.9.2-extras/po gcc-4.9.2/gcc/ &&
    mv gcc-4.9.2-extras/MD5SUMS gcc-4.9.2/ &&
    rm -rf gcc-4.9.2-extras.src.tar.gz gcc-4.9.2-extras gcc-4.9.2.src.tar.gz &&
    tar zcf gcc-4.9.2.src.tar.gz gcc-4.9.2/ &&
    rm -rf gcc-4.9.2/
    SPACER
}

BUILD_BINUTILS_PASS1 () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building binutils-2.25 PASS 1..."
    printf "\n\n"
    WHITE

    ###################
    ## Binutils-2.25 ##
    ## ============= ##
    ##    PASS -1-   ##
    #########################################################################################################
    ## To determine SBUs, use the following command:                                                       ##
    ## =============================================                                                       ##
    ## time { ../binutils-2.25/configure --prefix=/tools --with-sysroot=$IGos --with-lib-path=/tools/lib \ ##
    ## --target=$IGos_TGT --disable-nls --disable-werror && make && case $(uname -m) in \                  ##
    ## x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;; esac && make install; }                   ##
    ## =================================================================================                   ##
    ## Example results for SBU with the following hardware:                                                ##
    ## ====================================================                                                ##
    ## 8GB Memory, Intel Core i3, SSD:                                                                     ##
    ## real - 2m 1.212s                                                                                    ##
    ## user - 1m 32.530s                                                                                   ##
    ## sys  - 0m 5.540s                                                                                    ##
    ## ================                                                                                    ##
    #########################################################################################################

    tar xf binutils-2.25.src.tar.gz &&
    cd binutils-2.25/
    mkdir -v ../binutils-build
    cd ../binutils-build
    ../binutils-2.25/configure     \
        --prefix=/tools            \
        --with-sysroot=$IGos       \
        --with-lib-path=/tools/lib \
        --target=$IGos_TGT         \
        --disable-nls              \
        --disable-werror &&
    make &&
    case $(uname -m) in
        x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
    esac &&
    make install &&
    cd .. && rm -rf binutils-2.25 binutils-build/
    printf "\n\n"
    BOLD
    GREEN
    echo "binutils-2.25 PASS 1 completed..."
    SPACER
    WHITE
}

BUILD_GCC_PASS1 () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building gcc-4.9.2 PASS 1..."
    printf "\n\n"
    WHITE

    ###############
    ## Gcc-4.9.2 ##
    ## ========= ##
    ##  PASS -1- ##
    ###############

    tar xf gcc-4.9.2.src.tar.gz
    cd gcc-4.9.2/
    tar -xf ../mpfr-3.1.2.src.tar.gz
    mv -v mpfr-3.1.2 mpfr
    tar -xf ../gmp-6.0.0a.src.tar.gz
    mv -v gmp-6.0.0a gmp
    tar -xf ../mpc-1.0.2.src.tar.gz
    mv -v mpc-1.0.2 mpc
    for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); do
        cp -uv $file{,.orig}
        sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' -e 's@/usr@/tools@g' $file.orig > $file
        echo '
    #undef STANDARD_STARTFILE_PREFIX_1
    #undef STANDARD_STARTFILE_PREFIX_2
    #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
    #define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
        touch $file.orig
    done
    sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure
    mkdir -v ../gcc-build
    cd ../gcc-build
    ../gcc-4.9.2/configure                               \
        --target=$IGos_TGT                               \
        --prefix=/tools                                  \
        --with-sysroot=$IGos                             \
        --with-newlib                                    \
        --without-headers                                \
        --with-local-prefix=/tools                       \
        --with-native-system-header-dir=/tools/include   \
        --disable-nls                                    \
        --disable-shared                                 \
        --disable-multilib                               \
        --disable-decimal-float                          \
        --disable-threads                                \
        --disable-libatomic                              \
        --disable-libgomp                                \
        --disable-libitm                                 \
        --disable-libquadmath                            \
        --disable-libsanitizer                           \
        --disable-libssp                                 \
        --disable-libvtv                                 \
        --disable-libcilkrts                             \
        --disable-libstdc++-v3                           \
        --enable-languages=c,c++ &&
    make &&
    make install &&
    cd .. && rm -rf gcc-4.9.2 gcc-build/
    printf "\n\n"
    BOLD
    GREEN
    echo "gcc-4.9.2 PASS 1 completed..."
    SPACER
    WHITE
}

BUILD_LINUX_API_HEADERS () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building linux-3.19 API Headers..."
    printf "\n\n"
    WHITE

    ## Updated kernel to 3.19 ###
    #############################
    ## Linux-3.19 API Headers  ##
    ## ======================= ##
    #############################

    tar xf linux-3.19.src.tar.gz &&
    cd linux-3.19/
    make mrproper &&
    make INSTALL_HDR_PATH=dest headers_install &&
    cp -rv dest/include/* /tools/include &&
    cd .. && rm -rf linux-3.19
    printf "\n\n"
    BOLD
    GREEN
    echo "linux-3.19 API Headers completed..."
    SPACER
    WHITE
}

BUILD_GLIBC () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building glibc-2.21..."
    printf "\n\n"
    WHITE

    ################
    ## Glibc-2.21 ##
    ## ========== ##
    ################

    tar xf glibc-2.21.src.tar.gz &&
    cd glibc-2.21/
    if [ ! -r /usr/include/rpc/types.h ]; then
        su -c 'mkdir -pv /usr/include/rpc'
        su -c 'cp -v sunrpc/rpc/*.h /usr/include/rpc'
    fi
    sed -e '/ia32/s/^/1:/' \
        -e '/SSE2/s/^1://' \
        -i  sysdeps/i386/i686/multiarch/mempcpy_chk.S
    mkdir -v ../glibc-build
    cd ../glibc-build
    ../glibc-2.21/configure                           \
        --prefix=/tools                               \
        --host=$IGos_TGT                              \
        --build=$(../glibc-2.21/scripts/config.guess) \
        --disable-profile                             \
        --enable-kernel=2.6.32                        \
        --with-headers=/tools/include                 \
        libc_cv_forced_unwind=yes                     \
        libc_cv_ctors_header=yes                      \
        libc_cv_c_cleanup=yes &&
    make &&
    make install &&
    printf "\n\n"
    BOLD
    GREEN
    echo "glibc-2.21 completed..."
    printf "\n\n"
    echo "stand by, performing glibc sanity checks..."
    WHITE
    sleep 4

    ##########################
    ## glibc sanity testing ##
    ## ==================== ##
    ##############################################################################
    ## The actual Sanity Check will look like the following in terminal:        ##
    ## =================================================================        ##
    ## [igos@Arch glibc-build]$ echo 'main(){}' > dummy.c                       ##
    ## [igos@Arch glibc-build]$ $IGos_TGT-gcc dummy.c                           ##
    ## [igos@Arch glibc-build]$ readelf -l a.out | grep ': /tools'              ##
    ##      [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2] ##
    ## ======================================================================== ##
    ## The following section will kill the build if the Sanity Check fails:     ##
    ## ===================================================================      ##
    ##############################################################################

    echo 'main(){}' > dummy.c
    $IGos_TGT-gcc dummy.c

    Expected="Requestingprograminterpreter/tools/lib64/ld-linux-x86-64.so.2"
    Actual="$(readelf -l a.out | grep ': /tools' | sed s/://g | cut -d '[' -f 2 | cut -d ']' -f 1 | awk '{print $1$2$3$4}')"

    if [ $Expected != $Actual ]; then
        BOLD
        RED
        echo "!!!!!GLIBC 1st PASS SANITY CHECK FAILED!!!!! Halting build, check your work."
        printf "\n\n\n\n\n"
        WHITE
        exit 1
    else
        SPACER
        BOLD
        GREEN
        echo "Compiler and Linker are functioning as expected, continuing build."
        sleep 4
        SPACER
    fi
    WHITE
    rm -v dummy.c a.out
    cd .. && rm -rf glibc-2.21 glibc-build/
    printf "\n\n"
    BOLD
    GREEN
    echo "glibc-2.21 completed..."
    SPACER
    WHITE
}

BUILD_LIBSTDC () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building libstdc++-4.9.2..."
    printf "\n\n"
    WHITE

    #################################
    ##       Libstdc++-4.9.2       ##
    ## (Part of Gcc-4.9.2 package) ##
    ## =========================== ##
    #################################

    tar xf gcc-4.9.2.src.tar.gz &&
    cd gcc-4.9.2/
    mkdir -pv ../gcc-build
    cd ../gcc-build
    ../gcc-4.9.2/libstdc++-v3/configure \
        --host=$IGos_TGT                \
        --prefix=/tools                 \
        --disable-multilib              \
        --disable-shared                \
        --disable-nls                   \
        --disable-libstdcxx-threads     \
        --disable-libstdcxx-pch         \
        --with-gxx-include-dir=/tools/$IGos_TGT/include/c++/4.9.2 &&
    make &&
    make install
    cd .. && rm -rf gcc-4.9.2 gcc-build/
    printf "\n\n"
    BOLD
    GREEN
    echo "libstdc++-4.9.2 completed..."
    SPACER
    WHITE
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

cd /mnt/igos
sed -i '/.\/build_temporary_system.sh/d' /home/igos/.bashrc # Removes bashrc entry that executes the temp-system build
cd /mnt/igos/sources
SET_GCC_AND_LINUX 2>&1 | tee bin_pass1_log1 &&
BUILD_BINUTILS_PASS1 2>&1 | tee bin_pass1_log2 &&
BUILD_GCC_PASS1 2>&1 | tee gcc_pass1 &&
BUILD_LINUX_API_HEADERS 2>&1 | tee lin_api &&
BUILD_GLIBC 2>&1 | tee glibc &&
BUILD_LIBSTDC 2>&1 | tee libstdc &&
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' bin_pass1_log1
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' bin_pass1_log2
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' gcc_pass1
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' lin_api
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' glibc
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' libstdc
cat bin_pass1_log1 > temp_binutils_pass1
cat bin_pass1_log2 >> temp_binutils_pass1
rm bin_pass1_log1 bin_pass1_log2
mv temp_binutils_pass1 /var/log/InterGenOS/BuildLogs/temp_binutils_pass1_"$TIMESTAMP"
mv gcc_pass1 /var/log/InterGenOS/BuildLogs/temp_gcc_pass1_"$TIMESTAMP"
mv lin_api /var/log/InterGenOS/BuildLogs/temp_lin_api_"$TIMESTAMP"
mv glibc /var/log/InterGenOS/BuildLogs/temp_glibc_"$TIMESTAMP"
mv libstdc /var/log/IngerGenOS/BuildLogs/temp_libstdc_"$TIMESTAMP"

#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################
