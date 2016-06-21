//Project 4
//Solution

PImage im; //the canvas image
int activeLayer = -1; //start with no selected layer
int texttimer = 0; //use this to determine how long to leave text on the screen
Layer[] layers = new Layer[10]; //an array of layer object. Change the size if you want.

void setup(){
  //im = loadImage("cagehead.png");
  im = createImage(1450,600,RGB); //create a 300x300 blank image (black)
  size(im.width, im.height);
  frame.setResizable(true);//allow the test cases to resize the window
  
  //setup layers
  //layers[0] = new Layer("apple.png");
  layers[0] = new Layer("shot1.jpg", 177,261,0.0,0.42000043,0.46000046);
  layers[1] = new Layer("shot2.jpg", 17,318,0.0,0.20000036,0.20000036);
  layers[2] = new Layer("shot3.jpg", 499,263,0.0,0.42000043,0.5000005);
  layers[3] = new Layer("shot4.jpg", 794,275,0.0,0.44000044,0.48000047);
  layers[4] = new Layer("shot5.jpg", 973,300,0.0,0.46000046,0.46000046);
  layers[5] = new Layer("shot6.jpg", 962,375,8.0,0.22000036,0.22000036);
  layers[6] = new Layer("shot7.jpg", 1114,309,-6.0,0.3400004,0.3400004);
  layers[7] = new Layer("shot8.jpg", 441,224,4.0,0.44000044,0.44000044);
 
}

void draw(){
  //load the pixels array for manipulation
  loadPixels();
  
  //copy the canvas image onto the screen over previous image
  //this clears the pixels array for the layers to be drawn on top
  for(int x=0; x<width; x++){
    for(int y=0; y<height; y++){
      //get the index in the pixel array for the pixel at x,y
      int ix = pixIX(x, y);
      //set the pixel color to that of the canvas image
      pixels[ix] = im.get(x,y); //remember that PImage.get(x,y) returns a color
    }
  }
  
  //move the selected layer with the mouse
  if(mousePressed){
    if(activeLayer >= 0){
      if(layers[activeLayer] != null){
        layers[activeLayer].x += mouseX-pmouseX;
        layers[activeLayer].y += mouseY-pmouseY;
      }
    }
  }
  
  //draw the layers
  for(int i=0; i<layers.length; i++){
    if(layers[i] == null)
      break;
    PImage l = rotated(scaled(layers[i].im, layers[i].sx, layers[i].sy), layers[i].angle); //rotated and scaled layer image
    
    //clip the layer image to the dimensions of the canvas
    int endx =  min(width-layers[i].x, l.width);
    int endy =  min(height-layers[i].y, l.height);
    int startx = layers[i].x >= 0 ? 0 : -layers[i].x;
    int starty = layers[i].y >= 0 ? 0 : -layers[i].y;
    
    //draw the layer onto the canvas, with translation
    for(int x=startx; x< endx; x++){
      for(int y=starty; y< endy; y++){
        color c = l.get(x,y);
        if(alpha(c) > 0)
          pixels[pixIX(x+layers[i].x, y+layers[i].y)] = c;
      }
    }
  }
  
  //update the screen with the pixels we have set
  updatePixels();
  
  //after drawing the image, draw text on top
  //this text appears if a layer was selected in that last second
  if(texttimer > 0){
    fill(0, 0, 0);
    textSize(32);
    text("Active Layer: " + activeLayer, 10, 30);
    texttimer--;
  } 
}

//get the array index of a pixel in the pixels array given its x and y location
int pixIX(int x, int y){
  return x + y*width;
}

