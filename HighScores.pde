final String HIGHSCORE_FILE = "highscores.csv";

final class Score {
    int score;
    String name;

    Score(int score, String name) {
        this.score = score;
        this.name = name;
    }
}

final class HighScores {

    ArrayList<Score> scores;

    void initializeFile() {
        if (!new File(HIGHSCORE_FILE).exists()) {
            saveStrings(HIGHSCORE_FILE, new String[] { 
                    "0,AAA",
                    "0,AAA",
                    "0,AAA",
                    "0,AAA",
                    "0,AAA",
                    "0,AAA",
                    "0,AAA",
                    "0,AAA",
                    "0,AAA",
                    "0,AAA"
                });    
        }
    }

    HighScores() {

        initializeFile();

        scores = new ArrayList<Score>();
        String[] lines = loadStrings(HIGHSCORE_FILE);
        if (lines != null) {
            for (String line : lines) {
                String[] parts = line.split(",");
                if (parts.length == 2) {
                    scores.add(new Score(Integer.parseInt(parts[0]), parts[1]));
                }
            }
        }
    }

    void saveScore(int score, String name) {

        initializeFile();

        // Find the smallest score that is smaller than the new score
        int smallestIndex = -1;
        int smallestScore = score;
        
        for (int i = 0; i < scores.size(); i++) {
            if (scores.get(i).score < score && 
            (smallestIndex == -1 || scores.get(i).score < smallestScore)) {
            smallestIndex = i;
            smallestScore = scores.get(i).score;
            }
        }
        
        // Replace the smallest score if found
        if (smallestIndex != -1) {
            scores.set(smallestIndex, new Score(score, name));
            
            // Sort scores in descending order
            scores.sort((a, b) -> b.score - a.score);
            
            // Save to file
            String[] lines = new String[scores.size()];
            for (int i = 0; i < scores.size(); i++) {
            lines[i] = scores.get(i).score + "," + scores.get(i).name;
            }
            saveStrings(HIGHSCORE_FILE, lines);
        }
    }

    void draw() {
        fill(255);
        textAlign(CENTER);
        textSize(32);
        text("High Scores", width / 2, 50);

        textSize(24);
        for (int i = 0; i < scores.size(); i++) {
            text(scores.get(i).name + " - " + scores.get(i).score, width / 2, 100 + i * 30);
        }
    }


}