int current=0;  // currently shown image
ImageSet set;   // bracketed image set
int w,h; // image size
int n;   // number of pixels
int superblack = 5, superwhite = 250;
boolean annotate_flag = false;

// full HDR image
PVector [][] full_image;

// setup Processing 
void setup () {
  
  // read in multiple images and create HDR image from them
  create_hdr();
  
  // setup display
  colorMode(RGB, 255);
//  size(w*2+256,h);
  size(w*2,h);
  frameRate(10);

  // show first image
  PImage img0 = set.image(0);
  displayImage(img0);
 
  // draw tone mapped version of HDR image
  draw_blurred();
 
} // setup

// draw blurred version of the current image
void draw_blurred()
{
  int i,j;
  
  PImage img = set.image(current);
  PVector[][] float_img = new PVector[w][h];
  
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      color c = img.get(i,j);
      float_img[i][j] = new PVector (red(c), green(c), blue(c));
    }
    
  PVector[][] blur_image = blur (float_img, 8);
  display_with_scale (blur_image, 1);
}

// per-color channel version of high/low frequency separation tone mapping
void per_color_tone_map()
{
  PVector[][] hdr;           // HDR image
  PVector[][] blur_image;    // low frequency image
  PVector[][] diff_image;    // "detail" image (high frequencies)
  
  hdr = new_copy_of_image (full_image);
      
  log_image (hdr);  
  blur_image = blur (hdr, 8);
  diff_image = difference_image (hdr, blur_image);
  scale_image (blur_image, 0.3);
  hdr = add_image (blur_image, diff_image);
  exp_image (hdr);
  
  // draw the final image
  display_with_scale (hdr, 20);
}

// luminance only version of high/low frequency separation tone mapping
void luminance_only_tone_map()
{
  PVector[][] hdr;           // HDR image
  PVector[][] blur_image;    // low frequency image
  PVector[][] diff_image;    // "detail" image (high frequencies)
  PVector[][] luminance_image;   // original luminance channel
  
  hdr = new_copy_of_image (full_image);
    
  rgb_to_yuv (hdr);
  luminance_image = new_copy_of_image (hdr);
  
  log_image (hdr);  
  blur_image = blur (hdr, 8);
  diff_image = difference_image (hdr, blur_image);
  scale_image (blur_image, 0.3);
  hdr = add_image (blur_image, diff_image);
  exp_image (hdr);
  
  add_back_color (full_image, luminance_image, hdr, 0.8);

  // draw the final image
  display_with_scale (hdr, 20);
}

// display the given image, possibly with color channel scaling
void display_with_scale(PVector[][] img, float s) {
  int i,j;
  
  // Find minimum and maximum in I
  float maxI=-Float.MIN_VALUE,minI=Float.MAX_VALUE; 
  
  for (j = 0; j < h; j++)
    for(i = 0; i < w; i++) {
      minI = min(img[i][j].x, minI);
      minI = min(img[i][j].y, minI);
      minI = min(img[i][j].z, minI);
      
      maxI = max(img[i][j].x, maxI);
      maxI = max(img[i][j].y, maxI);
      maxI = max(img[i][j].z, maxI);
    }        
        
  println("minI = "+minI);
  println("maxI = "+maxI);

  // tonemap the pixels
  PImage img2 = new PImage(w,h);
  for (j = 0; j < h; j++)
    for(i = 0; i < w; i++) {
      if (Float.isNaN(full_image[i][j].x))
        img2.pixels[i]=color(0,0,255);
      else {
        // this is where the re-mapping happens
        float r = clamp (256 * s * img[i][j].x/maxI, 0, 255);
        float g = clamp (256 * s * img[i][j].y/maxI, 0, 255);
        float b = clamp (256 * s * img[i][j].z/maxI, 0, 255);
        //img.pixels[i]=annotatedColor(color(r,g,b));
        img2.set(i,j,annotatedColor(color(r,g,b)));
      }
    }
  
  // draw the result on the right
  image(img2,w,0);
}

// clamp a value to a given min/max range
float clamp (float value, float min, float max)
{
  if (value < min)
    return (min);
  else if (value > max)
    return (max);
  else
    return (value);
}

// Draw is called at frameRate
void draw () {
  
  int nrImages = set.nrImages();
  
  // Show camera response
  //displayResponse();
  
} // draw

// Display camera response at far right
void displayResponse() {
  float maxX=Float.MIN_VALUE;
  for(int c=0;c<3;c++) for (int z=0;z<256;z++) maxX=max(maxX,finv[c][z]);
  rectMode(CORNER);
  noStroke();
  fill(255);
  rect(2*w,0,255,h-1);
  stroke(255,0,0);
  for (int z=0;z<256;z++) point(2*w + z, h - h * finv[0][z]/ maxX);
  stroke(0,255,0);
  for (int z=0;z<256;z++) point(2*w + z, h - h * finv[1][z]/ maxX);
  stroke(0,0,255);
  for (int z=0;z<256;z++) point(2*w + z, h - h * finv[2][z]/ maxX);
}

// Convert color to show truncation as green or red
color annotatedColor(color c) {
  if (annotate_flag) {
    if (red(c)>=superwhite) return color(255,0,0);
    if (red(c)<=superblack) return color(0,255,0);
  }
  return c;
}

// display an image with red and green for superblack/white
void displayImage(PImage source) {

  PImage img = new PImage(w,h);
  loadPixels();
  for(int i=0;i<n;i++) {
    color c = source.pixels[i];
    img.pixels[i] = annotatedColor(c);
  }
  updatePixels();
  image(img,0,0);
}

void mousePressed()
{
  int nrImages = set.nrImages();

  if (mouseX<w) {
    current = (current+1) % nrImages;
    displayImage(set.image(current));
  }
  else {
    int x = mouseX - w;
    int y = mouseY;
    println ("mouse: " + x + " " + y);
  }
}

void keyPressed()
{
  int nrImages = set.nrImages();
  
  if (key == CODED) {
    if (keyCode == RIGHT) {
      if (current < nrImages-1)
        current++;
      displayImage(set.image(current));
      return;
    }
    else if (keyCode == LEFT) {
      if (current > 0)
        current--;
      displayImage(set.image(current));
      return;
    }
  }

  if (key == '1') {
    draw_blurred();
  }
  else if (key == '2') {
    per_color_tone_map();
  }
  else if (key == '3') {
    luminance_only_tone_map();
  }
  else if (key == 'q' || key == 'Q') {
    exit();
  }
}


