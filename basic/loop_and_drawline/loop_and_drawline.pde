import javax.swing.JFileChooser;

PImage img;
int pointillize = 16;
int target;
int x;
int y;
boolean finish = false;
int step = 5;
int tolerance = 50;

void setup() {
  JFileChooser chooser = new JFileChooser("/tmp/");
  chooser.setFileFilter(chooser.getAcceptAllFileFilter());
  int returnVal = chooser.showOpenDialog(null);
  if (returnVal == JFileChooser.APPROVE_OPTION) 
  {
    img = loadImage(chooser.getSelectedFile().getPath());
    size(img.width, img.height);
    
    if(img.width>500) {
     step = img.width/50; 
    }
    
    background(0);
    smooth();
  } else {
    exit();
  }
}

void draw() {
  int ttarget = 0;
  int alphav = 128;
  loadPixels();
  if (!finish) {
    for (int y=0; y<img.height; y+=step) {
       for (int x=0; x<img.width; x+=step) {

          target  = x+y*img.width;
          float sr = red(img.pixels[target]);
          float sg = green(img.pixels[target]);
          float sb = blue(img.pixels[target]);
          fill(sr,sg,sb,alphav);
          ellipse(x,y,pointillize,pointillize);
          pointillize = (int)random(1*step)+floor(step/2);
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

