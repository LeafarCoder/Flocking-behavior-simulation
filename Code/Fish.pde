/*
  Implementation of the abstract Fish class
  Used to extend certain characteristics and methods to Classes whose objects are similar (in this case LittleFish and Shark)
*/

abstract class Fish {
  // Attributes
  private PVector position;      // the position of the fish. PVector is a class implemented in Processing that defines objects that are vectors (allows storing two values [x and y] and has methods to modify this vector [.add(...); .mult(...); .div(...); .normalize(); ...]
  private PVector velocity;      // the velocity of the fish
  private int avoidRadius = 80;  // radius for calculating the contribution of obstacles in direction change
  public int ID;                 // ID of the fish. Shared by LittleFish and Shark
  public int time;               // "age" of the fish. This value is incremented for each fish after each simulation cycle.
  
  // Class constructor! Always has the same name as the class! Multiple constructors can exist if the number of parameters varies (in this case we opt for just one constructor)
  Fish (float xx, float yy) {        // receives as arguments the x and y coordinates we want to give to the fish.
    velocity = new PVector(0, 0);    // defines the fish's velocity as 0 (the fish is stationary).
    position = new PVector(xx, yy);  // defines the fish's position using the constructor parameters.
  }
  
  // We now define getters and setters to obtain/define (respectively) the fish's position and velocity
  public PVector getPos(){
    return position;
  }
  public void setPos(PVector p){
    position = p;
  }
  public PVector getVel(){
    return velocity;
  }
  public void setVel(PVector vel){
    velocity = vel;
  }

  // All fish swim! That's why we implement this method in this abstract class!
  void swim(){
    velocity = move();        // Calculate the fish's velocity. This velocity depends on the fish's behavior (whether it's a little fish or shark) and therefore the "move()" function will be defined not here (Fish) but in the sub-classes (LittleFish and Shark).
    position.add(velocity);   // Having the velocity, the new position is obtained by adding the velocity to the old position. v = dr/dt <=> v = (r_f - r_i) / (t_f - t_i) <=> v * (t_f - t_i) + r_i = r_f    Since the time interval in the simulator is discrete it doesn't matter and we can consider dt = t_f - t_i = 1 from which comes r_f = r_i + v
    wrap();                   // This function handles the situation of fish swimming outside the sketch. As soon as a fish passes the sketch limit it is teleported to the opposite edge of the sketch
  }

  // Each fish (LittleFish and Shark) moves differently so we leave its implementation to the sub-classes. For this we define the "move()" method as "abstract".
  abstract PVector move();
  // How do these behaviors vary?
  
  // Class LittleFish: the little fish uses several factors to move:
  //   - Repulsion from obstacles
  //   - Repulsion from other little fish
  //   - Repulsion from sharks
  //   - Cohesion between little fish (to form a group)
  //   - Velocity alignment with other little fish
  //   - A random component
  
  // Class Shark: the shark uses other factors to move:
  //   - Repulsion from obstacles
  //   - Repulsion from other sharks
  //   - A random component
  
  
  
  // Function to be used by sub-classes: defines the repulsion vector of the fish due to nearby obstacles (within radius "avoidRadius")
  PVector getAvoidObstacles(){
    PVector steer = new PVector(0, 0);                                  // The final result starts at zero (null vector)

    for (Obstacle obs : obstacles) {                                    // For each existing obstacle "obs":
      float d = PVector.dist(this.getPos(), obs.getPos());             // Calculate the distance "d" that this obstacle (obs) is from the fish (this)
      if(d < avoidRadius){                                             // If the obstacle "obs" is within the "avoidRadius" then:
        PVector diff = PVector.sub(this.getPos(), obs.getPos());       // Calculate the repulsion vector (it's the difference between the position vectors)
        diff.normalize();                                              // Normalize the diff vector
        diff.div(d);                                                   // Locally weight the vector. If the obstacle is very close it creates greater repulsion so the vector will be larger and vice versa.
        steer.add(diff);                                               // Add this "diff" vector to the final result "steer"
      }
    }
    return steer;                                                      // return the final result "steer" which is the result of repulsions made by obstacles near the fish
  }

  // This function handles the situation of fish swimming outside the sketch. As soon as a fish passes the sketch limit it is teleported to the opposite edge of the sketch
  void wrap () {
    position.x = (position.x + width) % width;
    position.y = (position.y + height) % height;
  }

  // This function defines how to draw a fish
  void draw_fish (color c, float s) {
    noStroke();
    fill(c);              // Each fish sub-class has a different color (shark: red; little fish: green)
    pushMatrix();
    translate(this.getPos().x, this.getPos().y);
    rotate(this.getVel().heading());
    scale(s);             // Each fish sub-class has a different size (shark: 1.0; little fish: 0.7)
    beginShape();
    vertex(15, 0);        // Each of the fish's vertices.
    vertex(-7, 7);
    vertex(-7, -7);
    endShape(CLOSE);
    popMatrix();
  }
}