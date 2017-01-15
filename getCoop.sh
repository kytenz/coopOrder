#!/bin/bash
ITEMSEARCH=$(echo $1 | sed -e 's/ /\%20/g')
echo "You searched for $ITEMSEARCH"
# Only gets kyckling at the moment
GETPRICE=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$1" | sed -e 's/<[^>]*>//g' | sed -e 's/[}"]*\(.\)[{"]*/\1/g;y/,/\n/' | grep pricePerPc | sed -e 's/pricePerPc://g' | awk '{printf("%d\n",$1 + 0.5)}' | sort -nu | sed -n -e 's/^\([0-9]*\).*/\1/' -e '1p')
echo "$1: $GETPRICE SEK"



# Old code
#GETPRICE=$(curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  "https://www.coop.se/handla-online/sok/kyckling" | grep "$1" | sed -e 's/<[^>]*>//g' | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["'pricePerPc'"]';)
