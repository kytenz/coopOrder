#!/bin/bash
# Example of run with curl: curl -s localhost/getCoop.sh | ITEM=kyckling bash
# Rewrite search to set %20 instead of space and swedish letters to aaoAAO
ITEM=$1
ITEMSEARCH=$(echo $ITEM | sed -e 's/ /\%20/g' | tr '[åäöÅÄÖ]' '[aaoAAO]' | sed -e 's/ar$//g' | sed -e 's/e$//g' | sed -e 's/na$//g')

# Get the lowest priced item (Used to then filter on the item for the lowest priced item) 
# TODO: Maybe change to comparativePrice and not lowest price? Depends on size the user wants also
GETLOWPRICE=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$ITEM" | sed -e 's/<[^>]*>//g' | sed 's/\ //g' | sed -n '/^{/p' | /usr/local/bin/jq -r '.pricePerPc' | sort -nu | awk 'NR==1{print $1}')

# Get all information about the lowest priced item (json format)
# TODO: Get more than just one hit, maybe top 3?
GETITEM=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$ITEM" | sed -e 's/<[^>]*>//g' | grep -m 1 ":$GETLOWPRICE,")
GETCOMPAREPRICE=$(echo $GETITEM | /usr/local/bin/jq -r '.comparativePrice')
GETNAME=$(echo $GETITEM | /usr/local/bin/jq -r '.priceUnit')
GETNAME=$(echo $GETITEM | /usr/local/bin/jq -r '.name')
GETMANUFACTURER=$(echo $GETITEM | /usr/local/bin/jq -r '.manufacturer')

JSONFILE="test.json"
> $JSONFILE
echo -e "{" >> $JSONFILE
echo -e "\"response_type\": \"in_channel\"," >> $JSONFILE
echo -e "\t\"text\": \"$GETNAME ($GETMANUFACTURER)\"," >> $JSONFILE
echo -e "\t\t\"attachments\": [" >> $JSONFILE
echo -e "\t\t\t{" >> $JSONFILE
echo -e "\t\t\t\t\"text\":\"$GETLOWPRICE SEK (Jmfr. pris: $GETCOMPAREPRICE/$GETUNIT)\"" >> $JSONFILE
echo -e "\t\t\t}" >> $JSONFILE
echo -e "\t\t]" >> $JSONFILE
echo -e "}" >> $JSONFILE

#TEXTFILE="output.txt"
#> $TEXTFILE
#echo "$GETNAME ($GETMANUFACTURER): $GETLOWPRICE SEK (Jmfr. pris: $GETCOMPAREPRICE/$GETUNIT)" >> $TEXTFILE

# Old code
# Get lowest price from coop (2017-01-16)
#GETPRICE=$(curl -s -X GET -H "Content-type: application/json" -H "Accept: application/json"  https://www.coop.se/handla-online/sok/"$ITEMSEARCH" | grep -i "$ITEM" | sed -e 's/<[^>]*>//g' | sed -e 's/[}"]*\(.\)[{"]*/\1/g;y/,/\n/' | grep pricePerPc | sed -e 's/pricePerPc://g' | sort -nu | awk 'NR==1{print $ITEM}')
#GETCOMPAREPRICE=$(echo $GETLOWPRICE | sed -e 's/[}"]*\(.\)[{"]*/\1/g;y/,/\n/' | grep comparativePrice | sed -e 's/comparativePrice://g' | sort -nu | awk 'NR==1{print $ITEM}')
