/*
  Implementation of the Obstacle class
  Used to create repulsion and opposition to fish movement
*/

class Obstacle {
  // Attributes
  PVector pos;    // position of the obstacle
  int size;       // size of the obstacle 

  // Class constructor! Has the same name as the class! Multiple constructors can exist if the number of parameters varies (in this case we opt for just one constructor)
  Obstacle(float xx, float yy, int s) {    // receives as arguments the coordinates xx and yy that we want to give to the obstacle and its size s.
    pos = new PVector(xx, yy);             // define the position
    size = s;                              // define the size
  }

  // In this class we only need to ask for the position (the setter is not needed because we assume the object will always be stationary)
  public PVector getPos() {
    return pos;
  }

  // function that defines how to draw the object
  void draw_obs () {
    fill(0);                              // filled with black
    ellipse(pos.x, pos.y, size, size);    // an ellipse with position (pos.x, pos.y) and size (vertical axis: size, horizontal axis: size)
  }
}