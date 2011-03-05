 
PImage img;       // The source image
int cellsize = 10; // Dimensions of each cell in the grid
int columns, rows;   // Number of columns and rows in our system
float cnt = 0;

float w = .01;
float a = 2;
int t = 0;
float phi = 0;

float ZDIR = -1;

boolean update_image = true;

void setup() {
  size(600, 600, P3D); 
  img = loadImage("avril.png");  // Load the image
  columns = (img.width<width) ? img.width / cellsize : width / cellsize;  // Calculate # of columns
  rows = (img.height<height) ? img.height / cellsize : height / cellsize;  // Calculate # of columns
}

void keyPressed() {
 if(key=='z') {
   ZDIR = -1*ZDIR;
 } 
}

void mouseClicked() {
  update_image = !update_image;  
}

void draw() {
  background(0);
  // Begin loop for columns
  if(update_image) {
    for ( int i = 0; i < columns; i++) {
      // Begin loop for rows
      for ( int j = 0; j < rows; j++) {
        int x = i*cellsize + cellsize/2;  // x position
        int y = j*cellsize + cellsize/2;  // y position
        int loc = x + y*img.width;  // Pixel array location
        color c = img.pixels[loc];  // Grab the color
        // Calculate a z position as a function of mouseX and pixel brightness
        float z = 25*ZDIR*sin(dist(mouseX, mouseY, x, y)/50+phi);
        // Translate to the location, set fill and stroke, and draw the rect
        pushMatrix();
        //float x2 = x + a*sin(j/w+phi);
        //float y2 = y + a*sin(i/w+phi);
        float x2 = x;
        float y2 = y;
        translate(x2, y2, z);
        fill(c);
        noStroke();
        rectMode(CENTER);
        
        rect(0, 0, cellsize+2, cellsize+2);
        popMatrix();
      }
    }

    
    phi += .1;

  }
}

