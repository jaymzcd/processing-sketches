import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class circle_packing extends PApplet {

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

  public void draw() {
    ellipse(position.x, position.y, radius, radius);
  }  
}

public void setup() {
  background(0);
  smooth();
  stroke(255);
  fill(0);
  size(_width, _height);
}

public void keyPressed() {
  if(key==32) {
    drawMidCircles();
  }
}

public boolean doesntExist(PVector current) {
   for(int x=0; x<circles.size()-1; x++) {
     Circle c = (Circle)circles.get(x);
     if (current.x==c.position.x&&current.y==c.position.y) {
       return false;
     } 
   }
   return true;
}

public void mouseReleased() {
  circles.add(new Circle(PApplet.parseInt(random(20, 200)), mouseX, mouseY));
  Circle c = (Circle)circles.get(circles.size()-1);
  c.draw();
  println("added a circle at "+mouseX+","+mouseY+" : now "+circles.size());
} 

public void draw() {
  //PVector current = new PVector(mouseX, mouseY);

}

public void drawMidCircles() {
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

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#DFDFDF", "circle_packing" });
  }
}
