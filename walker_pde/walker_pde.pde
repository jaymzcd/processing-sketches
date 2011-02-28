class Walker {
  float xpos, ypos;
  int x0, y0;
  int radius, maxRadius = 1;
  color c0;
  int lifeForce = 100;
  Boolean alive = true;
  
  Walker(float _x, float _y, color c) {
    xpos = _x;
    ypos = _y;
    x0 = int(_x);
    y0 = int(_y);
    maxRadius = (int)random(50);
    c0 = c;    
    println("Walker with color "+hex(c)+" at "+x0+" "+y0);
  }  

  void update(int ticker) {
    xpos = x0+(cos(ticker)*radius-sin(ticker)*radius);
    ypos = y0+(sin(ticker)*radius + cos(ticker)*radius);
    radius++;
    if(lifeForce<0) {
      alive = false;
    } else {
      lifeForce--;
    }
  }
  
  void draw() {
    fill(c0);
    stroke(255);
    //ellipse(xpos, ypos, radius, radius);
    set(int(xpos), int(ypos),  c0); 
  }
}

ArrayList Walkers = new ArrayList();
int ticker = 0;
PImage img;

void setup() {
  size(600, 600);
  colorMode(RGB);
  smooth();
  noStroke();
  background(0);
  img = loadImage("rainbow.jpg");
  ellipseMode(CENTER);
}

void draw() {
  //image(img, 0, 0);
  for (int i=0; i<Walkers.size(); i++) {
    Walker w = (Walker)Walkers.get(i);
    w.update(ticker);
    if(w.alive) {
      w.draw();
    } else {
      Walkers.remove(i);
       println("Walker "+i+" dead!");
    }
  }
  ticker++;
} 

void mouseMoved() {
  img.loadPixels();
  try {
    color c = img.pixels[mouseY*600+mouseX];
    println("Color at "+mouseX+" "+mouseY+" "+hex(c));
    Walkers.add(new Walker(mouseX, mouseY, c));
  } catch (ArrayIndexOutOfBoundsException e) {
    
  }  
}

