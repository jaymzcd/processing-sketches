/*
 * Convolver
 * ~jaymz 25/01/10
 *
 */

import javax.swing.JFileChooser;

PImage img;
int x;
int y;
int step = 1;
int windowSize = 50;
PFont font;
boolean neg = false;

int[] kernel = { -1, 0, 1, -2, 0, 2, -1, 0, 1 };
float strength = 5;

void setup() {
  JFileChooser chooser = new JFileChooser("/home/jaymz/pictures/color-workout/");
  chooser.setFileFilter(chooser.getAcceptAllFileFilter());
  int returnVal = chooser.showOpenDialog(null);
  if (returnVal == JFileChooser.APPROVE_OPTION) 
  {
    img = loadImage(chooser.getSelectedFile().getPath());
    size(img.width, img.height);
    background(0);
    smooth();
    noStroke();
  } else {
    exit();
  }
}

int alignCenter(int input){
 return (input-windowSize/2);
}

void keyPressed() {
   if(key=='z') {
      windowSize += 10;
   } 
   if(key=='x'&&windowSize>0) {
      windowSize -= 10;
   } 
   if(key=='a') {
      step += 1;
   } 
   if(key=='s'&&step>0) {
      step -= 1;
      if(step==0) {
        step = 1;
      }
   } 
   if(key=='q') {
      strength += 1;
   } 
   if(key=='w'&&step>0) {
      strength -= 1;
      if(strength==0) {
        strength = 1;
      }
   } 
   if(key=='-') {
      neg = true; 
   }
   if(keyCode>95&&keyCode<106) {
     int inp = int(keyCode-96);
     if(neg==true) {
       inp = inp*-1;
       neg = false;
     }
     println(inp);
     kernel = subset(splice(kernel, inp, 0), 0, 8);
   }
   println("Strength: "+strength);
   println("Sampling (px): "+step);
   println("Window size: "+windowSize+"px");
   println("Convolution Kernel: "+dumpKernel());
}

String dumpKernel() {
  String out = "";
  for(int i=0; i<kernel.length; i++) {
    out = out + " " + kernel[i];
  }
  return out;
}

void draw() {
  float[] drawKernel = new float[9];
  for(int i=0; i<kernel.length; i++) {
   drawKernel[i] = kernel[i]*strength; 
  }
  image(img, 0, 0);
  loadPixels();
  if(mousePressed==true) {
    noCursor();
    noStroke();
    for (int y=alignCenter(mouseY); y<(alignCenter(mouseY)+windowSize); y+=step) {
       for (int x=alignCenter(mouseX); x<(alignCenter(mouseX)+windowSize); x+=step) {
           int cnt = 0;
           int[] val = {0, 0, 0};
           for (int j=(y-1); j<(y+2); j++) {
             for (int i=(x-1); i<(x+2); i++) {
               try {
                 color cp = pixels[j*img.width+i];
                  val[0] += (cp>>16&0xFF)*drawKernel[cnt];
                  val[1] += (cp>>8&0xFF)*drawKernel[cnt];                
                  val[2] += (cp&0xFF)*drawKernel[cnt++];                
               } catch (ArrayIndexOutOfBoundsException e) {
               }
             }
           }
           try {
             val[0] /= cnt;
             val[1] /= cnt;
             val[2] /= cnt;
             color c = color(val[0], val[1], val[2]);
             if(step==1) {
               set(x, y, c);
             } else {
               fill(c);
               rect(x, y, step, step);
             }
           } catch(ArithmeticException e) {
             
           }
      }
    }
  } else {
    cursor();
  }
  noFill();
  stroke(255);
  rect(mouseX-(windowSize/2), mouseY-(windowSize/2), windowSize, windowSize);
}

