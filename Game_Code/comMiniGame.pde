class comMiniGame {
  int timer;
  int points = 0;
  float pointX, pointY;
  float pointRadius = pow(1.05, -points) * 100;
  boolean miniGameStarted = false;

  public comMiniGame() {
  }

  public int update(float px, float py) {
    if (timer <= 0) {
      pointX = -999;
      miniGameStarted=false;
      return points;
    } else if (miniGameStarted == true) {
      timer--;
    }
    if (dist(px, py, pointX, pointY) < pointRadius/2+10) {
      points++;
      generateNewPoint();
    }
    fill(0, 0, 255);
    noStroke();
    ellipse(pointX, pointY, pointRadius, pointRadius);
    return -1;
  }

  private void generateNewPoint() {
    pointRadius=pow(1.05, -points) * 100;
    pointX=random(width-(pointRadius*8)) + (pointRadius*4);
    pointY=random(height-(pointRadius*8)) + (pointRadius*4);
  }

  public void startGame(int timeInSec) {
    points=0;
    timer = timeInSec * 60;//the game runs at 60fps so this timer counts down at 1 number per frame
    miniGameStarted=true;
    generateNewPoint();
  }
}
