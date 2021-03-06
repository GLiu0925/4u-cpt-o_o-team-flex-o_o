PImage spaceship;
PImage background;
PImage enemy;

//screen 
int screen = 0;

// ship initial data setup
int shipHP = 5;
float shipX = 300;
float shipY = 550;

// enemy initial data setup
ArrayList<Enemy> enemies;
ArrayList<Bullet> bullets;
int eHP = 3;

class Bullet {
  int damage = 1;
  int diameter = 10;
  int speed = 8;
  PVector loc;
  
  Bullet(PVector loc) {
    this.loc = loc;
  }
  
  void draw() {
    noStroke();
    fill(#FFFF33);
    ellipse(loc.x, loc.y, diameter, diameter);
    loc.y = loc.y - speed;
  }
}

class Ship {
  PVector loc;
  int health;
  
  Ship(PVector loc, int health) {
    this.loc = loc;
    this.health = health;
  }
  
  void draw() {
    image(spaceship, shipX, shipY, 60, 60);
  }
}

class Enemy {
  PVector eLoc;
  int health;
  int size = 50;
  final int BAR = 30;
  //10 
  
  Enemy(PVector eLoc, int health) {
    this.eLoc = eLoc;
    this.health = health;
  }
  
  void draw() {
    image(enemy, eLoc.x, eLoc.y, 50, 50);
    eLoc.y = eLoc.y + 3;
    fill(#00FF00);
    rect(10 + eLoc.x, 10 + eLoc.y, BAR/(3.0) * health, 10 );
    for (int i = 0; i < enemies.size(); i++) {
      if(eLoc.y > 650) {
        enemies.remove(i);
        screen = 1;
      }
    }
  }
}
  
void setup() {
  size(650, 650);
  
  // sets up initial game images
  String backgroundUrl = "https://img.purch.com/w/660/aHR0cDovL3d3dy5saXZlc2NpZW5jZS5jb20vaW1hZ2VzL2kvMDAwLzA5Ny85NTcvb3JpZ2luYWwvc3BhY2UuanBn";
  background = loadImage(backgroundUrl, "jpg");
  String spaceshipUrl = "http://www.pngmart.com/files/3/Spaceship-PNG-File.png";
  spaceship = loadImage(spaceshipUrl, "png");
  String enemyUrl = "https://i.pinimg.com/originals/8b/ef/50/8bef5062bcbd04329ab604fe41ad9f74.png";
  enemy = loadImage(enemyUrl, "png");

  bullets = new ArrayList();
  enemies = new ArrayList();
  
  for (int i = 0; i < 3; i++) {
    float enemyX = random(0, width);
    float enemyY = 3;
    PVector eLoc = new PVector(enemyX, enemyY);
    enemies.add(new Enemy(eLoc, eHP));
  }
}

void draw() {
  image(background, 0, 0, 650, 650);
  PVector loc = new PVector(shipX, shipY);
  Ship ship = new Ship(loc, shipHP);
  ship.draw();
  
  if (frameCount % 60 == 0) {
    float enemyX = random(0, width);
    float enemyY = 3;
    PVector eLoc = new PVector(enemyX, enemyY);
    Enemy enemy = new Enemy(eLoc, eHP);
    enemies.add(enemy);
    enemy.draw();
  }
  
  if(shipX > 650) {
    shipX = 0;
  }
  
  if(shipX < 0) {
    shipX = 650;
  }
  
  for (int i = 0; i < enemies.size(); i++) {
    enemies.get(i).draw();
  }
  for (int i = 0; i < bullets.size(); i++) {
    bullets.get(i).draw();
  }
  
  for (int i = 0; i < bullets.size(); i++) {
    if (bullets.get(i).loc.y <= 3) {
      bullets.remove(i);
      continue;
    }
    for (int j = 0; j < enemies.size(); j++) {
      Bullet ball = bullets.get(i);
      Enemy enem = enemies.get(j);
      if (ball.loc.x < enem.eLoc.x + 50 && ball.loc.x > enem.eLoc.x) {
     
        if (ball.loc.y <= enem.eLoc.y + 50) {
          enem.health -= ball.damage;
          bullets.remove(i);
          if (enem.health <= 0) {
            enemies.remove(j);
          }
         break;
        }
      }
    }
  }
  
  if (screen == 1) {
    background(0 ,0 ,0);
    textSize(30);
    text("You lost! YOU PROCRASTINATED.", 80, 100);
    textSize(25);
    text("Press spacebar to go back/continue.", 100, 300);
    fill(0, 102, 153);
  }

//System.out.println("Score: " + );
}

void keyPressed() {
  
  if (keyCode == RIGHT) {
    shipX = shipX + 15;
  }
  
  if (keyCode == LEFT) {
    shipX = shipX - 15;
  }
  
  if (keyCode == 32 && screen == 0 && keyPressed == true) {
    PVector bLoc = new PVector(shipX + 30, shipY);
    bullets.add(new Bullet(bLoc));
  }
  
  // keyCode 32 is spacebar (lose screen)
  if (keyCode == 32 && screen == 1) {
    screen = 0;
  }
}
