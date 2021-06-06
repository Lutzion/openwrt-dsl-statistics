# openwrt-dsl-statistics #
As i got some trouble with my dsl connection one of the possible solutions was to change the router.   
I got an old AVM 3370 with old firmware. So i decided to flash this one with the newest OpenWRT firmware and get perfect statistics with [luci-statistics](https://openwrt.org/docs/guide-user/luci/luci_app_statistics).   
   
Installation of `collectd+rrdtool` was no problem and soon I got statistics for 
- interfaces
- system load
- memory
and so on.   
   
## The problem ##
But all code samples that are readily available for dsl-statistics did not work.   
This [article](https://forum.openwrt.org/t/openwrt-21-02-dsl-control/89962/23) in the openwrt-forum explains why. There have been several changes in openwrt.   
- `(v)dsl_cpe_control`   
does not exist anymore.   

Furthermore the statistics output of 
`dsl_control dslstat` has an json output different to the outputs before.   

Additionally the `collect-mod-exec` module, which allows to call user defined scripts, does not allow root access, which is neccessary to call `dsl_control dslstat`.   

## The solution ##
### Cronjob to get json data ###
The entry    
`* * * * * /etc/init.d/dsl_control dslstat > /tmp/dslstat.txt`   
in **Scheduled Tasks** writes the json output to ram (actually file `/tmp/dslstat.txt`). Also it might be needed to restart the cron service.   
   
### Filling the rrd database ### 
The script `dsl_stats.sh`, that is called by the module `collect-mod-exec`, decodes the json format of the data using the library `/usr/share/libubox/jshn.sh`.   
   
You can save the script wherever you want, but better not in folders that do not survive a reboot.
I mounted a usb-stick to also keep my statistics data there. That is also my place for the script. 
Also do not forget to give it execution permissions and make it accessable by nobody:nogroup
`chmod 777 dsl_stats.sh`
`chmod +x dsl_stats.sh`   
  
   
### Creating the graphs ###
As the systems does not know how to present data of user defined scripts, the javascript `exec.js` has to do that.   
This script must be saved in the folder `/www/luci-static/resources/statistics/rrdtool/definitions/`.   
**ATTENTION**: If there is already a script `exec.js` you should not override it, but add the code.   

A look at my first data:
![dsl-statistics](./assets/dslstatistics.png)   
and the data after first reconnect with errors.   
![dsl-statistics-1day](./assets/dslstatistics_1day.png)   

There is even much more data in the json file.   
I tried, to find out, which are important for analysing errors.   
If I forgot essentials, let me know.
