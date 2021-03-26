from gpiozero import Button
from gpiozero import LED
from time import sleep
from signal import pause

button = Button(3)
power = LED(17)
choice = LED(27)

def pour():
        choice.on()
        sleep(2)
        choice.off()
        sleep(2)

while True:
        should_i_run = requests.get('http://165.227.76.232:3000/sdl2141/running')
	if should_i_run.json() and button.is_pressed:
		power.on()
                pour()
                power.off()
	else:
		power.off()
