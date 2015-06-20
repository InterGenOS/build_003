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
    printf "\n\n\n\n\n\n\n\n\n\n"
    DIVIDER
    BOLD
    GREEN
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
    Actual="$(readelf -l a.out | grep ': /tools' spacing | sed -e 's/://' -e 's/\[/ /' -e 's/\]/ /' | awk '{print $1$2$3$4}')"

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
    DIVIDER
    printf "\n\n\n\n\n\n\n\n\n\n"
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

BUILD_BINUTILS_PASS2 () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building binutils-2.25 PASS 2..."
    printf "\n\n"
    WHITE

    ####################
    ## Binutils-2.25  ##
    ## =============  ##
    ##   PASS  -2-    ##
    ####################

    tar xf binutils-2.25.src.tar.gz &&
    cd binutils-2.25/
    mkdir -v ../binutils-build
    cd ../binutils-build
    CC=$IGos_TGT-gcc               \
    AR=$IGos_TGT-ar                \
    RANLIB=$IGos_TGT-ranlib        \
    ../binutils-2.25/configure     \
        --prefix=/tools            \
        --disable-nls              \
        --disable-werror           \
        --with-lib-path=/tools/lib \
        --with-sysroot &&
    make &&
    make install &&
    printf "\n\n\n\n\n\n\n\n\n\n"
    DIVIDER
    BOLD
    GREEN
    echo "Preparing the linker for re-adjusting..."
    printf "\n"
    WHITE
    make -C ld clean &&
    make -C ld LIB_PATH=/usr/lib:/lib &&
    cp -v ld/ld-new /tools/bin
    sleep 4
    printf "\n"
    BOLD
    GREEN
    echo "linker re-adjustment complete"
    DIVIDER
    printf "\n\n\n\n\n\n\n\n\n\n"
    cd .. && rm -rf binutils-2.25 binutils-build/
    printf "\n\n"
    BOLD
    GREEN
    echo "binutils-2.25 PASS 2 completed..."
    SPACER
    WHITE
}

