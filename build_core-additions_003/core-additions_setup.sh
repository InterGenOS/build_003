#!/bin/bash
# setup.sh
# -------------------------------------------------------
# InterGenOS: A Linux from Source Project
# build: CoreAdditions.build.003
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
    echo -e "\e[34m\e[1m    InterGen\e[37mOS \e[32mCore Additions \e[0mbuild.003"
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

#------------------------------------------------#
# BEGIN - CORE ADDITIONS PACKAGE BUILD FUNCTIONS #
#------------------------------------------------#

BUILD_PAM_1 () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding linux-pam-1.1.8...\e[0m"
    sleep 3
    printf "\n\n"

    #####################
    ## Linux-PAM-1.1.8 ##
    ## =============== ##
    #####################

    cd /sources_core-additions
    tar xf Linux-PAM-1.1.8.src.tar.gz &&
    cd Linux-PAM-1.1.8
    tar -xf ../Linux-PAM-1.1.8-docs.tar.bz2 --strip-components=1
    ./configure --prefix=/usr            \
        --sysconfdir=/etc                \
        --libdir=/usr/lib                \
        --enable-securedir=/lib/security \
        --docdir=/usr/share/doc/Linux-PAM-1.1.8 &&
    make
    install -v -m755 -d /etc/pam.d
}

