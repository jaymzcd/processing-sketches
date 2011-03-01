class Walker {
  int xpos, ypos;
  int x0, y0;
  float radius, maxRadius = 1;
  color c0;
  int lifeForce = int(random(1, 100))/1;
  Boolean alive = true;
  float xaccel, yaccel;
  float xdir, ydir;

  Walker(int _x, int _y, color c) {
    xpos = _x;
    ypos = _y;
    x0 = int(_x);
    y0 = int(_y);
    maxRadius = (int)random(15);
    c0 = c;   
    c0 = color(red(c0), green(c0), blue(c0), alpha(c0)/2); 
    xaccel = random(1, 5);
    yaccel = random(1, 5);
    xdir = randomDirection();
    ydir = randomDirection(); 
    //println("Walker with color "+hex(c)+" at "+x0+" "+y0+" "+xdir+" "+ydir);
  }  

  float randomDirection() {
    float x = random(-1, 1);
    if(x<0) {
      return -1;
    } 
    else {
      return 1;
    }
  }

  void update(int ticker) {
    if(ticker%2==0) {
      if (radius<maxRadius) {
        radius += 0.5;
      } else {
         radius = 0;
      }
    }
    
    x0 = xpos;
    y0 = ypos;
    xpos += (xdir*xaccel);
    ypos += (ydir*yaccel);
    xpos += xdir*int((cos(ticker)*radius-sin(ticker)*radius));
    ypos += ydir*int((sin(ticker)*radius + cos(ticker)*radius));
    float itemAlpha = alpha(c0)-2;
    if(itemAlpha<0) {
      itemAlpha = 0;
    }        
    c0 = color(red(c0), green(c0), blue(c0), itemAlpha);
    
    if(lifeForce<0||itemAlpha==0) {
      alive = false;
    } 
    else {
      lifeForce--;
    }
  }

  void draw() {
    fill(c0);
    stroke(c0);
    line(x0, y0, xpos, ypos);
    //ellipse(xpos, ypos, radius/2, radius/2);
  }
}

ArrayList Walkers = new ArrayList();
int ticker = 0;
float SCALE = 1;
PImage img;

void setup() {
  img = loadImage("nike.jpg");
  size(int(SCALE*img.width), int(SCALE*img.height));
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

  int count = 5000;
  for(int x=0; x<count; x++) {
    int xin = int(random(0, width));
    int  yin = int(random(0, height));  
    try {
      color c = img.pixels[int((yin/SCALE)*(width/SCALE)+(xin/SCALE))];
      addWalker(xin, yin, c);
    } 
    catch (ArrayIndexOutOfBoundsException e) {
    }
  }
}

void addWalker(int xin, int yin, color c) {
  Walkers.add(new Walker(xin, yin, c));
}

