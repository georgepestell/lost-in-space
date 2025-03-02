import java.util.Iterator;

final int MY_WIDTH = 1200;
final int MY_HEIGHT = 800;

final float MIN_ASTEROID_SIZE = 30;
final float MAX_ASTEROID_SIZE = 120;

final float DAMAGE_MULTIPLIER = 0.1;

final int MAX_ASTEROIDS = 15;

int xStart, yStart, xEnd, yEnd;

ForceRegistry forceRegistry;
ContactResolver contactResolver;

ScoreBoard scoreBoard;

Weapon playerWeapon = null;

UserInput userInput;

String playerName = "";

Player player;

HighScores highScores;

CollisionCheck collisionChecker;

ArrayList<PowerUp> powerups = new ArrayList<PowerUp>();

ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

ArrayList<PhysicsObject> objects = new ArrayList<PhysicsObject>();

boolean gameover = false;
boolean showHighScores = false;
boolean keyProcessed = false;

float calculateDamage(Asteroid asteroid) {

  // Get the impact speed
  PVector relativeVelocity = PVector.sub(player.velocity, asteroid.velocity);
  float impactSpeed = relativeVelocity.mag();

  // Calculate the damage based on the impact speed and mass of the asteroid
  float damage = impactSpeed * (1 / asteroid.invMass) * DAMAGE_MULTIPLIER;
  return damage;

}

void checkCollisions() {
    // Get projectile contacts with asteroids
  ArrayList<Contact> projectileContacts = new ArrayList<Contact>();
  ArrayList<Projectile> collidedProjectiles = new ArrayList<Projectile>();
  for (int i = 0; i < playerWeapon.projectiles.size(); i++) {

    // Check collision with player
    if (collisionChecker.checkCollision(player, playerWeapon.projectiles.get(i))) {
      PVector normal = PVector.sub(player.position, playerWeapon.projectiles.get(i).position);
      normal.normalize();
      collidedProjectiles.add(playerWeapon.projectiles.get(i));
      player.damage();
      continue;
    }

    // Check projectile collision with asteroids
    boolean collided = false;
    for (Asteroid asteroid : asteroids) {
      if (playerWeapon != null) {
          if (collisionChecker.checkCollision(asteroid, playerWeapon.projectiles.get(i))) {

            // Destroy the projectile and damage the asteroid
            collidedProjectiles.add(playerWeapon.projectiles.get(i));
            asteroid.damage();
            
            collided = true;

            // Smaller asteroids score more points
            scoreBoard.score((int) (1000 / asteroid.size));

            // Check if a new powerup should be spawned
            if (random(1) > 0.995) {
              int powerUpType = (int) random(0, 2);

              if (powerUpType == 0) {
                powerups.add(new ShieldPowerUp((int) random(0, MY_WIDTH), (int) random(0, MY_HEIGHT), 5));
              } else if (powerUpType == 1) {
                powerups.add(new HealthPowerUp((int) random(0, MY_WIDTH), (int) random(0, MY_HEIGHT), 5));
              } else {
              powerups.add(new HealthPowerUp((int) random(0, MY_WIDTH), (int) random(0, MY_HEIGHT), 5));
              }
            }

            break;
          }
        }
    }

    if (collided) {
      continue;
    }

    // Check collision with other projectiles
    for (int j = i + 1; j < playerWeapon.projectiles.size(); j++) {
      if (collisionChecker.checkCollision(playerWeapon.projectiles.get(i), playerWeapon.projectiles.get(j))) {
        collidedProjectiles.add(playerWeapon.projectiles.get(i));
        collidedProjectiles.add(playerWeapon.projectiles.get(j));
      }
    }
  }

  for (Projectile projectile : collidedProjectiles) {
    playerWeapon.projectiles.remove(projectile);
  }
  collidedProjectiles.clear();

  for (Projectile projectile : collidedProjectiles) {
    playerWeapon.projectiles.remove(projectile);
  }
  collidedProjectiles.clear();

  // Get asteroid contacts with other asteroids
  ArrayList asteroidContacts = new ArrayList();
  for (int i = 0; i < asteroids.size(); i++) {
    for (int j = i + 1; j < asteroids.size(); j++) {
      if (asteroids.get(i).position.dist(asteroids.get(j).position) < asteroids.get(i).size / 2 + asteroids.get(j).size / 2) {
        // Calculate the contact normal
        PVector normal = PVector.sub(asteroids.get(i).position, asteroids.get(j).position);
        normal.normalize();
        asteroidContacts.add(new Contact(asteroids.get(i), asteroids.get(j), 1f, normal));
      }
    }
  }

  contactResolver.resolveContacts(asteroidContacts);

  // Check player collision with asteroids
  ArrayList playerContacts = new ArrayList();
  for (Asteroid asteroid : asteroids) {
    if (collisionChecker.checkCollision(player, asteroid)) {
      PVector normal = PVector.sub(player.position, asteroid.position);
      normal.normalize();
      playerContacts.add(new Contact(player, asteroid, 1f, normal));
      player.damage();
      break;
    }
  }

  contactResolver.resolveContacts(playerContacts);

  // Get the player contacts with powerups
  ArrayList powerupContacts = new ArrayList();
  for (PowerUp powerup : powerups) {
    if (collisionChecker.checkCollision(player, powerup)) {
      powerupContacts.add(new Contact(player, powerup, 1f, new PVector(0, 0)));
    }
  }

}

