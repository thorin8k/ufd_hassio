#!/bin/sh

# date=$(date +'%H')



cat ./data.json | jq -r --arg hour $date '.items[0].consumptions.items[] | select(.hour==($hour | tonumber)).consumptionValue'

#echo $(date -d "yesterday 13:00" '+%d/%m/%Y')