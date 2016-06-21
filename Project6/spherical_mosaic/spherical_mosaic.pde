int currentImage = 1;
boolean fastMode = false;
boolean rerender = false;
int waitCounter = 0;

// 2D Coordinate of pixel
class PixelCoordinate {
  int x, y;  
  // Constructor
  PixelCoordinate(int x_, int y_) {
    x = x_;
    y = y_;
  }
}

// Ray in space
class Ray {
  float phi, theta;
  // Constructor
  Ray(float phi_, float theta_) {
    phi = phi_;
    theta = theta_;
  }
}

// 3D Point Class
class Point3D {
  float X, Y, Z;
  // Constructor
  Point3D(float X_, float Y_, float Z_) {
    X = X_;
    Y = Y_;
    Z = Z_;
  }
  // Construct from Ray
  Point3D(Ray ray, float R) {
    float cp = cos(ray.phi*PI/180);
    float sp = sin(ray.phi*PI/180);
    float ct = cos(ray.theta*PI/180);
    float st = sin(ray.theta*PI/180);
    X =  R*ct*sp;
    Y = -R*st;
    Z =  R*ct*cp;
  }
}

// Mosaic Class
class Mosaic extends PImage {
  float horizontalFOV, verticalFOV;
  // Constructor
  Mosaic(int w, int h, float horizontalFOV_, float verticalFOV_) {
    super(w, h);
    horizontalFOV=horizontalFOV_;
    verticalFOV=verticalFOV_;
  }
  // Convert from mosaic coordinates to a ray in space (phi,theta)
  Ray ray(int i, int j) {
    float phi = ((float)i/width-0.5)*horizontalFOV;
    float theta = ((float)j/height-0.5)*verticalFOV;
    return new Ray(phi, theta);
  }
}

// View Class
class View {
  PImage img;   // actual image
  float f;      // focal length
  float x0, y0; // image center
  Ray center;   // where is camera pointing?
  // Constructor
  View(String filename, float f_, float phi, float theta) {
    img = loadImage(filename);
    f = f_;
    x0=(float)img.width/2.0;
    y0=(float)img.height/2.0;
    center =  new Ray(phi, theta);
  }
  // Transform world point into camera coordinate
  Point3D transform(Point3D wP) {
    // First yaw
    float cp = cos(center.phi*PI/180);
    float sp = sin(center.phi*PI/180);
    float X1 = cp*wP.X - sp*wP.Z;  
    float Y1 = wP.Y;
    float Z1 = sp*wP.X + cp*wP.Z;  
    // Then pitch
    float ct = cos(center.theta*PI/180);
    float st = sin(center.theta*PI/180);
    float X = X1;
    float Y = ct*Y1 - st*Z1;  
    float Z = st*Y1 + ct*Z1;  
    return new Point3D(X, Y, Z);
  }
  // Project 3D point into image
  PixelCoordinate project(Point3D P) {
    int x = (int)(0.5+x0+f*P.X/P.Z);
    int y = (int)(0.5+y0-f*P.Y/P.Z);
    return new PixelCoordinate(x, y);
  }
  // Check whether projection within image
  boolean valid(PixelCoordinate p) {
    if (p.x<0 || p.y<0 || p.x>=img.width || p.y>=img.height) return false;
    return true;
  }
  // Print out parameters
  void print() {
    println("phi,theta = " + center.phi + "," + center.theta + ", f=" + f);
  }
}

//===================================================================================

Mosaic mosaic; // destination spherical mosaic
View[] views;  // declare input camera views
int numViews;

void renderMosaic() {
  // ============= Define the mosaic ===============================
  int w = 1000, h = 500;
  mosaic = new Mosaic(w, h, 180, 90);
  size(w, h);
  
  // ======== Render the mosaic from the input views ===============
  // Loop over destination mosaic pixels
  int step = (fastMode ? 5 : 1);
  for (int i=0;i<mosaic.width;i+=step) 
    for (int j=0;j<mosaic.height;j+=step)
    {
      Ray mosaicRay = mosaic.ray(i, j);  // calculate ray in space
      // Check if falls in any view
      for (int v=0;v<numViews;v++) {
        Point3D wP = new Point3D(mosaicRay, 1); // world point
        Point3D cP = views[v].transform(wP);    // camera point
        // If point in front of image plane, project it
        if (cP.Z>0) {
          PixelCoordinate p = views[v].project(cP); // project into image
          if (views[v].valid(p)) {                  // if within image
            color c = views[v].img.get(p.x, p.y);   // get color from source pixel
            if(v == currentImage-1)
              c = color(red(c)+60, green(c), blue(c));            
            for(int x=0; x<step; x++){
              for(int y=0; y<step; y++){
                mosaic.set(i+x, j+y, c);   
              }
            }
            if(v == currentImage-1)
              break;
          }
        }
      }
    }
}

// do this once
void setup() {
  frameRate(15);
  
  // ========== Define the input views =============================
  views = new View[20]; // actually create array of input views
  numViews = 6;

  float f = 1120;
  views[0] = new View("Pro1.jpg", f, -39, 13);
  views[1] = new View("Pro2.jpg", f, 0, 20);
  views[2] = new View("Pro3.jpg", f, 32, 10);
  views[3] = new View("Pro4.jpg", f, -45, 13);
  views[4] = new View("Pro5.jpg", f, 5, 20);
  views[5] = new View("Pro6.jpg", f, 40, 10);
  
  renderMosaic();
}

void draw () {
  
  if(rerender) {
    renderMosaic();
    rerender = false;
  }
  
  image(mosaic, 0, 0);
    
  // Render in full quality next time, unless a key is pressed again  
  if(fastMode) {
    waitCounter --;
    if(waitCounter <= 0) {
      fastMode = false;
      rerender = true;
    }
  }
}

// keys to adjust view parameters
void keyPressed() {
  if(key >= '0' && key <= '9') {
    currentImage = key - '0';
    println("Current image is now " + currentImage);
  }else if(key == 's'){
    save("out.png");
  }
  if(key == CODED){
    if (keyCode == LEFT) {
      currentImage = max(0, currentImage-1);
      println("Current image is now " + currentImage);
    }else if (keyCode == RIGHT) {
      currentImage = min(numViews, currentImage+1);
      println("Current image is now " + currentImage);
    }
  }
  //views[currentImage-1].print();
  
  fastMode = true;
  waitCounter = 5;
  rerender = true;
}

void mouseDragged(){
  if(currentImage <= numViews && currentImage > 0){
    if(keyPressed){
      if(key == 'f'){
        views[currentImage-1].f += mouseX-pmouseX;
      }
    }else{
      views[currentImage-1].center.phi += (mouseX-pmouseX)*0.2;
      views[currentImage-1].center.theta -= (mouseY-pmouseY)*0.2;
    }
    fastMode = true;
    waitCounter = 5;
    rerender = true;
  }
}

//comment out if your code is breaking
void mouseWheel(MouseEvent event){
  int e = -event.getCount();
  currentImage = min(max(0, currentImage+e), numViews);
  println("Current image is now " + currentImage);
  fastMode = true;
  waitCounter = 5;
  rerender = true;
}
