#include <WebServer.h>
#include <WiFi.h>
//#include <WiFiUdp.h>
// https://lastminuteengineers.com/creating-esp32-web-server-arduino-ide/
// the IP of the machine to which you send msgs - this should be the correct IP in most cases (see note in python code)
//#define CONSOLE_IP "192.168.1.2"
//#define CONSOLE_PORT 4210
const char* ssid = "ESP32";
const char* password = "12345678";

IPAddress local_ip(192, 168, 1, 1);
IPAddress gateway(192, 168, 1, 1);
IPAddress subnet(255, 255, 255, 0);
WebServer server(80);

int fanPin = 13;
bool fanState = HIGH;
int powerPin = 25;
bool power = LOW;

void setup()
{
  Serial.begin(115200);
  
  WiFi.softAP(ssid, password);
  WiFi.softAPConfig(local_ip, gateway, subnet);
  server.begin();

  pinMode(fanPin, OUTPUT);
  pinMode(powerPin, OUTPUT);
  digitalWrite(fanPin, fanState);
  digitalWrite(powerPin, power);
  
  server.on("/", handle_OnConnect);
  server.on("/led1on", handle_led1on);
  server.on("/led1off", handle_led1off);
  //server.on("/led2on", handle_led2on);
  //server.on("/led2off", handle_led2off);
  server.onNotFound(handle_NotFound);
  
  server.begin();
  Serial.println("HTTP server started");
  
}

void loop()
{
  server.handleClient();
  if(!power){
    digitalWrite(powerPin, LOW);
  }else{
    Serial.println(power);
    digitalWrite(powerPin, HIGH);
    fanState = HIGH;
    digitalWrite(fanPin, fanState);
    delay(2000);
    fanState = LOW;
    digitalWrite(fanPin, fanState);
    delay(10000);
  }
}


void handle_OnConnect() {
  power = LOW;
  //LED2status = LOW;
  Serial.println("GPIO4 Status: OFF | GPIO5 Status: OFF");
  server.send(200, "text/html", SendHTML(power)); 
}

void handle_led1on() {
  power = HIGH;
  Serial.println("GPIO4 Status: ON");
  server.send(200, "text/html", SendHTML(true)); 
}

void handle_led1off() {
  power = LOW;
  Serial.println("GPIO4 Status: OFF");
  server.send(200, "text/html", SendHTML(false)); 
}

void handle_NotFound(){
  server.send(404, "text/plain", "Not found");
}


String SendHTML(uint8_t led1stat){
  String ptr = "<!DOCTYPE html> <html>\n";
  ptr +="<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\">\n";
  ptr +="<title>LED Control</title>\n";
  ptr +="<style>html { font-family: Helvetica; display: inline-block; margin: 0px auto; text-align: center;}\n";
  ptr +="body{margin-top: 50px;} h1 {color: #444444;margin: 50px auto 30px;} h3 {color: #444444;margin-bottom: 50px;}\n";
  ptr +=".button {display: block;width: 80px;background-color: #3498db;border: none;color: white;padding: 13px 30px;text-decoration: none;font-size: 25px;margin: 0px auto 35px;cursor: pointer;border-radius: 4px;}\n";
  ptr +=".button-on {background-color: #3498db;}\n";
  ptr +=".button-on:active {background-color: #2980b9;}\n";
  ptr +=".button-off {background-color: #34495e;}\n";
  ptr +=".button-off:active {background-color: #2c3e50;}\n";
  ptr +="p {font-size: 14px;color: #888;margin-bottom: 10px;}\n";
  ptr +="</style>\n";
  ptr +="</head>\n";
  ptr +="<body>\n";
  ptr +="<h1>ESP32 Web Server</h1>\n";
  ptr +="<h3>Using Access Point(AP) Mode</h3>\n";
  
   if(led1stat)
  {ptr +="<p>Cooling Status: ON</p><a class=\"button button-off\" href=\"/led1off\">OFF</a>\n";}
  else
  {ptr +="<p>Cooling Status: OFF</p><a class=\"button button-on\" href=\"/led1on\">ON</a>\n";}
/*
  if(led2stat)
  {ptr +="<p>LED2 Status: ON</p><a class=\"button button-off\" href=\"/led2off\">OFF</a>\n";}
  else
  {ptr +="<p>LED2 Status: OFF</p><a class=\"button button-on\" href=\"/led2on\">ON</a>\n";}
*/
  ptr +="</body>\n";
  ptr +="</html>\n";
  return ptr;
}


/*

import socket

# use ifconfig -a to find this IP. If your pi is the first and only device connected to the ESP32, 
# this should be the correct IP by default on the raspberry pi
LOCAL_UDP_IP = "192.168.1.2"
SHARED_UDP_PORT = 4210
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  # Internet  # UDP
sock.bind((LOCAL_UDP_IP, SHARED_UDP_PORT))

def loop():
    while True:
        data, addr = sock.recvfrom(2048)
        print(data)

if __name__ == "__main__":
    loop()
    
*/
