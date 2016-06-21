PImage canvas; //canvas image
PImage layer; //layer image
PImage m; //mask image
Layer l;

void setup(){
  //load canvas and setup the screen
  canvas = loadImage("cage.png");
  size(canvas.width, canvas.height);
  
  //setup layers
  
  //setup layers
  layer = loadImage("hoff.png");
  m = loadImage("mask.png");
  
  l = new Layer(layer, m, 0, 0);
}

void draw(){
  //MOVE THE LAYER WITH THE MOUSE
  
  if (mousePressed) {
    
    l.x += mouseX - pmouseX;
    l.y += mouseY - pmouseY;
    
  }
  
  //load the pixels array for manipulation
  loadPixels();
  
  //copy the canvas image onto the screen
  for(int x=0; x<width; x++){
    for(int y=0; y<height; y++){
      //get the index in the pixel array for the pixel at x,y
      int ix = pixIX(x, y);
      //set the pixel color to that of the canvas image
      pixels[ix] = canvas.get(x,y); //remember that PImage.get(x,y) returns a color
    }
  }

  //YOUR CODE HERE
  
  for (int i = 0; i < l.mask.width; i++) {
    
    for (int j = 0; j < l.mask.height; j++) {
      
          if (l.x + i < width && l.y + j < height && l.x + i >= 0 && l.y + j >= 0) {
      
            color getCanvas = canvas.get(i+l.x,j+l.y);
            color getLayer = l.layer.get(i,j);
            color getMask = l.mask.get(i,j);
    
            float masked = red(getMask) / 255;
    
            float R = (masked * red(getLayer)) + ((1 - masked) * red(getCanvas));
            float G = (masked * green(getLayer)) + ((1 - masked) * green(getCanvas));
            float B = (masked * blue(getLayer)) + ((1 - masked) * blue(getCanvas));
     
            color blend = color(R, G, B);
            
            int pic = pixIX(i+l.x,j+l.y);
            
            if (pic < pixels.length && pic >= 0) {
    
              pixels[pic] = blend;
              
            }
            
          }
          
    }
    
  }
  
  //update the screen with the pixels we have set
  updatePixels();
}

void keyPressed(){
  //println((int)key);
  if((key >=48) && (key <= 57)){
    //switch the active layer
  }else if(key == 's'){
    //save("out.png");
  }
}

//get the array index of a pixel in the pixels array given its x and y location
int pixIX(int x, int y){
  return x + y*width;
}
