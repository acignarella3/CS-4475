// Routines to manipulate floating-point images

// convert RGB image to YUV
void rgb_to_yuv (PVector[][] img)
{
  int i,j;
    
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      float r = img[i][j].x;
      float g = img[i][j].y;
      float b = img[i][j].z;
      float y = r *  0.299 +   g * 0.587 +    b * 0.114;
      float u = r * -0.14713 + g * -0.28886 + b * 0.436;
      float v = r *  0.615 +   g * -0.51499 + b * -0.10001;
      img[i][j].x = y;
      img[i][j].y = u;
      img[i][j].z = v;
    }
}

// convert YUV image to RGB
void yuv_to_rgb (PVector[][] img)
{
  int i,j;
    
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      float y = img[i][j].x;
      float u = img[i][j].y;
      float v = img[i][j].z;
      float r = y + v * 1.13983;
      float g = y + u * -0.39456 + v * -0.5806;
      float b = y + u * 2.03211;
      img[i][j].x = r;
      img[i][j].y = g;
      img[i][j].z = b;
    }
}

// copy the UV channels from a second image into the first
/*
void add_back_chroma (PVector[][] img, PVector[][] chroma_image, float s)
{
  int i,j;
    
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      img[i][j].x *= s;
      img[i][j].y = chroma_image[i][j].y;
      img[i][j].z = chroma_image[i][j].z;
    }
}
*/

// add back color into lum_out
void add_back_color (PVector[][] color_in, PVector[][] lum_in, PVector[][] lum_out, float s)
{
  int i,j;
    
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      float r_ratio = color_in[i][j].x / lum_in[i][j].x;
      float g_ratio = color_in[i][j].y / lum_in[i][j].x;
      float b_ratio = color_in[i][j].z / lum_in[i][j].x;
      float lumin_out = lum_out[i][j].x;
      lum_out[i][j].x = pow(r_ratio, s) * lumin_out;
      lum_out[i][j].y = pow(g_ratio, s) * lumin_out;
      lum_out[i][j].z = pow(b_ratio, s) * lumin_out;
    }
}

// log of an image
void log_image (PVector[][] img)
{
  int i,j;
  float base_two = 1.0 / log(2.0);
    
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      img[i][j].x = base_two * log(img[i][j].x);
      img[i][j].y = base_two * log(img[i][j].y);
      img[i][j].z = base_two * log(img[i][j].z);
    }
}

// exp of an image
void exp_image (PVector[][] img)
{
  int i,j;
    
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      img[i][j].x = pow(2.0, img[i][j].x);
      img[i][j].y = pow(2.0, img[i][j].y);
      img[i][j].z = pow(2.0, img[i][j].z);
    }
}
      
// scale an image
void scale_image (PVector[][] img, float s)
{
  int i,j,k;
    
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      img[i][j].x = s * img[i][j].x;
      img[i][j].y = s * img[i][j].y;
      img[i][j].z = s * img[i][j].z;
    }
}

// subtract two images
PVector[][] difference_image (PVector[][] img1, PVector[][] img2)
{
  int i,j,k;
  PVector[][] new_img = new PVector[w][h];
    
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      new_img[i][j] = PVector.sub(img1[i][j], img2[i][j]);
    }
  
  return (new_img);
}
      
// add two images
PVector[][] add_image (PVector[][] img1, PVector[][] img2)
{
  int i,j,k;
  PVector[][] new_img = new PVector[w][h];
    
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      new_img[i][j] = PVector.add(img1[i][j], img2[i][j]);
    }
  
  return (new_img);
}

// create a new copy of an image
PVector[][] new_copy_of_image(PVector[][] original)
{
  int i,j;
  
  // create space for the copy
  PVector[][] target = new PVector[w][h];
  
  // copy values
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      target[i][j] = original[i][j].get();
    }
  
  // return the copy
  return (target);
}

// copy an image that is made of floating-point PVectors
void copy_image_values(PVector[][] source, PVector[][] target)
{
  int i,j;
  
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      target[i][j] = source[i][j].get();
    }
}

