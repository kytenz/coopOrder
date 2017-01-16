#!/bin/bash
# Rewrite search to set %20 instead of space and swedish letters to aaoAAO
ITEMSEARCH=$(echo $1 | sed -e 's/ /\%20/g' | tr '[åäöÅÄÖ]' '[aaoAAO]')
echo "You searched for $ITEMSEARCH"

# Get the lowest priced item (Used to then filter on the item for the lowest priced item) (Change to camparativePrice later)
GETLOWPRICE=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$1" | sed -e 's/<[^>]*>//g' | sed 's/\ //g' | sed -n '/^{/p' | jq -r '.pricePerPc' | sort -nu | awk 'NR==1{print $1}')
echo "GET LOW PRICE: $GETLOWPRICE"

# Get all information about the lowest priced item (json format)
GETITEM=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$1" | sed -e 's/<[^>]*>//g' | grep ":$GETLOWPRICE,")
echo $GETITEM
GETCOMPRPRICE=$(echo $GETITEM | jq -r '.comparativePrice')
GETUNIT=$(echo $GETITEM | jq -r '.priceUnit')
echo "Compare price: $GETCOMPAREPRICE"
echo "$1: $GETLOWPRICE SEK (Jmfr. pris: $GETCOMPRPRICE/$GETUNIT)"


# Old code
# Get lowest price from coop (2017-01-16)
#GETPRICE=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$1" | sed -e 's/<[^>]*>//g' | sed -e 's/[}"]*\(.\)[{"]*/\1/g;y/,/\n/' | grep pricePerPc | sed -e 's/pricePerPc://g' | sort -nu | awk 'NR==1{print $1}')
#GETCOMPAREPRICE=$(echo $GETLOWPRICE | sed -e 's/[}"]*\(.\)[{"]*/\1/g;y/,/\n/' | grep comparativePrice | sed -e 's/comparativePrice://g' | sort -nu | awk 'NR==1{print $1}')
