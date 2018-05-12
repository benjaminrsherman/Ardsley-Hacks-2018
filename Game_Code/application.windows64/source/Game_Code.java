import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import javafx.scene.media.Media; 
import javafx.scene.media.MediaPlayer; 
import java.util.Random; 
import http.requests.*; 
import org.gamecontrolplus.gui.*; 
import org.gamecontrolplus.*; 
import net.java.games.input.*; 

import org.apache.commons.httpclient.auth.*; 
import org.apache.commons.httpclient.util.*; 
import org.apache.commons.httpclient.*; 
import org.apache.commons.httpclient.params.*; 
import org.apache.commons.httpclient.protocol.*; 
import org.apache.commons.httpclient.methods.multipart.*; 
import org.apache.commons.httpclient.methods.*; 
import org.apache.commons.httpclient.cookie.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Game_Code extends PApplet {







Random r = new Random();

boolean doYouHaveAWiiFitBoard = true; // CHANGE THIS BASED ON YOUR SITUATION

Player p1 = new Player(0, 'q', this, !doYouHaveAWiiFitBoard);
Player p2 = new Player(1, 'w', this, !doYouHaveAWiiFitBoard);

Race race = new Race(p1, p2);

mapMaker map = new mapMaker();

int timer = 0;

String name = "";
boolean keyJustPressed=false;

int mapid=-999;


comMiniGame miniGame = new comMiniGame();

int gameMode = 0; //0==game menue; 10==race; 20==mapMaker; 30==mini games
boolean keyAlreadyPressed;

public void setup() {
  

  p1.init();
  p2.init();
  race.init();

  thread("genSteps");


  motivate();
}

public void draw() {
  background(255, 255, 240);
  stroke(0);

  if (gameMode == 0) {
    mainMenu();
  } else if (gameMode == 10) {
  } else if (gameMode == 20) {
    background(00, 165, 80);
    strokeWeight(0);
    rectMode(CORNER);
    fill(0);
    rect(width - 76, 0, width, height);

    rectMode(CENTER);
    strokeWeight(3);
    fill(255, 87, 10);
    if (mouseX > (width - 38)-(50/2) && mouseX < (width - 38)+(50/2) && mouseY > 50-(50/2) && mouseY < 50+(50/2)) {
      fill(255, 135, 75);
      if (mousePressed && map.checkMode() == 2) {
        selectOutput("Pick a place to save your map", "saveFileFromSelection");
        noLoop();
      }
    }
    rect(width - 38, 50, 50, 50, 10);
    fill(0);
    textSize(13);
    text("Save", width - 38, 55);


    fill(255, 87, 10);
    if (mouseX > (width - 38)-(50/2) && mouseX < (width - 38)+(50/2) && mouseY > 125-(50/2) && mouseY < 125+(50/2)) {
      fill(255, 135, 75);
      if (mousePressed) {
        map.clearMap();
        timer = 0;
      }
    }
    rect(width - 38, 125, 50, 50, 10);
    fill(0);
    textSize(13);
    text("Restart", width - 38, 130);

    fill(9, 64, 116);
    if (mouseX > (width - 38)-(50/2) && mouseX < (width - 38)+(50/2) && mouseY > (height-55)-(50/2) && mouseY < (height-55)+(50/2)) {
      fill(65, 110, 150);
      if (mousePressed) {
        p1.stopRace();
        p2.stopRace();
        gameMode = 0;
        timer = 0;
      }
    }
    rect(width - 38, height-55, 50, 50, 10);
    fill(255);
    textSize(13);
    text("Home", width - 38, height-50);



    map.makeMap();
    map.drawMap();
  } else if (gameMode == 25) {
    background(00, 165, 80);
    strokeWeight(0);
    rectMode(CORNER);
    fill(0);
    rect(width - 76, 0, width, height);

    rectMode(CENTER);
    strokeWeight(3);
    fill(255, 87, 10);
    if (mouseX > (width - 38)-(50/2) && mouseX < (width - 38)+(50/2) && mouseY > 50-(50/2) && mouseY < 50+(50/2)) {
      fill(255, 135, 75);
      if (mousePressed) {
        selectInput("Select map to load", "loadFileFromSelection");
        timer = 0;
        noLoop();
        println("loading");
      }
    }
    rect(width - 38, 50, 50, 50, 10);
    fill(0);
    textSize(13);
    text("Load", width - 38, 55);


    fill(255, 87, 10);
    if (mouseX > (width - 38)-(50/2) && mouseX < (width - 38)+(50/2) && mouseY > 125-(50/2) && mouseY < 125+(50/2)) {
      fill(255, 135, 75);
      if (mousePressed) {

        p1.startRace();
        p2.startRace();
        timer = 0;
      }
    }
    rect(width - 38, 125, 50, 50, 10);
    fill(0);
    textSize(13);
    text("Restart", width - 38, 130);

    fill(9, 64, 116);
    if (mouseX > (width - 38)-(50/2) && mouseX < (width - 38)+(50/2) && mouseY > (height-55)-(50/2) && mouseY < (height-55)+(50/2)) {
      fill(65, 110, 150);
      if (mousePressed) {
        gameMode = 0;
      }
    }
    rect(width - 38, height-55, 50, 50, 10);
    fill(255);
    textSize(13);
    text("Home", width - 38, height-50);




    if (p1.getLapNumber() <= 3) {
      p1.drawMap(p2);
      fill(255, 215, 0);
      rectMode(CENTER);
      noStroke();
      rect(width/2-76, height/2, 350, 75, 100);
      fill(0);
      textSize(50);
      text("Player 1 Wins!", width/2-76, height/2+17);
      //println("score = " + timer);
      nameBox(p1);
    } else if (p2.getLapNumber() >= 3) {
      p1.drawMap(p2);
      fill(255, 215, 0);
      rectMode(CENTER);
      noStroke();
      rect(width/2-76, height/2, 350, 75, 100);
      fill(0);
      textSize(50);
      text("Player 2 Wins!", width/2-76, height/2+17);
      //println("score = " + timer);
      nameBox(p2);
    } else {
      timer++;
      if (timer>=60*3) {
        p1.startLaps();
        p2.startLaps();
      } else {
        noStroke();
        fill(0, 0, 0, 100);
        rect(width/2, height/2, 150, 150);
        fill(255);
        textSize(100);
        text(3-floor(timer/60), width/2, height/2+33);
      }
      //p1.startLaps();
      //  p1.startLaps();
      p1.race(p2);
      p2.race();
    }
  } else if (gameMode == 30) {
    p1.showCOM();
    if (miniGame.update(p1.getX(), p1.getY())>-1) {
      gameMode=0;
    }
  }
  //p1.showCOM();
  //p2.showCOM();
}

public void nameBox(Player winningPlayer) {
  if (keyPressed == true) {
    if (keyJustPressed==false) {
      keyJustPressed=true;
      println(key);
      if (key == '') {
        println("backspace");
        if (name.length()>0) {
          name=name.substring(0, name.length()-1);
        }
      } else {
        name+=key;
        name=name.toUpperCase();
      }
    }
  } else {
    keyJustPressed=false;
  }

  fill(255);
  stroke(0);
  rect(width/2-76, height/2+100, 350, 75, 100);

  textAlign(LEFT);
  fill(0);
  text(name, width/2-76-(350/2)+5, height/2+17+100);
  textAlign(CENTER);



  fill(255, 87, 10);
  if (mouseX > (width/2 + 150)-(75/2) && mouseX < (width/2 + 150)+(75/2) && mouseY > (height/2+100)-(75/2) && mouseY < (height/2+100)+(75/2)) {
    fill(255, 135, 75);
    if (mousePressed) {
      String score = winningPlayer.getScore(timer);

      String url2 = "http://home.bensherman.io:42069/post-score/?map_id=" + mapid + "&name=" + name + "&score=" + score;
      println(url2);
      GetRequest get2 = new GetRequest(url2);
      get2.send();
      println("Reponse Content: " + get2.getContent());
    }
  }
  rect(width/2 + 150, height/2+100, 75, 75, 10);
  fill(255, 255, 255);
  text("+", width/2 + 150, height/2+100+13);
  
  scoreBoard();
}


public void scoreBoard(){
  
  
  
}

public void sendScoreToServer() {
}



public void genSteps() {
  while (true) {
    p1.getUserInput();
    p2.getUserInput();
    p1.emulateSteps();
    p2.emulateSteps();
    p1.updateSteps();
    p2.updateSteps();

    try {
      Thread.sleep(5);
    } 
    catch (InterruptedException e) {
      println("rip");
      System.exit(-1); // No more thread = no more input
    }
  }
}

public void motivate() {
  println("Initializing motivation...");
  String songLoc = "Game_Code/assets/";
  switch (r.nextInt(2)) {
  case 0:
    songLoc = songLoc + "mortal_kombat.wav";
    break;
  case 1:
    songLoc = songLoc + "hampster.wav";
    break;
  }

  //Media song = new Media(new File(songLoc).toURI().toString());
  //MediaPlayer mediaPlayer = new MediaPlayer(song);
  //mediaPlayer.play();
}


public void mainMenu() {
  noStroke();
  background(9, 64, 116);
  textAlign(CENTER);
  textSize(50);
  fill(255, 255, 255);
  text("Weclome To Health Connect!", width/2, 75);

  rectMode(CENTER);

  fill(215, 38, 56);
  if (mouseX > (width/2)-(350/2) && mouseX < (width/2)+(350/2) && mouseY > 150-(75/2) && mouseY < 150+(75/2)) {
    fill(255, 75, 100);
    if (mousePressed) {
      //p1.startRace();
      //p2.startRace();
      //gameMode = 10;
      selectInput("Select map to load", "loadFileFromSelection");
      noLoop();
    }
  }
  rect(width/2, 150, 350, 75, 10);
  fill(255, 255, 255);
  text("Start A Race", width/2, 167);

  fill(255, 87, 10);
  if (mouseX > (width/2)-(350/2) && mouseX < (width/2)+(350/2) && mouseY > 250-(75/2) && mouseY < 250+(75/2)) {
    fill(255, 135, 75);
    if (mousePressed) {
      gameMode = 20;
    }
  }
  rect(width/2, 250, 350, 75, 10);
  fill(255, 255, 255);
  text("Make A Map", width/2, 267);


  //plus button
  fill(255, 87, 10);
  if (mouseX > (width/2 + 250)-(75/2) && mouseX < (width/2 + 250)+(75/2) && mouseY > 250-(75/2) && mouseY < 250+(75/2)) {
    fill(255, 135, 75);
    if (mousePressed) {
      String url2 = "http://home.bensherman.io:42069/get-map/?map_id=" + "74112";
      println(url2);
      GetRequest get2 = new GetRequest(url2);
      get2.send();
      println("Reponse Content: " + get2.getContent());


      gameMode = 25;
      //map.loadMap(selection);
      p1.startTopDownRace("red", get2.getContent());
      p2.startTopDownRace("dark blue", get2.getContent());
      p1.startRace();
      p2.startRace();
      timer = 0;
    }
  }
  rect(width/2 + 250, 250, 75, 75, 10);
  fill(255, 255, 255);
  text("+", width/2 + 250, 267);
  //plus button

  //fill(50, 159, 91);
  //if (mouseX > (width/2)-(350/2) && mouseX < (width/2)+(350/2) && mouseY > 350-(75/2) && mouseY < 350+(75/2)) {
  //  fill(100, 200, 135);
  //  if (mousePressed) {
  //    gameMode = 30;
  //    miniGame.startGame(30);
  //  }
  //}
  //rect(width/2, 350, 350, 75, 10);
  //fill(255, 255, 255);
  //text("Mini Games", width/2, 367);
}

public void loadFileFromSelection(File selection) {
  if (selection == null) {
  } else if (selection.getAbsolutePath().indexOf(".AHMAP")>=0) {
    String[] newPoints = loadStrings(selection.getAbsolutePath());
    String jsonPointsString = "";
    for (int i=0; i<newPoints.length; i++) {
      jsonPointsString+=newPoints[i];
    }
    JSONObject jsonPoints = parseJSONObject(jsonPointsString);
    mapid = PApplet.parseInt(jsonPoints.getString("map_id"));
    println("mapid= " + mapid);
    
    
    
    gameMode = 25;
    //map.loadMap(selection);
    p1.startTopDownRace("red", selection);
    p2.startTopDownRace("dark blue", selection);
    p1.startRace();
    p2.startRace();
    timer = 0;
  }
  mousePressed=false;
  loop();
}

public void saveFileFromSelection(File selection) {
  int theMapId = floor(random(10000, 99999));
  String pointsToSend = "";
  ArrayList<PVector> points = map.getPoints();
  if (selection == null) {
  } else {
    String saveLocation = selection.getAbsolutePath();
    if (selection.getAbsolutePath().indexOf(".") > 0) {
      saveLocation = selection.getAbsolutePath().substring(0, selection.getAbsolutePath().indexOf("."));
    }
    PrintWriter saver = createWriter(saveLocation + ".AHMAP"); 
    saver.println("{");
    saver.println("\"map_id\": \"" + theMapId + "\",");
    saver.print("\"points\": [");
    pointsToSend +="'";
    for (int i=0; i<points.size(); i++) {
      saver.print("\"" + points.get(i).x + " " + points.get(i).y);
      pointsToSend +=points.get(i).x + "-" + points.get(i).y + ",";
      if (i+1==points.size()) {
        saver.print("\"");
        //pointsToSend += ",";
      } else {
        saver.print("\",");
        //pointsToSend += ",";
      }
    }
    saver.println("]");
    saver.println("}");
    saver.flush();
    saver.close();
    pointsToSend +="'";
    String url = "http://home.bensherman.io:42069/post-map/?map_id=" + theMapId + "&points=" + pointsToSend;
    println(url);
    GetRequest get = new GetRequest(url);
    get.send();
    println("sent");
    println("Reponse Content: " + get.getContent());

    delay(1000);

    String url2 = "http://home.bensherman.io:42069/get-map/?map_id=" + theMapId;
    println(url2);
    GetRequest get2 = new GetRequest(url2);
    get2.send();
    println("Reponse Content: " + get2.getContent());
  }
  mousePressed=false;
  loop();
}




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
  float stepOfsetPercentage = .15f; //this is how far off from the center(defaultX) the COM of the player must be to count as a step

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

  public void updateSteps() { 
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
       //println("steps taken: " + id + " "+ pStepsTakenf);
    }
    //println("steps taken: " + id + " "+ pStepsTakenf);
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

  public void startRace() {
    //raceStarted = true;
    myCar.restart();
  }
  
  public void startLaps(){
    raceStarted = true;
  }



  public void startTopDownRace(String carColor, File selection) {
    myCar = new car(carColor);
    myCar.loadMap(selection);
  }
  
    public void startTopDownRace(String carColor, String thePoints) {
    myCar = new car(carColor);
    myCar.loadMap(thePoints);
  }
  
  public void stopRace() {
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
  
  
  public String getScore(int time){
    return myCar.getScore(time);
  }
}
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

    if (car1prog >= 1 && car1prog >= car2prog) {
      println("Car 1 wins!");
      System.exit(0);
    } else if (car2prog >= 1) {
      println("Car 2 wins!");
      System.exit(0);
    }

    image(car1, (int)((width-idealWidth)*car1prog), 0);
    image(car2, (int)((width-idealWidth)*car2prog), height/2);
  }

  public void rescaleImage(PImage img) {
    float ratio = img.width/img.height;
    img.resize(idealWidth, (int)(idealWidth/ratio));
  }
}
class car {

