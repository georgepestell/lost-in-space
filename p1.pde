import java.util.Iterator;

final int MY_WIDTH = 500;
final int MY_HEIGHT = 500;

Particle[] particles;

int xStart, yStart, xEnd, yEnd;

ForceRegistry forceRegistry;
ContactHandler contactHandler;

Player player;

void setup() {
  size(500, 500);
  
  forceRegistry = new ForceRegistry();
  contactHandler =  new ContactHandler();

  UserInput userInput = new UserInput(0.1);

  player = new Player(100, 100, 1);
  forceRegistry.register(player, userInput);
}
  
void draw() {
  background(128);
  
  forceRegistry.updateForces();

  player.integrate();
  player.draw();
  
}

void mousePressed() {
  xStart = mouseX;
  yStart = mouseY;
}

void mouseReleased() {
  xEnd = mouseX;
  yEnd = mouseY;
}