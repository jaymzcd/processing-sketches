ArrayList particles;
ArrayList blocks;
int t = 0;
int pcnt = 0;
int frameCnt = 0;
boolean DRAW_BLOCKS = false;
boolean REPAINT = false;

int FRAMERATE = 60;
int WIDTH = 800;
int HEIGHT = 600;
int MAX_PARTICLES = 1250;
int VIS_MODE = 1; // 0 for rect, 1 for ellipse
PVector G = new PVector(0, .05);

PVector m_now, m_prev, m_velocity;

int[][] block_data = { 
  {0, 160, 400, 20},
};

void keyPressed() {
  if(keyCode==LEFT) {
    MIN_HUE-=10;
    MIN_HUE = (MIN_HUE<0) ? 0 : MIN_HUE;
    MAX_HUE-=10;
    MAX_HUE = (MAX_HUE<50) ? 50 : MAX_HUE;
  }
  if(keyCode==RIGHT) {
    MIN_HUE+=10;
    MIN_HUE = (MIN_HUE>205) ? 205 : MIN_HUE;
    MAX_HUE+=10;
    MAX_HUE = (MAX_HUE>255) ? 255 : MAX_HUE;
  }
  if(keyCode==UP) {
    G.add(new PVector(0, 0.01));
  }
  if(keyCode==DOWN) {
    G.sub(new PVector(0, 0.01)); 
  }
  if(key=='v') {
    VIS_MODE = (VIS_MODE==1) ? 0 : 1; 
  }
  if(key=='p') {
    REPAINT = (REPAINT==true) ? false : true;
  }
  if(key=='z') {
    G = new PVector(0, 0); 
  }
  if(key=='b') {
    DRAW_BLOCKS = (DRAW_BLOCKS==true) ? false : true; 
  }
  if(keyCode==32) {
    particles = new ArrayList();
  }
  G.limit(.1);
  println("Gravity now "+G);
}

void setup() {
  particles = new ArrayList();
  blocks = new ArrayList();
  size(WIDTH, HEIGHT);
  frameRate(FRAMERATE);
  background(0);
  noStroke();
  smooth();
  fill(255);
  ellipseMode(CENTER);
  for(int i=0; i<block_data.length; i++) {
    blocks.add(new Block(block_data[i], "block"+i));    
  }
  m_now = new PVector(mouseX, mouseY);
  m_prev = m_now;
}

void mouseDragged() {
  m_now = new PVector(mouseX, mouseY);
  m_velocity = PVector.sub(m_now, m_prev);
  m_velocity.div(2);
  m_prev = m_now.get();
}

void draw() {
  if(REPAINT) {
    background(0);
  }
  if(mousePressed==true&&particles.size()<MAX_PARTICLES&&m_velocity!=null) {
    for(int i=5; i<8; i++) {
      pcnt++;
      particles.add(new Particle(mouseX+i*random(-5,5), mouseY+i*random(-5,5), m_velocity.get(), "Particle "+pcnt));
    }
  }
  if(DRAW_BLOCKS) {
    for(int i=0; i<block_data.length; i++) {
      Block b = (Block)blocks.get(i);
      b.draw();
    }  
  }
  for(int i=0; i<particles.size(); i++) {
    Particle p = (Particle)particles.get(i);
    p.update();
    if(p.dead()) {
      particles.remove(i); 
    }
    if(DRAW_BLOCKS) {
      for(int j=0; j<blocks.size(); j++) {
         Block b = (Block)blocks.get(j);
         if(collision(p, b)) {
           p.doCollision(b);
         }
      }
    }
  } 
  t++;
  if(++frameCnt%FRAMERATE==0) {
    //println("Particles in system: "+particles.size());
  }
}

float distance(float x1, float y1, float x2, float y2) {
  return sqrt(sq(x2-x1)+sq(y2-y1));
}

boolean collision(Particle p, Block b) {
  if((p.location.y+p.psize>b.ypos&&p.location.y<(b.ypos+b.bheight))&&(p.location.x+p.psize>b.xpos&&p.location.x<(b.xpos+b.bwidth))) {
    return true; 
  }
  return false;
}


