#!/usr/bin/env bash

#Color variables in ANSI encoding
red="\033[31m"
yellow="\033[33m"
green="\033[32m"
NC="\033[0m"

#How it works: color_func (value) (value in yellow) (value in red)
color_func () {
	local parameter=$1
 	local warning=$2
 	local critical=$3

	if [ "$parameter" -ge "$warning" ]; then
 		echo -e "${yellow}${parameter}${NC}"
 	elif [ "$parameter" -ge "$critical" ]; then
		echo -e "${red}${parameter}${NC}"
	else 
		echo -e "${green}${parameter}${NC}"
	fi 

}

#Collected parameters
Temperature_wd=$(sensors | awk '/Core/ { temp += $3; cont++ } END { print temp / cont }' | tr -d '+ºC')
Temperature=${Temperature_wd%[.,]*}
#Hay que cambiar esto porque no en todos los sitemas sensors se comporta de la misma manera, y si llega a detectar que no hay cores habrá una división por 0 y todo será un desastre.

RAM=$(free -m | grep "Mem:" | awk '{ print $3 }') #RAM usage is collected only in MB

CPU=$(top -b -n1 | grep "Cpu(s)" | awk -F ',' '{ print $1+$3 }')
	
CPU_whd=${CPU%.*} #Variable of CPU without decimals

Disk=$(df -h --output=target,pcent /home | awk '/home/ { gsub("%", ""); print $2 }')

SSH_fail=$(journalctl -u ssh --since "5 minutes ago" 2>/dev/null | grep -c "Failed password")

ram50=$(free -m | grep "Mem:" | awk '{ print $3 * 0.5 }')
ram80=$(free -m | grep "Mem:" | awk '{ print $3 * 0.8 }')

ram5=${ram50%,*}
ram8=${ram80%,*}

#Variables that use the newly created function
temp=$(color_func $Temperature 50 80)
ram=$(color_func ${RAM} ${ram5} ${ram8})
cpu=$(color_func $CPU 50 80)
disk=$(color_func $Disk 50 70)
ssh_failed=$(color_func $SSH_fail 1 2)

#Sentinel log graphic monitor
echo -e "${yellow}──────────────────────────────────────────────────${NC}"
echo -e "${green} L O G  V I E W E R  ${NC}   |   $(date +'%H:%M:%S')"
echo -e "${yellow}──────────────────────────────────────────────────${NC}"

printf "  %-15s %b\n" "🌡️ TEMP:" "${temp} ºC"
printf "  %-15s %b\n" "📊 RAM:" "${RAM} Mb"
printf "  %-15s %b\n" "⚙️ CPU:" "${cpu} %"
printf "  %-15s %b\n" "💾 DISK:" "${disk} %"
printf "  %-15s %b\n" "🛡️ SSH FAIL:" "${ssh_failed} attempts"

echo -e "${yellow}──────────────────────────────────────────────────${NC}"
