import javax.swing.JFileChooser;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

    
PImage img;
int pointillize = 16;
int target;
int x;
int y;
boolean finish = false;
int step = 15;
int tolerance = 100;

private int flipFlag() {
  return ((int)random(2)==1) ? -1 : 1;
}

private String getDateTime() {
    DateFormat dateFormat = new SimpleDateFormat("MMdd-HHmmss");
    Date date = new Date();
    return dateFormat.format(date);
}

void setup() {
  JFileChooser chooser = new JFileChooser("/home/jaymz/Desktop/processing-code/source-images/");
  chooser.setFileFilter(chooser.getAcceptAllFileFilter());
  int returnVal = chooser.showOpenDialog(null);
  if (returnVal == JFileChooser.APPROVE_OPTION) 
  {
    img = loadImage(chooser.getSelectedFile().getPath());
    size(img.width, img.height);
    if(img.width*img.height>=100000) {
      step = floor(sqrt(((img.width*img.height)/1000))); 
    }
    print("total pixels: "+(img.width*img.height)+", using step size "+step+"\n");
    background(0);
    smooth();
  } else {
    exit();
  }
}

void draw() {
  int ttarget = 0;
  int alphav = 10;
  
  if(mousePressed==true) {
    
    x = mouseX;
    y = mouseY;
  
    loadPixels();

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
                int[] flips = {flipFlag(), flipFlag(), flipFlag(), flipFlag()};
                print(flips[0]);
                bezier(x, y, flips[0]*(x+random(3*step)), flips[1]*(y+random(3*step)), flips[2]*(i-random(3*step)), flips[3]*(j-random(3*step)), i, j);
            }
        }
      }
      print("source: ("+x+", "+y+") - done\n");
      
    } catch(ArrayIndexOutOfBoundsException e) {

    }
  }    
}