BUILD_PAM_2 () {

    cd /sources_core-additions/Linux-PAM-1.1.8
    rm -rfv /etc/pam.d
    make install &&
    chmod -v 4755 /sbin/unix_chkpwd &&
    for file in pam pam_misc pamc; do
        mv -v /usr/lib/lib${file}.so.* /lib &&
        ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
    done
    cd /sources_core-additions
    rm -rf Linux-PAM-1-1.8
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mlinux-pam-1.1.8 completed...\e[0m"
    sleep 2
}

BUILD_SHADOW () {

    clear
    HEADER
    echo -e "\e[1m\e[32mRebuilding shadow-4.2.1 with linux-pam support...\e[0m"
    sleep 3
    printf "\n\n"

    ##################
    ## Shadow-4.2.1 ##
    ## ============ ##
    ##################

    cd /sources
    tar xf shadow-4.2.1.src.tar.gz &&
    cd shadow-4.2.1
    sed -i 's/groups$(EXEEXT) //' src/Makefile.in
    find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
    sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' -e 's@/var/spool/mail@/var/mail@' etc/login.defs
    sed -i 's@DICTPATH.*@DICTPATH\t/lib/cracklib/pw_dict@' etc/login.defs
    sed -i 's/1000/999/' etc/useradd
    ./configure --sysconfdir=/etc --with-group-name-max-length=32
    make &&
    make install &&
    mv -v /usr/bin/passwd /bin
    pwconv
    grpconv
    sed -i 's/yes/no/' /etc/default/useradd
    echo "root:intergenos" | chpasswd &&
    cd /sources
    rm -rf shadow-4.2.1
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mshadow-4.2.1 completed...\e[0m"
    sleep 2

}

BUILD_SUDO () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding sudo-1.8.10p3 with linux-pam support...\e[0m"
    sleep 3
    printf "\n\n"

    ###################
    ## Sudo-1.8.10p3 ##
    ## ============= ##
    ###################

    cd /sources_core-additions
    tar xf sudo-1.8.10p3.src.tar.gz &&
    cd sudo-1.8.10p3
    ./configure --prefix=/usr                 \
        --libexecdir=/usr/lib                 \
        --with-all-insults                    \
        --with-env-editor                     \
        --docdir=/usr/share/doc/sudo-1.8.10p3 \
        --with-passprompt="[sudo] password for %p" &&
    make
    cd /sources_core-additions
    rm -rf sudo-1.8.10p3
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32msudo-1.8.10p3 completed...\e[0m"
    sleep 2

}

BUILD_OPENSSL () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding openssl-1.0.1i...\e[0m"
    sleep 3
    printf "\n\n"

    ####################
    ## OpenSSL-1.0.1i ##
    ## ============== ##
    ####################

    cd /sources_core-additions
    tar xf openssl-1.0.1i.src.tar.gz &&
    cd openssl-1.0.1i
    COMPILE_OPENSSL () {
        cd /sources_core-additions/openssl-1.0.1i
        patch -Np1 -i ../openssl-1.0.1i-fix_parallel_build-1.patch &&
        ./config --prefix=/usr    \
            --openssldir=/etc/ssl \
            --libdir=lib          \
            shared                \
            zlib-dynamic &&
        make
        sed -i 's# libcrypto.a##;s# libssl.a##' Makefile
    }
    sudo -u intergen COMPILE_OPENSSL &&
    make MANDIR=/usr/share/man MANSUFFIX=ssl install &&
    install -dv -m755 /usr/share/doc/openssl-1.0.1i  &&
    cp -vfr doc/*     /usr/share/doc/openssl-1.0.1i
    cd /sources_core-additions
    rm -rf openssl-1.0.1i
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mopenssl-1.0.1i completed...\e[0m"
    sleep 2

}

BUILD_NETTLE () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding nettle-2.7.1...\e[0m"
    sleep 3
    printf "\n\n"

    ##################
    ## nettle-2.7.1 ##
    ## ============ ##
    ##################

    cd /sources_core-additions
    tar xf nettle-2.7.1.src.tar.gz &&
    cd nettle-2.7.1
    COMPILE_NETTLE () {
        cd /sources_core-additions/nettle-2.7.1
        ./configure --prefix=/usr &&
        make
        sed -i '/^install-here/ s/install-static//' Makefile
    }
    sudo -u intergen COMPILE_NETTLE &&
    make install &&
    chmod -v 755 /usr/lib/libhogweed.so.2.5 /usr/lib/libnettle.so.4.7 &&
    install -v -m755 -d /usr/share/doc/nettle-2.7.1 &&
    install -v -m644 nettle.html /usr/share/doc/nettle-2.7.1
    cd /sources_core-additions
    rm -rf nettle-2.7.1
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mnettle-2.7.1 completed...\e[0m"
    sleep 2

}

BUILD_WGET () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding wget-1.15...\e[0m"
    sleep 3
    printf "\n\n"

    ###############
    ## wget-1.15 ##
    ## ========= ##
    ###############

    cd /sources_core-additions
    tar xf wget-1.15.src.tar.gz &&
    cd wget-1.15
    COMPILE_WGET () {
        cd /sources_core-additions/wget-1.15
        ./configure --prefix=/usr \
            --sysconfdir=/etc     \
            --with-ssl=openssl &&
            make
    }
    sudo -u intergen COMPILE_WGET &&
    make install &&
    cd /sources_core-additions
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mInitial wget-1.15 build completed\e[0m"
    printf "\n"
    echo -e "\e[1m\e[32mSource Directory will be removed following\e[0m"
    echo -e "\e[1m\e[32mCertificate-Authority-Certificates creation...\e[0m"
    printf "\n\n"
    sleep 2

}

BUILD_CERTIFICATE-AUTHORITY-CERTIFICATES () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding certificate-authority-certificates...\e[0m"
    sleep 3
    printf "\n\n"

    ########################################
    ## certificate-authority-certificates ##
    ## ================================== ##
    ########################################

    cd /sources_core-additions
    COMPILE_CERTIFICATE-AUTHORITY-CERTIFICATES () {
        cd /sources_core-additions/
        URL=http://anduin.linuxfromscratch.org/sources/other/certdata.txt &&
        rm -f certdata.txt &&
        wget $URL          &&
        make-ca.sh         &&
        remove-expired-certs.sh certs
        echo ca-directory=/etc/ssl/certs >> /etc/wgetrc
    }
    sudo -u intergen COMPILE_CERTIFICATE-AUTHORITY-CERTIFICATES  &&
    SSLDIR=/etc/ssl                                              &&
    install -d ${SSLDIR}/certs                                   &&
    cp -v certs/*.pem ${SSLDIR}/certs                            &&
    c_rehash                                                     &&
    install BLFS-ca-bundle*.crt ${SSLDIR}/ca-bundle.crt          &&
    ln -sfv ../ca-bundle.crt ${SSLDIR}/certs/ca-certificates.crt &&
    unset SSLDIR
    cd /sources_core-additions
    rm -r certs BLFS-ca-bundle*
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mcertificate-authority-certificates completed...\e[0m"
    sleep 2

}

BUILD_LIBFFI () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding libffi-3.1...\e[0m"
    sleep 3
    printf "\n\n"

    ################
    ## libffi-3.1 ##
    ## ========== ##
    ################

    cd /sources_core-additions
    tar xf libffi-3.1.src.tar.gz &&
    cd libffi-3.1
    COMPILE_LIBFFI () {
        cd /sources_core-additions/libffi-3.1
        sed -e '/^includesdir/ s:$(libdir)/@PACKAGE_NAME@-@PACKAGE_VERSION@/include:$(includedir):' -i include/Makefile.in &&
        sed -e '/^includedir/ s:${libdir}/@PACKAGE_NAME@-@PACKAGE_VERSION@/include:@includedir@:' -e 's/^Cflags: -I${includedir}/Cflags:/' -i libffi.pc.in &&
        ./configure --prefix=/usr --disable-static &&
        make
    }
    sudo -u intergen COMPILE_LIBFFI &&
    make install &&
    cd /sources_core-additions
    rm -rf libffi-3.1
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mlibffi-3.1 completed...\e[0m"
    sleep 2

}

BUILD_LIBTASN1 () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding libtasn1-4.1...\e[0m"
    sleep 3
    printf "\n\n"

    ##################
    ## libtasn1-4.1 ##
    ## ============ ##
    ##################

    cd /sources_core-additions
    tar xf libtasn1-4.1.src.tar.gz &&
    cd libtasn1-4.1
    COMPILE_LIBTASN1 () {
        cd /sources_core-additions/libtasn1-4.1
        ./configure --prefix=/usr --disable-static &&
        make
    }
    sudo -u intergen COMPILE_LIBTASN1 &&
    make install &&
    make -C doc/reference install-data-local
    cd /sources_core-additions
    rm -rf libtasn1-4.1
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mlibtasn1-4.1 completed...\e[0m"
    sleep 2

}

BUILD_P11-KIT () {

    clear
    HEADER
    echo -e "\e[1m\e[32mBuilding p11-kit-0.20.6...\e[0m"
    sleep 3
    printf "\n\n"

    ####################
    ## p11-kit-0.20.6 ##
    ## ============== ##
    ####################

    cd /sources_core-additions
    tar xf p11-kit-0.20.6.src.tar.gz &&
    cd libtasn1-4.1
    COMPILE_P11-KIT () {
        cd /sources_core-additions/p11-kit-0.20.6
        ./configure --prefix=/usr --sysconfdir=/etc &&
        make
    }
    sudo -u intergen COMPILE_P11-KIT &&
    make install &&
    cd /sources_core-additions
    rm -rf p11-kit-0.20.6
    printf "\n\n"
    sleep 3
    echo -e "\e[1m\e[32mp11-kit-0.20.6 completed...\e[0m"
    sleep 2

}

# To build next:
#    libffi-3.1 - Done
#    libtasn1-4.1 - Done
#    p11-kit-0.20.6 - Done
#    GnuTLS-3.3.7


#----------------------------------------------#
# END - CORE ADDITIONS PACKAGE BUILD FUNCTIONS #
#----------------------------------------------#

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
    echo -e "\e[1m\e[37mInterGenOS Core Additions must be built as \e[1m\e[31mroot\e[0m"
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

clear
HEADER
cd /
echo -e "\e[1m\e[32mPreparing core-additions sources for compilation...\e[0m"
sleep 3

# Create non-priveleged user for compiling
useradd -m -g users -s /bin/bash intergen

printf "\n\n"
echo -e "\e[32m\e[1mCore-additions source preparation complete\e[0m"
sleep 2

BUILD_PAM_1

cat > /etc/pam.d/other << "EOF"
auth     required       pam_deny.so
account  required       pam_deny.so
password required       pam_deny.so
session  required       pam_deny.so
EOF

BUILD_PAM_2

cat > /etc/pam.c/other << "EOF"
# Begin /etc/pam.d/other

auth            required        pam_unix.so     nullok
account         required        pam_unix.so
session         required        pam_unix.so
password        required        pam_unix.so     nullok

# End /etc/pam.d/other
EOF

BUILD_SHADOW

BUILD_SUDO

cat > /etc/pam.d/sudo << "EOF"
# Begin /etc/pam.d/sudo

# include the default auth settings
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session

# End /etc/pam.d/sudo
EOF
chmod 644 /etc/pam.d/sudo

BUILD_OPENSSL
BUILD_NETTLE
BUILD_WGET

# Start CACert script creation
clear
HEADER
echo -e "\e[1m\e[32mCreating CACert scripts...\e[0m"
printf "\n\n"
sleep 3
cd /sources_core-additions
cat > /usr/bin/make-cert.pl << "EOF"
#!/usr/bin/perl -w

# Used to generate PEM encoded files from Mozilla certdata.txt.
# Run as ./mkcrt.pl > certificate.crt
#
# Parts of this script courtesy of RedHat (mkcabundle.pl)
#
# This script modified for use with single file data (tempfile.cer) extracted
# from certdata.txt, taken from the latest version in the Mozilla NSS source.
# mozilla/security/nss/lib/ckfw/builtins/certdata.txt
#
# Authors: DJ Lucas
#          Bruce Dubbs
#
# Version 20120211

my $certdata = './tempfile.cer';

open( IN, "cat $certdata|" )
    || die "could not open $certdata";

my $incert = 0;

while ( <IN> )
{
    if ( /^CKA_VALUE MULTILINE_OCTAL/ )
    {
        $incert = 1;
        open( OUT, "|openssl x509 -text -inform DER -fingerprint" )
            || die "could not pipe to openssl x509";
    }

    elsif ( /^END/ && $incert )
    {
        close( OUT );
        $incert = 0;
        print "\n\n";
    }

    elsif ($incert)
    {
        my @bs = split( /\\/ );
        foreach my $b (@bs)
        {
            chomp $b;
            printf( OUT "%c", oct($b) ) unless $b eq '';
        }
    }
}
EOF

chmod +x /usr/bin/make-cert.pl

cat > /usr/bin/make-ca.sh << "EOF"
#!/bin/sh
# Begin make-ca.sh
# Script to populate OpenSSL's CApath from a bundle of PEM formatted CAs
#
# The file certdata.txt must exist in the local directory
# Version number is obtained from the version of the data.
#
# Authors: DJ Lucas
#          Bruce Dubbs
#
# Version 20120211

certdata="certdata.txt"

if [ ! -r $certdata ]; then
  echo "$certdata must be in the local directory"
  exit 1
fi

REVISION=$(grep CVS_ID $certdata | cut -f4 -d'$')

if [ -z "${REVISION}" ]; then
  echo "$certfile has no 'Revision' in CVS_ID"
  exit 1
fi

VERSION=$(echo $REVISION | cut -f2 -d" ")

TEMPDIR=$(mktemp -d)
TRUSTATTRIBUTES="CKA_TRUST_SERVER_AUTH"
BUNDLE="BLFS-ca-bundle-${VERSION}.crt"
CONVERTSCRIPT="/usr/bin/make-cert.pl"
SSLDIR="/etc/ssl"

mkdir "${TEMPDIR}/certs"

# Get a list of staring lines for each cert
CERTBEGINLIST=$(grep -n "^# Certificate" "${certdata}" | cut -d ":" -f1)

# Get a list of ending lines for each cert
CERTENDLIST=`grep -n "^CKA_TRUST_STEP_UP_APPROVED" "${certdata}" | cut -d ":" -f 1`

# Start a loop
for certbegin in ${CERTBEGINLIST}; do
  for certend in ${CERTENDLIST}; do
    if test "${certend}" -gt "${certbegin}"; then
      break
    fi
  done

  # Dump to a temp file with the name of the file as the beginning line number
  sed -n "${certbegin},${certend}p" "${certdata}" > "${TEMPDIR}/certs/${certbegin}.tmp"
done

unset CERTBEGINLIST CERTDATA CERTENDLIST certebegin certend

mkdir -p certs
rm -f certs/*      # Make sure the directory is clean

for tempfile in ${TEMPDIR}/certs/*.tmp; do
  # Make sure that the cert is trusted...
  grep "CKA_TRUST_SERVER_AUTH" "${tempfile}" | \
    egrep "TRUST_UNKNOWN|NOT_TRUSTED" > /dev/null

  if test "${?}" = "0"; then
    # Throw a meaningful error and remove the file
    cp "${tempfile}" tempfile.cer
    perl ${CONVERTSCRIPT} > tempfile.crt
    keyhash=$(openssl x509 -noout -in tempfile.crt -hash)
    echo "Certificate ${keyhash} is not trusted!  Removing..."
    rm -f tempfile.cer tempfile.crt "${tempfile}"
    continue
  fi

  # If execution made it to here in the loop, the temp cert is trusted
  # Find the cert data and generate a cert file for it

  cp "${tempfile}" tempfile.cer
  perl ${CONVERTSCRIPT} > tempfile.crt
  keyhash=$(openssl x509 -noout -in tempfile.crt -hash)
  mv tempfile.crt "certs/${keyhash}.pem"
  rm -f tempfile.cer "${tempfile}"
  echo "Created ${keyhash}.pem"
done

# Remove blacklisted files
# MD5 Collision Proof of Concept CA
if test -f certs/8f111d69.pem; then
  echo "Certificate 8f111d69 is not trusted!  Removing..."
  rm -f certs/8f111d69.pem
fi

# Finally, generate the bundle and clean up.
cat certs/*.pem >  ${BUNDLE}
rm -r "${TEMPDIR}"
EOF

chmod +x /usr/bin/make-ca.sh

cat > /usr/bin/remove-expired-certs.sh << "EOF"
#!/bin/sh
# Begin /usr/bin/remove-expired-certs.sh
#
# Version 20120211

# Make sure the date is parsed correctly on all systems
mydate()
{
  local y=$( echo $1 | cut -d" " -f4 )
  local M=$( echo $1 | cut -d" " -f1 )
  local d=$( echo $1 | cut -d" " -f2 )
  local m

  if [ ${d} -lt 10 ]; then d="0${d}"; fi

  case $M in
    Jan) m="01";;
    Feb) m="02";;
    Mar) m="03";;
    Apr) m="04";;
    May) m="05";;
    Jun) m="06";;
    Jul) m="07";;
    Aug) m="08";;
    Sep) m="09";;
    Oct) m="10";;
    Nov) m="11";;
    Dec) m="12";;
  esac

  certdate="${y}${m}${d}"
}

OPENSSL=/usr/bin/openssl
DIR=/etc/ssl/certs

if [ $# -gt 0 ]; then
  DIR="$1"
fi

certs=$( find ${DIR} -type f -name "*.pem" -o -name "*.crt" )
today=$( date +%Y%m%d )

for cert in $certs; do
  notafter=$( $OPENSSL x509 -enddate -in "${cert}" -noout )
  date=$( echo ${notafter} |  sed 's/^notAfter=//' )
  mydate "$date"

  if [ ${certdate} -lt ${today} ]; then
     echo "${cert} expired on ${certdate}! Removing..."
     rm -f "${cert}"
  fi
done
EOF

chmod +x /usr/bin/remove-expired-certs.sh
printf "\n\n"
echo -e "\e[1m\e[32mCACert script creation completed\e[0m"
sleep 3
# End CACert script creation

BUILD_CERTIFICATE-AUTHORITY-CERTIFICATES

# Clean up wget build directory
clear
HEADER
echo -e "\e[1m\e[32mCleaning up wget-1.15 source directory...\e[0m"
cd /sources_core-additions
rm -rf wget-1.15
sleep 3
printf "\n\n"
echo -e "\[1m\e[32mCleanup complete\e[0m"
sleep 3

BUILD_LIBFFI
BUILD_LIBTASN1
BUILD_P11-KIT

#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################

exit 0
