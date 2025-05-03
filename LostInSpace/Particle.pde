final float DRAW_SIZE = 5;

final class Particle extends PhysicsObject{

  PVector position, velocity;
  PVector forceAccumulator;
  
  private float invMass;
  
  Particle(int x, int y, float xVel, float yVel, float invM) {
    position = new PVector(x, y);
    velocity = new PVector(xVel, yVel);
    invMass = invM;
  }
  
  void draw() {
    circle(position.x, position.y, DRAW_SIZE);
  }
  
}