BUILD_GCC_PASS2 () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building gcc-4.9.2 PASS 2..."
    printf "\n\n"
    WHITE

    ###############
    ## Gcc-4.9.2 ##
    ## ========= ##
    ##  PASS -2- ##
    ###############

    tar xf gcc-4.9.2.src.tar.gz &&
    cd gcc-4.9.2/
    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
        `dirname $($IGos_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
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
    tar -xf ../mpfr-3.1.2.src.tar.gz
    mv -v mpfr-3.1.2 mpfr
    tar -xf ../gmp-6.0.0a.src.tar.gz
    mv -v gmp-6.0.0a gmp
    tar -xf ../mpc-1.0.2.src.tar.gz
    mv -v mpc-1.0.2 mpc
    mkdir -v ../gcc-build
    cd ../gcc-build
    CC=$IGos_TGT-gcc                                     \
    CXX=$IGos_TGT-g++                                    \
    AR=$IGos_TGT-ar                                      \
    RANLIB=$IGos_TGT-ranlib                              \
    ../gcc-4.9.2/configure                               \
        --prefix=/tools                                  \
        --with-local-prefix=/tools                       \
        --with-native-system-header-dir=/tools/include   \
        --enable-languages=c,c++                         \
        --disable-libstdcxx-pch                          \
        --disable-multilib                               \
        --disable-bootstrap                              \
        --disable-libgomp &&
    make &&
    make install &&
    ln -sv gcc /tools/bin/cc &&
    printf "\n\n"
    BOLD
    GREEN
    echo "gcc-4.9.2 PASS 2 completed..."
    printf "\n\n\n\n\n\n\n\n\n\n"
    DIVIDER
    BOLD
    GREEN
    echo "stand by, performing gcc sanity checks..."
    WHITE
    sleep 4

    ##############################
    ## gcc pass2 sanity testing ##
    ## ======================== ##
    ##############################################################################
    ## The actual Sanity Check will look like the following in terminal:        ##
    ## =================================================================        ##
    ## [igos@Arch gcc-build]$ echo 'main(){}' > dummy.c                         ##
    ## [igos@Arch gcc-build]$ cc dummy.c                                        ##
    ## [igos@Arch gcc-build]$ readelf -l a.out | grep ': /tools'                ##
    ##      [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2] ##
    ## ======================================================================== ##
    ## The following script will kill the build if the Sanity Check fails:      ##
    ## ===================================================================      ##
    ##############################################################################

    echo 'main(){}' > dummy.c
    cc dummy.c

    Expected2="Requestingprograminterpreter/tools/lib64/ld-linux-x86-64.so.2"
    Actual2="$(readelf -l a.out | grep ': /tools' spacing | sed -e 's/://' -e 's/\[/ /' -e 's/\]/ /' | awk '{print $1$2$3$4}')"

    if [ $Expected2 != $Actual2 ]; then
        BOLD
        RED
        echo "!!!!!GCC 2nd PASS SANITY CHECK FAILED!!!!! Halting build, check your work."
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
    DIVIDER
    printf "\n\n\n\n\n\n\n\n\n\n"
    BOLD
    GREEN
    echo "gcc-4.9.2 completed..."
    SPACER
    WHITE
    rm -v dummy.c a.out
    cd .. && rm -rf gcc-4.9.2 gcc-build/
}

BUILD_TCL () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building tcl-8.6.3..."
    printf "\n\n"
    WHITE

    ###############
    ## Tcl-8.6.3 ##
    ## ========= ##
    ###############

    tar xf tcl-8.6.3.src.tar.gz &&
    cd tcl-8.6.3/
    cd unix
    ./configure --prefix=/tools &&
    make &&
    make install &&
    chmod -v u+w /tools/lib/libtcl8.6.so &&
    make install-private-headers &&
    ln -sv tclsh8.6 /tools/bin/tclsh
    cd .. && cd .. && rm -rf tcl-8.6.3
    printf "\n\n"
    BOLD
    GREEN
    echo "tcl-8.6.3 completed..."
    SPACER
    WHITE
}

BUILD_EXPECT () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building expect-5.45..."
    printf "\n\n"
    WHITE

    #################
    ## Expect-5.45 ##
    ## =========== ##
    #################

    tar xf expect-5.45.src.tar.gz &&
    cd expect-5.45/
    cp -v configure{,.orig}
    sed 's:/usr/local/bin:/bin:' configure.orig > configure
    ./configure --prefix=/tools \
        --with-tcl=/tools/lib   \
        --with-tclinclude=/tools/include &&
    make &&
    make SCRIPTS="" install
    cd .. && rm -rf expect-5.45
    printf "\n\n"
    BOLD
    GREEN
    echo "expect-5.45 completed..."
    SPACER
    WHITE
}

BUILD_DEJAGNU () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building dejagnu-1.5.2..."
    printf "\n\n"
    WHITE

    ###################
    ## DejaGNU-1.5.2 ##
    ## ============= ##
    ###################

    tar xf dejagnu-1.5.2.src.tar.gz &&
    cd dejagnu-1.5.2/
    ./configure --prefix=/tools &&
    make install &&
    cd .. && rm -rf dejagnu-1.5.2
    printf "\n\n"
    BOLD
    GREEN
    echo "dejagnu-1.5.2 completed..."
    SPACER
    WHITE
}

BUILD_CHECK () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building check-0.9.14..."
    printf "\n\n"
    WHITE

    ##################
    ## Check-0.9.14 ##
    ## ============ ##
    ##################

    tar xf check-0.9.14.src.tar.gz &&
    cd check-0.9.14/
    PKG_CONFIG= ./configure --prefix=/tools &&
    make &&
    make install
    cd .. && rm -rf check-0.9.14
    printf "\n\n"
    BOLD
    GREEN
    echo "check-0.9.14 completed..."
    SPACER
    WHITE
}

BUILD_NCURSES () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building ncurses-5.9..."
    printf "\n\n"
    WHITE

    #################
    ## Ncurses-5.9 ##
    ## =========== ##
    #################

    tar xf ncurses-5.9.src.tar.gz &&
    cd ncurses-5.9/
    ./configure --prefix=/tools \
        --with-shared   \
        --without-debug \
        --without-ada   \
        --enable-widec  \
        --enable-overwrite &&
    make &&
    make install &&
    cd .. && rm -rf ncurses-5.9
    printf "\n\n"
    BOLD
    GREEN
    echo "ncurses-5.9 completed..."
    SPACER
    WHITE
}

BUILD_BASH () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building bash-4.3.30..."
    printf "\n\n"
    WHITE

    #################
    ## Bash-4.3.30 ##
    ## =========== ##
    #################

    tar xf bash-4.3.30.src.tar.gz &&
    cd bash-4.3.30/
    ./configure --prefix=/tools --without-bash-malloc &&
    make &&
    make install &&
    ln -sv bash /tools/bin/sh
    cd .. && rm -rf bash-4.3.30
    printf "\n\n"
    BOLD
    GREEN
    echo "bash-4.3.30 completed..."
    SPACER
    WHITE
}

BUILD_BZIP2 () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building bzip2-1.0.6..."
    printf "\n\n"
    WHITE

    #################
    ## Bzip2-1.0.6 ##
    ## =========== ##
    #################

    tar xf bzip2-1.0.6.src.tar.gz &&
    cd bzip2-1.0.6/
    make && make PREFIX=/tools install &&
    cd .. && rm -rf bzip2-1.0.6
    printf "\n\n"
    BOLD
    GREEN
    echo "bzip2-1.0.6 completed..."
    SPACER
    WHITE
}

BUILD_COREUTILS () {
    clear
    HEADER
    BOLD
    GREEN
    echo "Building coreutils-8.23..."
    printf "\n\n"
    WHITE

    ####################
    ## Coreutils-8.23 ##
    ## ============== ##
    ####################

    tar xf coreutils-8.23.src.tar.gz &&
    cd coreutils-8.23/
    ./configure --prefix=/tools --enable-install-program=hostname &&
    make &&
    make install &&
    cd .. && rm -rf coreutils-8.23
    printf "\n\n"
    BOLD
    GREEN
    echo "coreutils-8.23 completed..."
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

# The actual workhorse
SET_GCC_AND_LINUX 2>&1 | tee bin_pass1_log1 &&
BUILD_BINUTILS_PASS1 2>&1 | tee bin_pass1_log2 &&
BUILD_GCC_PASS1 2>&1 | tee gcc_pass1 &&
BUILD_LINUX_API_HEADERS 2>&1 | tee lin_api &&
BUILD_GLIBC 2>&1 | tee glibc &&
BUILD_LIBSTDC 2>&1 | tee libstdc &&
BUILD_BINUTILS_PASS2 2>&1 | tee bin_pass2 &&
BUILD_GCC_PASS2 2>&1 | tee gcc_pass2 &&
BUILD_TCL 2>&1 | tee tcl &&
BUILD_EXPECT 2>&1 | tee expect &&
BUILD_DEJAGNU 2>&1 | tee dejagnu &&
BUILD_CHECK 2>&1 | tee check &&
BUILD_NCURSES 2>&1 | tee ncurses &&
BUILD_BASH 2>&1 | tee bash_log &&
BUILD_BZIP2 2>&1 | tee bzip2 &&
BUILD_COREUTILS 2>&1 | tee coreutils &&

# Log cleaning
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' bin_pass1_log1
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' bin_pass1_log2
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' gcc_pass1
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' lin_api
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' glibc
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' libstdc
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' bin_pass2
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' gcc_pass2
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' tcl
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' expect
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' dejagnu
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' check
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' ncurses
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' bash_log
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' bzip2
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' coreutils

cat bin_pass1_log1 > temp_binutils_pass1
cat bin_pass1_log2 >> temp_binutils_pass1
rm bin_pass1_log1 bin_pass1_log2

# Filing the logs
mv temp_binutils_pass1 /var/log/InterGenOS/BuildLogs/temp_binutils_pass1_"$TIMESTAMP"
mv gcc_pass1 /var/log/InterGenOS/BuildLogs/temp_gcc_pass1_"$TIMESTAMP"
mv lin_api /var/log/InterGenOS/BuildLogs/temp_lin_api_"$TIMESTAMP"
mv glibc /var/log/InterGenOS/BuildLogs/temp_glibc_"$TIMESTAMP"
mv libstdc /var/log/InterGenOS/BuildLogs/temp_libstdc_"$TIMESTAMP"
mv bin_pass2 /var/log/InterGenOS/BuildLogs/temp_binutils_pass2_"$TIMESTAMP"
mv gcc_pass2 /var/log/InterGenOS/BuildLogs/temp_gcc_pass2_"$TIMESTAMP"
mv tcl /var/log/InterGenOS/BuildLogs/temp_tcl_"$TIMESTAMP"
mv expect /var/log/InterGenOS/BuildLogs/temp_expect_"$TIMESTAMP"
mv dejagnu /var/log/InterGenOS/BuildLogs/temp_dejagnu_"$TIMESTAMP"
mv check /var/log/InterGenOS/BuildLogs/temp_check_"$TIMESTAMP"
mv ncurses /var/log/InterGenOS/BuildLogs/temp_ncurses_"$TIMESTAMP"
mv bash_log /var/log/InterGenOS/BuildLogs/temp_bash_"$TIMESTAMP"
mv bzip2 /var/log/InterGenOS/BuildLogs/temp_bzip2_"$TIMESTAMP"
mv coreutils /var/log/InterGenOS/BuildLogs/temp_coreutils_"$TIMESTAMP"

#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################
