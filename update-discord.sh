#!/bin/bash

DISCORD_PATH="Discord"
DISCORD_LINUX_DOWNLOAD_URL="https://discord.com/api/download?platform=linux&format=tar.gz"
DISCORD_TEMP_FILE="/tmp/discord.tmp.tar.gz"

force_update=false
check_only=false
while getopts d:cf flag
do
	case "${flag}" in
		d) DISCORD_PATH=${OPTARG};;
		c) check_only=true;;
		f) force_update=true;;
	esac
done

if $force_update && [ ! -d $DISCORD_PATH ]
then
	echo "[+] Force update mode: Creating folder: $DISCORD_PATH"	
	mkdir "$DISCORD_PATH"
fi

if [ -d $DISCORD_PATH ]
then
	echo "[+] Discord installation folder found"
else
	echo "[-] ERROR: Discord installation not found: $DISCORD_PATH"
	exit 1
fi

if ! $force_update
then
	local_version=$(jq '.version' $DISCORD_PATH/resources/build_info.json | tr -d '"')

	remote_version=$(curl -s -I "$DISCORD_LINUX_DOWNLOAD_URL" | grep "location:" | grep -oP "/\d+\.\d+\.\d+/" | tr -d '/')

	if [[ "$local_version" == "$remote_version" ]]
	then
		echo "[+] Version $local_version is up to date. Exiting."
		exit 0
	fi
fi

if $check_only
then
	echo "[+] Local is not the current version (Local: $local_version x Remote: $remote_version). Check only. Exiting."
	exit 0
else
	echo "[+] Local is not the current version. Updating to version: $remote_version."
fi

echo "[+] Downloading package"
wget -q "$DISCORD_LINUX_DOWNLOAD_URL" -O "$DISCORD_TEMP_FILE" 

echo "[+] Deleting old discord folder"
rm -r $DISCORD_PATH/

echo "[+] Creating new discord folder"
mkdir "$DISCORD_PATH"

echo "[+] Extracting package"
tar -xzf "$DISCORD_TEMP_FILE" --strip-components=1 -C "$DISCORD_PATH" 

echo "[+] Deleting downloaded package"
rm "$DISCORD_TEMP_FILE"

echo "[+] Done"
