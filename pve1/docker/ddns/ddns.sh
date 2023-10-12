#!/bin/ash

# Get IP addr
echo "Beginning Cloudflare DDNS Job"

ip4=$(curl -s -4 icanhazip.com)

# Regular expression for IPv4
regex="^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$"

if [[ "$ip4" =~ "$regex" ]]
then
    printf "A valid IP address for this device could not be resolved.\n\n"
    exit 1
fi

baseUrl="https://api.cloudflare.com"
contentType="Content-Type: application/json"

API_KEY=$(cat $API_KEY_FILE)
bearerAuthHeader="Authorization: Bearer $API_KEY"

echo "Fetching DNS Zone information for $ZONE"

# Get DNS Zones
zoneId=$(curl -s --request GET --url "$baseUrl/client/v4/zones?name=$ZONE" -H "$contentType" -H "$bearerAuthHeader" | jq -r --arg ZONE "$ZONE" '.result[] | select(.name==$ZONE) | .id' | cat)
echo "Zone Id: $zoneId"

if [[ -z $zoneId ]]
then
    printf "Could not resolve a zone id. This script does not support initializing zones.\n\n"
    exit 1
fi

url="$SUBZONE.$ZONE"
echo "Fetching DNS Record information for $url"

# Get DNS Records
dnsRecordResponse=$(curl -s --request GET --url "$baseUrl/client/v4/zones/$zoneId/dns_records?type=A&name=$url" -H "$contentType" -H "$bearerAuthHeader")

recordId=$(echo "$dnsRecordResponse"| jq -r --arg url "$url" '.result[] | select(.name=$url) | .id' | cat)
echo "DNS Record Id: $recordId"

if [[ -z $recordId ]]
then
    echo "Could not resolve a DNS record. A new record will be created."
else
    echo "Found an existing DNS record. Determining if the record needs to be updated."
    currentIp=$(echo "$dnsRecordResponse"| jq -r --arg url "$url" '.result[] | select(.name=$url) | .content' | cat)

    if [[ $currentIp == $ip4 ]]
    then 
        printf "DNS record content matches current record. No need to Update.\n\n"
        exit 0
    else
        echo "DNS record content is oudated. The record will be updated."
    fi
fi

requestMethod=$([ -z "$recordId" ] && echo "POST" || echo "PUT")
requestUrl="$baseUrl/client/v4/zones/$zoneId/dns_records$([ -z "$recordId" ] && echo "" || echo "/$recordId")"
requestBody='{
    "content": "'"$ip4"'",
    "name": "'"$url"'",
    "proxied": true,
    "type": "A",
    "ttl": 1
}'

# Create or Update DNS Record
result=$(curl -s --request "$requestMethod" --url "$requestUrl" -H "$contentType" -H "$bearerAuthHeader" -d "$requestBody" | jq -r '.success')

if [[ $result == "true" ]]
then
    printf "Successfully created or updated the DNS record for $url\n\n"
    exit 0
else
    printf "Failed to create or update the DNS Record for $url\n\n"
    exit 1
fi
