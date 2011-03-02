/**
 * Load and Display 
 * 
 * Images can be loaded and displayed to the screen at their actual size
 * or any other size. 
 */
 
PImage img;  // Declare variable "a" of type PImage
int columns, rows;   // Number of columns and rows in our system
int cellsize = 2;

void setup() {
  size(600, 600, P3D);
  img = loadImage("logo.png");  // Load the image into the program  
  columns = img.width / cellsize;  // Calculate # of columns
  rows = img.height / cellsize;  // Calculate # of rows
  print(columns+"x"+rows);
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  background(0);
  for ( int i = 0; i < columns; i++) {
    for ( int j = 0; j < rows; j++) {  
      int x = i*cellsize + cellsize/2;  // x position
      int y = j*cellsize + cellsize/2;  // y position
      int loc = x + y*img.width;  // Pixel array location
      //print("loc is "+loc+"\n");
      color c = img.pixels[loc];  // Grab the color
      //print ("Color is "+c);
      // Calculate a z position as a function of mouseX and pixel brightness
      float z = (mouseX / float(width)) * brightness(img.pixels[loc]) - 20.0;
      // Translate to the location, set fill and stroke, and draw the rect
      pushMatrix();
      translate(x+rows, y+columns, z);
      fill(c, 204);
      noStroke();
      rectMode(CENTER);
      rect(0, 0, cellsize, cellsize);
      popMatrix();      
    }
  }
  
//  image(img, 0, 0); 
}
