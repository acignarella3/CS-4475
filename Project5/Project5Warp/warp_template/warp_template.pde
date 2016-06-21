// Image warping using radial basis functions.
//
// Greg Turk, June 2014

PImage source;  // source image
PImage target;  // warped image

int w,h;                // size of the input images (in pixels)

float x_offset_mouse;   // distinguishes if we're editing the left or right points

boolean draw_points = true;

int NULL_MODE = 1;
int MOVE_MODE = 2;
int input_mode = NULL_MODE;

void setup() {
  int i,j;
  int xscreen,yscreen;
  
  source = loadImage("match.jpg");
  target = loadImage("match.jpg");

  // get the image size (in pixels)
  w = source.width;
  h = source.height;
  
  // initialize the point lists
  init_points();
  
  size (w * 2, h);
}

void draw() {

  // make a gray background
  noStroke();
  fill (128, 128, 128);
  rect (0, 0, w*2, h);
  
  // draw the source image
  image (source, 0, 0);
  image (target, w, 0);
  
  // maybe draw the point pairs
  if (draw_points)
    draw_points();
  
  // draw lines separating the sub-windows
  stroke (0, 0, 0);
  line (w, 0, w, h);
}

void mousePressed()
{
  // see which picture was clicked
  if (mouseX < w) {
    x_offset_mouse = 0;
    plist_current = plist1;
  }
  else if (mouseX < w * 2) {
    x_offset_mouse = w;
    plist_current = plist2;
  }
  else {
    return;
  }
  
  PVector p = new PVector (mouseX - x_offset_mouse, mouseY);
  
  boolean selecting = select_point (p.x, p.y);

  if (selecting) {  // get ready to drag an existing point
    input_mode = MOVE_MODE;
  }
  else {           // add a new point
    input_mode = NULL_MODE;
    add_point (p.x, p.y);
    perform_warp();
  }
}

// rubber-banding while editing a vertex of a polyline
void mouseDragged() {
  if (input_mode == MOVE_MODE) {
    PVector p = new PVector (mouseX - x_offset_mouse, mouseY);
    update_current_point (p.x, p.y);
  }
}

void mouseReleased() {
  if (input_mode == MOVE_MODE) {
    input_mode = NULL_MODE;
    perform_warp();
  }
}

// process keyboard events
void keyPressed() {
    
  if (key == BACKSPACE) {
    delete_current_point();
    perform_warp();
  }
  else if (key == 'x' || key == 'X') {
    draw_points = !draw_points;
  }
  else if (key == 's' || key == 'S') {
    target.save ("warped.png");
  }
  else if (key == 'q' || key == 'Q') {
    exit();
  }
  else {
    println ("No key command for " + key + ".");
  }

}


