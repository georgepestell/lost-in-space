final class ShieldPowerUp extends PowerUp {
    
    ShieldPowerUp(int x, int y, int duration) {
        super(x, y, duration);
        name = "Shield";
    }
    
    void apply(Player player) {
        player.setShield(10);
    }

    void setColour() {
        fill(0, 0, 255);
    }
}