boolean doYouHaveAWiiFitBoard = false; // CHANGE THIS BASED ON YOUR SITUATION

Player p1 = new Player(0, 'q', this, !doYouHaveAWiiFitBoard);
Player p2 = new Player(1, 'w', this, !doYouHaveAWiiFitBoard);

public void setup() {
  size(400, 400);
  p1.init();
  p2.init();

  thread("genSteps");
}

public void draw() {
  background(255, 255, 240);

  p1.showCOM();

  println(p1.getSteps() + " " + p2.getSteps());
}

void genSteps() {
  while(true) {
    p1.getUserInput();
    p2.getUserInput();
    p1.emulateSteps();
    p2.emulateSteps();
    p1.updateSteps();

    try {
      Thread.sleep(5);
    } catch (InterruptedException e) {
      println("rip");
      System.exit(-1); // No more thread = no more input
    }
  }
}
