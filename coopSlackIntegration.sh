#!/bin/bash
# Example of run with curl: curl -s localhost/getCoop.sh | ITEM=kyckling bash
# Rewrite search to set %20 instead of space and swedish letters to aaoAAO
ITEM=$1
ITEMSEARCH=$(echo $ITEM | sed -e 's/ /\%20/g' | tr '[åäöÅÄÖ]' '[aaoAAO]' | sed -e 's/ar$//g' | sed -e 's/e$//g' | sed -e 's/na$//g')
#echo "You searched for $ITEMSEARCH"

# Get the lowest priced item (Used to then filter on the item for the lowest priced item) 
# TODO: Maybe change to comparativePrice and not lowest price? Depends on size the user wants also
GETLOWPRICE=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$ITEM" | sed -e 's/<[^>]*>//g' | sed 's/\ //g' | sed -n '/^{/p' | jq -r '.pricePerPc' | sort -nu | awk 'NR==1{print $1}')
#echo "GET LOW PRICE: $GETLOWPRICE"

# Get all information about the lowest priced item (json format)
# TODO: Get more than just one hit, maybe top 3?
GETITEM=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$ITEM" | sed -e 's/<[^>]*>//g' | grep -m 1 ":$GETLOWPRICE,")
#echo $GETITEM
DATE=$(date +%Y%m%d%H%M%S)
GETCOMPAREPRICE=$(echo $GETITEM | jq -r '.comparativePrice')
GETNAME=$(echo $GETITEM | jq -r '.priceUnit')
GETNAME=$(echo $GETITEM | jq -r '.name')
GETMANUFACTURER=$(echo $GETITEM | jq -r '.manufacturer')
#echo "$ITEM: $GETLOWPRICE SEK (Jmfr. pris: $GETCOMPAREPRICE/$GETUNIT)"
#echo "$GETNAME ($GETMANUFACTURER): $GETLOWPRICE SEK (Jmfr. pris: $GETCOMPAREPRICE/$GETUNIT)"
JSONFILE="test.json"
> $JSONFILE
echo "{" >> $JSONFILE
echo "    \"text\": \"$GETNAME ($GETMANUFACTURER): $GETLOWPRICE SEK (Jmfr. pris: $GETCOMPAREPRICE/$GETUNIT)\"," >> $JSONFILE
echo "    \"attachments\": [" >> $JSONFILE
echo "        {" >> $JSONFILE
echo "            \"text\":\"$DATE\"" >> $JSONFILE
echo "        }" >> $JSONFILE
echo "    ]" >> $JSONFILE
echo "}" >> $JSONFILE


# Old code
# Get lowest price from coop (2017-01-16)
#GETPRICE=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$ITEM" | sed -e 's/<[^>]*>//g' | sed -e 's/[}"]*\(.\)[{"]*/\1/g;y/,/\n/' | grep pricePerPc | sed -e 's/pricePerPc://g' | sort -nu | awk 'NR==1{print $ITEM}')
#GETCOMPAREPRICE=$(echo $GETLOWPRICE | sed -e 's/[}"]*\(.\)[{"]*/\1/g;y/,/\n/' | grep comparativePrice | sed -e 's/comparativePrice://g' | sort -nu | awk 'NR==1{print $ITEM}')
