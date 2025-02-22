final char LEFT_THRUSTER_KEY = 'j';
final char RIGHT_THRUSTER_KEY = 'k';

public final class Player extends Object {

  Player(int x, int y, int scale) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    invMass = 0.003f;
    invInertia = 0.01f;
  }

  void draw() {
    // Draw an isoceles triangle pointing in the direction of the player using rotation
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle); // Apply rotation before drawing the triangle
    triangle(-15, 10, 0, -20, 15, 10);
    popMatrix();
  }
}
