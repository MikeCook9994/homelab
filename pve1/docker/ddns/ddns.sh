#!/bin/bash

# Get IP addr
ip4=$(curl -s -4 icanhazip.com)

echo "$ip4"

# Regular expression for IPv4
regex="^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$"

if [[ "$ip4" =~ "$regex" ]]
then
    echo "No valid IP address found"
    exit 1
fi

baseUrl="https://api.cloudflare.com"
contentType="Content-Type: application/json"

$API_KEY=$(cat $API_KEY_FILE)
bearerAuthHeader="Authorization: Bearer $API_KEY"

url="$HOSTNAME.$SUBZONE"

echo "$url"

# Get DNS Zones
zoneId=$(curl -s --request GET --url "$baseUrl/client/v4/zones?name=$SUBZONE" -H "$contentType" -H "$bearerAuthHeader" | jq -r --arg SUBZONE "$SUBZONE" '.result[] | select(.name==$SUBZONE) | .id' | cat)

echo "$SUBZONEId"

if [[ -z $SUBZONEId ]]
then
    echo "Could not resolve a zone id"
    exit 1
fi

# Get DNS Records
recordId=$(curl -s --request GET --url "$baseUrl/client/v4/zones/$SUBZONEId/dns_records?type=A&name=$url" -H "$contentType" -H "$bearerAuthHeader" | jq -r --arg url "$url" '.result[] | select(.name=$url) | .id' | cat)

echo "$recordId"

if [[ -z $recordId ]]
then
    echo "Could not resolve a record id. A new record will be created"
fi

requestMethod=$([ -z "$recordId" ] && echo "POST" || echo "PUT")
requestUrl="$baseUrl/client/v4/zones/$SUBZONEId/dns_records$([ -z "$recordId" ] && echo "" || echo "/$recordId")"
requestBody='{
    "content": "'"$ip4"'",
    "name": "'"$url"'",
    "proxied": true,
    "type": "A",
    "ttl": 1
}'

# Create or Update DNS Record
result=$(curl -s --request "$requestMethod" --url "$requestUrl" -H "$contentType" -H "$bearerAuthHeader" -d "$requestBody" | jq -r '.success')

echo "$result"
exit $([ "$result" == "true" ] && echo 0 || echo 1)