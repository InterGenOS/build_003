#!/usr/bin/bash
# libcheck.sh
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
# Checks for the trio of libgmp.la, libmpfr.la, and libmpc.la
# Either all three should be present or absent, but not only one or two
# If the problem exists on your system, either rename or delete the .la files or
# install the appropriate missing package.

printf "\n\n"
for lib in lib{gmp,mpfr,mpc}.la; do
    echo $lib: $(if find /usr/lib* -name $lib|
        grep -q $lib;then :;else echo not;fi) found
done
printf "\n\n"
unset lib
exit 0
