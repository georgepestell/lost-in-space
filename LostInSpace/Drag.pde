public final class Drag extends ForceGenerator {
  
  private float k1;
  private float k2;
  
  Drag(float k1, float k2) {
    this.k1 = k1;
    this.k2 = k2;
  }
  
  public void updateForce(PhysicsObject object) {
    
    PVector force = object.velocity.get();
    
    float dragCoeff = force.mag();
    dragCoeff = k1 * dragCoeff + k2 * dragCoeff * dragCoeff;
    
    force.normalize();
    force.mult(-dragCoeff);
    object.addForce(force);
    
  }
    
}
