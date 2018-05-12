import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

class Player {
  int id;
  char stepID;

  PApplet mainThread;

  ControlIO control;
  ControlDevice stick;

  float px, py;

  boolean keyAlreadyPressed;

  boolean ben;

  int pStepsTaken = 0;//total number of steps taken so far
  float defaultX = 1280/2;//this should be where the board defaults to when nobody is on it
  float defaultY = 720/2;//this should be where the board defaults to when nobody is on it
  int stepNeeded = 0; //0==any leg can step; 1==right leg must step; -1==left leg must step
  float stepOfsetPercentage = .15; //this is how far off from the center(defaultX) the COM of the player must be to count as a step

  boolean raceStarted = false;


  car myCar;

  float pStepsTakenf = 0;//total number of steps taken so far


  public Player(int num, char step, PApplet  main) {
    id = num;
    stepID = step;
    mainThread = main;
  }
  public Player(int num, char step, PApplet main, boolean runningOnBensComputerBecauseHesAPlebWithoutAWiiFitBoard) { // Descriptive variable names amirite
    id = num;
    stepID = step;
    mainThread = main;
    ben = runningOnBensComputerBecauseHesAPlebWithoutAWiiFitBoard;
  }

  public void init() {
    if (ben) { 
      return;
    }

    // Initialise the ControlIO
    control = ControlIO.getInstance(mainThread);
    // Find a device that matches the configuration file
    stick = control.getMatchedDevice("inp" + id);
    if (stick == null) {
      println("No device with name inp" + id + "!");
      System.exit(-1); // ABORT MISSION
    }


    defaultX = map(stick.getSlider("X").getValue(), -1, 1, 0, width);
    defaultY = map(stick.getSlider("Y").getValue(), -1, 1, 0, height);
    // println("defaultX " + defaultX);
    //println("defaultY " + defaultY);
  }

  public void emulateSteps() { // Code that emulates steps.  Press stepID to add a step.
    if (keyPressed) {
      if (keyAlreadyPressed == false) {
        keyAlreadyPressed = true;
        if (key == stepID) {
          pStepsTaken++;
        }
      } else {
        keyAlreadyPressed = false;
      }
    }
  }

  public void showCOM() {
    noStroke();
    fill(255, 0, 0);
    ellipse(px, py, 20, 20);

    strokeWeight(10);
    stroke(0);
    //line(defaultX+(width*stepOfsetPercentage), 0, defaultX+(width*stepOfsetPercentage), height);
    //line(defaultX-(width*stepOfsetPercentage), 0, defaultX-(width*stepOfsetPercentage), height);
    //line(defaultX,0,defaultX,height);
  }

  public void getUserInput() { // This code gets the location of the COM
    px=mouseX;
    py=mouseY;

    if (ben) {
      return;
    }
    px = map(stick.getSlider("X").getValue(), -1, 1, 0, width);
    py = map(stick.getSlider("Y").getValue(), -1, 1, 0, height);

    //println(px);
  }

  void updateSteps() { 
    if (raceStarted == true) {
      if (stepNeeded>=0) {//right
        float tempStepTaken = abs(defaultX-px)/( width *stepOfsetPercentage);
        if (tempStepTaken >=1 && defaultX-px < 0) {
          tempStepTaken = 1;
          myCar.moveStep(floor(pStepsTakenf)+tempStepTaken-pStepsTakenf);
          pStepsTakenf=floor(pStepsTakenf)+1;
          stepNeeded = -1;
        } else if (floor(pStepsTakenf)+tempStepTaken > pStepsTakenf && defaultX-px < 0) {
          myCar.moveStep(floor(pStepsTakenf)+tempStepTaken-pStepsTakenf);
          pStepsTakenf=floor(pStepsTakenf)+tempStepTaken;
        }
        // println("right tempStepTaken: " + tempStepTaken);
      } else if (stepNeeded<=0) {//right
        float tempStepTaken = abs(defaultX-px)/( width *stepOfsetPercentage);
        if (tempStepTaken >=1 && defaultX-px > 0) {
          tempStepTaken = 1;
          myCar.moveStep(floor(pStepsTakenf)+tempStepTaken-pStepsTakenf);
          pStepsTakenf=floor(pStepsTakenf)+1;
          stepNeeded = 1;
        } else if (floor(pStepsTakenf)+tempStepTaken > pStepsTakenf && defaultX-px > 0) {
          myCar.moveStep(floor(pStepsTakenf)+tempStepTaken-pStepsTakenf);
          pStepsTakenf=floor(pStepsTakenf)+tempStepTaken;
        }
        //  println("left tempStepTaken: " + tempStepTaken);
      }
       println("steps taken: " + id + " "+ pStepsTakenf);
    }
    println("steps taken: " + id + " "+ pStepsTakenf);
  } 

  public float getX() { 
    return px;
  }
  public float getY() { 
    return py;
  }
  public int getSteps() { 
    return pStepsTaken;
  }

  void startRace() {
    raceStarted = true;
    myCar.restart();
  }



  void startTopDownRace(String carColor, File selection) {
    myCar = new car(carColor);
    myCar.loadMap(selection);
  }
  void stopRace() {
    //myCar.stopRace();
  }

  public void drawMap(Player p2) {
     myCar.drawMap(p2.getCar());
  }
  public void race(Player p2) {
    myCar.drawMap(p2.getCar());
    myCar.moveCar();
  }

  public void race() {
    myCar.moveCar();
  }

  public int getLapNumber() {
    return myCar.getLapNumber();
  }

  public car getCar() {
    return myCar;
  }
}
