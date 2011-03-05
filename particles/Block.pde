class Block {
  int xpos, ypos, bwidth, bheight;
  String name;
  
  Block(int init[], String name) {
    xpos = init[0];
    ypos = init[1];
    bwidth = init[2];
    bheight = init[3]; 
    this.name = name;
  }
  
  void draw() {
    fill(255);
    rect(xpos, ypos, bwidth, bheight); 
  }
  
}
