/*
  Implementation of the LittleFish class
  This class extends the abstract Fish class and therefore inherits all its attributes and methods
*/

public class LittleFish extends Fish {

  ArrayList<LittleFish> closeLittleFishes;      // vector that keeps track of nearby little fish

  // Attributes (behavior variables)
  private int friendRadius = 70;   // radius needed to acquire the velocity of neighbors (alignment)
  private int crowdRadius = 50;    // radius needed for repulsion from other little fish
  private int coheseRadius = 65;   // radius needed for cohesion between a little fish and a school
  private int sharkRadius = 200;   // radius needed for repulsion from sharks
  private int maxSpeed = 2;        // maximum speed of the little fish

  // constructor for little fish (same name as the class!)
  LittleFish(float xx, float yy, int id) {
    super(xx, yy);                                      // Uses the constructor of the class we're extending (in this case the Fish class) to initialize attributes that come from there
    ID = id;                                            // And now initializes the attributes we defined in the LittleFish class
    closeLittleFishes = new ArrayList<LittleFish>();    // Initialize the closeLittleFishes variable to an empty list. Before this, the variable wasn't an empty list! It was Null, meaning that comparing with matter it wasn't even "vacuum" since vacuum already implies volume. The absence of everything is Null. A strange but important concept!
  }

  // The "move" function was declared but not defined in the Fish class, because each type of fish moves in a certain way.
  PVector move() {
    time++;                                           // increments the fish's age
    getCopy();                                        // makes a copy of the list of nearby little fish

    PVector vel = this.getVel();                      // velocity starts as the current velocity

    // There are 6 factors that influence a little fish's movement:
    PVector allign = getAverageDir();                                                                  // vector that defines the general direction of movement of a school
    PVector avoidDir = getAvoidLittleFishDir();                                                       // vector that defines the direction of repulsion from little fish
    PVector avoidSharkDir = getAvoidSharkDir();                                                       // vector that defines the direction of repulsion from sharks
    PVector cohese = getCohesion();                                                                   // vector that defines the cohesion of a certain school of little fish
    PVector avoidObstacles = getAvoidObstacles();                                                     // vector that defines the direction of repulsion from obstacles
    PVector noise = new PVector(2*noise(time/800., ID*800) - 1, 2*noise(time/800., ID*800+10) - 1);  // vector that defines a random direction using Perlin Noise (a more organic type of randomness)

    // each of the six factors can have a different weight
    allign.mult(2);
    avoidDir.mult(1);
    avoidSharkDir.mult(30);
    avoidObstacles.mult(5);
    noise.mult(0.1);
    cohese.mult(0.005);

    // adds the factors (vectors) to the velocity
    vel.add(allign);
    vel.add(avoidDir);
    vel.add(avoidSharkDir);
    vel.add(avoidObstacles);
    vel.add(noise);
    vel.add(cohese);

    vel.limit(maxSpeed);      // limits the velocity magnitude (to prevent indefinite addition and overflow)

    return vel;               // returns the velocity
  }

  // gets nearby little fish and copies them to "closeLittleFish"
  void getCopy() {
    ArrayList<LittleFish> nearby = new ArrayList<LittleFish>();                                            // creates a temporary array
    for (LittleFish other : littleFishes) {                                                               // for each little fish "other":
      if (other != this && PVector.dist(other.getPos(), this.getPos()) < friendRadius) nearby.add(other); // if it's not the fish itself (this) and if it's within proximity radius
    }
    closeLittleFishes = nearby;    // copies the temporary vector to the global vector
  }

  // The following defines 4 functions that model the fish's swimming behavior.
  
  // Gets the average velocity of neighboring fish (not exactly true because in the end it doesn't divide by the number of elements; instead it normalizes and makes it a unit vector)
  PVector getAverageDir () {
    PVector sum = new PVector(0, 0);

    for (LittleFish other : closeLittleFishes) {
      float d = PVector.dist(this.getPos(), other.getPos());
      if (d < friendRadius) {
        PVector copy = other.getVel().copy();
        copy.normalize();
        copy.div(d);
        sum.add(copy);
      }
    }
    return sum;
  }

  // Gets the repulsion velocity between fish (to avoid high fish density per m^2)
  PVector getAvoidLittleFishDir() {
    PVector steer = new PVector(0, 0);

    for (LittleFish other : closeLittleFishes) {
      float d = PVector.dist(this.getPos(), other.getPos());
      if (d < crowdRadius) {
        PVector diff = PVector.sub(this.getPos(), other.getPos());
        diff.normalize();
        diff.div(d);
        steer.add(diff);
      }
    }
    return steer;
  }
  
  // Gets the repulsion vector between the current little fish and sharks (to avoid being eaten)
  PVector getAvoidSharkDir() {
    PVector steer = new PVector(0, 0);

    for (Shark other : sharks) {
      float d = PVector.dist(this.getPos(), other.getPos());
      if (d < sharkRadius) {
        PVector diff = PVector.sub(this.getPos(), other.getPos());
        diff.normalize();
        diff.div(d);
        steer.add(diff);
      }
    }
    return steer;
  }
  
  // Gets the cohesion vector. This vector points to the center of mass of neighbors within a certain radius in an attempt for the fish to integrate more centrally in the group.
  // The repulsion from getAvoidLittleFishDir() prevents fish from converging to the same point (the Center of Mass of all fish).
  PVector getCohesion () {
    PVector sum = new PVector(0, 0);
    for (LittleFish other : closeLittleFishes) {
      float d = PVector.dist(this.getPos(), other.getPos());
      if (d < coheseRadius) {
        PVector cohesion = PVector.sub(other.getPos(), this.getPos());
        cohesion.normalize();
        cohesion.div(d);
        sum.add(cohesion); // Add location
      }
    }
    return sum;
  }
}