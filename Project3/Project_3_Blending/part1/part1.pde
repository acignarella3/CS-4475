//This code blends two images of equivalent size
//By: Alexander Cignarella

PImage canvas; //canvas image
PImage layer; //layer image
PImage m; //mask image

void setup(){
  //load canvas and setup the screen
  canvas = loadImage("coke.png");
  size(canvas.width, canvas.height);
  
  //setup layers
  
  //setup layers
  layer = loadImage("pepsi.png");
  m = loadImage("mask.png");
}

void draw(){
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


  //go through the x and y coordinates of the mask
  for (int i = 0; i < m.width; i++) {
    
    for (int j = 0; j < m.height; j++) {
      
          //get the colors of the canvas, layer, and mask
          color getCanvas = canvas.get(i,j);
          color getLayer = layer.get(i,j);
          color getMask = m.get(i,j);
    
          //scale the mask
          float masked = red(getMask) / 255;
    
          //calculate RGB values using the provided formula
          float R = (masked * red(getLayer)) + ((1 - masked) * red(getCanvas));
          float G = (masked * green(getLayer)) + ((1 - masked) * green(getCanvas));
          float B = (masked * blue(getLayer)) + ((1 - masked) * blue(getCanvas));
          
          //use these RGB values to create a color
          color blend = color(R, G, B);
    
          //place this color into the pixels array at the right spot
          pixels[pixIX(i,j)] = blend;
          
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
    save("part1.png");
  }
}

//get the array index of a pixel in the pixels array given its x and y location
int pixIX(int x, int y){
  return x + y*width;
}
