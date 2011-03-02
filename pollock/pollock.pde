boolean DEBUG = false;
int PMAX = 10;
int HMIN = 0;
int HMAX = 20;

class Trail {
  float xpos;
  float ypos;
  float xprev;
  float yprev;
  float accel = 10;
  color c;
  boolean alive = true;
  float talpha = 255;
  
  Trail(float xpos, float ypos, float ssize, color c) {
    this.xpos = xpos;
    this.ypos = ypos;  
    xprev = xpos;
    yprev = ypos;
    accel = ssize+random(-2, 2);
    this.c = c;
    talpha = alpha(c);
    if(DEBUG)
      println("New trail at ("+xpos+", "+ypos+") accel: "+accel+" "+hex(c));
  }
 
  void draw() {
    color d = color(hue(c), brightness(c), saturation(c), talpha);
    stroke(d);
    line(xprev, yprev, xpos, ypos);
    xprev = xpos;
    yprev = ypos;
    xpos += accel*0.2*random(-1,1);
    ypos += accel;
    accel -= 1;
    talpha -= 40;
    if(DEBUG)
      println("Trail: alpha="+talpha+" accel="+accel);
    if(accel<0 || talpha<0) {
      alive = false;
    }    
  } 
}

class Splat {
  int splats = 1;
  int hswing = 5; // hue shift (degrees)
  color c;
  float x, y;
  
  Splat(float xpos, float ypos, float xtarget, float ytarget, color c) {
    splats = floor(abs((ytarget-ypos)/(xtarget-xpos)));
    if (splats>15) {
     splats = 15;
    }
    if(splats<2) {
      splats = 2; 
    }

    this.c = c;
    x = (xpos+xtarget)/2;
    y = (ypos+ytarget)/2;
  }
  void draw() {
    float t = alpha(c);
    float h = hue(c);
    float s = saturation(c);
    float b = brightness(c);
    for(int i=-floor(splats/2); i<(splats/2); i++) {
      t -= 10;
      h += random(-hswing, hswing);
      color d = color(h, s, b, t);   
      fill(d);
      float _x = x+i*random(-2, 2);
      float _y = y+i*random(-2, 2);
      float esize = abs(i*2);
      ellipse(_x, _y, esize, esize);
      if(esize>5) {
        trails.add(new Trail(_x, _y, esize, d));        
      }
    }
  }
}

class Walker {
  boolean alive = true;
  float x0 = width/2+random(-50, 50);
  float y0 = height/2+random(-50, 50);
  float step = random(delta_min, delta_max);
  float xsig;
  float ysig;
  float xprev;
  float yprev;
  color c = color(random(0, 360), 255, 255);
  
  Walker(float _x, float _y, color c) {
    x0 = _x;
    y0 = _y;
    this.c = c;
    if(DEBUG)
      println("Added walker at ("+_x+", "+_y+"), "+hex(c));    
  }  
  
  Walker(int _x, int _y) {
    x0 = float(_x);
    y0 = float(_y);
    if(DEBUG)
      println("Added walker at ("+_x+", "+_y+")");    
  }  
  
  void draw(){
    xsig = x0 + (int)random(-step,step);
    ysig = y0 + (int)random(-step,step);
    xprev = x0;
    yprev = y0;
    boolean isBounded = false;
    
    if(xsig < 0 || xsig > width || height < 0 || ysig >height){
      alive = false;
      if (DEBUG)
        println("Walker is dead - outside canvas");
    } else {
      
      if(CHECK_BOUNDS) {
        for(int i=0; i<polys.size(); i++) {
          Polygon p = (Polygon)polys.get(i);
          if (p.pointBounded(x0, y0)) {
            isBounded = true;
            break;
          }  
        }
      } else {
        isBounded = true; 
      }
      
      if (isBounded) {
        stroke(255, 30);
        line(x0, y0, xsig, ysig);
        noStroke();
        Splat s = new Splat(x0, y0, xsig, ysig, c);
        s.draw();
        x0 = xsig;
        y0 = ysig;
      } else {
        alive = false;
      }
    }
  }
}

class Point {
  float x;
  float y;
  
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
}

class Polygon {
  ArrayList points = new ArrayList(); 
  float[] vertx;
  float[] verty;    

  Polygon() {
    
  }
  
  Point lastPoint() {
    return (Point)points.get(points.size()-1);
  }

  void addPoint(float x, float y) {
    points.add(new Point(x, y));
    makeArrays(); 
  }
  
  void makeArrays() {
      vertx = new float[points.size()];
      verty = new float[points.size()];
      for(int i=0; i<points.size(); i++) {
          Point p = (Point)points.get(i);
          vertx[i] = p.x;
          verty[i] = p.y;          
      } 
      
  }
  
  void draw() {
    stroke(128);
    for(int i=0; i<points.size(); i++) {
      try {
        Point p1 = (Point)points.get(i);
        Point p2 = (Point)points.get(i+1);      
        line(p1.x, p1.y, p2.x, p2.y);
      } catch (Exception e) {
        Point p1 = (Point)points.get(i);
        Point p2 = (Point)points.get(0);      
        line(p1.x, p1.y, p2.x, p2.y);
      }
    } 
  }
  
