final class HealthPowerUp extends PowerUp {
    
    // Engine image
    PImage engineImage;

    HealthPowerUp(int x, int y, int duration) {
        super(x, y, duration);
        name = "Health";
        engineImage = loadImage("assets/engine.png");
    }
    
    void apply(Player player) {
        player.engines += 1;
    }
    
    void draw() {
        // Draw as the engine image
        image(engineImage, position.x, position.y);
    }

    void setColour() {
        fill(0, 255, 0);
    }
}