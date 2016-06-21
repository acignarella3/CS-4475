//This code uses three methods of white balancing on a chosen image
//By: Alex Cignarella

// Source and destination images
PImage src, dst;

// Shrink images larger than this size
static final int maxImageSize = 600;

// Color correction mode (1 = Spot, 2 = Max, 3 = Gray world)
// Don't edit this in the code, instead you press a key at runtime to change
// the mode (see below)
int whiteBalanceMode;

// This function is called once
void setup() {
  // load image
  src = loadImage("coke_daylight.jpg");
  
  // If image is larger than 600 pixels, shrink it.  We do this here so that the program
  // does not loop over the pixels of the large image and thus runs quickly.
  if(src.width > src.height && src.width > maxImageSize) {
    float scaleFactor = (float)maxImageSize / src.width;
    src.resize(round(scaleFactor * src.width), round(scaleFactor * src.height));
  } else if(src.height > src.width && src.height > maxImageSize) {
    float scaleFactor = (float)maxImageSize / src.height;
    src.resize(round(scaleFactor * src.width), round(scaleFactor * src.height));
  }
  
  // Set the window to twice the image width so we can show 2 images side by side, and room
  // at the bottom for the buttons.
  size(2 * src.width, src.height);

  // Create empty destination image
  dst = createImage(src.width, src.height, RGB);
  
  // Initialize the image by showing the source image on the left side.
  image(src, 0, 0);
  
  // Start in spot mode
  whiteBalanceMode = 1;
}

// This function does white balance correction from a reference color
void adjustFromReferenceColor(color colorPrime) {
    float Rprime = red(colorPrime), Gprime = green(colorPrime), Bprime = blue(colorPrime);
    
    // Compute target level (average of r',g',b')
    float c = 1.0/3.0 * (Rprime + Gprime + Bprime);
    float scaleR = c / Rprime, scaleG = c / Gprime, scaleB = c / Bprime;
  
    // loop over all destination pixels
    int nrPixels = dst.pixels.length;
    for (int i=0; i<nrPixels; ++i) {
      // get corresponding pixel in source image
      int src_i = src.pixels[i];
      
      // get individual RGB color components
      float r_i = red(src_i), g_i = green(src_i), b_i = blue(src_i);
      
      // Scale r,g,b
      r_i *= scaleR;
      g_i *= scaleG;
      b_i *= scaleB;

      // set destination pixel as a function of RGB
      dst.pixels[i] = color(r_i, g_i, b_i);
    }
}

// This function is called once, after setup
void draw() {
  // Make sure we can access pixels in src and dst
  src.loadPixels();
  dst.loadPixels();
  
  float[] arrayR = new float[src.pixels.length];
  float[] arrayG = new float[src.pixels.length];
  float[] arrayB = new float[src.pixels.length];
  
  for (int i = 0; i < src.pixels.length; i++) {
    
    arrayR[i] = red(src.pixels[i]);
    arrayG[i] = green(src.pixels[i]);
    arrayB[i] = blue(src.pixels[i]);
    
  }
  
  
  if(whiteBalanceMode == 1) {
    // Spot mode:  If the user clicks or holds the mouse button in the original image, adjust
    // the white balance using the clicked color as a reference.
    if(mousePressed && mouseX < src.width) {
      // Get the color under the mouse in the original image
      color colorMouse = src.pixels[mouseY*src.width + mouseX];
      
      // Correct the white balance
      adjustFromReferenceColor(colorMouse);
    }
    
  } else if(whiteBalanceMode == 2) {
    // *******************************************************
    // Max mode:  Adjust the white balance using the maximum RGB values
    
    //determine the max RGB
    float maxR = findMax(arrayR);
    float maxG = findMax(arrayG);
    float maxB = findMax(arrayB);
    
    //set a color with these maxs.
    color colorMax = color(maxR, maxG, maxB);
    
    // Correct the white balance
    adjustFromReferenceColor(colorMax);
    
  } else if(whiteBalanceMode == 3) {
    // *******************************************************
    // Gray world mode:  Adjust the white balance using the average RGB values
    
    //determine the average RGB
    float avgR = findAvg(arrayR);
    float avgG = findAvg(arrayG);
    float avgB = findAvg(arrayB);
    
    //set a color with these averages
    color colorGray = color(avgR, avgG, avgB);

    // Correct the white balance
    adjustFromReferenceColor(colorGray);

  }
      
  // Update destimation image and show the dst image to the right of the src image
  dst.updatePixels();
  image(dst, src.width, 0);
}

//Helper function to find the max, taking in a float array
float findMax(float[] arr) {
  
  //default the maximum to zero
  float max = 0;
  
  //examine the entire array
  for (int i = 0; i < arr.length; i++) {
    
    //if the particular value is greater than the current max, make the max
    //equal this value
    if (arr[i] > max) {
      
      max = arr[i];
      
    }
    
  }
  
  //return the maximum
  return max;
  
}

//Helper fucntion to find the average, taking in a float array
float findAvg(float[] arr) {
  
  //set up a sum variable
  float sum = 0;
  
  //go through the array
  for (int i = 0; i < arr.length; i++) {
    
    //add the particular value onto the sum
    sum = sum + arr[i];
    
  }
  
  //divide the sum by the array's length to find the average
  sum = sum / arr.length;
  
  //return the average
  return sum;
  
}

void keyPressed() {  
  if(key == 's') {
    // If the user presses the 's' key, save the white balance corrected image
    if(whiteBalanceMode == 1)
      dst.save("whitebalanced_spot.png");
    else if(whiteBalanceMode == 2)
      dst.save("whitebalanced_max.png");
    else if(whiteBalanceMode == 3)
      dst.save("whitebalanced_grayworld.png");
  } else if(key == '1') {
    // Change to spot mode
    whiteBalanceMode = 1;
  } else if(key == '2') {
    // Change to max mode
    whiteBalanceMode = 2;
  } else if(key == '3') {
    // Change to gray world mode
    whiteBalanceMode = 3;
  }
}

