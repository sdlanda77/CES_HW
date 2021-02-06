# Generative Art: Tides By Your Side
Homework from Creative Embedded Systems, Spring 2021

This repository contains the code to set up a generative art installation based off of the tides and wind at a specified location. Currently, the location is set to Washington, DC, on the Potomac River. Two scripts are included, one in python and the other in JavaScript using the p5.js library. 

A video of the project can be found here:

# Materials
- Raspberry Pi (I used a Raspberry Pi 4, but other models may work.)
- Power supply for Raspberry Pi
- Monitor and HDMI cord (I used one that was approximately 7in x 5in.)
- Circular 8 RGB LED module
- Three female to female wires

# API
This generative art uses data from the [National Oceanic and Athmospheric Administration's Tides and Current Map](https://tidesandcurrents.noaa.gov/). Documentation on the API can be found [here](https://api.tidesandcurrents.noaa.gov/api/prod/)

# Visualization
The visualization for this project must be run from a desktop or laptop. It can be started via the Processing IDE and can be run in any browser. The browser on the Raspberry Pi will mirror this by pointing it to the IP address and port number associated with the visualization on the desktop or laptop.

# Configuration
For the code to run on boot of the Raspberry Pi, it is necessary to add some code to two pre-existing files. In the command line, type `sudo vi /etc/rc.local` and add the following line of code to the bottom of the file, before `exit 0`: `sudo python3 /home/pi/Desktop/LED/lighthouse.py`. This is assuming that the python script is in a folder called LED on the Desktop. If your script is located in another place, make sure to change the path accordingly. 

Next, type `sudo vi /etc/xdg/lxsession/LXDE-pi/autostart` and add the following line to the end of the file: `@chromium-browser --kiosk <IP>:<PortNumber>`. IP should be the IP address of the computer on which the visual is running, and PortNumber should is the associated port number. These can be found by looking in the address bar of the browser on your computer.

