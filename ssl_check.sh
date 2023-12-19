#!/bin/bash
echo "Enter your Webhook URL"
read  Webhook

while read -r url ;do

	exp_date=$(echo | openssl s_client -servername "$url" -connect "$url":443 2>/dev/null | openssl x509 -noout -dates | grep "notAfter" | cut -d= -f2)
	exp_epoch=$(date -d "$exp_date" "+%s")
	current_epoch=$(date "+%s")
	days_left=$(( (exp_epoch - current_epoch) / 86400 ))
	if [ $days_left -lt "30" ]; then
		message="your SSL certificate for URL "$url" will expire in $days_left days"
		curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$message\"}" "$Webhook"
	fi
done<./URLs
