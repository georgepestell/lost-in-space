public final class UserInput extends ForceGenerator {

    // Add rotate force to the object
  public final float rotationForce;
     
  UserInput(float rotationForce) {
    this.rotationForce = rotationForce;
  }
  
  public void updateForce(Object object) {
    // Add rotation force
    object.addTorque(rotationForce);
  }


}