  ArrayList<PVector> points = new ArrayList<PVector>();
  float distToMove = 0;
  int currentPoint = 0;

  float x =-99;
  float y =-99;
  float ang = 0;


  int lapNumber = 0;

  PImage img;
  final int idealSize = 50;

  public car(String carColor) {
    img = loadImage("assets/top down cars/top down " + carColor + " car.png");
    rescaleImage(img);
    lapNumber = 0;
    currentPoint = 0;
    distToMove = 0;
  }

  public void rescaleImage(PImage img) {
    float ratio = img.width/img.height;
    img.resize(idealSize, (int)(idealSize/ratio));
  }

  public void loadMap(File selection) {
    while (points.size() > 0) {
      points.remove(0);
    }


    String[] newPoints = loadStrings(selection.getAbsolutePath());
    String jsonPointsString = "";
    for (int i=0; i<newPoints.length; i++) {
      jsonPointsString+=newPoints[i];
    }
    JSONObject jsonPoints = parseJSONObject(jsonPointsString);
    JSONArray values = jsonPoints.getJSONArray("points");
    //println(values.getString(1));

    for (int i=0; i<values.size(); i++) {
      String[] specificPoint = split(values.getString(i), " ");
      points.add(new PVector(PApplet.parseInt (specificPoint[0]), PApplet.parseInt (specificPoint[1])));
    }
  }


