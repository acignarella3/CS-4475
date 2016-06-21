public class Layer{
  String file;
  PImage im; //source layer image
  int x, y; //offset of the layer from the canvas (translation)
  float angle, sx, sy; //rotation angle, scale value in x and y axis (before rotation)
  
  //create a layer with no rotation, scale or translation
 Layer(String filename){
  file = filename;
  x = y = 0;
  angle = 0;
  sx = sy = 1;
  im = loadImage(filename);
 }
 
 //create a layer with only translation
 Layer(String filename, int _x, int _y){
  file = filename;
  x = _x;
  y = _y;
  angle =0;
  sx = sy = 1;
  im = loadImage(filename);
 }
 
 //create a layer with translation, scale and rotation
 Layer(String filename, int _x, int _y, float a, float _sx, float _sy){
  file = filename;
  x = _x;
  y = _y;
  angle = a;
  sx = _sx;
  sy = _sy;
  im = loadImage(filename);
 }
}
