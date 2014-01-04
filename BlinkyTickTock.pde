import processing.serial.*;

BlinkyTape bt = null;

int val = 0;

float randcolor1_r = 0;
float randcolor1_g = 0;
float randcolor1_b = 0;

float randcolor2_r = 0;
float randcolor2_g = 0;
float randcolor2_b = 0;

float color_trans_r = 0;
float color_trans_g = 0;
float color_trans_b = 0;

float gradient_r = 0;
float gradient_g = 0;
float gradient_b = 0;

boolean reset = false;

void setup() {

  frameRate(30);

  for (String p : Serial.list()) {

	// Set your serial port here:
	//
    if (p.startsWith("COM31")) {

      bt = new BlinkyTape(this, p, 60);

    }

  }
  
  colorSetup();
  
}

void colorSetup() {
  
  randcolor1_r = random(255);
  randcolor1_g = random(255);
  randcolor1_b = random(255);

  // Rotate the colour wheel in a random direction:
  //
  if (random(1) <= 0.5) {
    
    randcolor2_r = randcolor1_g;
    randcolor2_g = randcolor1_b;
    randcolor2_b = randcolor1_r;
    
  } else {
    
    randcolor2_r = randcolor1_b;
    randcolor2_g = randcolor1_r;
    randcolor2_b = randcolor1_g;

  }    
  
  color_trans_r = randcolor2_r - randcolor1_r;
  color_trans_g = randcolor2_g - randcolor1_g;
  color_trans_b = randcolor2_b - randcolor1_b;
  
}

void serialEvent(Serial m_outPort) {
  
  val = m_outPort.read();

  // It seems that it always shows 15 until the button is pushed, when it seems to be 7:
  //
  if (val != 15) colorSetup();
  
}

void draw() {

  if (bt != null) {

	// We'll go 1 to 60 to use all the lights instead of 0 to 59. :)
	//
    int current_second = second()+1;

	// "reset" logic keeps the first LED from cycling more than once during the first second of the minute.
	//
    if (current_second <= 1 && reset == false) {
      
      colorSetup();
      reset = true;
      
    } else if (current_second > 1 && reset == true) {
      
      reset = false;
      
    }
    
    for (float frame = 0; frame < 60; frame++) {

      if (frame < current_second) {

		/* 
		The idea here is that we're calculating the crossfade between two numbers in the range of 0-255, either up or down.
		We're calculating a percentage of the color_trans (difference) number for each frame.
		If we're going down, the number will be negative.  Up will be positive.
		The effect is two fixed colours moving farther apart, with the gradient being calculated between them at each step.
		The first and last colour should stay the same in every frame. Subtle but pleasant.
		*/
		
        gradient_r = (frame / current_second) * color_trans_r;
        gradient_g = (frame / current_second) * color_trans_g;
        gradient_b = (frame / current_second) * color_trans_b;

        color c = color(randcolor1_r+gradient_r, randcolor1_g+gradient_g, randcolor1_b+gradient_b);
        
        bt.pushPixel(c);
        
      }  else {

		// blank out other pixels:
		//
        color c = color(0, 0, 0);
        
        bt.pushPixel(c);
        
      }
      
    }

    bt.update();
    
  }
  
}

