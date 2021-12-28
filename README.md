This a simple POSIX compliant shell script that shows the current download and upload
bandwidth of a network interface on Linux. It relies on `ip` to get RX and TX bytes
instead of reading `/proc/net/dev` so that the script can run on Android without root privileges.

![](linux_netspeed.gif)

Downloading and running instructions:
```sh
# cd into the directory you want the script to be downloaded in and then run:
curl -Os 'https://raw.githubusercontent.com/Aptrug/linux_netspeed/master/linux_netspeed.sh'

# In order to run the script, it has to be executable, for that you have to run:
chmod +x ./linux_netspeed.sh

# You can now run the script. Pressing CTRL-C will stop it.
./linux_netspeed.sh
```
