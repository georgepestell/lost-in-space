final class ScoreBoard {

    private int score = 0;
    Player player;

    ScoreBoard(Player player) {
        this.player = player;
    }

    void draw() {
        // Draw the score in the top left offset by 10 pixels
        
        fill(255);
        textSize(16);
        textAlign(LEFT);
        text("Score: " + score, 10, 30);
    }

    void score(int points) {
        score += points;
    }

}