Player p1 = new Player(0, 'q');
Player p2 = new Player(1, 'w');

public void setup() {
  size(400, 400);
  p1.init();
  p2.init();
}

public void draw() {
  p1.getUserInput(); // Polling
  p2.getUserInput();
  background(255, 255, 240);
  p1.emulateSteps();
  p2.emulateSteps();

  println(p1.getSteps() + " " + p2.getSteps());
}
