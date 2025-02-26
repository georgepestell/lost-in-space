import java.util.Iterator;

final int MY_WIDTH = 500;
final int MY_HEIGHT = 500;

final float MIN_ASTEROID_SIZE = 30;
final float MAX_ASTEROID_SIZE = 120;

final float DAMAGE_MULTIPLIER = 0.1;

int xStart, yStart, xEnd, yEnd;

ForceRegistry forceRegistry;
ContactResolver contactResolver;

Weapon playerWeapon = null;

UserInput userInput;

Player player;

ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

ArrayList<Object> objects = new ArrayList<Object>();

float calculateDamage(Asteroid asteroid) {

  // Get the impact speed
  PVector relativeVelocity = PVector.sub(player.velocity, asteroid.velocity);
  float impactSpeed = relativeVelocity.mag();

  // Calculate the damage based on the impact speed and mass of the asteroid
  float damage = impactSpeed * (1 / asteroid.invMass) * DAMAGE_MULTIPLIER;

  return damage;

}

void setup() {
  size(500, 500);
  
  forceRegistry = new ForceRegistry();
  contactResolver =  new ContactResolver();

  userInput = new UserInput(0.25, 180, 0.1, 1.5);

  player = new Player(100, 100, 1);
  forceRegistry.register(player, userInput);

  playerWeapon = new Blaster(new PVector(0, -20), new PVector(0, 0), 0.5f, 25, 10);
  playerWeapon.setParent(player);

  // Register Objects for collisions
  objects.add(player);

}
  
void draw() {

  final int MAX_ASTEROIDS = 8;
  final int ASTEROID_ADD_RATE = 100;
  if (asteroids.size() < MAX_ASTEROIDS && frameCount % ASTEROID_ADD_RATE == 0) {
    int leftRight = random(1) > 0.5 ? 0 : MY_WIDTH;
    int topBottom = random(1) > 0.5 ? 0 : MY_HEIGHT;
    Asteroid asteroid = new Asteroid(leftRight, topBottom, new PVector(random(-2, 2), random(-2, 2)), random(MIN_ASTEROID_SIZE, MAX_ASTEROID_SIZE));
    objects.add(asteroid);
    asteroids.add(asteroid);
  }

  background(0);
  
  forceRegistry.updateForces();

  // Get projectile contacts with asteroids
  ArrayList<Contact> projectileContacts = new ArrayList<Contact>();
  ArrayList<Projectile> collidedProjectiles = new ArrayList<Projectile>();

  for (int i = 0; i < playerWeapon.projectiles.size(); i++) {

    // Check collision with player
    if (player.position.dist(playerWeapon.projectiles.get(i).position) < 5) {
      PVector normal = PVector.sub(player.position, playerWeapon.projectiles.get(i).position);
      normal.normalize();
      collidedProjectiles.add(playerWeapon.projectiles.get(i));
      player.damage(playerWeapon.damage);
      continue;
    }

    // Check projectile collision with asteroids
    boolean collided = false;
    for (Asteroid asteroid : asteroids) {
      if (playerWeapon != null) {
          if (playerWeapon.projectiles.get(i).position.dist(asteroid.position) < asteroid.size / 2) {
            collidedProjectiles.add(playerWeapon.projectiles.get(i));
            asteroid.damage(playerWeapon.damage);
            collided = true;
            break;
          }
        }
    }

    if (collided) {
      continue;
    }


    // Check collision with other projectiles
    for (int j = i + 1; j < playerWeapon.projectiles.size(); j++) {
      if (playerWeapon.projectiles.get(i).position.dist(playerWeapon.projectiles.get(j).position) < 5) {
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
    if (player.position.dist(asteroid.position) < asteroid.size / 2) {
      PVector normal = PVector.sub(player.position, asteroid.position);
      normal.normalize();
      playerContacts.add(new Contact(player, asteroid, 1f, normal));
      player.damage(calculateDamage(asteroid));
      break;
    }
  }

  contactResolver.resolveContacts(playerContacts);

  player.integrate();

  // Check player health
  if (player.health <= 0) {
    player = new Player(100, 100, 1);
    playerWeapon.setParent(player);
    forceRegistry.register(player, userInput);
    objects.clear();
    asteroids.clear();
    playerWeapon.clear();
    objects.add(player);
  }

  player.draw();

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
  if (key == 'h') {
    userInput.updateRotation(-1);
  }
  else if (key == 'l') {
    userInput.updateRotation(1);
  }

  if (key == 'k') {
    userInput.updateThrusting(-1);
  } else if (key == 'j') {
    userInput.updateThrusting(1);
  }
  if (key == ' ') {
    if (playerWeapon != null) {
      playerWeapon.fire();
    }
  }
}

void keyReleased() {
  if (key == 'h' || key == 'l') {
    userInput.updateRotation(0);
  }
  if (key == 'j' || key == 'k') {
    userInput.updateThrusting(0);
  }
}