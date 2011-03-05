/*
 * Plasma effect
 * ~jaymz 25/01/10
 *
 */

int WIDTH = 300;
int HEIGHT = WIDTH;
float MID = 128;

int f = 0;
float t = 0;
float NORMALIZE = WIDTH/(2*PI)/2;

int[][] clookup = new int[3][256]; 

void setup() {
  size(WIDTH, HEIGHT);
  println("Normalize factor is: "+NORMALIZE+"\nMaking lookup tables");
  for (int i=0; i<256; i++) {
    clookup[0][i] = floor(MID*sin(PI*i/MID)+MID);
    clookup[1][i] = floor(MID*cos(PI*i/MID)+MID);
    clookup[2][i] = floor(MID*sin(PI*i/20)+MID); //lowish divisors give a posterized effect
  }
  println("Done, starting plasma");
}

float distance(float x1, float y1, float x2, float y2) {
  return sqrt(sq(x2-x1)+sq(y2-y1));
}

void draw() {
  for(int y=0; y<HEIGHT; y++) {
    for(int x=0; x<WIDTH; x++) {
      float h = floor(MID+sin(distance(x, y, (MID * sin(-t) + (WIDTH/2)), (MID * cos(-t) + (HEIGHT/2)))/NORMALIZE)*MID);
      float g = floor(MID+sin(x/NORMALIZE+t)*MID);
      float i = floor(MID+sin(y/NORMALIZE+t)*MID);      
      f = floor((g+h+i)/3);
      color c = color(clookup[0][f], clookup[1][f], clookup[2][f]);
      set(x, y, c);
    } 
  }
  t += 0.1;
}
void mousePressed() {
}
