class raceTopDown {

  Player p1;
  Player p2;

  PImage car1;
  PImage car2;

  float car1DistanceToMove = 0;
  float car2DistanceToMove = 0;
  int car1CurrentPoint=0;
  int car2CurrentPoint=0;

  int stepSpeed = 5;

  final int idealWidth = 25;

  ArrayList<PVector> points = new ArrayList<PVector>();

  public raceTopDown(Player first, Player second) {
    p1 = first;
    p2 = second;
  }

  public void init() {
    car1 = loadImage("assets/top down cars/top down red car.png");
    car2 = loadImage("assets/top down cars/top down dark blue car.png");

    rescaleImage(car1);
    rescaleImage(car2);
  }

  public void draw() {
    image(car1, 50, 0);
    image(car2, 50, height/2);
  }

  void rescaleImage(PImage img) {
    float ratio = img.width/img.height;
    img.resize(idealWidth, (int)(idealWidth/ratio));
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
}