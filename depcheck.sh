#!/bin/bash
# depcheck.sh
# Simple script to list version numbers of critical development tools

export LC_ALL=C
printf "\n\n\n"
bash --version | head -n1 | cut -d" " -f2-4 | sed 's/-release//' | awk '{print $1" "$3}' | sed 's/,//'
echo "   /bin/sh -> `readlink -f /bin/sh`"
echo -n "Binutils "; ld --version | head -n1 | cut -d" " -f3- | sed 's/(GNU Binutils) //'
bison --version | head -n1 | sed 's/(GNU Bison) //'

if [ -h /usr/bin/yacc ]; then
  echo "   /usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
  echo "   yacc is $(/usr/bin/yacc --version | head -n1 | sed 's/(GNU Bison) //')"
else
  echo "yacc not found"
fi

bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6- | sed 's/,/ /g' | awk '{print $1" "$3}'
echo -n "Coreutils"; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1 | sed 's/(GNU diffutils) //' | awk '{print $1"utils "$2" "$3}'
find --version | head -n1 | sed 's/(GNU findutils) //' | awk '{print $1"utils "$2" "$3}'
gawk --version | head -n1 | cut -d ',' -f 1

if [ -h /usr/bin/awk ]; then
  echo "   /usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
  echo yacc is `/usr/bin/awk --version | head -n1`
else
  echo "awk not found"
fi

gcc --version | head -n1 | sed 's/(GCC) //'
g++ --version | head -n1 | sed 's/(GCC) //'
ldd --version | head -n1 | cut -d" " -f2-  | awk '{print "glibc "$3}' # glibc version
grep --version | head -n1 | sed 's/(GNU grep) //'
gzip --version | head -n1
cat /proc/version | awk '{print $1" "$3}'
m4 --version | head -n1 | awk '{print $1" "$4}'
make --version | head -n1 | awk '{print $2" "$3}'
patch --version | head -n1 | awk '{print $2" "$3}'
echo Perl `perl -V:version` | sed -e "s/'/ /g" -e "s/=//" | cut -d ';' -f 1 | awk '{print $1" "$3}'
sed --version | head -n1 | sed 's/(GNU sed) //'
tar --version | head -n1 | sed 's/(GNU tar) //'
makeinfo --version | head -n1 | sed 's/makeinfo (GNU texinfo)/texinfo/'
xz --version | head -n1 | sed 's/(XZ Utils) //'

echo 'main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
  then tput setaf 2
       echo "   g++ compilation OK"
       tput sgr0
       printf "\n\n";
  else tput bold
       tput setaf 1
       echo "   g++ compilation failed"
       tput sgr0
       printf "\n\n"; fi
rm -f dummy.c dummy
