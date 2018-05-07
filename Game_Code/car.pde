class car {

  ArrayList<PVector> points = new ArrayList<PVector>();
  float distToMove = 0;
  int currentPoint = 0;

  float x =-99;
  float y =-99;

  PImage img;
  final int idealSize = 50;

  public car(String carColor) {
    img = loadImage("assets/top down cars/top down " + carColor + " car.png");
    rescaleImage(img);
  }

  void rescaleImage(PImage img) {
    float ratio = img.width/img.height;
    img.resize(idealSize, (int)(idealSize/ratio));
  }

  public void loadMap(File selection) {
    while (points.size() > 0) {
      points.remove(0);
    }
    String[] newPoints = loadStrings(selection.getAbsolutePath());
    for (int i=0; i<newPoints.length; i++) {
      String[] specificPoint = split(newPoints[i], " ");
      points.add(new PVector(int (specificPoint[0]), int (specificPoint[1])));
    }
  }

  private void moveCar() {
    PVector curPointPlus1;
    PVector curPoint;

    if (currentPoint<points.size()) {
      curPoint = points.get(currentPoint);
    } else {
      curPoint = points.get(0);
    }


    if (currentPoint+1<points.size()) {
      curPointPlus1 = points.get(currentPoint+1);
    } else {
      curPointPlus1 = points.get(0);
    }



    float distBetweenPoints = abs(dist(curPoint.x, curPoint.y, curPointPlus1.x, curPointPlus1.y));
    if (distBetweenPoints < distToMove) {
      distToMove-=distBetweenPoints;
      if (currentPoint + 1<points.size()) {
        currentPoint++;
      } else {
        currentPoint=0;
      }

      moveCar();
    } else {
      PVector trackSection = new PVector(points.get(currentPoint + 1).x - curPoint.x, points.get(currentPoint + 1).y - curPoint.y);
      trackSection.setMag(abs(distToMove));
      imageMode(CENTER);

      pushMatrix();
      translate(curPoint.x+trackSection.x, curPoint.y+trackSection.y);
      rotate(trackSection.heading());
      image(img, 0, 0);
      popMatrix();

      // ellipse(curPoint.x+trackSection.x, curPoint.y+trackSection.y, 15, 15);
      // println(trackSection.mag());
    }
  }


  public void drawMap() {
    strokeWeight(10);
    stroke(0);
    for (int i=1; i<points.size(); i++) {
      strokeWeight(10);
      stroke(0);
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }
    for (int i=1; i<points.size(); i++) {
      //center of road
      strokeWeight(3);
      stroke(239, 183, 0);
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }
  }

  public void moveStep() {
    distToMove+=25;
  }
}