float t = 0;
float inc = TWO_PI/25;
float a = 60;

int WIDTH = 500;
int HEIGHT = WIDTH;

int g_alpha = 15;
int g_bright = 70;
int g_sat = 100;

float cx = WIDTH/2;
float cy = HEIGHT/2;
float pt_x = cx;
float pt_y = cy;

void keyPressed() {
 if(keyCode==32) {
  background(100, 0, 100, 100);
 }
 if(keyCode==UP&&g_alpha<100) {
    g_alpha+=10;
 }
 if(keyCode==DOWN&&g_alpha>0) {
   g_alpha-=10;
 }
 if(keyCode==LEFT) {
   a-=3;
 }
 if(keyCode==RIGHT) {
   a+=3;
 }
 println(a);
}

void mouseClicked() {
  pt_x = mouseX;
  pt_y = mouseY;
}

void setup() {
  background(255);
  size(WIDTH,HEIGHT);
  colorMode(HSB, 100);
  smooth();
}

void draw() {
  stroke(a*sin(t), g_sat, g_bright, g_alpha);
  PVector mouse = new PVector(mouseX,mouseY);
  PVector center = new PVector(cx,cy);
  mouse.sub(center);
  cx = (pt_x)+a*sin(t);
  cy = (pt_y)+a*cos(t);
  t+=inc;
  translate(cx,cy);
  line(0,0,mouse.x,mouse.y);
}

