final class ScoreBoard {

    private int score = 0;
    Player player;

    ScoreBoard(Player player) {
        this.player = player;
    }

    void draw() {
        // Draw health bar with health and maxHealth attributes
        float barWidth = 200;
        float barHeight = 5;
        float healthPercentage = player.health / player.maxHealth;
        
        // Draw background (red) bar
        fill(255, 0, 0);
        rect(10, 10, barWidth, barHeight);
        
        // Draw foreground (green) bar based on health
        fill(0, 255, 0);
        rect(10, 10, barWidth * healthPercentage, barHeight);

        fill(255);
        // Draw the score in the top left offset by 10 pixels
        textSize(16);
        textAlign(LEFT);
        text("Score: " + score, 10, 30);

    }

    void score(int points) {
        score += points;
    }

}