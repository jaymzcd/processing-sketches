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
    ellipse(position.x, position.y, radius*2, radius*2);
  }  
}

void setup() {
  background(0);
  smooth();
  stroke(255);
  noFill();
  size(_width, _height);
}

void keyPressed() {
  if(key==32) {
    drawMidCircles();
  }
  if(key=='a') {
    background(0); 
    circles = new ArrayList();     
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
  circles.add(new Circle(int(random(5, 70)), mouseX, mouseY));
  Circle c = (Circle)circles.get(circles.size()-1);
  c.draw();
  println("added a circle at "+mouseX+","+mouseY+" : now "+circles.size());
  if(circles.size()>1){
    //drawMidCircles();  
  }
} 

void draw() {
  //PVector current = new PVector(mouseX, mouseY);

}

void drawMidCircles() {
  for(int y=0; y<circles.size()-1; y++) {
    Circle c1 = (Circle)circles.get(y);
    Circle c2 = (Circle)circles.get(y+1);
    PVector v = new PVector((c1.position.x-c2.position.x), (c1.position.y-c2.position.y));
    v.normalize();
    float d = c2.position.dist(c1.position);
    PVector edge_c2 = new PVector(c2.position.x+v.x*c2.radius, c2.position.y+v.y*c2.radius);
    PVector edge_c1 = new PVector(c2.position.x+v.x*(d-c1.radius), c2.position.y+v.y*(d-c1.radius));
    PVector midpoint = new PVector((edge_c2.x+edge_c1.x)/2, (edge_c2.y+edge_c1.y)/2);
    float s = edge_c2.dist(edge_c1);
    ellipse(midpoint.x, midpoint.y, s, s);
    line(edge_c2.x, edge_c2.y, edge_c1.x, edge_c1.y);
  }
}


