// Warp the source image into the target

// Perform the warp, based on the point pairs.
// YOU NEED TO WRITE THIS FUNCTION !!!
void perform_warp()
{
  int i,j,k;
  
  // don't do anything if we don't have any point correspondences
  if (plist1.size() == 0)
    return;
  
  // example of looping through all the point pairs
  println();
  for (k = 0; k < plist1.size(); k++) {
    PVector p1 = plist1.get(k);
    PVector p2 = plist2.get(k);
    println ("bi = " + p1.x + " " + p1.y + ", ci = " + p2.x + " " + p2.y);
  }
  
  // dummy loop through all of the pixels
  /*for (j = 0; j < h; j++)
    for (i = 0; i < w; i++) {
      color c = source.get(i, j);  // get color from source image
      target.set (i, j, c);        // put it into the target image
    }
  }*/
  
  for (i = 0; i < w; i++) {
    
    for (j = 0; j < h; j++) {
      
      PVector vsum = new PVector (0,0);
      float wsum = 0;
      
      PVector v, dist, ps, ci, wv;
      PVector p = new PVector (i,j);
      float d, w;
      
      for (int a = 0; a < plist2.size(); a++) {
        
        ci = plist2.get(a);
        
        dist = PVector.sub(p,ci);
        
        d = sqrt((dist.x*dist.x) + (dist.y*dist.y));
        
        w = 1 / ((d*d) + 0.000001);
        
        v = PVector.sub(plist1.get(a),ci);
        
        wv = PVector.mult(v,w);
        
        vsum = PVector.add(vsum,wv);
        
        wsum = wsum + w;
        
      }
      
      v = PVector.div(vsum,wsum);
      
      ps = PVector.add(p,v);
      
      //color c = source.get((int) ps.x, (int) ps.y);
      
      color c00 = source.get(floor(ps.x), floor(ps.y));
      color c10 = source.get(floor(ps.x), ceil(ps.y));
      
      color c01 = source.get(ceil(ps.x), floor(ps.y));
      color c11 = source.get(ceil(ps.x), ceil(ps.y));
      
      int ix = floor(ps.x);
      int iy = floor(ps.y);
      
      float s = ps.x - ix;
      float t = ps.y - iy;
      
      color c0 = lerpColor(c00, c10, s);
      color c1 = lerpColor(c01, c11, s);
      
      color c = lerpColor(c0, c1, t);
      
      target.set(i,j,c);
      
    }
    
  }
  
}

