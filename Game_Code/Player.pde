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
  float stepOfsetPercentage = .02; //this is how far off from the center(defaultX) the COM of the player must be to count as a step


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
    println("defaultX " + defaultX);
    println("defaultY " + defaultY);
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

  public void showCOM() { // Shows the center of mass of the player. Don't use unless you're Eli
    noStroke();
    fill(255, 0, 0);
    ellipse(px, py, 20, 20);

    strokeWeight(10);
    stroke(0);
    line(defaultX+(width*stepOfsetPercentage), 0, defaultX+(width*stepOfsetPercentage), height);
    line(defaultX-(width*stepOfsetPercentage), 0, defaultX-(width*stepOfsetPercentage), height);
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
    if (px > defaultX+(width*stepOfsetPercentage) && stepNeeded>=0) {
      stepNeeded = -1;
      pStepsTaken++;
      println("right step, total steps taken=" + pStepsTaken);
    }
    if (px < defaultX-(width*stepOfsetPercentage) && stepNeeded<=0) {
      stepNeeded = 1;
      pStepsTaken++;
      println("left step, total steps taken=" + pStepsTaken);
    }
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
}