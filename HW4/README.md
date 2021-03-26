# Kinetic Sculpture: Does anyone have an umbrella? 
Homework from Creative Embedded Systems, Spring 2021

This repository contains the code to be uploaded to a Raspberry Pi for a fountain machine.
# Materials
- Raspberry Pi (4)
- Two of each
  - Bottles
  - Pouring spouts
  - Solenoid valve
  - Relays
  - 1kOhm resistor
  - NPN transistor
- Tubing (1/4 inch)
- Button
- Scrap wood, screws, drill (for structure)
- Breadboard
- Jumper wires
- 12V DC plug

# Technical Design

The code for this projet is straightforward. When the API call returns true and the button is pressed, the solenoid valves open alternatively. They continue to alternate two second pours until either the button is releases or the API returns false. Simply download control.py onto your Raspberry Pi and run it, making sure that the API call is to the correct IP and port. The API call can be removed and should_i_run set to true to be able to run the device with the button as the only input.
