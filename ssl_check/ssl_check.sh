#!/bin/bash

#webhook url and urls file
Webhook_url=https://hooks.slack.com/services/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
URLs_list=$(mktemp)
cat /home/ahmed98/devops_training/Bash/Git_hub/Bash_script/ssl_check/list |egrep -v "[*# ,]|^$" >$URLs_list

#Write the date on logs file
echo -e "\n\n##########################\n$(date)\n##########################\n" >>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/ssl_check/url.log

#Looping over the file
while read -r url ;do

	#Get the expiration date
	exp_date=$(echo | openssl s_client -servername "$url" -connect "$url":443 2>/dev/null | openssl x509 -noout -dates | grep "notAfter" | cut -d= -f2)

	#calculating how many days for expiration
	exp_date_seconds=$(date -d "$exp_date" "+%s")
	current_date_seconds=$(date "+%s")
	days_left=$(( (exp_date_seconds - current_date_seconds) / 86400 ))

	#Sent to slack and logs file if the expiration date less than 30 days
	if [[ $days_left -lt "30" &&  $days_left -gt "1" ]]; then
		message="your SSL certificate for URL "$url" will expire in $days_left days"
		echo -e "$message">>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/ssl_check/url.log
		curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$message\"}" "$Webhook_url"
	fi
done<$URLs_list