  public void loadMap(String thePoints) {
    while (points.size() > 0) {
      points.remove(0);
    }


    //String[] newPoints = loadStrings(selection.getAbsolutePath());
    //String jsonPointsString = "";
    //for (int i=0; i<newPoints.length; i++) {
    //  jsonPointsString+=newPoints[i];
    //}
    //JSONObject jsonPoints = parseJSONObject(jsonPointsString);
    //JSONArray values = jsonPoints.getJSONArray("points");
    //println(values.getString(1));
    String[] specificPoint = split(thePoints, ",");
    for (int i=0; i<specificPoint.length; i++) {

      String[] newPoint = split(specificPoint[i], "-");
      if (newPoint.length >=2) {
        points.add(new PVector(PApplet.parseInt (newPoint[0]), PApplet.parseInt (newPoint[1])));
        println("newPoint");
      }
    }

    for (int i=0; i<points.size(); i++) {
      println(points.get(i));
    }
  }

  private void moveCar() {
    PVector curPointPlus1;
    PVector curPoint;

    if (currentPoint<points.size()) {
      curPoint = points.get(currentPoint);
    } else {
      curPoint = points.get(0);
    }


    if (currentPoint+1<points.size()) {
      curPointPlus1 = points.get(currentPoint+1);
    } else {
      curPointPlus1 = points.get(0);
      lapNumber++;
    }
    //println(lapNumber);



    float distBetweenPoints = abs(dist(curPoint.x, curPoint.y, curPointPlus1.x, curPointPlus1.y));
    if (distBetweenPoints < distToMove) {
      distToMove-=distBetweenPoints;
      if (currentPoint + 1<points.size()) {
        currentPoint++;
      } else {
        currentPoint=0;
      }

      moveCar();
    } else {
      PVector trackSection = new PVector(points.get(currentPoint + 1).x - curPoint.x, points.get(currentPoint + 1).y - curPoint.y);
      trackSection.setMag(abs(distToMove));
      imageMode(CENTER);

      pushMatrix();
      translate(curPoint.x+trackSection.x, curPoint.y+trackSection.y);
      rotate(trackSection.heading());
      image(img, 0, 0);
      popMatrix();

      x = curPoint.x+trackSection.x;
      y = curPoint.y+trackSection.y;
      ang = trackSection.heading();

      // ellipse(curPoint.x+trackSection.x, curPoint.y+trackSection.y, 15, 15);
      // println(trackSection.mag());
    }
  }


