# Interactive Device: Interactive Photobooth
Homework from Creative Embedded Systems, Spring 2021

This repository contains the code to set up a interactive art installation that can be used to control and create projections to be projected onto performing artists or photo and video shoots.

# Materials
- Raspberry Pi (I used a Raspberry Pi 4, but other models may work.)
- Power supply for Raspberry Pi
- ESP32 wrover dev kit
- Breadboard and wires
- Projector and HDMI cord
- Analog Joystick
- 2 push buttons
- SDST switch

# Visualization
The visualization for this project is a Processing sketch. It can be run on the Raspberry Pi to start the interactive device. 

# Configuration
Make sure that the pins used to connect the sensors to the esp32 match the ones specified in the "HW2_ESP.ino" arduino code. You may need to press and hold reset on the ESP32 to start serial communication once the esp is connected to the raspberry pi.
