class car {

  ArrayList<PVector> points = new ArrayList<PVector>();
  float distToMove = 0;
  int currentPoint = 0;

  float x =-99;
  float y =-99;
  float ang = 0;


  int lapNumber = 0;

  PImage img;
  final int idealSize = 50;

  public car(String carColor) {
    img = loadImage("assets/top down cars/top down " + carColor + " car.png");
    rescaleImage(img);
    lapNumber = 0;
    currentPoint = 0;
    distToMove = 0;
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
    String jsonPointsString = "";
    for (int i=0; i<newPoints.length; i++) {
      jsonPointsString+=newPoints[i];
    }
    JSONObject jsonPoints = parseJSONObject(jsonPointsString);
    JSONArray values = jsonPoints.getJSONArray("points");
    //println(values.getString(1));

    for (int i=0; i<values.size(); i++) {
      String[] specificPoint = split(values.getString(i), " ");
      points.add(new PVector(int (specificPoint[0]), int (specificPoint[1])));
    }
  }


  public void loadMap(String thePoints) {
    while (points.size() > 0) {
      points.remove(0);
    }


    //String[] newPoints = loadStrings(selection.getAbsolutePath());
    //String jsonPointsString = "";
    //for (int i=0; i<newPoints.length; i++) {
    //  jsonPointsString+=newPoints[i];
    //}
    //JSONObject jsonPoints = parseJSONObject(jsonPointsString);
    //JSONArray values = jsonPoints.getJSONArray("points");
    //println(values.getString(1));
    String[] specificPoint = split(thePoints, ",");
    for (int i=0; i<specificPoint.length; i++) {

      String[] newPoint = split(specificPoint[i], "-");
      if (newPoint.length >=2) {
        points.add(new PVector(int (newPoint[0]), int (newPoint[1])));
        println("newPoint");
      }
    }

    for (int i=0; i<points.size(); i++) {
      println(points.get(i));
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
      lapNumber++;
    }
    //println(lapNumber);



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

      x = curPoint.x+trackSection.x;
      y = curPoint.y+trackSection.y;
      ang = trackSection.heading();

      // ellipse(curPoint.x+trackSection.x, curPoint.y+trackSection.y, 15, 15);
      // println(trackSection.mag());
    }
  }


  public void drawMap(car secondCar) {
    ////line(points.get(0).x, points.get(0).y, points.get(i-1).x, points.get(i-1).y);
    //pushMatrix();
    //translate(x, y);
    //rotate(ang);
    ////image(img, 0, 0);
    ////line()
    //popMatrix();




    for (int i=1; i<points.size(); i++) {
      strokeWeight(30);
      stroke(0);
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }
    for (int i=1; i<points.size(); i++) {
      //center of road
      strokeWeight(3);
      stroke(239, 183, 0);
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }

    this.showCar();
    secondCar.showCar();


    //PVector line1 = new PVector(points.get(2).x - points.get(0).x, points.get(2).y - points.get(0).y);
    //PVector line2 = new PVector(points.get(points.size()-1).x - points.get(0).x, points.get(points.size()-1).y - points.get(0).y);
    //line1.setMag(10000);

    //fill(255, 124, 0);
    //line(300,300,300+line1.x,300+line1.y);
    //println("test");
  }

  public void showCar() {
    imageMode(CENTER);

    pushMatrix();
    translate(x, y);
    rotate(ang);
    image(img, 0, 0);
    popMatrix();
  }

  public void moveStep(float ammount) {
    distToMove += 75*ammount;
  }

  public int getLapNumber() {
    return lapNumber;
  }

  public void restart() {
    distToMove = 0;
    currentPoint = 0;
    lapNumber = 0;
  }


  public String getScore(int time) {
    float totalDist = 0;
    for (int i = 0; i<points.size()-1; i++) {
      totalDist += abs(dist(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y));
    }
    totalDist += abs(dist(points.get(0).x, points.get(0).y, points.get(points.size()-1).x, points.get(points.size()-1).y));

   println(floor((totalDist/(1+time))*1000));
   int score = floor((totalDist/(1+time))*1000);
    
    String text = String.format("%09d", score);
    println(text);


    return text;
  }
}
