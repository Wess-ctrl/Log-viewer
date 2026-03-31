#!/usr/bin/env bash

declare -A alerted #Declaro el array asociativo para utilizarlo después, esto le dice a Bash que alerted se va a comportar como un array asociativo

#Programo el envio de notificaciones a través de ntfy al móvil
NTFY_URL=http://100.76.160.83:9459/log_manager

#El modo de usar esta funcion es: notificar (valor actual) (valor máximo) (titulo) (mensaje)
ntfy_func () {
	local actual_value=$1
	local limit=$2
	local title=$3
	local message=$4
	local key="alert_${title//[^a-zA-Z0-9]/_}"

	if [[ $actual_value -ge $limit ]]; then
		if [[ ! -v alerted["$key"] ]]; then #! indica negación y -v existencia (por lo menos en variables), esto dice que si no existe la variable key dentro del array "alerted" entonces se envie la notificacion
			curl -H "Title: $title" -H "Priority: 5" -d "$message (Valor: $actual_value)" $NTFY_URL
			alerted["$key"]=1 #Se introduce la variable "key" decntro del array "alerted" y se le asigna un valor
		fi
	elif [[ -v alerted["$key"] ]]; then #Si existe la variable "key" dentro del array "alerted" entonces se elimina la key del array.
			unset alerted["$key"] #"unset" sirve para eliminar keys dentro de arrays asociativos
		fi
	fi
}

#Aquí se recogen las variables de la temperatura del procesador, el uso de memoria RAM, el % de almacenamiento en el disco, los inicios de sesión fallidos al entrar por ssh y el % de uso del procesador.
while true; do

	Temperature_wd=$(sensors | awk '/Core/ { temp += $3; cont++ } END { print temp / cont }' | tr -d '+ºC')
	Temperature=${Temperature_wd%[.,]*}

	RAM=$(free -m | awk '/Mem:/ { print $3 }') # Se obtiene solo el uso de memoria RAM en Mb.

	CPU=$(top -b -n1 | grep "Cpu(s)" | awk -F ',' '{ print $1+$3 }')
	#Variable de CPU without decimals
	CPU_whd=${CPU%.*}

	Disk=$(df -h --output=target,pcent /home | awk '/home/ { gsub("%", ""); print $2 }')

	SSH_fail=$(journalctl -u ssh --since "5 minutes ago" 2>/dev/null | grep -c "Failed password")

	ram50=$(free -m | grep "Mem:" | awk '{ print $2 * 0.5 }')
	ram80=$(free -m | grep "Mem:" | awk '{ print $2 * 0.8 }')

	ram5=${ram50%[.,]*}
	ram8=${ram80%[.,]*}

    #Notifications
	ntfy_func $Temperature 60 "¡Temperatura elevada!" "La temperatura a superado el umbral establecido en padlab."
	ntfy_func $RAM $ram8 "Saturación de la RAM" "El uso de la memoria RAM es excesivo."
	ntfy_func $CPU_whd 80 "Sobrecarga de CPU" "El uso de CPU es demasiado elevado, se recomienda tomar medidas."
	ntfy_func $Disk 85 "Poco espacio de almacenamiento" "El almacenamiento ha llegado a su umbral de alerta."
    ntfy_func $SSH_fail 1 "Intento de intrusión SSH" "Se han registrado fallos de login, se requieren medidas inmediatas."

sleep 5
done