  public void drawMap(car secondCar) {
    ////line(points.get(0).x, points.get(0).y, points.get(i-1).x, points.get(i-1).y);
    //pushMatrix();
    //translate(x, y);
    //rotate(ang);
    ////image(img, 0, 0);
    ////line()
    //popMatrix();




    for (int i=1; i<points.size(); i++) {
      strokeWeight(30);
      stroke(0);
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }
    for (int i=1; i<points.size(); i++) {
      //center of road
      strokeWeight(3);
      stroke(239, 183, 0);
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }

    this.showCar();
    secondCar.showCar();


    //PVector line1 = new PVector(points.get(2).x - points.get(0).x, points.get(2).y - points.get(0).y);
    //PVector line2 = new PVector(points.get(points.size()-1).x - points.get(0).x, points.get(points.size()-1).y - points.get(0).y);
    //line1.setMag(10000);

    //fill(255, 124, 0);
    //line(300,300,300+line1.x,300+line1.y);
    //println("test");
  }

  public void showCar() {
    imageMode(CENTER);

    pushMatrix();
    translate(x, y);
    rotate(ang);
    image(img, 0, 0);
    popMatrix();
  }

  public void moveStep(float ammount) {
    distToMove += 75*ammount;
  }

  public int getLapNumber() {
    return lapNumber;
  }

