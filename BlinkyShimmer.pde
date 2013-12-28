// Dat Phan dat.hy.phan@gmail.com

// BlinkyShimmer - An aesthetically-pleasing random blinking animation for BlinkyTape

// My goal was to capture the shimmering effect of light reflecting
// off the top of waves in a body of water

import processing.serial.*;

int numberOfLEDs = 60;
PVector[] ledBuffer = new PVector[60];

Shimmer shim;

BlinkyTape bt = null;


void setup()
{
  // instantiate all the LEDs, set their values to 0
  for (int i = 0; i < numberOfLEDs; i++)
  {
     ledBuffer[i] = new PVector(0, 0, 0); 
  }
  
  // instantiate a Shimmer object
  shim = new Shimmer(numberOfLEDs);

  // connect to one blinkyboard at COM9 - change to fit your setup
  for (String p : Serial.list())
  {
    if (p.startsWith("COM9"))
    {
      bt = new BlinkyTape(this, p, 60);
    }
  }
}

void draw()
{
  shim.update();
  shim.sendToBuffer(ledBuffer, numberOfLEDs); 
  
  if (bt != null)
  {    
    for (int i = 0; i < 60; i++)
    {      
      color c = color(ledBuffer[i].x, ledBuffer[i].y, ledBuffer[i].z);
      bt.pushPixel(c);
    }
    bt.update();
  }
}