//return a scaled version of the image
PImage scaled(PImage im, float sx, float sy){
  //you must code this function
  
  //get the window dimensions (makes it easier to call)
  int w = im.width;
  int h = im.height;
  
  //find the new dimensions based on sx and sy
  int newWidth = (int) (w * sx);
  int newHeight = (int) (h * sy);
  
  //create a new image using new dimensions
  PImage scale = createImage(newWidth, newHeight, RGB);
  
  //cycle through all pixels in the new image
  for (int x = 0; x < scale.width; x++) {
    
    for (int y = 0; y < scale.height; y++) {

        //get new pixel points by dividing by scale factors
        int newX = (int) (x / sx);
        int newY = (int) (y / sy);
        
        //get color using new points
        color c = im.get(newX, newY);
        
        //set color on this pixel
        scale.set(x, y, c);
      
    }
    
  }
  
  return scale;
  
}

//return a rotated version of the image
PImage rotated(PImage im, float angle){
  //you must code this function
  
  //find window dimensions and angle in radians
  int w = im.width;
  int h = im.height;
  float a = radians(angle);
  
  //these arrays will carry the x and y coordinates of the image's corners
  float[] cornerX = new float[4];
  float[] cornerY = new float[4];
  
  //x-coordinates of the corners after translating so that origin is at center of pic
  cornerX[0] = -w/2;
  cornerX[1] = w/2;
  cornerX[2] = -w/2;
  cornerX[3] = w/2;
  
  //y-cooridnates of the corners after above translation
  cornerY[0] = -h/2;
  cornerY[1] = -h/2;
  cornerY[2] = h/2;
  cornerY[3] = h/2;
  
  //these max and min values are set in order to guarentee that they are overwritten
  float maxX = -9999.0;
  float minX = 9999.0;
  float maxY = -9999.0;
  float minY = 9999.0;
  
  //go through both arrays
  for (int i = 0; i < 4; i++) {
    
    //grab the chosen values
    int oldx = (int) cornerX[i];
    int oldy = (int) cornerY[i];
    
    //apply rotation matrix to values
    cornerX[i] = (oldx*cos(a)) - (oldy*sin(a));
    cornerY[i] = (oldx*sin(a)) + (oldy*cos(a));
    
    //replace max if greater (need to find highest point for width)
    if (cornerX[i] > maxX) {
      
      maxX = cornerX[i];
      
    }
    
    //replace min if lesser (need to find lowest point for width)
    if (cornerX[i] < minX) {
      
      minX = cornerX[i];
      
    }
    
    //repeat for max and min for height
    if (cornerY[i] > maxY) {
      
      maxY = cornerY[i];
      
    }
    
    if (cornerY[i] < minY) {
      
      minY = cornerY[i];
      
    }
    
  }
  
  //find new dimensions as difference of the max and min values
  int newW = (int) (maxX - minX);
  int newH = (int) (maxY - minY);
  
  //create new image based on these dimensions, while also allowing changes to alpha
  PImage rotate = createImage(newW,newH,ARGB);
  
  //go through each pixel
  for (int x = 0; x < rotate.width; x++) {
    
    for (int y = 0; y < rotate.height; y++) {
      
      //translate so origin is in center
      int newX = x - (int) (newW / 2);
      int newY = y - (int) (newH / 2);
      
      //apply inverse rotation matrix
      int invX = (int) ((newX*cos(a)) + (newY*sin(a)));
      int invY = (int) ((newY*cos(a)) - (newX*sin(a)));
      
      //translate back into image space, using old dimensions
      int retX = invX + (int) (w / 2);
      int retY = invY + (int) (h / 2);
      
      color c;
      
      //if the new coordinates are within the window, get color at that point
      //if not, then set alpha to zero (transparent)
      if (retX >= 0 && retX < w && retY >= 0 && retY < h) {
        
        c = im.get(retX, retY);
        
      } else {
        
        c = color(0,0,0,0);
        
      }
      
      //set color onto point
      rotate.set(x, y, c);
      
    }
    
  }
  
  return rotate;
  
}

