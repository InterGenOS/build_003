#!/bin/bash
# Checks for the triad of libgmp.la, libmpfr.la, and libmpc.la
# Either all three should be present or absent, but not only one or two
# If the problem exists on your system, either rename or delete the .la files or
# install the appropriate missing package.

for lib in lib{gmp,mpfr,mpc}.la; do
  echo $lib: $(if find /usr/lib* -name $lib|
               grep -q $lib;then :;else echo not;fi) found
done
unset lib
