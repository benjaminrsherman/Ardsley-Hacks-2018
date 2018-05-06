class Race {
  
  final int idealWidth = 240;
  final int stepGoal = 50; // Steps needed to win the game

  Player p1;
  Player p2;

  PImage car1;
  PImage car2;

  public Race(Player first, Player second) {
    p1 = first;
    p2 = second;
  }

  public void init() {
    car1 = loadImage("car1.png");
    car2 = loadImage("car1.png");

    rescaleImage(car1);
    rescaleImage(car2);
  }

  public void draw() {
    float car1prog = (float)p1.getSteps()/stepGoal;
    float car2prog = (float)p2.getSteps()/stepGoal;

    image(car1, (int)((width-idealWidth)*car1prog), 0);
    image(car2, (int)((width-idealWidth)*car2prog), height/2);
  }

  void rescaleImage(PImage img) {
    float ratio = img.width/img.height;
    img.resize(idealWidth, (int)(idealWidth/ratio));
  }
}
