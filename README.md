This a simple POSIX compliant shell script that shows the current download and upload
bandwidth of a network interface on Linux. It relies on `ip` to get RX and TX bytes
instead of reading `/proc/net/dev` so that the script can run on Android without root privileges.

Downloading:

	1. `cd` into the directory you want the script to be downloaded in.
	2. Run `curl -Os 'https://raw.githubusercontent.com/Aptrug/linux_netspeed/master/linux_netspeed.sh'`

Running:

	1. Make the script executable by running `chmod +x ./linux_netspeed.sh`
	2. Simply run `./linux_netspeed.sh`
	3. Press CTRL-C to stop the script
