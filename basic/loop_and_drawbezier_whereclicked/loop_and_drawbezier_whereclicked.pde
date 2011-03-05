import javax.swing.JFileChooser;

PImage img;
int pointillize = 16;
int target;
int x;
int y;
boolean finish = false;
int step = 5;
int tolerance = 100;

void setup() {
  JFileChooser chooser = new JFileChooser("/home/jaymz/pictures/");
  chooser.setFileFilter(chooser.getAcceptAllFileFilter());
  int returnVal = chooser.showOpenDialog(null);
  if (returnVal == JFileChooser.APPROVE_OPTION) 
  {
    img = loadImage(chooser.getSelectedFile().getPath());
    size(img.width, img.height);
    if(img.width*img.height>100000) {
      step = floor(sqrt(((img.width*img.height)/1000))); 
    }
    print("total pixels: "+(img.width*img.height)+", using step size "+step);
    background(0);
    smooth();
  } else {
    exit();
  }
}

void draw() {
  int ttarget = 0;
  int alphav = 128;
  if(mousePressed==true) {
    loadPixels();
    x = mouseX;
    y = mouseY;
    target  = x+y*img.width;
    try {
      
      float sr = red(img.pixels[target]);
      float sg = green(img.pixels[target]);
      float sb = blue(img.pixels[target]);
      fill(sr,sg,sb,alphav);
      ellipse(x,y,pointillize,pointillize);
      pointillize = 3;
      alphav = (int)random(10)+5;
      stroke(sr,sg,sb,alphav);
      for (int j=0; j<img.height; j+=step*2) {
         for (int i=0; i<img.width; i+=step*2) { 
            ttarget = i+j*img.width;
            float tr = red(img.pixels[ttarget]);
            float tg = green(img.pixels[ttarget]);
            float tb = blue(img.pixels[ttarget]);
            if( (tr>=(sr-tolerance)) && (tr<=(sr+tolerance)) && 
                (tg>=(sg-tolerance)) && (tg<=(sg+tolerance)) && 
                (tb>=(sb-tolerance)) && (tb<=(sb+tolerance)) 
              ) {
                noFill();
                ellipse(i,j,pointillize,pointillize);
                bezier(x, y, x+random(3*step), y+random(3*step), i-random(3*step), j-random(3*step), i, j);
            }
          print("source: ("+x+", "+y+") - scanning point ("+i+", "+j+")\n");
        }
      }
    } catch(ArrayIndexOutOfBoundsException e) {

    }
  }
}

