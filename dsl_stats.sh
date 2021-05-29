#!/bin/sh
##
##  Copyright Lutz Hillebrand
##  feel free to use for personal use
## 
# source jshn shell library
. /usr/share/libubox/jshn.sh

# generating json data
json_init

HOST=$COLLECTD_HOSTNAME
INTERVAL=$COLLECTD_INTERVAL

[ -z "$INTERVAL" ] && INTERVAL=60
INTERVAL=$(awk -v i=$INTERVAL 'BEGIN{print int(i)}')

while sleep $INTERVAL; do
  ## Status aus Datei laden, direkte Befehlsausfuehrung wg. erforderlichem root nicht moeglich
  #json_load "$(/etc/init.d/dsl_control dslstat)"
  json_load_file /tmp/dslstat.txt
  
  ## Uptime
  json_get_var upt uptime
  
  ## upstream
  json_select upstream
  json_get_var up_adr attndr
  json_get_var up_dr  data_rate
  json_get_var up_snr snr

  ## downstream
  json_select
  json_select downstream
  json_get_var dn_adr attndr
  json_get_var dn_dr  data_rate
  json_get_var dn_snr snr
  
  ## errors
  json_select
  json_select errors
  json_select near
  json_get_var en_loss loss
  json_get_var en_uas uas
  json_get_var en_crc crc_p
  json_get_var en_crcp crcp_p

  json_select ..
  ##json_select errors
  json_select far
  json_get_var ef_loss loss
  json_get_var ef_uas uas
  json_get_var ef_crc crc_p
  json_get_var ef_crcp crcp_p

  ## alles in Variablen / RRD fuer Grafik
  #echo "UP:   $up"
  # uptime
  echo "PUTVAL \"$HOST/exec-dsluptime/gauge\" interval=$INTERVAL N:$upt"
  echo "PUTVAL \"$HOST/exec-dsluptime/counter\" interval=$INTERVAL N:$upt"

  # up und downstream datarate
  echo "PUTVAL \"$HOST/exec-dsldr/gauge-updr\" interval=$INTERVAL N:$up_dr"
  echo "PUTVAL \"$HOST/exec-dsldr/gauge-downdr\" interval=$INTERVAL N:$dn_dr"
  echo "PUTVAL \"$HOST/exec-dsldr/gauge-upadr\" interval=$INTERVAL N:$up_adr"
  echo "PUTVAL \"$HOST/exec-dsldr/gauge-downadr\" interval=$INTERVAL N:$dn_adr"

  # up und downstream snr
  echo "PUTVAL \"$HOST/exec-dslsnr/gauge-up\" interval=$INTERVAL N:$up_snr"
  echo "PUTVAL \"$HOST/exec-dslsnr/gauge-down\" interval=$INTERVAL N:$dn_snr"

  # errors
  echo "PUTVAL \"$HOST/exec-dslerr/gauge-loss\" interval=$INTERVAL N:$en_loss"
  echo "PUTVAL \"$HOST/exec-dslerr/gauge-uas\" interval=$INTERVAL N:$en_uas"
  echo "PUTVAL \"$HOST/exec-dslerr/gauge-f_loss\" interval=$INTERVAL N:$ef_loss"
  echo "PUTVAL \"$HOST/exec-dslerr/gauge-f_uas\" interval=$INTERVAL N:$ef_uas"

  echo "PUTVAL \"$HOST/exec-dslcrc/gauge-crc\" interval=$INTERVAL N:$en_crc"
  echo "PUTVAL \"$HOST/exec-dslcrc/gauge-crcp\" interval=$INTERVAL N:$en_crcp"
  echo "PUTVAL \"$HOST/exec-dslcrc/gauge-f_crc\" interval=$INTERVAL N:$ef_crc"
  echo "PUTVAL \"$HOST/exec-dslcrc/gauge-f_crcp\" interval=$INTERVAL N:$ef_crcp"
done
