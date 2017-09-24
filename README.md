
<img src="https://github.com/sleepdefic1t/ark-nbx/blob/master/ark_nbx_logo.png" width="350">  

#### "Keep what matters, ***where*** it matters the most."  

-----

### What is ArkBox

ArkBox is an network box for communication and sharing files.  
Designed for security, it is inspired by the spirit of pirate radio,  
early hackers (Stallman, Draper, Gosper, Woz, etc),  
and--(per [*levy*](http://www.stevenlevy.com/))--the  **Hacker Ethic**  
1. Access to computers—and anything which might teach you something about the way the world works—should be unlimited and total. Always yield to the Hands-on Imperative!
2. All information should be free.
3. Mistrust authority—promote decentralization.
4. Hackers should be judged by their hacking, not bogus criteria such as degrees, age, race or position.
5. You can create art and beauty on a computer.
6. Computers can change your life for the better.  

Based on [**PirateBox**](https://piratebox.cc/) by [**David Darts**](https://daviddarts.com/), 
ArkBox is a FOSS project, GPL3 compatible and MIT Licensed.

-----

### Screenshot  

Address: **arkbox.lan**  

<img src="https://github.com/sleepdefic1t/ark-nbx/blob/master/screenshot.png" width="500">  

**Welcome Aboard!**  

-----

# Wiring  
## Raspberry Pi-Only:  

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
- Use [**Etcher**](https://etcher.io) or your favorite method to copy Raspbian to a micro-sd card.  
- Make sure you are sharing/bridging your internet connection via usb-cable with your RPi.
- Installation will take about 10-minutes.

Or just unzip and use [**arkbox-vx.x.x.img**](https://github.com/sleepdefic1t/ark-nbx/releases/download/v0.8.1/arkbox_v0.8.1.img.zip) provided in [**/releases**](https://github.com/sleepdefic1t/ark-nbx/releases)

# Requirements
- For non-Zero W Pi's, you will need a [**compatible**](http://elinux.org/RPi_USB_Wi-Fi_Adapters) USB-WiFi adapter.
- If installing from Raspbian or another RPi distro, you will need Git to clone this repo.  
  ```sudo apt-get install git```

# Installation:   

1. Connect to your RPi in "headless" or SSH mode.  
- if using Raspbian Stretch Lite  
``` ssh pi@raspberrypi.local```  
default password is: ```raspberry```  
**Be sure to change this afterwards.**  


- if using [**arkbox-vx.x.x.img**](https://github.com/sleepdefic1t/ark-nbx/releases/download/v0.8.1/arkbox_v0.8.1.img.zip) from [**/releases**](https://github.com/sleepdefic1t/ark-nbx/releases).   
```ssh ark@arkbox.local```  
default password is: ```arkbox```  
**Be sure to change this afterwards.**  
- Wifi Network: ```ArkBox - Welcome Aboard!```  
- (Stop at step 2 **Expanding Your Filesystem**.  
  No further install steps needed!)
-----

2. Expand your filesystem to use your whole microSD card:  
```sudo raspi-config```  
**Option 7: Advanced Options**  
**Option A1: Expand Filesystem**  
- Reboot when prompted,  
or manually via ```sudo reboot```

-----

3. Clone this repo & 'cd' into it:  
```git clone https://github.com/sleepdefic1t/ark-nbx```  
```cd ark-nbx```

-----

4. Change permissions of the "arkbox" folder:  
```sudo chmod -R 775 arkbox```  

-----

5. 'cd' to 'arkbox' and run the install.sh file:  
```cd arkbox```  
```sudo ./install.sh```  

-----

6. Wait about 1-minute after the install script finishes, then:   
```sudo shutdown now```  

-----

7. Plug your RPi into a power source (ex: micro-usb power port).
- **Your ArkBox will power on,  
and the WiFi network "ArkBox - Welcome Aboard!" will be visible.**  
- First boot can take 3-5 minutes depending on hardware(microSD speed, Pi-model, etc).

-----

8. Using a standard web-browser, navigate to:  
```arkbox.lan```  
**Welcome Aboard!**  

-----

## Troubleshooting:

### **'ArkBox - Welcome Aboard!' WiFi network not showing up.**  
There are many errors that can cause this.
Try running ```sudo ./install.sh``` again.  
Using another micro-usb cable or a 'class 10' microSD card can usually fix this as well.  

-----

### The Wifi signal drops/disappears every time I connect!
This is usually caused by not getting enough power(mAh/Ah).
Make sure to use a 5V >=1,000mAh/1Ah power supply. 2Ah or better if using NFC or additional hardware.
If your power source meets those requirements, try another power source or USB-cable.

-----

### **'Broken Pipe' / Timeout / Disconnect Errors**  
If for any reason your RPi's connection fails/freezes during installation,  
Reconnect to your Pi, then run:  
```sudo dpkg --configure -a```  
You should then return to Step 5,  
'cd' into 'arkbox' then,  
 ```sudo ./install.sh```  
to finish installation.

-----

### **The ArkBox time/date appears to be incorrect**
This is correct, it is a security measure.

#

## ToDo:

- [x] Improve Install/Uninstall Scripts
- [x] Optimize File Structure
- [x] Integrated RPi img.
- [ ] Implement Configuration Portal
- [ ] XPoint Integration
- [ ] Add mesh/network/node connectivity
- [ ] Implement IMS/WMS
- [ ] Optimize Message/Discussion Board  
- [ ] Documention!

#

### Tip Jar   
**ѦRK [Ѧ]:** ```AZreeHxX23s4jttL3ML8n6A2aLrwHPfVGZ```  
**DѦRK [DѦ]:** ```DHQ4Fjsyiop3qBR4otAjAu6cBHkgRELqGA```  
