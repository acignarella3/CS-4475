// Source images
PImage [] src;

// focus points
int [] xf, yf;

// Number of images
int N = 17;
int j=1;

// This function is called once
void setup() {

  // load image and make window same size
  src = new PImage[N];
  for (int i=1;i<=N;i++)
    src[i-1] = loadImage("Test"+i+".JPG");
  size(src[0].width, src[0].height);

  // allocate focus points
  xf = new int[N];
  yf = new int[N];

  // Make sure draw is called only once
  noLoop();
}

void mousePressed() {
  xf[j-1]=mouseX;
  yf[j-1]=mouseY;
  if (j==N) {
    for (int i=1;i<=N;i++)
      print(xf[i-1]+", ");
    println();
    for (int i=1;i<=N;i++)
      print(yf[i-1]+", ");
    println();
    j=1;
  }
  else {
    j+=1;
  }
  println(j);
  redraw();
}

// This function is called once, after setup
void draw() {
  image(src[j-1], 0, 0);
}

