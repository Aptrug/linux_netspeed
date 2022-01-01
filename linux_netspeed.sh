#!/bin/sh

export LC_ALL=C

get_active_network_interface() {
	readonly active_network_interface=${3}
}

get_rx_bytes_and_tx_bytes() {
	{
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
}

line=$(ip r)
# Get the last line of the output of `ip r`
get_active_network_interface ${line##*
}

[ -z ${active_network_interface} ] && exec echo 'No active network interface was detected.'

get_rx_bytes_and_tx_bytes

previous_rx_bytes=${rx_bytes}
previous_tx_bytes=${tx_bytes}

keep_going=true
trap 'keep_going=false' INT

if [ -t 0 ]; then
	# Interactive
	while ${keep_going}; do
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
	while ${keep_going}; do
		sleep 1

		get_rx_bytes_and_tx_bytes

		printf 'DOWN: %d KB/s | UP: %d KB/s\n'\
			$(((rx_bytes-previous_rx_bytes)>>10))\
			$(((tx_bytes-previous_tx_bytes)>>10))

		previous_rx_bytes=${rx_bytes}
		previous_tx_bytes=${tx_bytes}
	done
fi
echo
# vim:noet