void setup() {
  size(1200, 800, P2D);
  
  forceRegistry = new ForceRegistry();
  contactResolver =  new ContactResolver();

  userInput = new UserInput(0.25, 180, 0.1, 1.5);

  player = new Player(MY_WIDTH / 2, MY_HEIGHT / 2, 1);
  forceRegistry.register(player, userInput);

  playerWeapon = new Blaster(new PVector(0, -(3 * player.size + 5)), new PVector(0, 0), 0.5f, 25, 10);
  playerWeapon.setParent(player);

  scoreBoard = new ScoreBoard(player);
  highScores = new HighScores();

  // Register Objects for collisions
  objects.add(player);

  collisionChecker = new CollisionCheck();

}
  
void draw() {


  if (gameover == true) {

  objects.remove(player);
  for (PhysicsObject object : objects) {
      checkCollisions();
      object.integrate();
      object.draw();
    }

    // Show the end screen

    // Draw a full screen rectangle with a lower alpha value
    fill(0, 0, 0, 150);
    rect(0, 0, MY_WIDTH, MY_HEIGHT);

    fill(255);
    textSize(32);
    text("Game Over", MY_WIDTH / 2 - 50, MY_HEIGHT / 2);

    // Show score
    textSize(16);
    text("Score: " + scoreBoard.score, MY_WIDTH / 2 - 50, MY_HEIGHT / 2 + 18);

    textSize(16);
    text("Press 'ENTER' to restart", MY_WIDTH / 2 - 50, MY_HEIGHT / 2 + 36);
  
    
    // Let player enter alphanum characters and update the playerName
    if (keyPressed && !keyProcessed) {
      if (playerName.length() < 6 && ((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z') || (key >= '0' && key <= '9'))) {
      playerName += Character.toUpperCase(key);
      keyProcessed = true;
      } else if (key == BACKSPACE && playerName.length() > 0) {
      playerName = playerName.substring(0, playerName.length() - 1);
      keyProcessed = true;
      }
    } else if (!keyPressed && keyProcessed) {
      keyProcessed = false;
    }

    // Draw name
    textSize(16);
    text("Name: " + playerName, MY_WIDTH / 2 - 50, MY_HEIGHT / 2 + 54);

    if (key == ENTER) {
      highScores.saveScore(scoreBoard.score, playerName);
      player = new Player(MY_WIDTH / 2, MY_HEIGHT / 2, 1);
      playerWeapon.setParent(player);
      forceRegistry.register(player, userInput);
      objects.clear();
      asteroids.clear();
      playerWeapon.clear();
      objects.add(player);
      scoreBoard = new ScoreBoard(player);
      gameover = false;
      showHighScores = true;
    }
    return;
  }

  if (showHighScores) {
    background(0);
    highScores.draw();
    
    textSize(16);
    text("Press 'r' to restart", MY_WIDTH / 2, MY_HEIGHT - 50);

    if (key == 'r') {
      showHighScores = false;
    }
    return;
  }

  final int ASTEROID_ADD_RATE = 100;
  if (asteroids.size() < MAX_ASTEROIDS && frameCount % ASTEROID_ADD_RATE == 0) {


    Asteroid asteroid = null;

    // Check if the asteroid is too close to the player
    boolean goodPosition = false;

    while (!goodPosition) {
      // 0 = LEFT, 1 = TOP, 2 = RIGHT, 3 = BOTTOM
      int side = (int) random(0, 4);
      int leftRight = (side == 0 || side == 2) ? 0 : (int) random(0, MY_WIDTH);
      int topBottom = (side == 1 || side == 3) ? 0 : (int) random(0, MY_HEIGHT);

      goodPosition = true;
      asteroid = new Asteroid(leftRight, topBottom, new PVector(random(-2, 2), random(-2, 2)), random(MIN_ASTEROID_SIZE, MAX_ASTEROID_SIZE));

      if (player.position.dist(asteroid.position) < 100) {
        goodPosition = false;
      }

      // Check collisions with other asteroids
      for (Asteroid otherAsteroid : asteroids) {
        if (asteroid.position.dist(otherAsteroid.position) < asteroid.size / 2 + otherAsteroid.size / 2) {
          goodPosition = false;
        }
      }
    } 


    objects.add(asteroid);
    asteroids.add(asteroid);
  }

  background(0);
  
  forceRegistry.updateForces();

  checkCollisions();

  player.integrate();

  // Check player health
  if (player.engines <= 0) {
    // Wait until the player presses 'r' to restart
    gameover = true;
  }


  if (playerWeapon != null) {
    playerWeapon.integrate();
    playerWeapon.draw();
  }

  ArrayList<Asteroid> asteroidsToRemove = new ArrayList<Asteroid>();
  ArrayList<Asteroid> asteroidsToAdd = new ArrayList<Asteroid>();
  for (int i = 0; i < asteroids.size(); i++) {
    // Check splits and spawn two to three smaller asteroids with similar but diverging velocity
    if (asteroids.get(i).split) {
      asteroidsToRemove.add(asteroids.get(i));
      asteroidsToAdd.addAll(asteroids.get(i).createChildren(MIN_ASTEROID_SIZE));
      continue;
    }

    asteroids.get(i).integrate();
    asteroids.get(i).draw();
  }

  for (Asteroid asteroid : asteroidsToRemove) {
    objects.remove(asteroid);
    asteroids.remove(asteroid);
  }

  for (Asteroid asteroid : asteroidsToAdd) {
    asteroids.add(asteroid);
    objects.add(asteroid);
    asteroid.integrate();
    asteroid.draw();
  }

  // Draw the powerups
  ArrayList<PowerUp> powerupsToRemove = new ArrayList<PowerUp>();
  for (PowerUp powerup : powerups) {
    powerup.integrate();
    powerup.draw();

    if (collisionChecker.checkCollision(player, powerup)) {
      powerup.apply(player);
      powerupsToRemove.add(powerup);
    }
  }

  // Remove powerups that have been collected
  for (PowerUp powerup : powerupsToRemove) {
    powerups.remove(powerup);
  }

  player.draw();
  scoreBoard.draw();
  
}

void mousePressed() {
  xStart = mouseX;
  yStart = mouseY;
}

void mouseReleased() {
  xEnd = mouseX;
  yEnd = mouseY;
}

void keyPressed() {
  if (key == 'a') {
    userInput.updateRotation(-1);
  }
  else if (key == 'd') {
    userInput.updateRotation(1);
  }

  if (key == 'w') {
    userInput.updateThrusting(-1);
  } else if (key == 's') {
    userInput.updateThrusting(1);
  }
  if (key == 'j') {
    if (playerWeapon != null) {
      Projectile newProjectile = playerWeapon.fire();
      if (newProjectile != null) {
        userInput.recoil(player, newProjectile);
      }
    }
  }
}

void keyReleased() {
  if (key == 'a' || key == 'd') {
    userInput.updateRotation(0);
  }
  if (key == 's' || key == 'w') {
    userInput.updateThrusting(0);
  }
}