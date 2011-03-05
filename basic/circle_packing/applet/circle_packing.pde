int _radius = 10;
int target;
int x;
int y;
int _width = 800;
int _height = 600;
ArrayList circles = new ArrayList();

class Circle {
  int radius;
  PVector position;
  
  Circle(int r, float px, float py) {
    radius = r;
    position = new PVector(px, py); 
  }

  void draw() {
    ellipse(position.x, position.y, radius, radius);
  }  
}

void setup() {
  background(0);
  smooth();
  stroke(255);
  fill(0);
  size(_width, _height);
}

void keyPressed() {
  if(key==32) {
    drawMidCircles();
  }
}

boolean doesntExist(PVector current) {
   for(int x=0; x<circles.size()-1; x++) {
     Circle c = (Circle)circles.get(x);
     if (current.x==c.position.x&&current.y==c.position.y) {
       return false;
     } 
   }
   return true;
}

void mouseReleased() {
  circles.add(new Circle(int(random(20, 200)), mouseX, mouseY));
  Circle c = (Circle)circles.get(circles.size()-1);
  c.draw();
  println("added a circle at "+mouseX+","+mouseY+" : now "+circles.size());
} 

void draw() {
  //PVector current = new PVector(mouseX, mouseY);

}

void drawMidCircles() {
   for(int x=0; x<circles.size()-1; x++) {
     Circle c = (Circle)circles.get(x);
     for(int y=0; y<circles.size()-1; y++) {
       Circle d = (Circle)circles.get(y);
       if(d!=c) {
         line(c.position.x, c.position.y, d.position.x, d.position.y); 
       }
     }
   }
}
