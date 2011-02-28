class Walker {
  int xpos, ypos;
  int x0, y0;
  float radius, maxRadius = 1;
  color c0;
  int lifeForce = int(random(300, 1000));
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
         c0 = color(red(c0), green(c0), blue(c0), alpha(c0)-100); 
   accel = random(5)+0.1;
    xdir = randomDirection();
     ydir = randomDirection(); 
    println("Walker with color "+hex(c)+" at "+x0+" "+y0+" "+xdir+" "+ydir);
  }  

  int randomDirection() {
     float x = random(-1, 1);
    if(x<0) {
       return -1;
    } else {
       return 1;
    } 
  }

  void update(int ticker) {
    radius += 0.5;
    x0 = xpos;
    y0 = ypos;
    xpos += (xdir*accel);
    ypos += (ydir*accel);
    xpos += int((cos(ticker)*radius-sin(ticker)*radius));
    ypos += int((sin(ticker)*radius + cos(ticker)*radius));
    if(lifeForce<0) {
      alive = false;
    } else {
      lifeForce--;
      c0 = color(red(c0), green(c0), blue(c0), alpha(c0)-10); 
    }
  }
  
  void draw() {
    fill(c0);
    stroke(c0);
    line(x0, y0, xpos, ypos);
    //set(int(xpos), int(ypos),  c0); 
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

