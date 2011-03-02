import javax.swing.JFileChooser;

PImage img;
int pointillize = 1;
int target;
int x;
int y;
boolean finish = false;
int step = 25;
int tolerance = 255;

void setup() {
  JFileChooser chooser = new JFileChooser("/home/jaymz/development/processing/processing-sketches/color_clickmatch/");
  chooser.setFileFilter(chooser.getAcceptAllFileFilter());
  int returnVal = chooser.showOpenDialog(null);
  if (returnVal == JFileChooser.APPROVE_OPTION) 
  {
    img = loadImage(chooser.getSelectedFile().getPath());
    x = int(random(img.width));
    y = int(random(img.height));
    size(img.width, img.height);
    target = x + y*img.width;
    background(0);
    smooth();
  } else {
    exit();
  }
}

void draw() {
  loadPixels();
  int ttarget = 0;
  int alphav = 128;

  if (!finish) {
    for (int y=0; y<img.height; y+=step) {
       for (int x=0; x<img.width; x+=step) {
          target  = x+y*img.width;
          float sr = red(img.pixels[target]);
          float sg = green(img.pixels[target]);
          float sb = blue(img.pixels[target]);
          fill(sr,sg,sb,alphav);
          //ellipse(x,y,pointillize,pointillize);
          pointillize = (int)random(1*step)+floor(step/2);
          alphav = (int)random(10)+5;
          stroke(sr,sg,sb,alphav);
          for (int j=0; j<img.height; j+=step*2) {
             for (int i=0; i<img.width; i+=step*2) { 
                ttarget = i+j*img.width;
                float tr = red(img.pixels[ttarget]);
                float tg = green(img.pixels[ttarget]);
                float tb = blue(img.pixels[ttarget]);
                if( (tr>=(sr-tolerance)) && (tr<=(sr+tolerance)) ) {
                    //ellipse(i,j,pointillize,pointillize);
                    line(i,j,x,y);
                }
             }
          }
          print("finished scanning point ("+x+","+y+")\n");
       }
    }
    finish=true;
  }
  
}
