public class Projectile extends Object {

    int startFrame = frameCount;

    public Projectile(PVector position, PVector velocity) {
        super();
        this.position = position;
        this.velocity = velocity;
        this.invMass = 0.003f;
        this.invInertia = 0.002f;
    }

    void draw() {
        // Draw a small circle to represent the projectile
        fill(255);
        ellipse(position.x, position.y, 5, 5);
    }

}