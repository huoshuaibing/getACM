#!/bin/bash

## config param
endpoint=addr-hz-internal.edas.aliyun.com
# 3e7a4e68-e53c-4012-b3cc-440a86ef4110
namespace=$1
accessKey=$2
secretKey=$3
# ops_vue
dataId=$4
group=DEFAULT_GROUP
## config param end

## get serverIp from address server
serverIp=`curl $endpoint:8080/diamond-server/diamond -s | awk '{a[NR]=$0}END{srand();i=int(rand()*NR+1);print a[i]}'`

## config sign
timestamp=`echo $[$(date +%s%N)/1000000]`
signStr=$namespace+$group+$timestamp
signContent=`echo -n $signStr | openssl dgst -hmac $secretKey -sha1 -binary | base64`

## request
curl -H "Spas-AccessKey:"$accessKey -H "timeStamp:"$timestamp -H "Spas-Signature:"$signContent "http://"$serverIp":8080/diamond-server/config.co?dataId="$dataId"&group="$group"&tenant="$namespace -v
