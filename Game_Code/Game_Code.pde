import javafx.scene.media.Media;
import javafx.scene.media.MediaPlayer;
import java.util.Random;




Random r = new Random();

boolean doYouHaveAWiiFitBoard = false; // CHANGE THIS BASED ON YOUR SITUATION

Player p1 = new Player(0, 'q', this, !doYouHaveAWiiFitBoard);
Player p2 = new Player(1, 'w', this, !doYouHaveAWiiFitBoard);

Race race = new Race(p1, p2);

mapMaker map = new mapMaker();

int gameMode = 0; //0==game menue; 10==race; 20==mapMaker;
boolean keyAlreadyPressed;

public void setup() {
  size(1280, 720);

  p1.init();
  p2.init();
  race.init();

  thread("genSteps");


  motivate();
}

public void draw() {
  background(255, 255, 240);

  if (gameMode == 0) {
   mainMenu();
  } else if (gameMode == 10) {
    race.draw();
    p1.showCOM();
  } else if (gameMode == 20) {
    map.makeMap();
    map.drawMap();
  }
}

void genSteps() {
  while (true) {
    p1.getUserInput();
    p2.getUserInput();
    p1.emulateSteps();
    p2.emulateSteps();
    p1.updateSteps();

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


void mainMenu(){
   noStroke();
    background(9, 64, 116);
    textAlign(CENTER);
    textSize(50);
    fill(255, 255, 255);
    text("Weclome To Ardsley Racer!", width/2, 75);

    rectMode(CENTER);

    fill(215, 38, 56);
    if (mouseX > (width/2)-(350/2) && mouseX < (width/2)+(350/2) && mouseY > 150-(75/2) && mouseY < 150+(75/2)) {
      fill(255, 75, 100);
      if(mousePressed){
        gameMode = 10;
      }
    }
    rect(width/2, 150, 350, 75, 10);
    fill(255, 255, 255);
    text("Start A Race", width/2, 167);
    
    fill(255, 87, 10);
    if (mouseX > (width/2)-(350/2) && mouseX < (width/2)+(350/2) && mouseY > 250-(75/2) && mouseY < 250+(75/2)) {
      fill(255, 135, 75);
      if(mousePressed){
        gameMode = 20;
      }
    }
    rect(width/2, 250, 350, 75, 10);
    fill(255, 255, 255);
    text("Make A Map", width/2, 267);

    fill(50, 159, 91);
    if (mouseX > (width/2)-(350/2) && mouseX < (width/2)+(350/2) && mouseY > 350-(75/2) && mouseY < 350+(75/2)) {
      fill(100, 200, 135);
      if(mousePressed){
        gameMode = 30;
      }
    }
    rect(width/2, 350, 350, 75, 10);
    fill(255, 255, 255);
    text("Mini Games", width/2, 367);
}