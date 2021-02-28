import processing.serial.*;

Serial myPort;
String val;
String[] values;
int[] data = {0,0,0,0,0,0};

int flip;
int b1;
int b2;
int zVal;
int xVal;
int yVal;
int flip_past;
int b1_past;
int b2_past;
int zVal_past;
int xVal_past = xVal;
int yVal_past;
int xVal_raw;
int yVal_raw;

//smoke
float thold = 5;
float spifac = 1.05;
int outnum;
float drag = 0.01;
int big = 500;
ball bodies[] = new ball[big];
float mX;
float mY;
//blue bubbles
ArrayList<Particle> pts;
int onPressed;
PFont f;

int colorPick;

int state = 0;

void setup() {
  size(900, 450, P2D);
  strokeWeight(1);
  fill(255, 255, 255);
  stroke(255, 255, 255, 5);
  background(0, 0, 0);   
  smooth();
  colorMode(RGB);
  rectMode(CENTER);
  for(int i = 0; i < big; i++) {
    bodies[i] = new ball();
  }
  
  //blues
  pts = new ArrayList<Particle>();
  
  
  
  //serial
  String portName = Serial.list()[4];
  System.out.println(portName);
  myPort = new Serial(this, portName, 9600);
  
  for(int i = 0; i<5; i++)
  {
    System.out.println(myPort.readStringUntil('\n'));
  }
  
  System.out.println("reading Serial data");
  
}

void draw() {
  
  if(myPort.available() > 0)
  { 
    val = myPort.readStringUntil('\n');
    val = trim(val);
    //System.out.println("val: " + val);
  }
  
  if(val != null)
  {
    values = split(val, ',');
    for(int i = 0; i < values.length; i++)
    {
      if(values[i] != null && values.length == 6)
      {
        try
        {
          //System.out.println(i+ ": " + values[i]);
          //System.out.println(i+ ": " + Integer.parseInt(values[i]));
          data[i] = int(values[i]);
        }
        catch(NumberFormatException e)
        {
          System.out.println("Number Format Exception at " + i);
        }
      }
    }
  
  System.out.println("Data: " + data[0] + ", "+ data[1] + ", "+ data[2] + ", "+ data[3] + ", "+ data[4] + ", "+ data[5]);
  
  flip = data[0];
  b1 = data[1];
  b2 = data[2];
  zVal = data[3];
  xVal_raw = data[4];
  xVal = (data[4]*width)/4095;
  yVal_raw = data[5];
  yVal = (data[5]*height)/4095;
  }
  if(b2 == 0 && b2_past == 1){  //switch states
    state = (state + 1)%3;
  }
  
  //flipping the switch freezes the screen
  if(flip==0){
    ;
  }else{
    //*************STATES******************
    if(state == 0){
      smoke();
    }else if(state == 1){
      pickColor();
      
    }else{
      blues();
    }
  }
  flip_past = flip;
  b1_past = b1;
  b2_past = b2;
  zVal_past = zVal;
  xVal_past = xVal;
  yVal_past = yVal;
  
}



//*******************SMOKE******************
void smoke(){
  stroke(255, 255, 255, 5);
  strokeWeight(1);
  
  //b1 takes screen capture of the frame
  if(b1 == 0 && b1_past == 1) {
    saveFrame("Focus " + outnum);
    outnum++;
  }
  //pressing on the joystick makes the screen reset
  if(zVal == 0 && zVal_past == 1) {
    background(0, 0, 0);
    
    mX += 0.3 * (xVal - mX);
    mY += 0.3 * (yVal - mY);
  }
    //System.out.println("mouseX, mouseY: (" + mouseX +","+ mouseY+")");
    mX += 0.3 * (xVal - mX);
    mY += 0.3 * (yVal - mY);
  for(int i = 0; i < big; i++) {
    bodies[i].render();
  }    
  
}
//****************BLUES*****************
void blues(){
  System.out.println("State 1");
  //b1 takes screenshot
  if(b1 == 0 && b1_past == 1) {
    saveFrame("Focus " + outnum);
    outnum++;
  }
  
  onPressed = zVal;
  
  if (!boolean(onPressed)) {
    for (int i=0;i<10;i++) {
      Particle newP = new Particle(xVal, yVal, i+pts.size(), i+pts.size());
      pts.add(newP);
    }
  }
 
  for (int i=0; i<pts.size(); i++) {
    Particle p = pts.get(i);
    p.update();
    p.display();
  }
 
  for (int i=pts.size()-1; i>-1; i--) {
    Particle p = pts.get(i);
    if (p.dead) {
      pts.remove(i);
    }
  }
}

//****************PICKCOLOR*****************
void pickColor(){
  //System.out.println("pickColor: (" +xVal+","+yVal+")"); 
  if(xVal_raw == 0){
    colorPick = 0;//red      
  }else if(xVal_raw == 4095){
    colorPick = 1;//green
  }else if(yVal_raw == 4095){
    colorPick = 2;
  }
  System.out.println("State 2: "+ colorPick);
}

class ball {
  float X;
  float Y;
  float Xv;
  float Yv;
  float pX;
  float pY;
  float w;
  ball() {
    X = random(width);
    Y = random(height);
    w = random(1 / thold, thold);
  }
  void render() {
    if(!(zVal == 0 && zVal_past == 1)) {
      Xv /= spifac;
      Yv /= spifac;
    }
    Xv += drag * (mX - X) * w;
    Yv += drag * (mY - Y) * w;
    X += Xv;
    Y += Yv;
    line(X, Y, pX, pY);
    pX = X;
    pY = Y;
  }
}

class Particle{
  PVector loc, vel, acc;
  int lifeSpan, passedLife;
  boolean dead;
  float alpha, weight, weightRange, decay, xOffset, yOffset;
  color c;
   
  Particle(float x, float y, float xOffset, float yOffset){
    loc = new PVector(x,y);
     
    float randDegrees = random(360);
    vel = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    vel.mult(random(5));
     
    acc = new PVector(0,0);
    lifeSpan = int(random(30, 90));
    decay = random(0.75, 0.9);
    weightRange = random(3,50);
    
    if(colorPick == 0){
      c = color(255, random(255),random(255)); 
    }else if(colorPick == 1){
      c = color(random(255),255,random(255)); 
    }else{
      c = color(random(255),random(255),255); 
    }
     
    
     
    this.xOffset = xOffset;
    this.yOffset = yOffset;
  }
   
  void update(){
    if(passedLife>=lifeSpan){
      dead = true;
    }else{
      passedLife++;
    }
     
    alpha = float(lifeSpan-passedLife)/lifeSpan * 70+50;
    weight = float(lifeSpan-passedLife)/lifeSpan * weightRange;
     
    acc.set(0,0);
     
    float rn = (noise((loc.x+frameCount+xOffset)*0.01, (loc.y+frameCount+yOffset)*0.01)-0.5)*4*PI;
    float mag = noise((loc.y+frameCount)*0.01, (loc.x+frameCount)*0.01);
    PVector dir = new PVector(cos(rn),sin(rn));
    acc.add(dir);
    acc.mult(mag);
     
    float randDegrees = random(360);
    PVector randV = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    randV.mult(0.5);
    acc.add(randV);
     
    vel.add(acc);
    vel.mult(decay);
    vel.limit(3);
    loc.add(vel);
  }
   
  void display(){
    strokeWeight(weight+1.5);
    stroke(0, alpha);
    point(loc.x, loc.y);
     
    strokeWeight(weight);
    stroke(c);
    point(loc.x, loc.y);
  }
}
