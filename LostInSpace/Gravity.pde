public final class Gravity extends ForceGenerator {
  private PVector gravity;
  
  Gravity(PVector gravity) {
    this.gravity = gravity;
  } 
  
  void updateForce(PhysicsObject object) {
    PVector resultingForce = gravity.get();
    resultingForce.mult(object.getMass());
    object.addForce(resultingForce);
  }
  
}
