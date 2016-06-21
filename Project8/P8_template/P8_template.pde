// Source and destination images
PImage [] src;
PImage dst;


////focus on flower
//int [] xf = {
//  277, 291, 303, 284, 272, 268, 246, 232, 249, 258, 259, 243, 260, 262, 285, 272, 255, 265, 275, 263, 266, 279
//};
//int [] yf = {
//  109, 108, 102, 104, 123, 105, 116, 130, 117, 96, 116, 116, 112, 96, 112, 132, 111, 100, 90, 83, 108, 105
//};

//// focus on honey
//int [] xf = {
//  387, 413, 434, 400, 387, 379, 347, 325, 351, 364, 363, 340, 367, 370, 400, 380, 358, 372, 386, 366, 368, 388
//};
//int [] yf = {
//  232, 230, 225, 225, 248, 221, 233, 253, 239, 213, 239, 238, 233, 213, 234, 258, 231, 218, 203, 195, 222, 221
//};

//// focus on coffee
//int [] xf = {
//  484, 506, 523, 494, 480, 474, 445, 424, 447, 461, 459, 438, 462, 466, 493, 474, 456, 468, 481, 464, 465, 483
//};
//int [] yf = {
//  196, 194, 189, 189, 211, 187, 197, 217, 203, 178, 203, 202, 199, 179, 200, 221, 196, 184, 170, 163, 189, 188
//};

//// focus on bread
//int [] xf = {
//  388, 425, 454, 407, 392, 382, 339, 313, 344, 361, 359, 328, 364, 370, 407, 382, 355, 372, 388, 359, 364, 391
//};
//int [] yf = {
//  306, 304, 299, 296, 325, 290, 303, 327, 310, 281, 311, 309, 304, 281, 306, 336, 301, 285, 267, 254, 288, 287
//};

//// focus on button
//int [] xf = {
//  350, 369, 353, 366, 345, 316, 317, 327, 337, 346, 350, 328, 312, 323, 352, 339, 318
//};
//int [] yf = {
//  315, 314, 328, 342, 356, 347, 337, 336, 327, 312, 326, 313, 321, 320, 326, 305, 305 
//};

//// focus on hole
//int [] xf = {
//  429, 442, 431, 439, 424, 406, 407, 415, 424, 432, 437, 422, 408, 420, 439, 432, 417
//};
//int [] yf = {
//  56, 63, 77, 93, 105, 97, 91, 90, 81, 73, 84, 71, 78, 77, 86, 70, 64 
//};

// focus on chocolate tag
int [] xf = {
  276, 293, 282, 291, 282, 267, 267, 275, 285, 287, 292, 279, 269, 281, 300, 290, 281
};
int [] yf = {
  127, 132, 143, 155, 166, 158, 152, 152, 147, 136, 147, 138, 144, 145, 148, 133, 131, 
};

// Number of images
int N = 17;

// This function is called once
void setup() {

  // load image and make window same size
  src = new PImage[N];
  for (int i=1;i<=N;i++)
    src[i-1] = loadImage("Test"+i+".JPG");
  size(src[0].width, src[0].height);

  // Create empty destination image
  dst = createImage(width, height, RGB);

  // Make sure draw is called only once
  noLoop();
}

// This function is called once, after setup
void draw() {
  // Make sure we can access pixels in src and dst
  dst.loadPixels();

  //Your code here
  
  //Navigate through window
  for (int i = 0; i < width; i++) {
    
    for (int j = 0; j < height; j++) {
      
      //Starting variables (RGB values begin at 0,0,0)
      color d;
      
      float cr = 0;
      float cg = 0;
      float cb = 0;
      int dx, dy, nw, nh;
      int dr, dg, db;
      float fr, fg, fb;
      
      //Go through all available pictures
      for (int n = 0; n < N; n++) {
        
        //Get difference from base, using the first picture as the base
        dx = xf[n] - xf[0];
        dy = yf[n] - yf[0];
        
        //Add the differences to the current position values
        nw = i + dx;
        nh = j + dy;
        
        //Get the pixel at this new location
        d = src[n].get(nw, nh);
        
        //Add RGB values to current (iteration)
        cr +=  red(d);
        cg +=  green(d);
        cb +=  blue(d);
        
      }
      
      //Divide RGB values by N for average
      fr = cr / N;
      fg = cg / N;
      fb = cb / N;
      
      //Create color using final RGB values
      color k = color(fr, fg, fb);
      
      //Put color into pixels array
      dst.pixels[i + (dst.width * j)] = k;
      
    }
    
  }

  // Update destination image and show it in window
  dst.updatePixels();
  image(dst, 0, 0);

  // And save it
  save("result.jpg");
}

