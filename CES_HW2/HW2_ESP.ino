/**********************************************************************
  Filename    : ButtonAndLed
  Description : Control led by button.
  Auther      : www.freenove.com
  Modification: 2020/07/11
**********************************************************************/
#define PIN_LED      2
#define PIN_BUTTON_0 12
#define PIN_BUTTON_1 13
#define PIN_SWITCH   4
int xyzPins[] = {26,  25, 33};   //x,y,z pins

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin PIN_LED as an output.
  Serial.begin(115200);
  pinMode(PIN_BUTTON_0, INPUT_PULLUP);
  pinMode(PIN_BUTTON_1, INPUT_PULLUP);
  pinMode(xyzPins[2], INPUT_PULLUP);
  pinMode(PIN_SWITCH, INPUT_PULLUP);
}

// the loop function runs over and over again forever
void loop() {
  int button0 = digitalRead(PIN_BUTTON_0);
  int button1 = digitalRead(PIN_BUTTON_1);
  int xVal = analogRead(xyzPins[0]);
  int yVal = analogRead(xyzPins[1]);
  int zVal = digitalRead(xyzPins[2]);
  int flip = digitalRead(PIN_SWITCH);
  /*
  if (digitalRead(PIN_BUTTON_1) == LOW) {
    digitalWrite(PIN_LED,HIGH);
  }else{
    digitalWrite(PIN_LED,LOW);
  }*/
  Serial.printf("%d,", flip);
  Serial.printf("%d,%d,",button0, button1);
  Serial.printf("%d,%d,%d\n ", zVal, xVal, yVal); 
  delay(100);
  
}
