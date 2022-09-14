#!/bin/sh  

ADDR="https://www.abcdocker.com/"

SERVER=${ADDR#http://}
SERVER=${SERVER%%/*}

wget --html-extension --restrict-file-names=windows --convert-links --page-requisites --execute robots=off --mirror --exclude-directories /comment/reply/,/aggregator/,/user/ --reject "aggregator*"  "$ADDR"

find $SERVER -type f -name "*.css" -exec cat {} /; |
grep -o 'url(/[^)]*)' |
sort |
uniq |
sed 's/^url(/(.*/))$/http:////'$SERVER'/1/' |
wget --mirror --page-requisites -i -

for i in `find $SERVER -type f -name "*.css"`; do
PREFIX="$(echo $i | sed 's/[^//]*//g; s///$//; s////../////g')"
sed -i 's/url(///url('$PREFIX'/g' $i
done
