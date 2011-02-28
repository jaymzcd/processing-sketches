class Walker {
  float xpos, ypos;
  int x0, y0;
  int radius;
  color c0;

  Walker(float _x, float _y, color c) {
    xpos = _x;
    ypos = _y;
    x0 = int(_x);
    y0 = int(_y);
    radius = (int)random(250)+20;
    c0 = c;    
  }  

  void update(int ticker) {
    xpos = x0+(cos(ticker)*radius-sin(ticker)*radius);
    ypos = y0+(sin(ticker)*radius + cos(ticker)*radius);
  }
  
  void draw() {
    set(int(xpos), int(ypos),  c0); 
  }
}

ArrayList Walkers = new ArrayList();
int ticker = 0;
PImage img;

void setup() {
  size(600, 600);
  colorMode(HSB);
  smooth();
  noStroke();
  background(0);
  img = loadImage("nina.jpg");
  //image(img, 0, 0);
}

void draw() {
  for (int i=0; i<Walkers.size(); i++) {
    Walker w = (Walker)Walkers.get(i);
    w.update(ticker);
    w.draw();
    ticker++;
  }
} 

void mousePressed() {
  img.loadPixels();
  color c = img.pixels[mouseY*600+mouseX];
  Walkers.add(new Walker(mouseX, mouseY, c));
}

