import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
ControlDevice stick;
float px1, py1;


ControlIO control2;
ControlDevice stick2;
float px2, py2;


int p1StepsTaken = 0;
int p2StepsTaken = 0;

boolean keyAlreadyPressed = false; //this limits the user from holding donw a key for emulating steps to add more than one step press the key mulitaple times

public void setup() {
  size(400, 400);
  // Initialise the ControlIO
  control = ControlIO.getInstance(this);
  // Find a device that matches the configuration file
  stick = control.getMatchedDevice("joystick");
  if (stick == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }



  control2 = ControlIO.getInstance(this);
  // Find a device that matches the configuration file
  stick2 = control2.getMatchedDevice("joystick2");
  if (stick2 == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
}

public void draw() {
  getUserInput(); // Polling
  background(255, 255, 240);
  emulateSteps();

  println(p1StepsTaken + " " + p2StepsTaken);
}




void emulateSteps() {//Code that emulates steps press "q" to add to play 1 steps and "w" for player 2
  if (keyPressed) {
    if (keyAlreadyPressed == false) {
      keyAlreadyPressed = true;
      if (key == 'q') {
        p1StepsTaken++;
      }
      if (key == 'w') {
        p2StepsTaken++;
      }
    }
  } else {
    keyAlreadyPressed = false;
  }
}

void showCOM() {// this shows the center of mass of the player but do not use this unless you ask Eli how to set it up
  noStroke();
  fill(255, 0, 0);
  ellipse(px1, py1, 20, 20);

  noStroke();
  fill(0, 255, 0);
  ellipse(px2, py2, 20, 20);
}


public void getUserInput() {//this code gets the location of the COM of the person
  px1 = map(stick.getSlider("X").getValue(), -1, 1, 0, width);
  py1 = map(stick.getSlider("Y").getValue(), -1, 1, 0, height);

  px2 = map(stick2.getSlider("X").getValue(), -1, 1, 0, width);
  py2 = map(stick2.getSlider("Y").getValue(), -1, 1, 0, height);
}