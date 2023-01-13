#!/bin/sh

echo "[+] Downloading package"
wget -q "https://discord.com/api/download?platform=linux&format=tar.gz" -O discord.tmp.tar.gz
echo "[+] Deleting old discord folder"
rm -rf Discord/
echo "[+] Extracting package"
tar -xzf discord.tmp.tar.gz
echo "[+] Deleting downloaded package"
rm discord.tmp.tar.gz
echo "[+] Done"