  public void restart() {
    distToMove = 0;
    currentPoint = 0;
    lapNumber = 0;
  }


  public String getScore(int time) {
    float totalDist = 0;
    for (int i = 0; i<points.size()-1; i++) {
      totalDist += abs(dist(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y));
    }
    totalDist += abs(dist(points.get(0).x, points.get(0).y, points.get(points.size()-1).x, points.get(points.size()-1).y));

   println(floor((totalDist/(1+time))*1000));
   int score = floor((totalDist/(1+time))*1000);
    
    String text = String.format("%09d", score);
    println(text);


    return text;
  }
}
class comMiniGame {
  int timer;
  int points = 0;
  float pointX, pointY;
  float pointRadius = pow(1.05f, -points) * 100;
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
    pointRadius=pow(1.05f, -points) * 100;
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
class mapMaker {

  ArrayList<PVector> points = new ArrayList<PVector>();

  int mapMode = -1;//-1== no points yet; 0=placing point and has not left starting area; 1==placing track 2==done

  boolean mouseAlreadyPressed = true;


  public mapMaker() {
  }


  public void makeMap() {
    if (mousePressed) {
      //mouseAlreadyPressed = false;
      if (mouseAlreadyPressed == false) {
        if (mouseX<width-76) {
          if (mapMode == -1) {
            points.add(new PVector(mouseX, mouseY));
            mapMode = 0;
          } else if (mapMode < 2) {
            if (dist(mouseX, mouseY, points.get(0).x, points.get(0).y)<75/2) {
              if (mapMode==0) {
                points.add(new PVector(mouseX, mouseY));
              } else {
                points.add(new PVector(points.get(0).x, points.get(0).y));
                mapMode = 2;
                //saveMap();
              }
            } else {
              mapMode=1;
              points.add(new PVector(mouseX, mouseY));
            }
          }
        }
        //mouseAlreadyPressed = true;//remove "//" to allow free drawing
      }
    } else {
      mouseAlreadyPressed = false;
    }

    if (mapMode >-1 && mapMode<2) {
      fill(255, 0, 0);
      ellipseMode(CENTER);
      strokeWeight(3);
      ellipse(points.get(0).x, points.get(0).y, 75, 75);
    }
  }