// Blur an image multiple iterations, using a separable 1/16 * (1-4-6-4-1) filter in
// both the horizontal and vertical directions.  Be sure to blur all three color channels.
// (You will add code here!!!)

/*1) Apply 1-4-6-4-1 row-wise
2) Add it all together into single value
3) Find matching value in image
4) Apply 1-4-6-4-1 column-wise
5) Add together for new value
6) Find match, set as that value*/
PVector[][] blur (PVector[][] input_img, int blur_iterations)
{
  int i,j,x;
  
  // create space for the copy
  PVector[][] blurred = new PVector[w][h];
    
  // Add your blur code below.
  
  // copy values
  for (j = 0; j < h; j++) {
    
    for (i = 0; i < w; i++) {
      
      PVector start = input_img[i][j].get();
      PVector empty = new PVector(0,0,0);
      
      PVector backTwo, backOne, frontOne, frontTwo;
      PVector upTwo, upOne, downOne, downTwo;
      
      if (i - 2 > 0) { backTwo = input_img[i-2][j].get(); } else { backTwo = empty; }
      if (i - 1 > 0) { backOne = input_img[i-1][j].get(); } else { backOne = empty; }
      if (i + 1 < w) { frontOne = input_img[i+1][j].get(); } else { frontOne = empty; }
      if (i + 2 < w) { frontTwo = input_img[i+2][j].get(); } else { frontTwo = empty; }
      if (j - 2 > 0) { upTwo = input_img[i][j-2].get(); } else { upTwo = empty; }
      if (j - 1 > 0) { upOne = input_img[i][j-1].get(); } else { upOne = empty; }
      if (j + 1 < h) { downOne = input_img[i][j+1].get(); } else { downOne = empty; }
      if (j + 2 < h) { downTwo = input_img[i][j+2].get(); } else { downTwo = empty; }
      
      //if (i - 2 > 0) {
        
      //  backTwo = input_img
      
      if (i > 2 && i < w - 2 && j > 2 && j < h - 2) {
        
       float rowR = ((1.0/16.0)*backTwo.x) + ((4.0/16.0)*backOne.x) + ((6.0/16.0)*start.x) + ((4.0/16.0)*frontOne.x) + ((1.0/16.0)*frontTwo.x);
       float rowG = ((1.0/16.0)*backTwo.y) + ((4.0/16.0)*backOne.y) + ((6.0/16.0)*start.y) + ((4.0/16.0)*frontOne.y) + ((1.0/16.0)*frontTwo.y);
       float rowB = ((1.0/16.0)*backTwo.z) + ((4.0/16.0)*backOne.z) + ((6.0/16.0)*start.z) + ((4.0/16.0)*frontOne.z) + ((1.0/16.0)*frontTwo.z);
       
       PVector temp = new PVector(rowR, rowG, rowB);
       
       float colR = ((1.0/16.0)*upTwo.x) + ((4.0/16.0)*upOne.x) + ((6.0/16.0)*temp.x) + ((4.0/16.0)*downOne.x) + ((1.0/16.0)*downTwo.x);
       float colG = ((1.0/16.0)*upTwo.y) + ((4.0/16.0)*upOne.y) + ((6.0/16.0)*temp.y) + ((4.0/16.0)*downOne.y) + ((1.0/16.0)*downTwo.y);
       float colB = ((1.0/16.0)*upTwo.z) + ((4.0/16.0)*upOne.z) + ((6.0/16.0)*temp.z) + ((4.0/16.0)*downOne.z) + ((1.0/16.0)*downTwo.z);
        
       blurred[i][j] = new PVector (colR, colG, colB);
       
      } else {
        
        blurred[i][j] = start;
        
      }
      
    }
    
  }
  
  if (blur_iterations == 0) {
    
    return blurred;
    
  } else {
    
    return blur(blurred, blur_iterations - 1);
    
  }
  
  
}


