class mapMaker {

  ArrayList<PVector> points = new ArrayList<PVector>();

  int mapMode = -1;//-1== no points yet; 0=placing point and has not left starting area; 1==placing track 2==done

  boolean mouseAlreadyPressed = true;


  public mapMaker() {
  }


  public void makeMap() {
    if (mousePressed) {
      //mouseAlreadyPressed = false;
      if (mouseAlreadyPressed == false) {
        if (mouseX<width-76) {
          if (mapMode == -1) {
            points.add(new PVector(mouseX, mouseY));
            mapMode = 0;
          } else if (mapMode < 2) {
            if (dist(mouseX, mouseY, points.get(0).x, points.get(0).y)<75/2) {
              if (mapMode==0) {
                points.add(new PVector(mouseX, mouseY));
              } else {
                points.add(new PVector(points.get(0).x, points.get(0).y));
                mapMode = 2;
                //saveMap();
              }
            } else {
              mapMode=1;
              points.add(new PVector(mouseX, mouseY));
            }
          }
        }
        //mouseAlreadyPressed = true;//remove "//" to allow free drawing
      }
    } else {
      mouseAlreadyPressed = false;
    }

    if (mapMode >-1 && mapMode<2) {
      fill(255, 0, 0);
      ellipseMode(CENTER);
      strokeWeight(3);
      ellipse(points.get(0).x, points.get(0).y, 75, 75);
    }
  }


  public void drawMap() {
    strokeWeight(10);
    stroke(0);
    for (int i=1; i<points.size(); i++) {
      strokeWeight(30);
      stroke(0);
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }
    for (int i=1; i<points.size(); i++) {
      strokeWeight(3);
      stroke(239, 183, 0);
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }

    if (points.size()>0 && mapMode < 2) {
      if (dist(mouseX, mouseY, points.get(0).x, points.get(0).y)<75/2) {
        strokeWeight(30);
        stroke(0);
        line(points.get(points.size()-1).x, points.get(points.size()-1).y, points.get(0).x, points.get(0).y);
        strokeWeight(3);
        stroke(239, 183, 0);
        line(points.get(points.size()-1).x, points.get(points.size()-1).y, points.get(0).x, points.get(0).y);
      } else {
        strokeWeight(30);
        stroke(0);
        line(points.get(points.size()-1).x, points.get(points.size()-1).y, mouseX, mouseY);
        strokeWeight(3);
        stroke(239, 183, 0);
        line(points.get(points.size()-1).x, points.get(points.size()-1).y, mouseX, mouseY);
      }
    }
    strokeWeight(3);
    stroke(0);
  }

  public void SAVEmap() {
    selectOutput("Pick a location to save your map", "saveMapWithFileName");
    noLoop();
  }

  public void saveMap(File selection) {
    int theMapId = floor(random(10000, 99999));
    String pointsToSend = "";
    println("saving");
    if (selection == null) {
    } else {
      PrintWriter saver = createWriter(selection.getAbsolutePath() + ".AHMAP"); 
      saver.println("{");
      saver.println("\"map_id\": \"" + theMapId + "\",");
      saver.print("\"points\": \": [");
      pointsToSend +="'[";
      for (int i=0; i<points.size(); i++) {
        saver.print("\"" + points.get(i).x + " " + points.get(i).y + "\"");
        pointsToSend +="\"" + points.get(i).x + " " + points.get(i).y + "\"";
      }
      pointsToSend +="]'";
      saver.println("]");
      saver.println("}");
      saver.flush();
      saver.close();

      String url = "http://home.bensherman.io:42069/post-map/?map_id=" + theMapId + "?" + pointsToSend;
      println(url);
      

      GetRequest get = new GetRequest(url);

      get.send();
      println("Reponse Content: " + get.getContent());
    }
    mousePressed=false;
    loop();
  }

  public ArrayList getPoints() {
    return points;
  }

  public int checkMode() {
    return mapMode;
  }

  public void clearMap() {
    mapMode = -1;
    while (points.size() > 0) {
      points.remove(0);
    }
  }
}
