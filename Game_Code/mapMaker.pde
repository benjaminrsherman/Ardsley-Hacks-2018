class mapMaker {

  ArrayList<PVector> points = new ArrayList<PVector>();

  int mapMode = -1;//-1== no points yet; 0=placing point and has not left starting area; 1==placing track 2==done

  boolean mouseAlreadyPressed = true;

  public mapMaker() {
  }


  public void makeMap() {
    if (mousePressed) {
      if (mouseAlreadyPressed == false) {

        if (mapMode == -1) {
          points.add(new PVector(mouseX, mouseY));
          mapMode = 0;
        } else if (mapMode < 2) {
          if (dist(mouseX, mouseY, points.get(0).x, points.get(0).y)<10) {
            if (mapMode==0) {
              points.add(new PVector(mouseX, mouseY));
            } else {
              points.add(new PVector(points.get(0).x, points.get(0).y));
              mapMode = 2;
            }
          } else {
            mapMode=1;
            points.add(new PVector(mouseX, mouseY));
          }
        }


        mouseAlreadyPressed = true;
      }
    } else {
      mouseAlreadyPressed = false;
    }

    if (mapMode >-1 && mapMode<2) {
      fill(255, 0, 0);
      ellipseMode(CENTER);
      strokeWeight(1);
      ellipse(points.get(0).x, points.get(0).y, 20, 20);
    }
  }


  public void drawMap() {
    strokeWeight(10);
    stroke(0);
    for (int i=1; i<points.size(); i++) {
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }

    if (points.size()>0 && mapMode < 2) {
      if (dist(mouseX, mouseY, points.get(0).x, points.get(0).y)<10) {
        line(points.get(points.size()-1).x, points.get(points.size()-1).y, points.get(0).x, points.get(0).y);
      }else{
        line(points.get(points.size()-1).x, points.get(points.size()-1).y, mouseX, mouseY);
      }
      
    }
  }
}