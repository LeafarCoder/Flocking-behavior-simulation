/*
  Code developed for a Java Workshop (22/03/2018)
  Developed by: Rafael Correia

    This program (main file [WS_part2] and classes) is designed to simulate
  the behavior of certain animals (birds, fish, humans, ...) in aggregating and
  moving in groups (flocking behaviour).
  
    In this file (WS_part2), the Processing IDE's "setup" and "draw" functions are implemented (these don't exist in normal Java):
      - void setup: defines the initial state of the sketch (variable initialization, etc...)
      - void draw: is constantly called to draw the sketch. As soon as the "draw" function ends, it is called again and the simulator develops this way.
    
    We define four classes:
      - Fish: abstract class that is only used to transmit common characteristics of fish to the LittleFish and Shark classes.
      - LittleFish: class that implements small fish that will have flocking behavior. In addition to Fish characteristics, new characteristics are assigned to it.
                    These fish will try to avoid contact with objects of type Obstacle and Shark!
      - Shark: class that implements sharks that will swim through the sketch. In addition to Fish characteristics, new characteristics are assigned to it.
      - Obstacle: class that implements fixed obstacles in the sketch. Used to limit the movement of Fish objects (LittleFish and Shark).
      
*/

ArrayList<LittleFish> littleFishes;    // Declaration of a vector of objects of type LittleFish
ArrayList<Shark> sharks;               // Declaration of a vector of objects of type Shark
ArrayList<Obstacle> obstacles;         // Declaration of a vector of objects of type Obstacle

int countIDs = 0;    // Used to assign a specific ID to each Fish object (Shark and LittleFish objects share this variable)

// Function that initializes the sketch
void setup () {
  size(1024, 576);                                  // Creates a sketch window with size 1024x576 (in pixels). From here on we can use the variable "width" to indicate width (1024) and "height" to indicate height (576).
  colorMode(RGB);                                   // Sets the color mode to RGB (red, green, blue). Another option would be HSB (hue, saturation, brightness), among others. RGB is the most used and easiest to use.
  littleFishes = new ArrayList<LittleFish>();       // Initializes the vector of LittleFish objects. Before this line the variable had the value Null. Now it has the value {}. Note: Null != {}
  sharks = new ArrayList<Shark>();                  // Initializes the vector of Shark objects. Before this line the variable had the value Null. Now it has the value {}. Note: Null != {}
  obstacles = new ArrayList<Obstacle>();            // Initializes the vector of Obstacle objects. Before this line the variable had the value Null. Now it has the value {}. Note: Null != {}

  setupWalls();                                     // Calls the function that creates and defines the position of new obstacles. Can be replaced with "setupSin()" function for a different arrangement!
}

// This function creates and defines the position of new obstacles
void setupWalls() {
  obstacles = new ArrayList<Obstacle>();                // We already did this operation in "setup" before calling "setupWalls" but it's always better to make sure we start with an empty vector, so we initialize the variable again.
  for (int x = 0; x < width; x+= 15) {                  // For all points along the x-axis from coordinate x=0 to x=width with increments of 15: 0,15,30,45,...
    obstacles.add(new Obstacle(x, 10, 15));             // Creates a horizontal line of obstacles at the top of the sketch (y = 10); The parameter 15 defines the size of the obstacle in pixels
    obstacles.add(new Obstacle(x, height - 10, 15));    // Creates a horizontal line of obstacles at the bottom of the sketch (y = height - 10); The parameter 15 defines the size of the obstacle in pixels
  }
}

// This function creates and defines an alternative configuration to "setupWalls" for new obstacles
void setupSin() {
  obstacles = new ArrayList<Obstacle>();                                    // We already did this operation in "setup" before calling "setupWalls" but it's always better to make sure we start with an empty vector, so we initialize the variable again.
  for (int x = 0; x < width; x+= 15) {                                      // For all points along the x-axis from coordinate x=0 to x=width with increments of 15: 0,15,30,45,...
    obstacles.add(new Obstacle(x, 150 + 80 * sin(x/100.), 15));             // Creates a sinusoidal wave of obstacles at the top of the sketch (amplitude: 80 pixels); The parameter 15 defines the size of the obstacle in pixels
    obstacles.add(new Obstacle(x, height - 150 + 80 * sin(x/100.), 15));    // Creates a sinusoidal wave of obstacles at the bottom of the sketch (amplitude: 80 pixels); The parameter 15 defines the size of the obstacle in pixels
  }
}

// draw: Function that runs indefinitely after "setup" runs once.
void draw () {
  fill(0, 200, 255, 150);                    // Defines the color to be used in the next element to be created (in this case a rectangle in the line immediately below). The color is (red = 0, green = 200, blue = 255, alpha = 100); The alpha value allows defining the background transparency and therefore allows seeing the trails made by the fish
  rect(0, 0, width, height);                 // Draws the background rectangle (blue background)

  for (LittleFish l_f : littleFishes) {      // For each little fish:
    l_f.swim();                              // Ask the little fish to swim (calculate the velocity it needs to take)
    l_f.draw_fish(color(0, 150, 0), .4);    // Draw the little fish that is now at a new coordinate. Draw with color (red = 0, green = 150, blue = 0) and size = 0.7
  }

  for (Shark sk : sharks) {                  // For each shark:
    sk.swim();                               // Ask the shark to swim (calculate the velocity it needs to take)
    sk.draw_fish(color(250,0,0), .8);        // Draw the shark that is now at a new coordinate. Draw with color (red = 250, green = 0, blue = 0) and size = 1.
  }

  for (Obstacle obs : obstacles) {           // For each obstacle:
    obs.draw_obs();                          // Draw the obstacle that is now at a new coordinate... just kidding... the obstacles are stationary!
  }
}

void mousePressed () {                       // If any mouse button is pressed:
  if (mouseButton == LEFT) {                 // If the pressed button is the Left one:
    for (int i = 0; i < 20; i++) {           // Iterate variable i 20 times (we want to draw 20 little fish at random points near the mouse)
                                             // Creates a new instance of LittleFish class and adds it to the littleFishes vector. The coordinates are the mouse coordinates +- a random value up to 100 pixels (in absolute value).
      littleFishes.add(new LittleFish(mouseX + random(-100, 100), mouseY + random(-100, 100), countIDs++));
    }
  } else if (mouseButton == CENTER) {        // If the pressed button is the Center one (scroll wheel):
                                             // Creates a new instance of Obstacle class and adds it to the obstacles vector. The coordinates are the mouse coordinates. The obstacle size is 15 pixels.
    obstacles.add(new Obstacle(mouseX, mouseY, 15));
  } else if (mouseButton == RIGHT) {         // If the pressed button is the Right one:
                                             // Creates a new instance of Shark class and adds it to the sharks vector. The coordinates are the mouse coordinates +- a random value up to 50 pixels (in absolute value).
    sharks.add(new Shark(mouseX + random(-50, 50), mouseY + random(-50, 50), countIDs++));
  }
}