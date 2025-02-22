public final class UserInput extends ForceGenerator {

  // Add rotate force to the object
  public final float rotationForce;

  private boolean isRotating = false;

  UserInput(float rotationForce) {
    this.rotationForce = rotationForce;
  }
  
  public void updateForce(Object object) {
    if (this.isRotating) {
      // Add rotation force
      object.addTorque(rotationForce);
    }
  }

  public void updateIsRotating(boolean isRotating) {
    this.isRotating = isRotating;
  }

}