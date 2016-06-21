// List of corresponding points in the source and target images

ArrayList<PVector> plist1;
ArrayList<PVector> plist2;

ArrayList<PVector> plist_current = null;

int current_index;

// initialize the point lists
void init_points()
{
  plist1 = new ArrayList<PVector>();
  plist2 = new ArrayList<PVector>();
  
  current_index = -1;
}

// add a new point pair to the lists
void add_point(float x1, float y1)
{
  PVector p1 = new PVector (x1, y1);
  PVector p2 = new PVector (x1, y1);
  plist1.add(p1);
  plist2.add(p2);
  current_index = plist1.size() - 1;
}

// draw the points
void draw_points()
{
  int i;
  
  fill(255, 0, 0);
  noStroke();
  float radius = 3.5;
  
  // go through the point lists
  for (i = 0; i < plist1.size(); i++) {
    PVector p1 = plist1.get(i);
    PVector p2 = plist2.get(i);
    // specially color the current selected point
    if (i == current_index)
      fill (100, 100, 255);
    else
      fill (255, 0, 0);
    // draw the left point (in source
    ellipse (p1.x, p1.y, radius * 2, radius * 2);
    // draw the right point (in target)
    ellipse (p2.x + w, p2.y, radius * 2, radius * 2);
  }
}

// see if we are close enough to select an already existing point
boolean select_point (float x, float y)
{
  int i;
  float min_dist = 1e20;
  int index = -1;
  float close = 7 * 7;
  
  // bail if there are no points in the lists
  if (plist_current.size() == 0)
    return (false);
  
  for (i = 0; i < plist_current.size(); i++) {
    PVector p = plist_current.get(i);
    float dx = p.x - x;
    float dy = p.y - y;
    float dist = dx*dx + dy*dy;
    if (dist < min_dist) {
      min_dist = dist;
      index = i;
    }
  }
  
  // did we find a close enough point?
  if (index >= 0 && min_dist <= close) {
    current_index = index;
    return (true);
  }
  else {
    return (false);
  }
}

// update current point's position
void update_current_point(float x, float y)
{
  if (current_index == -1)
    return;
    
  PVector p = plist_current.get(current_index);
  p.x = x;
  p.y = y;
}

// delete the currently selected point (if there is one)
void delete_current_point()
{
  // bail if no point is selected
  if (current_index == -1)
    return;
    
  // make sure we've got enough points
  if (current_index >= plist1.size())
    return;
    
  // now delete the current point pair
  plist1.remove(current_index);
  plist2.remove(current_index);
  current_index = plist1.size() - 1;
}

