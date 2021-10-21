#!/bin/bash

cp /home/joshua/dotfiles/powershell/Cisco.ps1 /mnt/c/Users/josno/Cisco.ps1
/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0//powershell.exe 'C:\Users\josno\Cisco.ps1'

# Taken from https://community.cisco.com/t5/vpn/anyconnect-wsl-2-windows-substem-for-linux/td-p/4179888

TMP=`mktemp`
trap ctrlC INT

removeTempFiles() {
	rm -f $TMP
}

ctrlC() {
	echo
	echo "Trapped Ctrl-C, removing temporary files"
	removeTempFiles
	stty sane
}

echo "Current resolv.conf"
echo "-------------------"
cat /etc/resolv.conf | tee /etc/resolv.conf.bak

echo
echo "Creating new resolv.conf"
echo "------------------------"

{
	head -1 /etc/resolv.conf | grep '^#.*generated'
	for i in `/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Get-DnsClientServerAddress -AddressFamily ipv4 | Select-Object -ExpandProperty ServerAddresses"`; do
		echo nameserver $i
	done
	tail -n+2 /etc/resolv.conf | grep -v '^nameserver'
} | tr -d '\r' | tee $TMP

# Removed -i flag from cp since I did not like the interactive step
(set -x; sudo cp $TMP /etc/resolv.conf)

removeTempFiles
