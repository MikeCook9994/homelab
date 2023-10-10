#!/bin/bash

# Get IP addr
ip4=$(curl -s -4 icanhazip.com)

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

url="$HOSTNAME.$ZONE"

# Get DNS Zones
zoneId=$(curl -s --request GET --url "$baseUrl/client/v4/zones?name=$ZONE" -H "$contentType" -H "$bearerAuthHeader" | jq -r --arg ZONE "$ZONE" '.result[] | select(.name==$ZONE) | .id' | cat)

if [[ -z $zoneId ]]
then
    echo "Could not resolve a zone id"
    exit 1
fi

# Get DNS Records
recordId=$(curl -s --request GET --url "$baseUrl/client/v4/zones/$zoneId/dns_records?type=A&name=$url" -H "$contentType" -H "$bearerAuthHeader" | jq -r --arg url "$url" '.result[] | select(.name=$url) | .id' | cat)

if [[ -z $recordId ]]
then
    echo "Could not resolve a record id. A new record will be created"
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

exit $([ "$result" == "true" ] && echo 0 || echo 1)