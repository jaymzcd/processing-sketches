PImage img;
int STEP = 50; // sampling of image per input point
int SCAN_STEP = 50; // number of pixels to jump over to form a grid for main
int TOLERANCE = 30; // range to allow other colors to fall within
int STROKE_ALPHA = 5; // val for our connecting lines
int MIN_DISTANCE_DELTA = 0; // minium distance before drawing a connector
int MAX_DISTANCE_DELTA = 1000; // max distance before drawing a connector
int BLACK_TOLERANCE = 5; // colors less bright than this are "black"
int SAT_TOLERANCE = 0; // colors must have at least this saturation
Boolean IGNORE_BLACKS = true;
int LINE_COUNT = 0; // counts how many lines we've drawn


void setup() {
  img = loadImage("heart.jpg");
  size(img.width, img.height);
  background(0);
  noFill();
  smooth();
  img.loadPixels();
  tint(255, 30);
  image(img, 0, 0);
  doGrid();
}

void draw() {
}

// Following 3 methods give our deltas on HSV for the 
// two source colors

int hueDiff(color src, color tar) {
  return abs(int(hue(src)-hue(tar)));
}
int valDiff(color src, color tar) {
  return abs(int(brightness(src)-brightness(tar)));
}
int satDiff(color src, color tar) {
  return abs(int(saturation(src)-saturation(tar)));
}

Boolean withinTolerance(int val) {
  if (val<TOLERANCE) {
    return true;
  } else {
    return false;
  }
}

int distanceForPoints(int srcX, int srcY, int tarX, int tarY) {
   double delta = Math.pow(Math.pow((tarX-srcX), 2)+Math.pow((tarY-srcY), 2), 0.5);
   return (int)delta;
}

void mousePressed() {
  processColorPoint(mouseX, mouseY); 
}

void processColorPoint(int inX, int inY) {
  color c0 = img.pixels[inY*width+inX];
  println("Source point ("+inX+", "+inY+") color: "+hex(c0));
  for (int i=0; i<width; i+=STEP) {
    for(int j=0; j<height; j+=STEP) {
      
      int pointDistance = distanceForPoints(inX, inY, i, j);
      if (pointDistance<MIN_DISTANCE_DELTA||pointDistance>MAX_DISTANCE_DELTA) {
        continue; // We are not within the right distance
      }
      
      color csrc = img.pixels[j*width+i];

      if(brightness(csrc)<BLACK_TOLERANCE&&IGNORE_BLACKS) {
          continue;
      }

      if(saturation(csrc)<SAT_TOLERANCE) {
          continue; 
      }

      // Now get our color deltas to compare to tolerances      
      int hDelta = hueDiff(c0, csrc);
      int vDelta = valDiff(c0, csrc);
      int sDelta = satDiff(c0, csrc);
      
      if(withinTolerance(hDelta)&&withinTolerance(vDelta)&&withinTolerance(sDelta)) {
        //println("Match for "+hex(csrc)+" at ("+i+", "+j+")");
        stroke(red(c0), green(c0), blue(c0), STROKE_ALPHA);
        bezier(inX, inY, inX+50, inY+50, i-50, j-50, i, j);
        //line(inX, inY, i, j);
        LINE_COUNT++;
      }
        
    } 
  }
}

void doGrid() {
  // Go over whole image in a grid and draw connectors
  // for each point
  for (int i=0; i<width; i+=SCAN_STEP) {
    for(int j=0; j<height; j+=SCAN_STEP) {
      color csrc = img.pixels[j*width+i];      
      if(((brightness(csrc)>BLACK_TOLERANCE&&IGNORE_BLACKS)||!IGNORE_BLACKS)&&(saturation(csrc)>SAT_TOLERANCE))
        processColorPoint(i, j);
    }
  }
  println("Finished! Total lines drawn: "+LINE_COUNT);
}
