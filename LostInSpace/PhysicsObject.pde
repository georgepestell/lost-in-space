public abstract class PhysicsObject {
    PVector position;
    PVector velocity;
    PVector forceAccumulator = new PVector(0, 0);
    
    // New rotation-related variables
    float angle = 0;  // Current rotation angle in radians
    float angularVelocity = 0;  // Angular velocity in radians per frame
    float torqueAccumulator = 0;  // Accumulated torque
    float invInertia;  // Inverse moment of inertia
    
    float invMass;

    public float getMass() {
        return 1 / invMass;
    }

    void addForce(PVector force) {
        forceAccumulator.add(force);
    }

    // New method to add torque
    void addTorque(float torque) {
        torqueAccumulator += torque;
    }

    void integrate() {
        if (invMass <= 0f) {
            print("PhysicsObject has infinite mass, cannot move");
            return;
        }

        // Linear motion
        position.add(velocity);
        PVector resultingAcceleration = forceAccumulator.get();
        resultingAcceleration.mult(invMass);
        velocity.add(resultingAcceleration);

        // Angular motion
        angle += angularVelocity;
        angle %= 2 * PI;
        float angularAcceleration = torqueAccumulator * invInertia;
        angularVelocity += angularAcceleration;

        // Boundary checking (unchanged)
        if (position.x < 0) {
            velocity.x = velocity.x;
            position.x = width;
        } else if (position.x > width) {
            velocity.x = velocity.x;
            position.x = 0;
        }

        if (position.y < 0) {
            velocity.y = velocity.y;
            position.y = height;
        } else if (position.y > height) {
            velocity.y = velocity.y;
            position.y = 0;
        }

        // Reset accumulators
        forceAccumulator.x = 0;
        forceAccumulator.y = 0;
        torqueAccumulator = 0;
    }

    public abstract void draw();

    public void damage() {
        // Override this method in subclasses
    }

}