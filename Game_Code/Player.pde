import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

class Player {
  int id;
  char stepID;
  
  ControlIO control;
  ControlDevice stick;
  
  float px, py;

  int stepsTaken;

  boolean keyAlreadyPressed;

  public Player(int num, char step) {
    id = num;
    stepID = step;
  }

  public void init() {
    // Initialise the ControlIO
    control = ControlIO.getInstance(this);
    // Find a device that matches the configuration file
    stick = control.getMatchedDevice("inp" + num);
    if (stick == null) {
      println("No device with name inp" + num + "!");
      System.exit(-1); // ABORT MISSION
    }
  }

  public void emulateSteps() { // Code that emulates steps.  Press stepID to add a step.
    if (keyPressed) {
      if (keyAlreadyPressed == false) {
        keyAlreadyPressed = true;
        if (key == stepID) {
          stepsTaken++;
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
  }

  public void getUserInput() { // This code gets the location of the COM
    px = map(stick.getSlider("X").getValue(), -1, 1, 0, width);
    py = map(stick.getSlider("Y").getValue(), -1, 1, 0, heigth);
  }

  public float getX() { return px; }
  public float getY() { return py; }
  public int getSteps() { return stepsTaken; }
}
