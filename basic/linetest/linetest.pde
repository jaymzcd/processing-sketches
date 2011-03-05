PImage b;



void setup() {
  size(300, 300);
  b = loadImage("linetest.png");
  noLoop();
  println("about to start...");
}

void draw() {
  image(b, 0, 0); 
  loadPixels();

  for(int i=0; i<width*height; i++) {
    if(hex(pixels[i], 6).equals("000000")) {
      println("black found at "+i);      
    }
  }
}
