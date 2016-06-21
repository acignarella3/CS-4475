public class Layer {
  
  PImage layer; 
  PImage mask;
  int x;
  int y;
  
  public Layer(PImage layer, PImage mask, int x, int y) {
    
    this.layer = layer;
    this.mask = mask;
    this.x = x;
    this.y = y;
    
  }
  
}
