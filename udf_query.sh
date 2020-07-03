#!/bin/sh

username="-"
password="-"
cups="-"


yesterday=$(date -d "yesterday 13:00" '+%d/%m/%Y')



login () {
  curl -s --request POST \
  --url https://api.ufd.es/ufd/v1.0/login \
  --header 'content-type: application/json' \
  --header 'dnt: 1' \
  --header 'x-appclient: ACUFDW' \
  --header 'x-appclientid: ACUFDWeb' \
  --header 'x-appclientsecret: 4CUFDW3b' \
  --header 'x-application: ACUFD' \
  --header 'x-appversion: 1.0.0.0' \
  --header 'x-messageid: 0/kT1qKFKuYFVGt8K/0' \
  --data "{	\"user\": \"$username\",	\"password\":\"$password\" }"

}

token=$(echo $(login) | jq -r .accessToken)

# echo $token

consumption (){
  curl -s --request GET \
  --url "https://api.ufd.es/ufd/v1.0/consumptions?filter=nif::$username%7Ccups::$cups%7CstartDate::$yesterday%7CendDate::$yesterday%7Cgranularity::H%7Cunit::K%7Cgenerator::0%7CisDelegate::N%7CmeasurementSystem::O" \
  --header "authorization: Bearer $token" \
  --header 'dnt: 1' \
  --header 'x-appclient: ACUFDW' \
  --header 'x-appclientid: ACUFDWeb' \
  --header 'x-appclientsecret: 4CUFDW3b' \
  --header 'x-application: ACUFD' \
  --header 'x-appversion: 1.0.0.0' \
  --header 'x-messageid: 0/kT1qKFKuYFVGt8K/0'
}

hour=$(date +'%H')


# value=$(echo $(consumption) | jq -r --arg hour $hour '.items[0].consumptions.items[] | select(.hour==($hour | tonumber)).consumptionValue')
value=$(echo $(consumption) | jq -r '.items[0].consumptions.items')

echo $value