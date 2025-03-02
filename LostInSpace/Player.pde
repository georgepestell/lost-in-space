final char LEFT_THRUSTER_KEY = 'j';
final char RIGHT_THRUSTER_KEY = 'k';

public final class Player extends PhysicsObject {

  // Health
  float maxEngines = 3;
  float engines = maxEngines;

  // Image for the engines
  PImage enginesImage;

  float shield = 0;
  float shieldStart = 0;

  float size = 10;

  Player(int x, int y, int scale) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    invMass = 0.0003f;
    invInertia = 0.01f;

    // Load the image for the engines
    enginesImage = loadImage("assets/engine.png");

  }

  void integrate() {
    super.integrate();

    if (shield > 0) {
      if (frameCount - shieldStart > shield) {
        shield = 0;
      }
    }

  }

  void draw() {
    // Draw an isoceles triangle pointing in the direction of the player using rotation
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle); // Apply rotation before drawing the triangle

    if (shield > 0) {
      // Flash the shield every 1/4 second
      if (frameCount % 30 < 13) {
        fill(255, 255, 255, 100);
      } else {
        fill(255);
      }
    } else {
      fill(255);
    }

    triangle(- 2 * size, size, 0, -3*size, 2 * size, size);
    popMatrix();

    // Draw the engines as an image from the engine.png file
    for (int i = 0; i < maxEngines; i++) {
      if (i < engines) {
        image(enginesImage, 2 + i * 26, 32);
      }
    }

  }

  public void damage() {

    // Do not damage if the shield is active
    if (shield > 0) {
      return;
    } 
    // Remove an engine
    engines -= 1;

    // Activate the shield for 5 seconds
    setShield(5);
  }

  public void setShield(float time) {
    float frames = time * 60;
    if (shield == 0 || frameCount - shieldStart <= time) {
      shield = frames;
      shieldStart = frameCount;
    }
  }

  public ArrayList<PVector> getVertices() {
    ArrayList<PVector> vertices = new ArrayList<>();
    float x = position.x;
    float y = position.y;

    PVector v1 = new PVector(0, - 3 * size);
    PVector v2 = new PVector(2 * size, size);
    PVector v3 = new PVector(- 2 * size, size);

    v1.rotate(angle);
    v2.rotate(angle);
    v3.rotate(angle);

    v1.add(position);
    v2.add(position);
    v3.add(position);
  
    vertices.add(v1);
    vertices.add(v2);
    vertices.add(v3);

    return vertices;
  }

}
