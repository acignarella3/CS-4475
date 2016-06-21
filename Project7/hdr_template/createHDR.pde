// Creat an HDR image

// Unknown Irradiance Image I
// Unlike in class, now has three channels red.green, and blue
float [][] I;

// Unknown inverse f function, a lookup table
// Unlike in class, now has three channels red.green, and blue
float [][] finv;

// create our HDR image
void create_hdr()
{
  int i,j;

  // load images and exposure times

  if (true) {
  set = new ImageSet(6);
  set.load(0,"20070929_0020.jpg",0.4);
  set.load(1,"20070929_0019.jpg",1.0/5.0);
  set.load(2,"20070929_0018.jpg",1.0/10.0);
  set.load(3,"20070929_0017.jpg",1.0/40.0);
  set.load(4,"20070929_0016.jpg",1.0/60.0);
  set.load(5,"20070929_0015.jpg",1.0/100.0);
  }

  if (false) {
  set = new ImageSet(3);
  set.load(0,"brooks_0016.jpg",1.0);
  set.load(1,"brooks_0017.jpg",0.25);
  set.load(2,"brooks_0018.jpg",4.0);
  }

  if (false) {
  set = new ImageSet(3);
  set.load(0,"ccb_0016.jpg",1.0);
  set.load(1,"ccb_0017.jpg",0.25);
  set.load(2,"ccb_0018.jpg",4.0);
  }
  
  // determine image sizes
  PImage img0 = set.image(0);
  w = img0.width;
  h = img0.height;
  n = w*h;

  // Initialize the Irradiance Image and Lookup Table
  I = new float[3][n];
  finv = new float[3][256];
  for(int c=0;c<3;c++) for(int z=0; z<256; z++) finv[c][z] = (1000.0-100*c) * (float)z/255.0; 

  // create HDR image
  for (i = 0; i < 6; i++)
     one_hdr_iteration();

  // convert to full image
  full_image = new PVector[w][h];
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      int index = j * w + i;
      full_image[i][j] = new PVector (I[0][index], I[1][index], I[2][index]);
    }

  // get rid of NaN's
  for (i = 0; i < 5; i++)
    fix_not_a_number (full_image);

}

// one iteration of estimating f_inverse and radiances
void one_hdr_iteration()
{
  int nrImages = set.nrImages();

  // Estimate I from the images
  for(int c=0;c<3;c++) 
    for(int i=0;i<n;i++) {
      int x = i % w;
      int y = i / w;
      float g = 0.0;
      int m = 0;
      for(int j=0; j< nrImages; j++){
        int Zij = set.Channel(c,i,j);
        if (Zij>superblack && Zij<superwhite) {
          g += finv[c][Zij]/set.exposure(j);
          m += 1; //Count non-extreme pixels
        }
      } // j
      I[c][i] = m==0? Float.NaN : g/(float)m;
    } // i

  // Re-estimate finv for the next iteration
  float [] sum = new float[256];
  int [] count = new int[256];
  for(int c=0;c<3;c++) {
    for(int i=0;i<n;i++) {
      for(int j=0; j< nrImages; j++){
        int Zij = set.Channel(c,i,j);
        float Xij = I[c][i]*set.exposure(j);
        if (!Float.isNaN(Xij)) {
          sum[Zij] += Xij;
          count[Zij] += 1; 
        }
      } // image j
    } // pixel i
    for (int z = 0; z < 256; z++) 
      finv[c][z] = count[z] == 0 ? 0 : sum[z]/count[z];
  } // channel c

}

// fix NaN's, using a method similar to median filtering
void fix_not_a_number (PVector[][] img)
{
  int i,j;
  int aa,bb;
  float epsilon = 0.01;
  
  for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      // if we've got NaN, fill in from surrounding values
      if (Float.isNaN(img[i][j].x) || Float.isNaN(img[i][j].y) || Float.isNaN(img[i][j].z)) {
        int count = 0;
        float r = 0;
        float g = 0;
        float b = 0;
        // look in 3x3 neighborhood for good values
        for (aa = -1; aa <=1; aa++)
          for (bb = -1; bb <= 1; bb++) {
            int ii = i + aa;
            int jj = j + bb;
            if (ii < 0 || ii >= w || jj < 0 || jj >= h)
              continue;
            if (!Float.isNaN(img[ii][jj].x) && !Float.isNaN(img[ii][jj].y) && !Float.isNaN(img[ii][jj].z)) {
              r += img[ii][jj].x;
              g += img[ii][jj].y;
              b += img[ii][jj].z;
              count++;
            }
          }
        // if we got any good values, average them and replace NaN's with the average
        if (count > 0) {
          img[i][j] = new PVector (r / count, g / count, b / count);
        }
      }
    }
}

// An image Set of differently exposed pictures
class ImageSet {
  private int nrImages;
  private PImage [] I; // images
  private float  [] t; // exposure times

  ImageSet(int n) {
    nrImages=n;
    I = new PImage[n];
    t = new float[n];
  }

  int nrImages() { 
    return nrImages;
  }

  // load image j from file using exposure time t
  void load(int j, String file, float t0) {
    I[j] = loadImage(file);
    t[j] = t0;
  }

  PImage image(int j) { 
    return I[j];
  }

  float exposure(int j) { 
    return t[j];
  } 

  // pixel color i in image j 
  int Color(int i, int j) {
    return I[j].pixels[i];
  }

  // Channel c of pixel i in image j
  int Channel(int c, int i, int j) {
    switch (c) {
      case 0: return Red  (i,j);
      case 1: return Green(i,j);
      case 2: return Blue (i,j);
    }
    return 0;
  }

  // pixel R i in image j
  int Red(int i, int j) {
    int r = Color(i,j) >> 16 & 0xFF;
    return r;
  }

  // pixel G i in image j
  int Green(int i, int j) {
    int g = Color(i,j) >> 8 & 0xFF;
    return g;
  }

  // pixel B i in image j
  int Blue(int i, int j) {
    int b = Color(i,j) & 0xFF;
    return b;
  }

}

