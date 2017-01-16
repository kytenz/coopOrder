#!/bin/bash
# Rewrite search to set %20 instead of space and swedish letters to aaoAAO
ITEMSEARCH=$(echo $1 | sed -e 's/ /\%20/g' | tr '[åäöÅÄÖ]' '[aaoAAO]')
echo "You searched for $ITEMSEARCH"
# Get the lowest price of the value (pricePerPc)
GETPRICE=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$1" | sed -e 's/<[^>]*>//g' | sed -e 's/[}"]*\(.\)[{"]*/\1/g;y/,/\n/' | grep pricePerPc | sed -e 's/pricePerPc://g' | sort -nu | awk 'NR==1{print $1}')
GETCOMPAREPRICE=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$1" | sed -e 's/<[^>]*>//g' | grep "$GETPRICE")
GETCOMPAREPRICE=$(echo $GETCOMPAREPRICE | sed -e 's/[}"]*\(.\)[{"]*/\1/g;y/,/\n/' | grep comparativePrice | sed -e 's/comparativePrice://g' | sort -nu | awk 'NR==1{print $1}')
#echo $GETCOMPAREPRICE
echo "Compare price: $GETCOMPAREPRICE"
echo "$1: $GETPRICE SEK" # (Jmfr. pris: $GETCOMPAREPRICE)"



# Old code
#GETPRICE=$(curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  "https://www.coop.se/handla-online/sok/kyckling" | grep "$1" | sed -e 's/<[^>]*>//g' | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["'pricePerPc'"]';)
