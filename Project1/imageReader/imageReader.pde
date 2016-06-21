// This program takes an image, converts it to grayscale, and then
// mirrors the image.
// By: Alexander Cignarella

PImage im;    // an image

// The "setup" command is called once at the start of every
// Processing program.

void setup() {
  
  // read an image from the "data" subdirectory
  im = loadImage("barca.jpg"); 
  
  // create a window exactly the size of the image
  size(im.width, im.height);
  
  // the first loop makes the picture grayscale
  
  // navigate through every pixel in the picture
  for (int x = 0; x < im.width; x++) {
    
    for (int y = 0; y < im.height; y++) {
      
      color c = im.get(x, y);    // the color of this pixel
      
      float imR = red(c);        // the red value of this pixel
      float imG = green(c);      // the green value of this pixel
      float imB = blue(c);       // the blue value of this pixel
      
      //calculate the grayscale value using the formula given in class
      float bw = (0.6*imG) + (0.3*imR) + (0.1*imB);
      
      color d = color(bw, bw, bw);  // the new pixel, with bw as all RGB values
      
      // set the pixel onto the image
      im.set(x, y, d);
      
    }
    
  }
  
  // create a new image of the same size
  PImage newIm = createImage(im.width, im.height, RGB);
  
  // make this image into a copy of the image after the first loop
  newIm.copy(im, 0, 0, im.width, im.height, 0, 0, im.width, im.height);
  
  // the second loop mirrors the image
  
  for (int x = 0; x < im.width; x++) {
    
    for (int y = 0; y < im.height; y++) {
      
      // grab the color of the pixel from the starting image
      color c = im.get(x, y);
      
      // set this color in the copied image, same column but mirrored row
      newIm.set(im.width - 1 - x, y, c);
      
    }
    
  }
  
  // displays the image beginning at the first pixel (0,0)
  image(newIm,0,0);
}

