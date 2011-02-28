class Walker {
  int xpos, ypos;
  int x0, y0;
  float radius, maxRadius = 1;
  color c0;
  int lifeForce = int(random(300, 1000))/10;
  Boolean alive = true;
  float accel;
  int xdir, ydir;

  Walker(int _x, int _y, color c) {
    xpos = _x;
    ypos = _y;
    x0 = int(_x);
    y0 = int(_y);
    maxRadius = (int)random(50);
    c0 = c;   
    c0 = color(red(c0), green(c0), blue(c0), alpha(c0)); 
    accel = random(5)+0.1;
    xdir = randomDirection();
    ydir = randomDirection(); 
    println("Walker with color "+hex(c)+" at "+x0+" "+y0+" "+xdir+" "+ydir);
  }  

  int randomDirection() {
    float x = random(-1, 1);
    if(x<0) {
      return -1;
    } 
    else {
      return 1;
    }
  }

  void update(int ticker) {
    radius += 0.1;
    x0 = xpos;
    y0 = ypos;
    xpos += (xdir*accel);
    ypos += (ydir*accel);
    xpos += int((cos(ticker)*radius-sin(ticker)*radius));
    ypos += int((sin(ticker)*radius + cos(ticker)*radius));
    if(lifeForce<0) {
      alive = false;
    } 
    else {
      lifeForce--;
      c0 = color(red(c0), green(c0), blue(c0), alpha(c0)-10);
    }
  }

  void draw() {
    fill(c0);
    stroke(c0);
    line(x0, y0, xpos, ypos);
  }
}

ArrayList Walkers = new ArrayList();
int ticker = 0;
PImage img;

void setup() {
  img = loadImage("santa.jpg");
  size(img.width, img.height);
  colorMode(RGB);
  smooth();
  noStroke();
  background(0);
  ellipseMode(CENTER);
}

void draw() {
  //image(img, 0, 0);
  for (int i=0; i<Walkers.size(); i++) {
    Walker w = (Walker)Walkers.get(i);
    w.update(ticker);
    if(w.alive) {
      w.draw();
    } 
    else {
      Walkers.remove(i);
    }
  }
  ticker++;
} 

void mouseClicked() {
  img.loadPixels();

  int count = 500;
  for(int x=0; x<count; x++) {
    int xin = int(random(0, width));
    int  yin = int(random(0, height));  
    try {
      color c = img.pixels[yin*width+xin];
      addWalker(xin, yin, c);
    } 
    catch (ArrayIndexOutOfBoundsException e) {
    }
  }
}

void addWalker(int xin, int yin, color c) {
  Walkers.add(new Walker(xin, yin, c));
}

