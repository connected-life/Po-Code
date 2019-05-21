#!/usr/bin/env bash

#Connect BT (Your bluetooth speaker or headset MAC address)
bluetoothctl << EOF
connect xx:xx:xx:xx:xx:xx
exit
EOF

sleep 10

#Kill Bluealsa
sudo killall bluealsa

#Start Pulseaudio
#pax11publish -r
pulseaudio --start

#Connect BT (Your bluetooth speaker or headset MAC address)
bluetoothctl << EOF
connect xx:xx:xx:xx:xx:xx
exit
EOF

sleep 5

# set up PulseAudio for A2DP support
pacmd set-card-profile bluez_card.xx_xx_xx_xx_xx_xx a2dp_sink
pacmd set-default-sink bluez_sink.xx_xx_xx_xx_xx_xx.a2dp_sink

sleep 2

# For HSP support
# Correct the incorrect audio routing of SCO.
sudo hcitool cmd 0x3F 0x01C 0x01 0x02 0x00 0x01 0x01

#Set up Pulseaudio (Your bluetooth speaker or headset MAC address)
pacmd set-card-profile bluez_card.xx_xx_xx_xx_xx_xx headset_head_unit
pacmd set-default-sink bluez_sink.xx_xx_xx_xx_xx_xx.headset_head_unit
pacmd set-default-source bluez_source.xx_xx_xx_xx_xx_xx.headset_head_unit

exit 0
