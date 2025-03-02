abstract class PowerUp extends Circle { 

    int duration;
    int startFrame;
    String name;
    
    PowerUp(int x, int y, int duration) {
        position = new PVector(x, y);
        this.duration = duration * 60;
        startFrame = frameCount;

        // Set the inverse mass to be very light
        invMass = 0.3f;

        // Set the inverse inertia to be very light
        invInertia = 0.3f;
        velocity = new PVector(random(-1, 1), random(-1, 1));
        this.size = 50;
    }

    void draw() {
        setColour();
        ellipse(position.x, position.y, size, size);
        textSize(10);
        textAlign(CENTER, CENTER);
        fill(0);
        text(name, position.x, position.y);
    }

    // Ensure a child class implements setColour
    abstract void setColour();

    abstract void apply(Player player);

}