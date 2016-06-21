//This code creates 10 layers on a canvas, each of which can be moved at will.
//Pressing 0-9 on the keyboard determines which layer is moved at a time.
//By: Alexander Cignarella

PImage canvas; //canvas image
PImage layer0, layer1, layer2, layer3, layer4, layer5, layer6, layer7, layer8, layer9; //layer image
PImage m0, m1, m2, m3, m4, m5, m6, m7, m8, m9; //mask image
Layer l0, l1, l2, l3, l4, l5, l6, l7, l8, l9;
Layer[] layers = new Layer[10];
Layer chosen;

void setup(){
  //load canvas and setup the screen
  canvas = loadImage("backdrop.png");
  size(canvas.width, canvas.height);
  
  //setup layers
  
  //setup layers
  layer0 = loadImage("moon.png");
  layer1 = loadImage("cage.png");
  layer2 = loadImage("hoff.png");
  layer3 = loadImage("guan.png");
  layer4 = loadImage("thing.png");
  layer5 = loadImage("box.png");
  layer6 = loadImage("doorknob.png");
  layer7 = loadImage("shadow.png");
  layer8 = loadImage("armorine.png");
  layer9 = loadImage("deadpool.png");
  
  //setup masks
  m0 = loadImage("moonMask.png");
  m1 = loadImage("cageMask.png");
  m2 = loadImage("hoffMask.png");
  m3 = loadImage("guanMask.png");
  m4 = loadImage("thingMask.png");
  m5 = loadImage("boxMask.png");
  m6 = loadImage("doorknobMask.png");
  m7 = loadImage("shadowMask.png");
  m8 = loadImage("armorineMask.png");
  m9 = loadImage("deadpoolMask.png");
  
  //create Layers
  l0 = new Layer(layer0, m0, 50, 50);
  l1 = new Layer(layer1, m1, 50, 50);
  l2 = new Layer(layer2, m2, 50, 50);
  l3 = new Layer(layer3, m3, 50, 50);
  l4 = new Layer(layer4, m4, 50, 50);
  l5 = new Layer(layer5, m5, 50, 50);
  l6 = new Layer(layer6, m6, 50, 50);
  l7 = new Layer(layer7, m7, 50, 50);
  l8 = new Layer(layer8, m8, 50, 50);
  l9 = new Layer(layer9, m9, 50, 50);
  
  //insert into array
  layers[0] = l0;
  layers[1] = l1;
  layers[2] = l2;
  layers[3] = l3;
  layers[4] = l4;
  layers[5] = l5;
  layers[6] = l6;
  layers[7] = l7;
  layers[8] = l8;
  layers[9] = l9;
  
  //set initial layer to move
  chosen = layers[0];
  
}

void draw(){
  //MOVE THE LAYER WITH THE MOUSE
  
  if (mousePressed) {
    
    //adjust the position only of the chosen layer
    chosen.x += mouseX - pmouseX;
    chosen.y += mouseY - pmouseY;
    
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
  
  //navigagte through each layer in the array
  for (int n = 0; n < layers.length; n++) {
    
    //navigate through the layer's x and y coordinates
    for (int i = 0; i < layers[n].mask.width; i++) {
    
      for (int j = 0; j < layers[n].mask.height; j++) {
        
          //make sure the value is within the window
          if (layers[n].x + i < width && layers[n].y + j < height && layers[n].x + i >= 0 && layers[n].y + j >= 0) {
            
            //find the corresponding pixel in the pixels array
            int pic = pixIX(i+layers[n].x,j+layers[n].y);
            
            //proceed only if there is a match
            if (pic < pixels.length && pic >= 0) {
              
              //get the color of the canvas, layer, and mask
              //using the pixels array for the canvas allows it to be easily changed throughout the loop
              color getCanvas = pixels[pic];
              color getLayer = layers[n].layer.get(i,j);
              color getMask = layers[n].mask.get(i,j);
    
              //scale down the mask
              float masked = red(getMask) / 255;
  
              //get the RGB values for the color
              float R = (masked * red(getLayer)) + ((1 - masked) * red(getCanvas));
              float G = (masked * green(getLayer)) + ((1 - masked) * green(getCanvas));
              float B = (masked * blue(getLayer)) + ((1 - masked) * blue(getCanvas));
     
              color blend = color(R, G, B);
    
              //insert this color into the pixels array
              pixels[pic] = blend;
              
          }
          
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
    //make the chosen layer the one corresponding to the key pressed
    chosen = layers[key-48];
  }else if(key == 's'){
    save("part3.png");
  }
}

//get the array index of a pixel in the pixels array given its x and y location
int pixIX(int x, int y){
  return x + y*width;
}
