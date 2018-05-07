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
    if (currentPoint+1<points.size()) {
      float distBetweenPoints = abs(dist(points.get(currentPoint).x, points.get(currentPoint).y, points.get(currentPoint+1).x, points.get(currentPoint+1).y));
      if (distBetweenPoints < distToMove) {
        currentPoint++;
        distToMove-=distBetweenPoints;
        moveCar();
      } else {
        PVector trackSection = new PVector(points.get(currentPoint + 1).x - points.get(currentPoint).x, points.get(currentPoint + 1).y - points.get(currentPoint).y);
        trackSection.setMag(abs(distToMove));
        imageMode(CENTER);

        pushMatrix();
        translate(points.get(currentPoint).x+trackSection.x, points.get(currentPoint).y+trackSection.y);
        rotate(trackSection.heading());
        image(img, 0, 0);
        popMatrix();

        // ellipse(points.get(currentPoint).x+trackSection.x, points.get(currentPoint).y+trackSection.y, 15, 15);
        // println(trackSection.mag());
      }
    }
  }

  public void drawMap() {
    strokeWeight(10);
    stroke(0);
    for (int i=1; i<points.size(); i++) {
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }
  }

  public void moveStep() {
    distToMove+=25;
  }
}