  boolean pointBounded(float testx, float testy) {
    // http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
    int nvert = points.size();
    int i, j = 0;
    boolean c = false;
    for (i = 0, j = nvert-1; i < nvert; j = i++) {
      if ( ((verty[i]>testy) != (verty[j]>testy)) &&
  	 (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
         c = !c;
    }
    return c;
  }
  
}

ArrayList walkers = new ArrayList();
ArrayList trails = new ArrayList();
ArrayList polys = new ArrayList();
ArrayList splats;
int delta_min = 5;
int delta_max = 20;
boolean melted = false;
color[] palette;
String MODE = "poly";
boolean DRAW_BOUNDS, BURST, CHECK_BOUNDS = true;

void setup(){
  size(1000, 1000);
  colorMode(HSB);
  smooth();
  noStroke();
  background(0);
  palette = getPalatte(PMAX, HMIN, HMAX);
}

void draw() {  
  if (walkers.size()>0) {
    for (int i=0; i<walkers.size(); i++) {
      Walker w = (Walker)walkers.get(i);
      if (w.alive) {
        w.draw();
      } else {
        if(DEBUG)
          println("Removed dead walker at "+i);
        walkers.remove(i); 
      }
    }
  } else {
    if (!melted) {
      //melt();  
    }
  }
  
  if (trails.size() >0 ) {
    for(int i=0; i<trails.size(); i++) {
      Trail t = (Trail)trails.get(i);
      if(t.alive) {
        t.draw();        
      } else {
        trails.remove(t);        
      }
    }    
  }
  if (DRAW_BOUNDS) {
    drawPolys();
  }
}

void drawPolys() {
  for(int i=0; i<polys.size(); i++) {
     Polygon p = (Polygon)polys.get(i); 
     p.draw();
  }  
}

void mouseMoved() {
  if(MODE=="poly") {
    try {
      background(0);
      drawPolys();
      stroke(0, 100, 100);
      Polygon p = (Polygon)polys.get(polys.size()-1);
      Point last = p.lastPoint();
      line(last.x, last.y, mouseX, mouseY);
    } catch (Exception e) {
       
    } 
  }
}

void mousePressed() {
  if (MODE=="walker") {
    int cnt = 1;
    if(BURST) {
      cnt = 10;
    } 
    for(int i=0; i<cnt; i++) {
      color c = palette[int(random(0, PMAX))];
      walkers.add(new Walker(mouseX+random(-20, 20), mouseY+random(-20, 20), c)); 
    }
  }
  
  if(MODE=="poly") {
    background(0);
    try {
      Polygon p = (Polygon)polys.get(polys.size()-1);
      p.addPoint(float(mouseX), float(mouseY)); 
      p.draw();
    } catch (Exception e) {
      println("No polygons yet - added new one!"); 
      polys.add(new Polygon());
    }
  }
}

color[] getPalatte(int max, int hue_min, int hue_max) {
  println("Creating palette");
  color[] palette = new color[max];
  for (int i=0; i<max; i++) {
    palette[i] = color(random(hue_min, hue_max), 255, 255, random(50, 230));
    println("added color: "+hex(palette[i]));
  }
  return palette;  
}

void melt() {
  loadPixels();
  for (int x=0; x<width; x+=random(1, 10)) {
    for(int  y=0; y<height; y+=random(1, 10)) {
      color c = pixels[y*width+x];
      stroke(c);
      line(x, y, x, y+random(2, 20));
    }
  }
  melted = true;
}

void clearData() {
  walkers = new ArrayList(); 
  trails = new ArrayList();
  //polys = new ArrayList();
}
 
void keyPressed() {
  if(keyCode==32) {
    clearData();
    println("Cleared arrays - frozen");
  }
  if(key=='i') {
    polys = new ArrayList();
    println("Wiped polys"); 
  }
  if(key=='d') {
    background(0);
    clearData();
    melted = false;
    DRAW_BOUNDS = true;
    println("Cleared data & refreshed");
  }
  if(key=='p') {
    println("New palette being created");
    palette = getPalatte(PMAX, HMIN, HMAX); 
  }
  if(key=='m') {
    melt(); 
    println("Melted!");
  }
  if(key=='r') {
    walkers.add(new Walker(int(random(width)), int(random(height)), palette[int(random(PMAX))]));
    println("Now "+walkers.size()+" walkers");
  }
  if(key=='c') {
    background(0); 
    println("Background cleared [data ok]");
  }
  if(key=='w') {
    background(0);
    MODE = "walker"; 
    println("Mode set to walkers");
  }
  if(key=='l') {
     background(0);
     MODE = "poly"; 
     println("Mode set to polygon draw");
  }
  if(key=='s') {
    DRAW_BOUNDS = !DRAW_BOUNDS; 
    println("Bounds → "+DRAW_BOUNDS);
  }
  if(key=='n') {
    polys.add(new Polygon());
    println("Added new active polygon - "+polys.size());
  }
  if(key=='b') {
    BURST = !BURST;
  }
  if(key=='+') {
    HMIN += 30;
    HMAX += 30; 
    println("Hue range: "+HMIN+" → "+HMAX);
    palette = getPalatte(PMAX, HMIN, HMAX);     
  }
  if(key=='-') {
    HMIN -= 30;
    HMAX -= 30;
    println("Hue range: "+HMIN+" → "+HMAX);
    palette = getPalatte(PMAX, HMIN, HMAX);     
  }
  if(key=='t') {
    CHECK_BOUNDS = !CHECK_BOUNDS;
  }
}
