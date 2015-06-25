#!/tools/bin/bash
# strip_binaries-libraries.sh
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
PATH=/bin:/usr/bin:/sbin:/usr/sbin
export PATH

# Sets a start-point timestamp
TIMESTAMP="$(date +"%m-%d-%Y_%T")"

#########################################
##-------------------------------------##
## END - INITIAL VARIABLE DECLARATIONS ##
##-------------------------------------##
#########################################

#########################
##---------------------##
## BEGIN - CORE SCRIPT ##
##---------------------##
#########################

/tools/bin/find /{,usr/}{bin,lib,sbin} -type f \
    -exec /tools/bin/strip --strip-debug '{}' ';'

rm -rf /tmp/*

rm -rf /tools

printf "\n\n\n\n\n\n\n\n\n\n"
echo -e "    \e[1m\e[32mStripping Binaries and Libraries completed successfully..."
printf "\n\n"
sleep 3
echo -e "    \e[1m\e[32mRe-entering Root Shell..."
sleep 3

#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################

exit 0
