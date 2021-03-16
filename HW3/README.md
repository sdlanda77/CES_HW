# Going Wireless: Wifi-controlled Self Cooling Frozen Drink Glass
Homework from Creative Embedded Systems, Spring 2021

This repository contains the code to be uploaded to an ESP32 for a Wifi-controled frozen drink glass that keeps the drink cooler on a warm day.
# Materials
- ESP32 (with Wifi capabilities)
- Two of each
  - Relay
  - NPN transistor
  - 1kOhm resistor
- Peltier junction
- Heat sink
- 12v fan
- Neck of glass (STL in github)
- Bowl holder of glass (STL is github)
- Metal bowl (I used a dog food bowl)
- Breadboard
- Jumper wires
- Two 9v batteries

# Technical Design

To cool the glass I used a Peltier junction, attaching the cold side to the metal bowl. To prevent the Peltier junction from overheating, I used a heat sink attached to a 12V DC fan. In my code, when the glass is turned on, the Peltier junction is turned on for one second and then the fan runs for 10 seconds, supplying blasts of cold to the metal bowl, and then gradually dissipating the heat on the opposite side of the junction. To do this, I used the relay included in our ESP32 starter kit which I set up based on chapter 17 with a 1kOhm resistor and NPN transistor. (I don't completely understand the workings behind this, but this allows for a GPIO pin to control the coil that controls the relay by drawing from the 5V power supply. I believe this is necessary because the relay coil requires 5V, but I just followed the ESP32 tutorial in chapter 17 to set this up.) This relay dictated whether the Peltier or the fan was on at a given time, allowing me to alternate. I used an additionaly relay to control the state of the entire thing. This relay was controlled in a similar way (using a GPIO pin, transistor, and resistor) and connects a 9V battery to the relay controlling the fan/Peltier when turned on. In other words, one relay was used to toggle between on/off by connecting and disconnecting the 9v and the other was used to toggle between fan/peltier whenever the glass was turned on.

To control the glass, the ESP32 is in station mode and a phone/computer/tablet can connect to the ESP's Wifi server. I used code found here to format HTML text so that a simple button is displayed when the correct IP is pointed to. While the glass is directly controlled by this virtual button, the "unseen effect" is at play in that the glass is not immediately cooled and there is no direct indication that the glass is working (unless it is disassembled and you look to see if the fan starts moving). Additionally, the Peltier/fan continue to toggle on and off independently anytime the glass is turned on, without any action from the user.
