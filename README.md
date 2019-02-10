# Projet - Dispositifs médicaux implantables et télémonitoring
An Arduino-based network with data displayed in a Java Processing client.

## Hardware used

- [Arduino MKR WiFi 1010](https://www.arduino.cc/en/Guide/MKRWiFi1010) 
- [ADAFRUIT Si7021](https://learn.adafruit.com/adafruit-si7021-temperature-plus-humidity-sensor/overview)

Also, UDP packages are expected to be received from other Arduino in the same LAN.

## Run the code

Compile and ```arduino/udpserver/udpserver.ino``` in the Arduino MKR WiFi 1010. 

Run ```processing/main/main.pde``` in a Processing client.

Make sure serial communication is working and keep it available to Processing. Select the correct COM port and connect through the graphical interface.

## Screenshots

Connecting to a COM port:

<img src="https://user-images.githubusercontent.com/25482726/52534689-fdc3bb80-2d44-11e9-91f3-c9bba2419a5a.png" width="45%"></img> <img src="https://user-images.githubusercontent.com/25482726/52534687-fd2b2500-2d44-11e9-9296-1cbad0e0e2cc.png" width="45%"></img> 

Working interface:

<img src="https://user-images.githubusercontent.com/25482726/52534688-fdc3bb80-2d44-11e9-949d-8dd33c6e6c65.png" width="90%"></img> 

## Arduino code diagram

<img src="https://user-images.githubusercontent.com/25482726/52534679-e7b5fb00-2d44-11e9-9516-6f3f32c04a08.png" width="90%"></img> 