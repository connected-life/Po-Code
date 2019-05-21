# Po-Code

the portable remotely communication device to A.V.A. by M2M sim and GSM module.

<br>

#### Supported Environments

|                         |                                         |
|-------------------------|-----------------------------------------|
| **Operating systems**   | Linux                                   |
| **Python versions**     | Python 3.x (64-bit)                     |
| **Distros**             | Raspbian                                |
| **Package managers**    | APT, pip                                |
| **Languages**           | English                                 |
|                         |                                         |

### Requirements

##### Hardware
  
- Raspberry Pi zero, zero w
- Raspberry Pi compatible GSM/GPRS module/shield. ([this product](https://sixfab.com/product/gsmgprs-shield/) is used.)
- Headphones (wireless optional)
- 18650 Li-on battery
- Battery charger/supplier

##### Software

- Raspbian Stretch OS
- Embedded-A.V.A.


### Installation

#### Configuration of GSM Module

- Follow [the installation](https://sixfab.com/ppp-installer-for-sixfab-shield/) article for [this product](https://sixfab.com/product/gsmgprs-shield/).

#### Configuration of Bluetooth Headphone (optional)

- Update and Upgrade the packages:
```Shell
sudo apt-get update
sudo apt-get upgrade
sudo reboot
```
- PulseAudio 
    - PulseAudio in the repository has now native support of both A2DP and HSP. So PulseAudio is used. 
    But With Raspbian Stretch, it is no more installed by default. Bluez-alsa using in Stretch instead.
    
Then install PulseAudio Packages:
```Shell
sudo apt-get install pulseaudio pulseaudio-module-bluetooth
dpkg -l pulseaudio pulseaudio-module-bluetooth
```

- Bluetooth Connection (optional and its provided via pi zero w)
Use Bluetoothctl tool. It is installed by default in Raspbian:
```Shell
bluetoothctl

power on
agent on
default-agent
```
Make sure headset pair mode active, then:
```Shell
scan on
```
Some seconds later, headsets's MAC address will appear. Like "xx:xx:xx:xx:xx:xx".
Record the MAC address somewhere then kill the Bluealsa and start PulseAudio:
```Shell
sudo killall bluealsa
pulseaudio --start
```
Return to Bluetoothctl and:
```Shell
pair xx:xx:xx:xx:xx:xx
trust xx:xx:xx:xx:xx:xx
connect xx:xx:xx:xx:xx:xx
```
Device connection should be successful with the above step. 
Now let's solve A2DP and HSP supports. First A2DP:
```Shell
pacmd list-cards
pacmd set-card-profile bluez_card.xx_xx_xx_xx_xx_xx a2dp_sink
pacmd set-default-sink bluez_sink.xx_xx_xx_xx_xx_xx.a2dp_sink
```
And for HSP support:

To correcting the incorrect audio routing:
```Shell
sudo hcitool cmd 0x3F 0x01C 0x01 0x02 0x00 0x01 0x01
```
```Shell
pacmd set-card-profile bluez_card.xx_xx_xx_xx_xx_xx headset_head_unit
pacmd set-default-sink bluez_sink.xx_xx_xx_xx_xx_xx.headset_head_unit
pacmd set-default-source bluez_source.xx_xx_xx_xx_xx_xx.headset_head_unit
```
After all preparation, for automatically complete the connection at each boot, 
clone the GitHub repo and edit specific parts of `bluetooth_auto.sh`. 
Then copy the `bluetooth_auto.service` file under `/lib/systemd/system/`. (Edit the `ExecStart=/PATHtoFile/Po-Code/bluetooth_auto.sh` line.)
At last:
```shell
sudo chmod 644 /lib/systemd/system/bluetooth_auto.service
sudo systemctl daemon-reload
sudo systemctl enable bluetooth_auto.service
sudo reboot
```
note: Just one time, run `./PATHtoFile/Po-Code/bluetooth_auto.sh` command.

<sup><i>if there is any trouble during installation look at [that article](http://youness.net/raspberry-pi/how-to-connect-bluetooth-headset-or-speaker-to-raspberry-pi-3).</i></sup>

#### Running Software

- Clone the [Embedded-A.V.A.](https://github.com/connected-life/Embedded-A.V.A.)'s repository and install it like explained in there.

<br>

**Supported Distributions:** Raspbian. This release is fully supported. Any other Debian based ARM architecture distributions are partially supported.
