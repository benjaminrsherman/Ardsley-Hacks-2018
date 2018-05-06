class Race {
  
  final int idealHeight = 240;

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
    car2 = loadImage("car2.png");

    rescaleImage(car1);
    rescaleImage(car2);
  }

  public void draw() {
    image(car1, 0, 0);
    image(car2, 0, height/2);
  }

  void rescaleImage(PImage img) {
    float ratio = img.width/img.height;
    img.resize((int)(ratio*idealHeight), idealHeight);
  }
}
