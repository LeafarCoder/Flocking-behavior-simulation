/*
  Implementation of the Shark class
  This class extends the abstract Fish class and therefore inherits all its attributes and methods
*/

public class Shark extends Fish {

  ArrayList<Shark> closeSharks;    // vector that keeps track of nearby sharks

  private int crowdRadius = 300;   // radius at which sharks start to repel each other
  private int maxSpeed = 1;        // maximum speed of sharks

  // constructor for sharks (same name as the class!)
  Shark(float xx, float yy, int id) {
    super(xx, yy);                                // Uses the constructor of the class we're extending (in this case the Fish class) to initialize attributes that come from there
    ID = id;                                      // And now initializes the attributes we defined in the Shark class
    closeSharks = new ArrayList<Shark>();         // Initialize the closeSharks variable to an empty list. Before this, the variable wasn't an empty list! It was Null, meaning that comparing with matter it wasn't even "vacuum" since vacuum already implies volume. The absence of everything is Null. A strange but important concept!
  }

  // The "move" function was declared but not defined in the Fish class, because each type of fish moves in a certain way.
  PVector move() {
    time++;                            // increments the shark's age
    getCopy();                         // makes a copy of the list of nearby sharks

    PVector vel = this.getVel();       // velocity starts as the current velocity

    // There are 3 factors that influence a shark's movement:
    PVector avoidObstacles = getAvoidObstacles();                                                      // vector that defines the direction of obstacle repulsion
    PVector avoidSharks = getAvoidSharks();                                                           // vector that defines the direction of shark repulsion
    PVector noise = new PVector(2*noise(time/800., ID*800) - 1, 2*noise(time/800., ID*800+10) - 1);  // vector that defines a random direction using Perlin Noise (a more organic type of randomness)

    // each of the three factors can have a different weight
    avoidObstacles.mult(3);
    avoidSharks.mult(1);
    noise.mult(0.1);    // almost doesn't consider the random vector (this is just for some micro-variation)

    // adds the factors (vectors) to the velocity
    vel.add(avoidObstacles);
    vel.add(avoidSharks);
    vel.add(noise);

    vel.limit(maxSpeed);    // limits the velocity magnitude (to prevent indefinite addition and overflow)

    return vel;             // returns the velocity
  }

  // gets nearby sharks and copies them to "closeSharks"
  void getCopy() {
    ArrayList<Shark> copy = new ArrayList<Shark>();                                                      // creates a temporary array
    for (Shark other : sharks) {                                                                        // for each shark "other":
      if (other != this && PVector.dist(other.getPos(), this.getPos())< crowdRadius)copy.add(other);   // if it's not the shark itself (this) and if it's within proximity radius
    }
    closeSharks = copy;  // copies the temporary vector to the global vector
  }

  // Defines the method that indicates the repulsion vector that a shark feels from others:
  PVector getAvoidSharks() {
    PVector steer = new PVector(0, 0);                                    // The final result starts at zero (null vector)
    for (Shark other : closeSharks) {                                     // For each existing shark "other":
      float d = PVector.dist(this.getPos(), other.getPos());             // Calculate the distance "d" that this shark (other) is from the current shark (this)
      if (d < crowdRadius) {                                             // If the shark "other" is within the "crowdRadius" then:
        PVector diff = PVector.sub(this.getPos(), other.getPos());       // Calculate the repulsion vector (it's the difference between the position vectors)
        diff.normalize();                                                // Normalize the diff vector
        diff.div(d);                                                     // Locally weight the vector. If "other" is very close it creates greater repulsion so the vector will be larger and vice versa.
        steer.add(diff);                                                 // Add this "diff" vector to the final result "steer"
      }
    }
    return steer;                                                        // return the final result "steer" which is the result of repulsions made by nearby "other" sharks from the current shark (this)
  }
}