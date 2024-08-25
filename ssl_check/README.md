# SSL Certificate Expiration Checker

## Overview

This script is designed to check the expiration dates of SSL certificates for a list of URLs provided in a text file. If any certificates are found to be expiring within 30 days, the script will send a notification to a specified Slack channel.

## Features

- **URL List Input**: Reads a list of URLs from a text file.
- **SSL Certificate Check**: Verifies the SSL certificate expiration date for each URL.
- **Slack Notification**: Automatically sends a notification to a Slack channel if any certificates are expiring within 30 days.
