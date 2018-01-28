import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import peasy.test.*;

int hueSteps = 360;
int valueSteps = 40;
int saturationSteps = 40;


// just determine how big the cylinder is
float radius = 50;
float cHeight = 50;


int focusHue = 0;

boolean cut = false;

PeasyCam cam;

void setup() {
  size(1000, 500, P3D);
  colorMode(HSB);
  cam = new PeasyCam(this, 150);
}

void draw() {
  int counter = 0;
  background(100);
  ambientLight(255,255,255);
  directionalLight(255,255,255,0,0,-1);

  int hueStepsThisFrame;
  if (cut) {
    hueStepsThisFrame = hueSteps / 2;
  } else {
    hueStepsThisFrame = hueSteps;
  }

  for (int v = 0; v < valueSteps; v++) {
    for (int h = 0; h < hueStepsThisFrame; h++) {
      for (int s = 0; s < saturationSteps; s++) {
        if (v == 0 || v == valueSteps-1 || s ==  saturationSteps-1) { // DEFINITELY DRAW THE TOPS

          int currentHue = (h + focusHue) % hueSteps; // FIND THE 180 DEGREES THAT YOU ACTUALLY HAVE TO DRAW 
          float radiusMul = map(s, 0, saturationSteps, 0, 1); 

          float radians = map(h, 0, hueSteps, 0, TWO_PI); // find the angle of the point

          float x = cos(radians) * radiusMul * radius; // given the saturation, find the distance from the center (and x coordinate)
          float y = sin(radians) * radiusMul * radius; // given the saturation, find the distance from the center (and y coordinate)
          float z = map(v, 0, valueSteps, cHeight * -0.5, cHeight * 0.5);

          float hue = map(currentHue, 0, hueSteps, 0, 256);
          float saturation = map(s, 0, saturationSteps, 0, 256);
          float value = map(v, 0, valueSteps, 0, 256);

          //stroke(255);
          //strokeWeight(3);
          //point(x, y, z);

          strokeWeight(20);
          stroke(color(hue, saturation, value));
          point(x, y, z);
          //println(x,y,z);

          //println((focusHue + (hueSteps/2)) % hueSteps);
          if (cut && (currentHue == focusHue || currentHue == ((focusHue + (hueSteps/2)) % hueSteps) - 1)) {
            for (int s2 = 0; s2 < saturationSteps - 1; s2++) {
              counter++;
              radiusMul = map(s2, 0, saturationSteps, 0, 1);

              x = cos(radians) * radiusMul * radius;
              y = sin(radians) * radiusMul * radius;

              saturation = map(s2, 0, saturationSteps, 0, 256);
              stroke(color(hue, saturation, value));
              point(x, y, z);
            }
          }
        }
      }
    }
  }
  println(counter);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      focusHue = (focusHue + 1) % hueSteps;
      println(focusHue);
    } else if (keyCode == LEFT) {
      focusHue = focusHue - 1;
      if (focusHue < 0) focusHue = hueSteps - 1;
      println(focusHue);
    } else if(keyCode == UP){
      cam.setDistance(cam.getDistance()+10);
    } else if(keyCode == DOWN){
      cam.setDistance(cam.getDistance()-10);
    }
  } else {
    switch(key) {
    case 'c':
      cut = !cut;
      break;
    }
  }
}