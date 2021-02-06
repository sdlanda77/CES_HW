from time import sleep
import board
import neopixel
import requests
pixels = neopixel.NeoPixel(board.D18,8)
i = 0

URL = "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?date=latest&station=8594900&product=wind&datum=MTL&units=metric&time_zone=lst&application=ports_screen&format=json"



while True:
    r = requests.get(url = URL)
    data = r.json()

    direction = data['data'][0]['d']
    speed = data['data'][0]['s']
    s = float(speed)
    direction = float(direction)
    print(direction)
    print(speed)
    if s > 10:
        dim = 1
    else:
        dim = s/10

    print(dim)
    if (direction < 22) or (direction > 337):
        # North
        pixels[4] = (255*dim, 255*dim, 255*dim) 
    elif (direction < 67):
        # NE
        pixels[5] = (255*dim, 255*dim, 255*dim)
    elif (direction < 112):
        # E
        pixels[6] = (255*dim, 255*dim, 255*dim)
    elif (direction < 157):
        # SE
        pixels[7] = (255*dim, 255*dim, 255*dim)
    elif (direction < 202):
        # S 
        pixels[0] = (255*dim, 255*dim, 255*dim)
    elif (direction < 247):
        # SW 
        pixels[1] = (255*dim, 255*dim, 255*dim)
    elif (direction < 292):
        # W 
        pixels[2] = (255*dim, 255*dim, 255*dim)
    elif (direction < 337):
        # NW
        pixels[3] = (255*dim, 255*dim, 255*dim)
    sleep(60)
  
