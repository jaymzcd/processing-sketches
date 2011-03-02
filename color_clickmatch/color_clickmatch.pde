PImage img;
int STEP = 15; // number of pixels to jump over to form a grid
int TOLERANCE = 10; // range to allow other colors to fall within
int STROKE_ALPHA = 50; // val for our connecting lines
int DISTANCE_DELTA = 50; // minium distance before drawing a connector
Boolean IGNORE_BLACKS = true;

void setup() {
  img = loadImage("girly.png");
  size(img.width, img.height);
  background(0);
  smooth();
  img.loadPixels();
  
  doGrid();
}

void draw() {
}

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
  println(hex(c0));
  for (int i=0; i<width; i+=STEP) {
    for(int j=0; j<height; j+=STEP) {
      
      if (distanceForPoints(inX, inY, i, j)<DISTANCE_DELTA)
        break; // We are not far away enough to draw a line
      
      color csrc = img.pixels[j*width+i];
      
      int hDelta = hueDiff(c0, csrc);
      int vDelta = valDiff(c0, csrc);
      int sDelta = satDiff(c0, csrc);
      
      if(brightness(csrc)<TOLERANCE&&IGNORE_BLACKS) {
         break;
         
      } else {
        
        if(withinTolerance(hDelta)&&withinTolerance(vDelta)&&withinTolerance(sDelta)) {
          println("Match for "+hex(csrc)+" at ("+i+", "+j+")");
          stroke(red(c0), green(c0), blue(c0), STROKE_ALPHA);
          line(inY, inY, i, j);
        }
        
      }
      
    } 
  }
}

void doGrid() {
  for (int i=0; i<width; i+=STEP) {
    for(int j=0; j<height; j+=STEP) {
      processColorPoint(i, j);
    }
  }
}
