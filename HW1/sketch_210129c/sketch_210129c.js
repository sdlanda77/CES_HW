let _nsRate;
let _maxPoint;
let _aryObject = [];
let _objectNum;
let velocity;
let time;

function setup() {
  loadJSON('https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?date=latest&station=8594900&product=water_level&datum=MTL&units=metric&time_zone=lst&application=Tides_and_Currents&format=json', gotData)
  
  let canvasSize;
  if (windowWidth <= windowHeight) {
    canvasSize = windowWidth;
  } else {
    canvasSize = windowHeight;
  }
  createCanvas(displayWidth, displayHeight);
  frameRate(30);
  colorMode(HSB, 360, 100, 100, 255);
  strokeCap(SQUARE);
  strokeJoin(ROUND);
  noFill();
  
 

  _objectNum = 8;
  //print(velocity);
  _nsRate = 0.001;
  //abs(tides.features[0].properties.v)/50;// 0.001; --> DEPEND ON TIDE/CHOPPINESS
  _maxPoint = 250;
 
  for (let i = 0; i < _objectNum; i++) {
    _aryObject.push(new line());
  }
}

function gotData(data){
  //print(data);
  //print(data.data[0].v);
  velocity = data.data[0].v;
  time = data.data[0].t;
  let timeSplit = split(time, ' ');
  time = timeSplit[1];
  timeSplit = split(time, ':');
  time = timeSplit[0];
  print(time);
}

function draw() {
  clear();
  blendMode(DIFFERENCE);
  background(255);

  for (let i = 0; i < _objectNum; i++) {
    _aryObject[i].update();
    _aryObject[i].draw();
  }
}

class line {
  constructor() {
    this.nsX = random(100);
    this.nsY = random(100);
    this.color = color(random(0, 60), 100, 100, 255); //take from API? --> now it's cool colors
    this.sw = random(width/30, width/6);
    this.aryPoints = [];
  }
  update() {
    this.nsX += _nsRate;
    this.nsY += _nsRate;
    this.aryPoints.unshift([
      width/3 * cos(8*PI*noise(this.nsX)),
      height/3 * sin(8*PI*noise(this.nsY))
    ]);

    while (this.aryPoints.length > _maxPoint) {
      this.aryPoints.pop();
    }
   
  }
  draw() {
    
    if (!velocity){
      return;
    }
    _nsRate = velocity/700;
    _maxPoint = time*10;
    stroke(this.color);
    strokeWeight(this.sw);
    push();
    translate(width/2, height/2);
    beginShape();
    for (let i = 0; i < this.aryPoints.length; i++) {
      curveVertex(this.aryPoints[i][0], this.aryPoints[i][1]);
    }
    endShape();
    pop();
    //stroke('tan');
    //rect(0, 0, width, height*2);
  }
}
