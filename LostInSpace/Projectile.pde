public class Projectile extends Circle {

    int startFrame = frameCount;

    public Projectile(PVector position, PVector velocity) {
        super();
        this.position = position;
        this.velocity = velocity;
        this.invMass = 0.003f;
        this.invInertia = 0.002f;
        this.size = 5;
    }

    void draw() {
        // Draw a small circle to represent the projectile
        fill(255);
        ellipse(position.x, position.y, size, size);
    }

}