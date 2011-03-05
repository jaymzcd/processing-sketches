/* Basic particle class using PVector */

int MIN_SIZE = 4;
int MAX_SIZE = 7;
int MIN_LIFE = 100;
int MAX_LIFE = 500;
int MIN_HUE = 0;
int MAX_HUE = 50;
int LIFE_DECAY_RATE = 3; // decrement life by this much
float MIN_DAMPING = 0.4; // min & max damping for collisons
float MAX_DAMPING = 0.9;
float MAX_ALPHA = 200;
int SIZE_RATE_LIMIT = 10; // this % particle life is when the size decrements

boolean FADE_OUT = true; // this drops the brightness of the particles based on their life
boolean DRAW_CONNECTOR = false; // draws a connector line towards the mouse pointer
boolean STICKY = false; // keep the particles within a fixed radius
int STICKY_DISTANCE = 250; // radius for stickyness
boolean DRAW_TRAILS = true; // draw extra objects along the path of the particle
int NUM_TRAILS = 15; // number of extra particles

class Particle {
   PVector location;
   PVector velocity;
   PVector acceleration = new PVector(random(-0.2, 0.2), random(0.005, 0.01));
   color c;
   String name;
   int psize = int(random(MIN_SIZE, MAX_SIZE));
   float life = int(random(MIN_LIFE, MAX_LIFE));
   float life_init = life;
   float damping = random(MIN_DAMPING, MAX_DAMPING);
   
   Particle (float x, float y, PVector initial_velocity, String name) {
      //println("x: "+x+" y: "+y+" iv: "+initial_velocity+" n: "+name);
      colorMode(HSB);
      c = color(int(random(MIN_HUE, MAX_HUE)), int(random(200, 255)), int(random(200, 255)));
      location = new PVector(x, y);
      this.name = name;
      if(initial_velocity!=null) {
        this.velocity = initial_velocity;
      } else {
        this.velocity = new PVector(0, 0);
      }
    }
    
   void update() {
       checkWalls();
       acceleration.add(G);
       velocity.add(acceleration);
       location.add(velocity);
       life-=LIFE_DECAY_RATE;
       if(psize>MIN_SIZE&&life%SIZE_RATE_LIMIT==0) {
         psize--;
       }
       draw();
   }
   
   void finalize() {
     //TODO: some sort of explode??
   }
   
   void drawTrails() {
     // TODO: refactor this so it stores the past X amount of
     // locations and uses that rather than re-doing the arthmetic
     PVector ta = acceleration.get();
     PVector tv = velocity.get();
     PVector tl = location.get();   
     float csize = psize;
     color ccolor = c;
     for(int i=0; i<NUM_TRAILS; i++) {
       ta.sub(G);
       tv.sub(ta);
       tl.sub(tv);     
       if(csize>0) {
         ccolor = fadeColor(ccolor, csize, psize);
         fill(ccolor);
         ellipse(tl.x, tl.y, csize, csize);      
         csize -= 0.5;
       }
     }
   }

   void checkWalls() {
    if(location.x>WIDTH || location.x<0 || location.y<0 || location.y>HEIGHT) {
      velocity.mult(-1*damping);     
    }    
   }
   
   boolean dead() {
     if(life<=0 || psize==0) {
       return true;
     }
     return false; 
   }
   
   void doCollision(Block b) {
     location.y = b.ypos-psize;
     velocity.mult(-1*damping);     
   }
   
   color fadeColor(color input, float b_val, float b_max) {
     colorMode(HSB);
     float s = saturation(input);
     float h = hue(input);
     float b = brightness(input);
     float a = (b_val/b_max*255);
     a = (a>MAX_ALPHA) ? MAX_ALPHA : a;
     input = color(h, s, b, a);     
     return input;
   }

   void draw() {
     if(DRAW_CONNECTOR) {     
       stroke(255);
       PVector m = new PVector(mouseX, mouseY);
       PVector distance = PVector.sub(m, location);
       if(STICKY&&distance.mag()>STICKY_DISTANCE) {
         distance.normalize();
         distance.mult(STICKY_DISTANCE);
         location = PVector.add(m, distance);
       }
       line(location.x, location.y, m.x, m.y);
     }
     if(FADE_OUT) {
      c = fadeColor(c, life, life_init);
     }
     fill(c);
     noStroke();
     if(VIS_MODE==0) { 
       rect(location.x, location.y, psize, psize); 
     } else {
       ellipse(location.x, location.y, psize, psize); 
     }

     if(DRAW_TRAILS) { // 5 seems to be pretty slow when collided
       drawTrails(); 
     }
   }
}

