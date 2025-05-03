public final class UserInput extends ForceGenerator {

  // Add rotate force to the object
  public final float rotationForce;
  public final float thrustForce;

  private int rotation = 0;
  private int thrusting = 0;

  private float maxThrust;
  private float maxRotation;

  private float HALF_PI = PI / 2;

  UserInput(float rotationForce, float thrustForce, float maxRotation, float maxThrust) {
    this.rotationForce = rotationForce;
    this.thrustForce = thrustForce;
    this.maxRotation = maxRotation;
    this.maxThrust = maxThrust;
  }
  
  public void updateForce(PhysicsObject object) {
    if (this.rotation != 0) {

      // Only add rotation if the object is not rotating too fast
      if (rotation > 0 && object.angularVelocity > maxRotation || rotation < 0 && object.angularVelocity < -maxRotation) {
        // Do nothing
      } else {
        // Add rotation force
        object.addTorque(rotationForce * rotation);
      }

    }
    if (this.thrusting != 0) {

      // Get the object's current forwards velocity
      float vx = object.velocity.x;
      float vy = object.velocity.y;

      float a = (object.angle - HALF_PI) * - thrusting;
      float ux = cos(a);
      float uy = sin(a);

      float currentSpeed = vx * ux + vy * uy;

      // Only add thrust if the object is not moving too fast
      if (currentSpeed < maxThrust) {
      // Calculate forwards direction of object
      PVector force = new PVector(0, thrustForce * thrusting);
      force.rotate(object.angle);
      object.addForce(force);
      }

    }
  }

  public void updateRotation(int rotation) {
    this.rotation = rotation;
  }

  public void updateThrusting(int thrusting) {
    this.thrusting = thrusting;
  }

  public void recoil(PhysicsObject object, Projectile projectile) {
    // Add an equal and opposite force to the object based on the mass and velocity of the projectile
    PVector recoil = new PVector(projectile.velocity.x, projectile.velocity.y);
    recoil.mult(-1);
    recoil.mult(object.invMass);
    object.addForce(recoil);
  }

}