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

# Set build variables
set +h
umask 022
IGos=/mnt/igos
LC_ALL=POSIX
IGos_TGT=$(uname -m)-igos-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export IGos LC_ALL IGos_TGT PATH

# Sets a start-point timestamp
TIMESTAMP="$(date +"%m-%d-%Y_%T")"

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
    echo -e "\e[1m\e[32mSetting up gcc-4.9.2 and linux-3.19 packages...\e[0m"
    printf "\n\n"
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
    printf "\n"
    echo -e "\e[1m\e[32mPackage setup complete...\e[0m"
    SPACER
    sleep 5
}

BUILD_BINUTILS_PASS1 () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding binutils-2.25 PASS 1...\e[0m"
    printf "\n\n"
    sleep 5

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
    ## Example results for a single SBU measurement with the following hardware:                           ##
    ## =========================================================================                           ##
    ## 8GB Memory, Intel Core i3, SSD:                                                                     ##
    ## real - 2m 1.212s                                                                                    ##
    ## user - 1m 32.530s                                                                                   ##
    ## sys  - 0m 5.540s                                                                                    ##
    ## ================                                                                                    ##
    #########################################################################################################
    ## Example results for full temporary system build with the following hardware:                        ##
    ## ============================================================================                        ##
    ## 16GB Memory, Intel Core i3, SSD:                                                                    ##
    ## real - 38m 13.192s                                                                                  ##
    ## user - 35m 39.140s                                                                                  ##
    ## sys  - 2m  20.787s                                                                                  ##
    ## ==================                                                                                  ##
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
    echo -e "\e[1m\e[32mbinutils-2.25 PASS 1 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_GCC_PASS1 () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding gcc-4.9.2 PASS 1...\e[0m"
    printf "\n\n"
    sleep 5

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
    echo -e "\e[1m\e[32mgcc-4.9.2 PASS 1 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_LINUX_API_HEADERS () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding linux-3.19 API Headers...\e[0m"
    printf "\n\n"
    sleep 5

    #############################
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
    echo -e "\e[1m\e[32mlinux-3.19 API Headers completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_GLIBC () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding glibc-2.21...\e[0m"
    printf "\n\n"
    sleep 5

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
    echo -e "\e[1m\e[32mglibc-2.21 completed...\e[0m"
    printf "\n\n\n\n\n\n\n\n\n\n"
    DIVIDER
    echo -e "\e[1m\e[32mstand by, performing glibc sanity checks...\e[0m"
    sleep 5

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
    Actual="$(readelf -l a.out | grep ': /tools' | sed -e 's/://' -e 's/\[/ /' -e 's/\]/ /' | awk '{print $1$2$3$4}')"

    if [ "$Expected" != "$Actual" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!GLIBC 1st PASS SANITY CHECK FAILED!!!!! Halting build, check your work.\e[0m"
        printf "\n\n\n\n\n"
        sleep 5
        GLIBC_SANITY=BAD
        exit 1
    else
        SPACER
        echo -e "\e[1m\e[4m\e[32mCompiler and Linker are functioning as expected, continuing build.\e[0m"
        sleep 5
        SPACER
    fi
    DIVIDER
    printf "\n\n\n\n\n\n\n\n\n\n"
    rm -v dummy.c a.out
    cd .. && rm -rf glibc-2.21 glibc-build/
    printf "\n\n"
    echo -e "\e[1m\e[32mglibc-2.21 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_LIBSTDC () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding libstdc++-4.9.2...\e[0m"
    printf "\n\n"
    sleep 5

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
    echo -e "\e[1m\e[32mlibstdc++-4.9.2 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_BINUTILS_PASS2 () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding binutils-2.25 PASS 2...\e[0m"
    printf "\n\n"
    sleep 5

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
    echo -e "\e[1m\e[32mPreparing the linker for re-adjusting...\e[0m"
    printf "\n"
    make -C ld clean &&
    make -C ld LIB_PATH=/usr/lib:/lib &&
    cp -v ld/ld-new /tools/bin
    sleep 4
    printf "\n"
    echo -e "\e[1m\e[4m\e[32mlinker re-adjustment complete\e[0m"
    DIVIDER
    printf "\n\n\n\n\n\n\n\n\n\n"
    cd .. && rm -rf binutils-2.25 binutils-build/
    printf "\n\n"
    echo -e "\e[1m\e[32mbinutils-2.25 PASS 2 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_GCC_PASS2 () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding gcc-4.9.2 PASS 2...\e[0m"
    printf "\n\n"
    sleep 5

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
    echo -e "\e[1m\e[32mgcc-4.9.2 PASS 2 completed...\e[0m"
    printf "\n\n\n\n\n\n\n\n\n\n"
    DIVIDER
    echo -e "\e[1m\e[32mstand by, performing gcc sanity checks...\e[0m"
    sleep 5

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
    ## The following section will kill the build if the Sanity Check fails:     ##
    ## ====================================================================     ##
    ##############################################################################

    echo 'main(){}' > dummy.c
    cc dummy.c

    Expected2="Requestingprograminterpreter/tools/lib64/ld-linux-x86-64.so.2"
    Actual2="$(readelf -l a.out | grep ': /tools' | sed -e 's/://' -e 's/\[/ /' -e 's/\]/ /' | awk '{print $1$2$3$4}')"

    if [ "$Expected2" != "$Actual2" ]; then
        echo -e "\e[1m\e[5m\e[31m!!!!!GCC 2nd PASS SANITY CHECK FAILED!!!!! Halting build, check your work.\e[0m"
        printf "\n\n\n\n\n"
        sleep 5
        GCC_SANITY=BAD
        exit 1
    else
        SPACER
        echo -e "\e[1m\e[4m\e[32mCompiler and Linker are functioning as expected, continuing build.\e[0m"
        sleep 5
        SPACER
    fi
    DIVIDER
    printf "\n\n\n\n\n\n\n\n\n\n"
    echo -e "\e[1m\e[32mgcc-4.9.2 completed...\e[0m"
    SPACER
    rm -v dummy.c a.out
    cd .. && rm -rf gcc-4.9.2 gcc-build/
    sleep 5
}

BUILD_TCL () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding tcl-8.6.3...\e[0m"
    printf "\n\n"
    sleep 5

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
    echo -e "\e[1m\e[32mtcl-8.6.3 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_EXPECT () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding expect-5.45...\e[0m"
    printf "\n\n"
    sleep 5

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
    echo -e "\e[1m\e[32mexpect-5.45 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_DEJAGNU () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding dejagnu-1.5.2...\e[0m"
    printf "\n\n"
    sleep 5

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
    echo -e "\e[1m\e[32mdejagnu-1.5.2 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_CHECK () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding check-0.9.14...\e[0m"
    printf "\n\n"
    sleep 5

    ##################
    ## Check-0.9.14 ##
    ## ============ ##
    ##################

    tar xf check-0.9.14.src.tar.gz &&
    cd check-0.9.14/
    PKG_CONFIG= ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf check-0.9.14
    printf "\n\n"
    echo -e "\e[1m\e[32mcheck-0.9.14 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_NCURSES () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding ncurses-5.9...\e[0m"
    printf "\n\n"
    sleep 5

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
    echo -e "\e[1m\e[32mncurses-5.9 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_BASH () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding bash-4.3.30...\e[0m"
    printf "\n\n"
    sleep 5

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
    echo -e "\e[1m\e[32mbash-4.3.30 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_BZIP2 () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding bzip2-1.0.6...\e[0m"
    printf "\n\n"
    sleep 5

    #################
    ## Bzip2-1.0.6 ##
    ## =========== ##
    #################

    tar xf bzip2-1.0.6.src.tar.gz &&
    cd bzip2-1.0.6/
    make && make PREFIX=/tools install &&
    cd .. && rm -rf bzip2-1.0.6
    printf "\n\n"
    echo -e "\e[1m\e[32mbzip2-1.0.6 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_COREUTILS () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding coreutils-8.23...\e[0m"
    printf "\n\n"
    sleep 5

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
    echo -e "\e[1m\e[32mcoreutils-8.23 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_DIFFUTILS () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding diffutils-3.3...\e[0m"
    printf "\n\n"
    sleep 5

    ###################
    ## Diffutils-3.3 ##
    ## ============= ##
    ###################

    tar xf diffutils-3.3.src.tar.gz &&
    cd diffutils-3.3/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf diffutils-3.3
    printf "\n\n"
    echo -e "\e[1m\e[32mdiffutils-3.3 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_FILE () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding file-5.22...\e[0m"
    printf "\n\n"
    sleep 5

    ###############
    ## File-5.22 ##
    ## ========= ##
    ###############

    tar xf file-5.22.src.tar.gz &&
    cd file-5.22/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf file-5.22
    printf "\n\n"
    echo -e "\e[1m\e[32mfile-5.22 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_FINDUTILS () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding findutils-4.4.2...\e[0m"
    printf "\n\n"
    sleep 5

    #####################
    ## Findutils-4.4.2 ##
    ## =============== ##
    #####################

    tar xf findutils-4.4.2.src.tar.gz &&
    cd findutils-4.4.2/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf findutils-4.4.2
    printf "\n\n"
    echo -e "\e[1m\e[32mfindutils-4.4.2 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_GAWK () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding gawk-4.1.1...\e[0m"
    printf "\n\n"
    sleep 5

    ################
    ## Gawk-4.1.1 ##
    ## ========== ##
    ################

    tar xf gawk-4.1.1.src.tar.gz &&
    cd gawk-4.1.1/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf gawk-4.1.1
    printf "\n\n"
    echo -e "\e[1m\e[32mgawk-4.1.1 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_GETTEXT () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding gettext-0.19.4...\e[0m"
    printf "\n\n"
    sleep 5

    ####################
    ## Gettext-0.19.4 ##
    ## ============== ##
    ####################

    tar xf gettext-0.19.4.src.tar.gz &&
    cd gettext-0.19.4/
    cd gettext-tools
    EMACS="no" ./configure --prefix=/tools --disable-shared &&
    make -C gnulib-lib &&
    make -C intl pluralx.c &&
    make -C src msgfmt &&
    make -C src msgmerge &&
    make -C src xgettext &&
    cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
    cd .. && cd .. && rm -rf gettext-0.19.4
    printf "\n\n"
    echo -e "\e[1m\e[32mgettext-0.19.4 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_GREP () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding grep-2.21...\e[0m"
    printf "\n\n"
    sleep 5

    ###############
    ## Grep-2.21 ##
    ## ========= ##
    ###############

    tar xf grep-2.21.src.tar.gz &&
    cd grep-2.21/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf grep-2.21
    printf "\n\n"
    echo -e "\e[1m\e[32mgrep-2.21 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_GZIP () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding gzip-1.6...\e[0m"
    printf "\n\n"
    sleep 5

    ##############
    ## Gzip-1.6 ##
    ## ======== ##
    ##############

    tar xf gzip-1.6.src.tar.gz &&
    cd gzip-1.6/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf gzip-1.6
    printf "\n\n"
    echo -e "\e[1m\e[32mgzip-1.6 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_M4 () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding m4-1.4.17...\e[0m"
    printf "\n\n"
    sleep 5

    ###############
    ## M4-1.4.17 ##
    ## ========= ##
    ###############

    tar xf m4-1.4.17.src.tar.gz &&
    cd m4-1.4.17/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf m4-1.4.17
    printf "\n\n"
    echo -e "\e[1m\e[32mm4-1.4.17 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_MAKE () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding make-4.1...\e[0m"
    printf "\n\n"
    sleep 5

    ##############
    ## Make-4.1 ##
    ## ======== ##
    ##############

    tar xf make-4.1.src.tar.gz &&
    cd make-4.1/
    ./configure --prefix=/tools --without-guile &&
    make &&
    make install &&
    cd .. && rm -rf make-4.1
    printf "\n\n"
    echo -e "\e[1m\e[32mmake-4.1 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_PATCH () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding patch-2.7.4...\e[0m"
    printf "\n\n"
    sleep 5

    #################
    ## Patch-2.7.4 ##
    ## =========== ##
    #################

    tar xf patch-2.7.4.src.tar.gz &&
    cd patch-2.7.4/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf patch-2.7.4
    printf "\n\n"
    echo -e "\e[1m\e[32mpatch-2.7.4 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_PERL () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding perl-5.20.2...\e[0m"
    printf "\n\n"
    sleep 5

    #################
    ## Perl-5.20.2 ##
    ## =========== ##
    #################

    tar xf perl-5.20.2.src.tar.gz &&
    cd perl-5.20.2/
    sh Configure -des -Dprefix=/tools -Dlibs=-lm &&
    make &&
    cp -v perl cpan/podlators/pod2man /tools/bin
    mkdir -pv /tools/lib/perl5/5.20.2
    cp -Rv lib/* /tools/lib/perl5/5.20.2
    cd .. && rm -rf perl-5.20.2
    printf "\n\n"
    echo -e "\e[1m\e[32mperl-5.20.2 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_SED () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding sed-4.2.2...\e[0m"
    printf "\n\n"
    sleep 5

    ###############
    ## Sed-4.2.2 ##
    ## ========= ##
    ###############

    tar xf sed-4.2.2.src.tar.gz &&
    cd sed-4.2.2/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf sed-4.2.2
    printf "\n\n"
    echo -e "\e[1m\e[32msed-4.2.2 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_TAR () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding tar-1.28...\e[0m"
    printf "\n\n"
    sleep 5

    ##############
    ## Tar-1.28 ##
    ## ======== ##
    ##############

    tar xf tar-1.28.src.tar.gz &&
    cd tar-1.28/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf tar-1.28
    printf "\n\n"
    echo -e "\e[1m\e[32mtar-1.28 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_TEXINFO () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding texinfo-5.2...\e[0m"
    printf "\n\n"
    sleep 5

    #################
    ## Texinfo-5.2 ##
    ## =========== ##
    #################

    tar xf texinfo-5.2.src.tar.gz &&
    cd texinfo-5.2/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf texinfo-5.2
    printf "\n\n"
    echo -e "\e[1m\e[32mtexinfo-5.2 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_UTIL_LINUX () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding util-linux-2.26...\e[0m"
    printf "\n\n"
    sleep 5

    #####################
    ## Util-linux-2.26 ##
    ## =============== ##
    #####################

    tar xf util-linux-2.26.src.tar.gz &&
    cd util-linux-2.26/
    ./configure --prefix=/tools        \
        --without-python               \
        --disable-makeinstall-chown    \
        --without-systemdsystemunitdir \
        PKG_CONFIG="" &&
    make &&
    make install &&
    cd .. && rm -rf util-linux-2.26
    printf "\n\n"
    echo -e "\e[1m\e[32mutil-linux-2.26 completed...\e[0m"
    SPACER
    sleep 5
}

BUILD_XZ () {
    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding xz-5.2.0...\e[0m"
    printf "\n\n"
    sleep 5

    ##############
    ## Xz-5.2.0 ##
    ## ======== ##
    ##############

    tar xf xz-5.2.0.src.tar.gz &&
    cd xz-5.2.0/
    ./configure --prefix=/tools &&
    make &&
    make install &&
    cd .. && rm -rf xz-5.2.0
    printf "\n\n"
    echo -e "\e[1m\e[32mxz-5.2.0 completed...\e[0m"
    SPACER
    sleep 5
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

cd /mnt/igos/sources

# The actual workhorse
SET_GCC_AND_LINUX 2>&1 | tee bin_p1log &&
BUILD_BINUTILS_PASS1 2>&1 | tee bin_p2log &&
BUILD_GCC_PASS1 2>&1 | tee gcc_pass1_log &&
BUILD_LINUX_API_HEADERS 2>&1 | tee linux_api_log &&
BUILD_GLIBC 2>&1 | tee glibc_log &&
if [ "$GLIBC_SANITY" = "BAD" ]; then
    SPACER
    echo -e "\e[1m\e[5m\e[31mGlibc sanity check has failed\e[0m.  \e[1m\e[32mPlease review the logs at \e[1m\e[37m/var/log/InterGenOS\e[0m"
    printf "\n\n\n"
    sleep 5
    exit 1
fi
BUILD_LIBSTDC 2>&1 | tee libstdc_log &&
BUILD_BINUTILS_PASS2 2>&1 | tee bin_pass2_log &&
BUILD_GCC_PASS2 2>&1 | tee gcc_pass2_log &&
if [ "$GCC_SANITY" = "BAD" ]; then
    SPACER
    echo -e "\e[1m\e[5m\e[31mGCC sanity check has failed\e[0m.  \e[1m\e[32mPlease review the logs at \e[1m\e[37m/var/log/InterGenOS\e[0m"
    printf "\n\n\n"
    WHITE
    sleep 5
    exit 1
fi
BUILD_TCL 2>&1 | tee tcl_log &&
BUILD_EXPECT 2>&1 | tee expect_log &&
BUILD_DEJAGNU 2>&1 | tee dejagnu_log &&
BUILD_CHECK 2>&1 | tee check_log &&
BUILD_NCURSES 2>&1 | tee ncurses_log &&
BUILD_BASH 2>&1 | tee bash_log &&
BUILD_BZIP2 2>&1 | tee bzip2_log &&
BUILD_COREUTILS 2>&1 | tee coreutils_log &&
BUILD_DIFFUTILS 2>&1 | tee diffutils_log &&
BUILD_FILE 2>&1 | tee file_log_log &&
BUILD_FINDUTILS 2>&1 | tee findutils_log &&
BUILD_GAWK 2>&1 | tee gawk_log &&
BUILD_GETTEXT 2>&1 | tee gettext_log &&
BUILD_GREP 2>&1 | tee grep_log &&
BUILD_GZIP 2>&1 | tee gzip_log &&
BUILD_M4 2>&1 | tee m4_log &&
BUILD_MAKE 2>&1 | tee make_log &&
BUILD_PATCH 2>&1 | tee patch_log &&
BUILD_PERL 2>&1 | tee perl_log &&
BUILD_SED 2>&1 | tee sed_log &&
BUILD_TAR 2>&1 | tee tar_log &&
BUILD_TEXINFO 2>&1 | tee texinfo_log &&
BUILD_UTIL_LINUX 2>&1 | tee util_linux_log &&
BUILD_XZ 2>&1 | tee xz_log &&

cat bin_p1log > binutils_pass1_log
cat bin_p2log >> binutils_pass1_log
rm bin_p1log bin_p2log

# Log cleaning and filing
for log in $(find $(pwd) -type f -name '*log' | sed 's/\// /g' | awk '{print $NF}'); do
    sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' $log
    newlog=$(echo $log | sed -e "s/$/_$TIMESTAMP/g" -e 's/_log//g')
    cp $log /var/log/InterGenOS/BuildLogs/Temp_Sys_Buildlogs/$newlog
done

# Drop unecessary weight
strip --strip-debug /tools/lib/* &&
/usr/bin/strip --strip-unneeded /tools/{,s}bin/* &&
rm -rf /tools/{,share}/{info,man,doc} &&

SPACER
echo -e "\e[1m\e[4m\e[32mTemporary system build complete\e[0m"
printf "\n\n"
DIVIDER
SPACER
sleep 5

#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################

exit 0
