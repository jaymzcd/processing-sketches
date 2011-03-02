PImage img;
int STEP = 10; // number of pixels to jump over to form a grid
int TOLERANCE = 15; // range to allow other colors to fall within
int STROKE_ALPHA = 100; // val for our connecting lines

void setup() {
  img = loadImage("girly.png");
  size(img.width, img.height);
  background(0);
  smooth();
  img.loadPixels();
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

void mousePressed() {
  color c0 = img.pixels[mouseY*width+mouseX];
  println(hex(c0));
  for (int i=0; i<width; i+=STEP) {
    for(int j=0; j<height; j+=STEP) {
      color csrc = img.pixels[j*width+i];
      
      int hDelta = hueDiff(c0, csrc);
      int vDelta = valDiff(c0, csrc);
      int sDelta = satDiff(c0, csrc);
      
      if(withinTolerance(hDelta)&&withinTolerance(vDelta)&&withinTolerance(sDelta)) {
        println("Match for "+hex(csrc)+" at ("+i+", "+j+")");
        stroke(red(c0), green(c0), blue(c0), STROKE_ALPHA);
        line(mouseX, mouseY, i, j);
      }
      
    } 
  }
}