  public void drawMap() {
    strokeWeight(10);
    stroke(0);
    for (int i=1; i<points.size(); i++) {
      strokeWeight(30);
      stroke(0);
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }
    for (int i=1; i<points.size(); i++) {
      strokeWeight(3);
      stroke(239, 183, 0);
      line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
    }

    if (points.size()>0 && mapMode < 2) {
      if (dist(mouseX, mouseY, points.get(0).x, points.get(0).y)<75/2) {
        strokeWeight(30);
        stroke(0);
        line(points.get(points.size()-1).x, points.get(points.size()-1).y, points.get(0).x, points.get(0).y);
        strokeWeight(3);
        stroke(239, 183, 0);
        line(points.get(points.size()-1).x, points.get(points.size()-1).y, points.get(0).x, points.get(0).y);
      } else {
        strokeWeight(30);
        stroke(0);
        line(points.get(points.size()-1).x, points.get(points.size()-1).y, mouseX, mouseY);
        strokeWeight(3);
        stroke(239, 183, 0);
        line(points.get(points.size()-1).x, points.get(points.size()-1).y, mouseX, mouseY);
      }
    }
    strokeWeight(3);
    stroke(0);
  }

  public void SAVEmap() {
    selectOutput("Pick a location to save your map", "saveMapWithFileName");
    noLoop();
  }

  public void saveMap(File selection) {
    int theMapId = floor(random(10000, 99999));
    String pointsToSend = "";
    println("saving");
    if (selection == null) {
    } else {
      PrintWriter saver = createWriter(selection.getAbsolutePath() + ".AHMAP"); 
      saver.println("{");
      saver.println("\"map_id\": \"" + theMapId + "\",");
      saver.print("\"points\": \": [");
      pointsToSend +="'[";
      for (int i=0; i<points.size(); i++) {
        saver.print("\"" + points.get(i).x + " " + points.get(i).y + "\"");
        pointsToSend +="\"" + points.get(i).x + " " + points.get(i).y + "\"";
      }
      pointsToSend +="]'";
      saver.println("]");
      saver.println("}");
      saver.flush();
      saver.close();

      String url = "http://home.bensherman.io:42069/post-map/?map_id=" + theMapId + "?" + pointsToSend;
      println(url);
      

      GetRequest get = new GetRequest(url);

      get.send();
      println("Reponse Content: " + get.getContent());
    }
    mousePressed=false;
    loop();
  }

  public ArrayList getPoints() {
    return points;
  }

  public int checkMode() {
    return mapMode;
  }

  public void clearMap() {
    mapMode = -1;
    while (points.size() > 0) {
      points.remove(0);
    }
  }
}
  public void settings() {  size(1280, 720); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Game_Code" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
