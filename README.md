
<img src="https://github.com/sleepdefic1t/ark-nbx/blob/master/ark_nbx_logo.png" width="350">  

#### "Keep what matters, ***where*** it matters the most."  

-----

Address: **arkbox.lan**  
<img src="https://github.com/sleepdefic1t/ark-nbx/blob/master/screenshot.png" width="500">  
**Welcome Aboard!**  

-----

# Wiring  
## RPi-Only Wiring:  

<img src="https://github.com/sleepdefic1t/ark-nbx/blob/master/rpizw.png" width="300">


|    Part     |   Source    |
| :---------: | :---------: |
|Raspberry Pi Zero W | https://www.adafruit.com/product/3400 |  


## NFC Wiring:  

<img src="https://github.com/sleepdefic1t/ark-nbx/blob/master/pn532_rpizw_spi.png" width="500">


|  SPI Wiring  |    Parts    |
| :----------: | :---------: |
|<table> <tr><th>Wire</th><th>Color</th></tr><tr><td>3.3V</td><td>Red</td></tr> <tr><td>GND</td><td>Black</td></tr> <tr><td>-----</td><td>-----</td></tr> <tr><td>SCK</td><td>Orange</td></tr> <tr><td>MISO</td><td>Blue</td></tr> <tr><td>MOSI</td><td>Green</td></tr> </table> | <table> <tr><th>Part</th><th>Source</th></tr> <tr><td>PN532 NFC</td><td>https://www.adafruit.com/product/364</td></tr> <tr><td>Raspberry Pi Zero W</td><td>https://www.adafruit.com/product/3400</td></tr> </table> | 



# Preparation

- Download **RASPBIAN STRETCH LITE** from https://www.raspberrypi.org/downloads/raspbian/
- Or use the 'arkbox-core.img' provided in this repo
- Use [**Etcher**](https://etcher.io) or your favorite method to copy Raspbian to a micro-sd card.  
- Make sure you are sharing/bridging your internet connection via usb-cable with your RPi.
- Installation will take about 10-minutes.

# Installation:   

1. Connect to your RPi in "headless" or SSH mode.  
- if using Raspbian Stretch Lite  
``` ssh pi@raspberrypi.local```  
default password is: ```raspberry```  
**Be sure to change this afterwards.**  


- if using 'arkbox-core.img'  
```ssh ark@arkbox.local```  
default password is: ```arkbox```   
**Be sure to change this afterwards.**  

-----

2. Update your RPi:    
```sudo apt-get update```

-----

3. Expand your filesystem to use your whole microSD card:  
```sudo raspi-config```  
**Option 7: Advanced Options**  
**Option A1: Expand Filesystem**  
- Reboot when prompted,  
or manually via ```sudo reboot```

-----

4. Clone this repo & 'cd' into it:  
```git clone https://github.com/sleepdefic1t/ark-nbx```  
```cd ark-nbx```

-----

5. Change permissions of the "arkbox" folder:  
```sudo chmod -R 775 arkbox```  

-----

6. 'cd' to 'arkbox' and run the install.sh file:  
```cd arkbox```  
```sudo ./install.sh```  
- **Select 'Y/Yes' at each prompt to install and configure dependencies.**

-----

7. Wait about 1-minute after the install script finishes, then:   
```sudo reboot```  

-----

8. Reconnect via SSH to your RPi after it powers back on,    
wait an additional 1-2 minutes for configuration to complete, then:  
```sudo shutdown now```  
- **After the green LED on your RPi stops flashing (~5-seconds),  
it will power off.**

-----

9. Plug your RPi into a power source (ex: micro-usb power port).
- **Your ArkBox will power on,  
and the WiFi network "ArkBox - Welcome Aboard!" will be visible.**  

-----

10. Using a standard web-browser, navigate to:  
'''arkbox.lan'''  
**Welcome Aboard!**  

-----

## Troubleshooting:

### **'Broken Pipe' / Timeout / Disconnect Errors**  
If for any reason your RPi's connection fails/freezes during installation,  
Reconnect to your Pi, then run:  
```sudo dpkg --configure -a```  
You should then return to Step 5,  
'cd' into 'arkbox' then,  
 ```sudo ./install.sh```  
to finish installation.

-----

### **'ArkBox - Welcome Aboard!' Wifi network not showing up.**  
There are many errors that can cause this,
running ``sudo ./install.sh``` again,  
or trying another micro-usb cable or a 'class 10' microSD card  
will usually fix this.  

-----

### **The ArkBox time/date appears to be incorrect**
This is correct, it is a security measure.

#
