#!/bin/sh

export LC_ALL=C

get_active_network_interface() {
	active_network_interface=${3}
}

get_rx_bytes_and_tx_bytes() {
	while read -r line; do
		case ${line} in
			*" ${active_network_interface}:"*)
				read -r line
				read -r line
				read -r line
				rx_bytes=${line%% *}
				read -r line
				read -r line
				tx_bytes=${line%% *}
				break
			;;
			*)
			;;
		esac
	done <<-EOF
	$(ip -s l)
	EOF
}

line=$(ip r)
get_active_network_interface ${line#*$'\n'}

[ -z ${active_network_interface} ] && exec echo 'No active network interface was detected'

get_rx_bytes_and_tx_bytes

previous_rx_bytes=${rx_bytes}
previous_tx_bytes=${tx_bytes}

trap 'keep_going=false' INT
keep_going=true

while ${keep_going}; do
	sleep 1

	get_rx_bytes_and_tx_bytes

	printf '\r\033[0KDOWN: %d KB/s | UP: %d KB/s'\
		$(((rx_bytes-previous_rx_bytes)>>10))\
		$(((tx_bytes-previous_tx_bytes)>>10))

	previous_rx_bytes=${rx_bytes}
	previous_tx_bytes=${tx_bytes}
done
echo