//called once when a key is first pressed
void keyPressed(){
  //a key value between 48 and 57 corresponds to a number key (# = key-48)
  if((key >=48) && (key <= 57)){
    //switch the active layer
    activeLayer = (int)key-48;
    texttimer = (int)frameRate; //set a timer for text to appear for 1 second
  }else if(key == 's'){
    save("out.png"); //save the current screen image
  }else if(key == 'p'){
    printLayers(); //print layer properties
  }else if(key == 'q'){
    im = createImage(550,350,RGB);
    frame.setSize(im.width, im.height);
    //println(width);
   // println(height);
    //println(pixIX(width,height));
    //loadPixels();
    layers = new Layer[10];
    layers[0] = new Layer("cagehead.png", 270,-3,0.0,0.96000004,0.96000004);
    layers[1] = new Layer("cagehead.png", 337,221,0.0,0.16000037,0.060000386);
    layers[2] = new Layer("cagehead.png", 307,190,0.0,0.14000037,0.080000386);
    layers[3] = new Layer("cagehead.png", 288,235,0.0,0.14000031,0.1800003);
    layers[4] = new Layer("cagehead.png", 255,124,0.0,0.1800003,0.32000032);
    layers[5] = new Layer("cagehead.png", 167,209,0.0,0.3600004,0.24000035);
    layers[6] = new Layer("cagehead.png", 179,97,0.0,0.24000035,0.28000036);
    layers[7] = new Layer("cagehead.png", 100,161,0.0,0.26000035,0.3600004);
    layers[8] = new Layer("cagehead.png", 65,10,0.0,0.30000037,0.44000044);
    layers[9] = new Layer("cagehead.png", -77,157,0.0,0.7000002,0.2800003);
  }else if(key == 'w'){ //test of rotate
    im = createImage(420,430,RGB);
    frame.setSize(im.width, im.height);
    layers = new Layer[10];
    layers[0] = new Layer("apple.png", 0,0,110.0,1.0,1.0);
  }
  else if(key == 'e'){ //test of scale and rotate
    im = loadImage("people.jpg");
    frame.setSize(im.width, im.height);
    layers = new Layer[10];
    layers[0] = new Layer("squareface.jpg", 39,113,-8.0,0.060000386,0.080000386);
    layers[1] = new Layer("squareface.jpg", 120,66,-6.0,0.10000038,0.12000038);
    layers[2] = new Layer("squareface.jpg", 250,64,10.0,0.10000032,0.14000031);
    layers[3] = new Layer("squareface.jpg", 326,22,0.0,0.060000386,0.080000386);
    layers[4] = new Layer("squareface.jpg", 383,50,-18.0,0.10000038,0.16000037);
    layers[5] = new Layer("squareface.jpg", 516,69,-4.0,0.080000386,0.12000038);
    layers[6] = new Layer("squareface.jpg", 609,25,-10.0,0.060000386,0.080000386);
    layers[7] = new Layer("squareface.jpg", 675,96,-4.0,0.060000386,0.10000038);
  }
}

//use the mouseWheel to transform the current layer
void mouseWheel(MouseEvent event){
  float e = -event.getCount();
  if(keyPressed && activeLayer > -1){
    if(layers[activeLayer] != null){
      if(key == 'r'){
        layers[activeLayer].angle += e*2;
      }else if(key == 'x'){
        layers[activeLayer].sx += e/50.0;
      }else if(key == 'y'){
        layers[activeLayer].sy += e/50.0;
      }else if(key == 'b'){
        layers[activeLayer].sy += e/50.0;
        layers[activeLayer].sx += e/50.0;
      }
    }
  }
}

//print all information about the current layer properties
//use this to re-initialize the scene with a saved mosaic
void printLayers(){
  for(int l=0; l<layers.length; l++){
    if(layers[l] == null)
      break;
    println("layers["+l+"] = new Layer(\""+layers[l].file+"\", "+layers[l].x+","+layers[l].y+","+layers[l].angle+","+layers[l].sx+","+layers[l].sy+");");
  }
}


