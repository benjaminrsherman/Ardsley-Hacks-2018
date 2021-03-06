import javafx.scene.media.Media;
import javafx.scene.media.MediaPlayer;
import java.util.Random;
import http.requests.*;

import processing.sound.*;
SoundFile file;

String mapidString = "";
Random r = new Random();

boolean doYouHaveAWiiFitBoard = true; // CHANGE THIS BASED ON YOUR SITUATION

Player p1 = new Player(0, 'q', this, !doYouHaveAWiiFitBoard);
Player p2 = new Player(1, 'w', this, !doYouHaveAWiiFitBoard);

Race race = new Race(p1, p2);

mapMaker map = new mapMaker();

int timer = 0;

String name = "TYPE-NAME";
boolean keyJustPressed=false;

int mapid=-999;

String names ="";
String scores = "";
String mapids = "";
boolean needToGetScores = true;

comMiniGame miniGame = new comMiniGame();

int gameMode = 0; //0==game menue; 10==race; 20==mapMaker; 30==mini games
boolean keyAlreadyPressed;

public void setup() {
  size(1280, 720);
  
  file = new SoundFile(this, "C:/Users/elihs/OneDrive/Github/Ardsley-Hacks-2018/Game_Code/assets/bht.mp3");
  file.play();

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
  } else if (gameMode == 50) {
    background(255);
    text("Hold on while another player joins the game...", width/2, height/2);
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




    if (p1.getLapNumber() >= 3) {
      p1.drawMap(p2);
      fill(255, 215, 0);
      rectMode(CENTER);
      noStroke();
      rect(width/2-76, height/2, 350, 75, 100);
      fill(0);
      textSize(50);
      text("Player 1 Wins!", width/2-76, height/2+17);

      if (needToGetScores == true) {
        needToGetScores = false;
        getScores();
      }
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


      if (needToGetScores == true) {
        needToGetScores = false;
        getScores();
      }

      nameBox(p2);
    } else {
      p1.race(p2);
      p2.race();
      timer++;
      if (timer>=60*3) {
        p1.startLaps();
        p2.startLaps();
        textSize(25);
        text("Player 1 Score: " +  p1.getScore(timer), 150, 25);
        text("Player 2 Score: " +  p2.getScore(timer), 150, 50);
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



void mapBox() {
  if (keyPressed == true) {
    if (keyJustPressed==false) {
      keyJustPressed=true;
      println(key);
      if (key == '') {
        println("backspace");
        if (mapidString.length()>0) {
          mapidString=mapidString.substring(0, mapidString.length()-1);
        }
      } else {
        if (name == "TYPE-MAP-ID") {
          mapidString="" + key;
        } else {
          mapidString+=key;
          mapidString=mapidString.toUpperCase();
        }
      }
    }
  } else {
    keyJustPressed=false;
  }

  textMode(CENTER);
  fill(255);
  stroke(0);
  rect(width/2, height/2+100, 350, 75, 100);

  textAlign(CENTER);
  fill(0);
  text(mapidString, width/2, height/2+17+100);
  textAlign(CENTER);
}

void nameBox(Player winningPlayer) {
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
        if (name == "TYPE-NAME") {
          name="" + key;
          name=name.toUpperCase();
        } else {
          name+=key;
          name=name.toUpperCase();
        }
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
  text(name, width/2-76-(350/2)+10, height/2+17+100);
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



void getScores() {
  String url2 = "http://home.bensherman.io:42069/get-top-scores-name";
  GetRequest get2 = new GetRequest(url2);
  get2.send();
  println("Reponse Content: " + get2.getContent());
  names = get2.getContent();

  url2 = "http://home.bensherman.io:42069/get-top-scores-map";
  get2 = new GetRequest(url2);
  get2.send();
  println("Reponse Content: " + get2.getContent());
  mapids = get2.getContent();

  url2 = "http://home.bensherman.io:42069/get-top-scores-score";
  get2 = new GetRequest(url2);
  get2.send();
  println("Reponse Content: " + get2.getContent());
  scores = get2.getContent();
}


void scoreBoard() {
  noStroke();
  fill(0, 0, 0, 100);
  rectMode(CORNER);
  rect(50, 40, 325, 285);
  fill(255);
  textSize(25);
  textMode(CORNER);
  textAlign(LEFT);

  String[] tempNames = splitTokens(names);
  String[] tempScores = splitTokens(scores);
  String[] tempIds = splitTokens(mapids);
  //print(tempNames[0]);

  text("Global Top Scores:", 65, 70);
  for (int i=0; i<tempNames.length; i++) {
    text(i+1 + ": " + tempNames[i], 55, 100+(50*i));
    //text("Name", 80, 100+(50*i));

    text(tempScores[i], 75+150, 100+(50*i));
  }

  textAlign(CENTER);
}

void sendScoreToServer() {
}



void genSteps() {
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

void motivate() {
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


void mainMenu() {

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
      String url2 = "http://home.bensherman.io:42069/get-map/?map_id=" + mapidString;
      mapid=int(mapidString);
      println(url2);
      GetRequest get2 = new GetRequest(url2);
      get2.send();
      println("Reponse Content: " + get2.getContent());


      gameMode = 25;
      //map.loadMap(selection);
      needToGetScores = true;
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

  fill(50, 159, 91);
  if (mouseX > (width/2)-(350/2) && mouseX < (width/2)+(350/2) && mouseY > 350-(75/2) && mouseY < 350+(75/2)) {
    fill(100, 200, 135);
    if (mousePressed) {
      gameMode = 50;
      //miniGame.startGame(30);
    }
  }
  rect(width/2, 350, 350, 75, 10);
  fill(255, 255, 255);
  text("Play Online", width/2, 367);

  mapBox();
}

public void loadFileFromSelection(File selection) {
  if (selection == null) {
  } else if (selection.getAbsolutePath().indexOf(".AHMAP")>=0) {
    String[] newPoints = loadStrings(selection.getAbsolutePath());
    char[] _=newPoints[0].toCharArray();
    for (int __=0; __<_.length; __++)_[__]=(char)(_[__]^'_');
    JSONObject jsonPoints = parseJSONObject(new String(_));
    mapid = int(jsonPoints.getString("map_id"));
    println("mapid= " + mapid);
    needToGetScores = true;


    gameMode = 25;
    //map.loadMap(selection);
    p1.startTopDownRace("red", jsonPoints);
    p2.startTopDownRace("dark blue", jsonPoints);
    p1.startRace();
    p2.startRace();
    timer = 0;
  }
  mousePressed=false;
  loop();
}

public void saveFileFromSelection(File selection) {
  int theMapId = floor(random(10000, 99999));
  mapidString = "" + theMapId;
  String pointsToSend = "";
  ArrayList<PVector> points = map.getPoints();
  if (selection == null) {
  } else {
    String saveLocation = selection.getAbsolutePath();
    if (selection.getAbsolutePath().indexOf(".") > 0) {
      saveLocation = selection.getAbsolutePath().substring(0, selection.getAbsolutePath().indexOf("."));
    }
    String _ = "{\"map_id\":\""+theMapId+"\",\"points\":[";
    pointsToSend +="'";
    for (int i=0; i<points.size(); i++) {
      _+="\""+points.get(i).x+" "+points.get(i).y;
      pointsToSend +=points.get(i).x + "-" + points.get(i).y + ",";
      if (i+1==points.size()) {
        _+="\"";
      } else {
        _+="\",";
      }
    }
    _+="]}";
    char[] __=_.toCharArray();
    for (int ___=0; ___<__.length; ___++)__[___]=(char)(__[___]^'_');
    PrintWriter saver = createWriter(saveLocation + ".AHMAP"); 
    saver.print(new String(__));
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
