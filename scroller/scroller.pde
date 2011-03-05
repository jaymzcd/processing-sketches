ScrollerBar b;
ArrayList bars = new ArrayList();

void setup() 
{
  size(500,500);
  background(0);
  noStroke();
  for(int i=0; i<5; i++) {
    bars.add(new ScrollerBar(random(5, 8), int(random(1, 4))));
  }
}

void keyPressed() {
  if(keyCode==32) {
    bars.add(new ScrollerBar(random(5, 8), int(random(1, 4))));   
  } 
  if(keyCode==DOWN) {
    for(int i=0; i<bars.size(); i++) {
      ScrollerBar bar = (ScrollerBar)bars.get(i);
      bar.MAX_VELOCITY -= 1;
    }
  } 
  if(keyCode==UP) {
    for(int i=0; i<bars.size(); i++) {
      ScrollerBar bar = (ScrollerBar)bars.get(i);
      bar.MAX_VELOCITY += 1;
    }
  } 
}

void draw() 
{
  background(0);
  for(int i=0; i<bars.size(); i++) {
    ScrollerBar bar = (ScrollerBar)bars.get(i);
    bar.update();
    bar.draw();
  }
}

class ScrollerBar {
  /* Draws a scroller in the style of an old c64 type demo */
  
  PVector location = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0.5);
  
  int _width = width;
  int _height = int(random(16, 64));
  int ticker = 0;
  int dir = 1;
  int TICK_STEP = 1;
  
  final int[] COLOR_INIT = {
    int(random(128, 255)), 
    int(random(0, 255)),
    int(random(128, 255)), 
    int(random(0, 255)),
    int(random(128, 255)), 
    int(random(0, 255))
  };
  float MAX_VELOCITY = 10;
  final int BARS = 5; // number of bars to draw in between 
  
  public ScrollerBar(float max_v) {
    MAX_VELOCITY = max_v;
  }

  public ScrollerBar(float max_v, int tstep) {
    MAX_VELOCITY = max_v;
    TICK_STEP = tstep;
  }

  public void update() {
    velocity.add(acceleration);
    velocity.limit(MAX_VELOCITY);
    if(location.y>height-_height || location.y<0) {
      velocity.mult(-1);
      acceleration.mult(-1);      
    }
    location.add(velocity);

    if(ticker==0) { 
      dir = 1*TICK_STEP;
    } else if(ticker==255) {
      dir = -1*TICK_STEP;
    }
    ticker += dir;
  }
  
  public void draw() {
    colorMode(RGB);
    color tc = color(COLOR_INIT[0], COLOR_INIT[1], COLOR_INIT[2]);
    color fc = color(COLOR_INIT[3], COLOR_INIT[4], COLOR_INIT[5]);
    fill(fc);
    rect(location.x, location.y, _width, _height/BARS); 
    fill(tc);
    rect(location.x, location.y+_height-(_height/BARS), _width, _height/BARS); 
    for(float i=1; i<BARS; i++) {
      color ic = lerpColor(fc, tc, i/BARS);
      colorMode(HSB);
      float b = brightness(ic);
      fill(color(hue(ic), saturation(ic), ticker));
      rect(location.x, location.y+i*(_height/BARS), _width, _height/BARS); 
    }
  }
  
}
