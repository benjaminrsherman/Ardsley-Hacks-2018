class comMiniGame{
  int timer;
  int points = 0;
  float pointX, pointY;
  float pointRadius = pow(1.05,-points) * 100;
  
  public comMiniGame(int timeInSec){
    timer = timeInSec * 60;//the game runs at 60fps so this timer counts down at 1 number per frame
  }
  
  public void update(float px, float py){
    if(timer <= 0){
      pointX = -999;
    }else{
      timer--;
    }
    if(dist(px, py, pointX, pointY) < pointRadius/2){
      points++;
      generateNewPoint();
    }
    fill(0,0,255);
    ellipse(pointX, pointY, pointRadius, pointRadius);
  }
  
  private void generateNewPoint(){
    pointRadius=pow(1.05,-points) * 100;
    pointX=random(width-(pointRadius*2)) + pointRadius;
    pointY=random(height-(pointRadius*2)) + pointRadius;
  }
  
}