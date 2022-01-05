#!/bin/sh -eu

export LC_ALL=C

trap 'exec echo' INT

get_active_network_interface() {
	local ip_output
	local ip_output_last_line
	while true; do
		ip_output=$(ip r)
		if [ -n "${ip_output}" ]; then
			ip_output_last_line=${ip_output##*$'\n'}
			set -- ${ip_output_last_line}
			active_network_interface=${3}
			break
		else
			previous_rx_bytes=0
			sleep 1
		fi
	done
}

get_rx_bytes_and_tx_bytes() {
	get_active_network_interface
	{
		local line
		read -r line
		read -r line
		read -r line
		read -r line
		rx_bytes=${line%% *}
		read -r line
		read -r line
		tx_bytes=${line%% *}
	} <<-EOF
	$(ip -0 -s a s ${active_network_interface})
	EOF
	if [ ${previous_rx_bytes} -eq 0 ]; then
		previous_rx_bytes=${rx_bytes}
		previous_tx_bytes=${tx_bytes}
	fi
}

previous_rx_bytes=0
get_rx_bytes_and_tx_bytes

if [ -t 0 ]; then
	# Interactive
	while true; do
		sleep 1

		get_rx_bytes_and_tx_bytes

		printf '\r\033[0KDOWN: %d KB/s | UP: %d KB/s'\
			$(((rx_bytes-previous_rx_bytes)>>10))\
			$(((tx_bytes-previous_tx_bytes)>>10))

		previous_rx_bytes=${rx_bytes}
		previous_tx_bytes=${tx_bytes}
	done
else
	# Scripted
	while true; do
		sleep 1

		get_rx_bytes_and_tx_bytes

		printf 'DOWN: %d KB/s | UP: %d KB/s\n'\
			$(((rx_bytes-previous_rx_bytes)>>10))\
			$(((tx_bytes-previous_tx_bytes)>>10))

		previous_rx_bytes=${rx_bytes}
		previous_tx_bytes=${tx_bytes}
	done
fi
# vim:noet
