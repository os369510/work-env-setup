#!/bin/bash
cscope --version &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "\e[7;1;33m>> cscope may not install.\e[0m"
    exit -1
fi
echo -e "\e[7;1;33m>> Search .c, .cpp and .h files.\e[0m"
path=`pwd`
rm $path"/cscope.files" &> /dev/null
if [ $# -eq 0 ]; then
    find $path/. -name "*.c" -o -name "*.h" -o -name "*.cpp" > $path"/cscope.files"
fi
for p in $@
do
    find $path/$p -name "*.c" -o -name "*.h" -o -name "*.cpp" >> $path"/cscope.files"
done
echo -e "\e[7;1;33m>> Generate cscope files...\e[0m"
cscope -Rbqk 2> /dev/null
echo -e "\e[7;1;33m>> Done.\e[0m"
