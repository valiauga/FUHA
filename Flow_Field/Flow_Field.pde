String apiKey = "&appid=fb32502d721600d87fc1a5606ec527b2";
String city = "Kyoto";
String api = "http://api.openweathermap.org/data/2.5/weather?q=";
String url = api + city + apiKey+ "&mode=xml";

float windSpeed;
float windDirection = 0;
int sec;
float x2, x3, x2_5;

float maxSpeedMapped;

PFont font;
String descriptionString = "The Winds of Japan \n Installation brings motion and shape of the winds from Kyoto.";

float inc = 0.1;
int scl = 10;
float zoff = 0;

int cols;
int rows;

int noOfPoints = 3000;

Particle[] particles = new Particle[noOfPoints];
PVector[] flowField;

void setup() {
  requestData();
  font = loadFont("GTHaptikTrial-Bold-150.vlw");
  size(1710, 2400, P2D);

  background(0);
  //hint(DISABLE_DEPTH_MASK);

  cols = floor(width/scl);
  rows = floor(height/scl);

  flowField = new PVector[(cols*rows)];

  for (int i = 0; i < noOfPoints; i++) {
    particles[i] = new Particle();
  }
}

void draw() {
  fill(0, 7);
  rect(0, 0, width, height);
  noFill();

  float yoff = 0;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      int index = (x + y * cols);

      float angle = noise(xoff, yoff, zoff) /* * TWO_PI */  + x3/55;
      PVector v = PVector.fromAngle(angle);
      v.setMag(0.1);

      flowField[index] = v;

      stroke(245,124,53);

      //pushMatrix();

      //translate(x*scl, y*scl);
      //rotate(v.heading());
      //line(0, 0, scl, 0);

      //popMatrix();

      xoff = xoff + inc;
    }
    yoff = yoff + inc;
  }
  zoff = zoff + (inc / (windSpeed*40));

  for (int i = 0; i < particles.length; i++) {
    particles[i].follow(flowField);
    particles[i].update();
    particles[i].edges();
    particles[i].show();
  }
  if (frameCount % 60 == 0) {
    thread("timerInThread");
  }
  x2 = map(/*mouseX*/ windDirection, 0, width, 0, 360);
  x2_5 = map(mouseX, 0, width, 0, 360);
  x3 = map(x2, 0, 360, 0, 6.35);
  
  maxSpeedMapped = map(windSpeed,0,408,0,100);

  //# PLACE FOR LOGS!

}

//#PARSING WEATHER DATA

void requestData() {
  XML xml = loadXML(url);
  println(url);
  windSpeed = xml.getChild("wind/speed").getFloat("value");
  windDirection = xml.getChild("wind/direction").getFloat("value");
  println("speed: " + windSpeed + " & " + "direction: " + windDirection);
}

void timerInThread() {
  sec += 1;
  //println(sec);
  if (sec == 60) {
    requestData();
    sec = 0;
    
  }
}

//#SAVING AND PRINTING

void mousePressed() {
  //setup();
  delay(500);
  println("drawing");
  //printGraphics();

  println("saving");
  //img.save("image.jpg");
  save("image.jpg");

  println("printing");
  //launch("/Applications/OSX_PrintScript.app");
  try {
    Process p = Runtime.getRuntime().exec("lp /Users/lukasvaliauga/Desktop/FU_HA/sketches/prototype_4/Flow_Field/image.jpg");
  } 
  catch (Exception err) {
    err.printStackTrace();
  }
}

//#GRAPHICS

void printGraphics() {
  pushMatrix();
  textFont(font);
  textSize(150);
  fill(255);
  text("FU", 50, 150);
  popMatrix();

  pushMatrix();
  textFont(font);
  textSize(150);
  fill(255);
  text("_", width-300, 370);
  popMatrix();

  pushMatrix();
  textFont(font);
  textSize(150);
  fill(255);
  text("HA", width-270, 600);
  popMatrix();

  textFont(font);
  textSize(14);
  fill(255);
  text(descriptionString, 50, 700);
}