class Particle {
  PVector pos = new PVector(random(width), random(height));
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  float maxSpeed = windSpeed;
  float lifespan = 255;

  PVector prevPos = pos.copy();

  public void update() {
    vel.add(acc);
    vel.limit(maxSpeedMapped);
    pos.add(vel);
    acc.mult(0);
    //lifespan -= 2;
  }

  boolean isDead() {
  if (lifespan < 0) {
    return true; 
  }else{
    return false;
  }
  }
  
  public void follow(PVector[] vectors) {
    int x = floor(pos.x / scl);
    int y = floor(pos.y / scl);
    int index = (x-1) + ((y-1) * cols);
    // Sometimes the index ends up out of range, typically by a value under 100.
    // I have no idea why this happens, but I have to do some stupid if-checking
    // to make sure the sketch doesn't crash when it inevitably happens.
    //
    index = index - 1;
    if (index > vectors.length || index < 0) {
      //println("Out of bounds!");
      //println(index);
      //println(vectors.length);
      index = vectors.length - 1;
    }
    PVector force = vectors[index];
    applyForce(force);
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  public void show() {
    stroke(255, lifespan);
    strokeWeight(2.5);
    point(pos.x, pos.y);
  }

  public void updatePrev() {
    prevPos.x = pos.x;
    prevPos.y = pos.y;
  }

  public void edges() {
    if (pos.x > width) {
      pos.x = 0;
      pos.y=pos.y+random(-height/15,height/15);
      updatePrev();
    }
    if (pos.x < 0) {
      pos.x = width;
      pos.y=random(height);
      updatePrev();
    }

    if (pos.y > height) {
      pos.y = 0;
      pos.x=random(width);
      updatePrev();
    }
    if (pos.y < 0) {
      pos.y = height;
      pos.x=random(width);
      updatePrev();
    }
  }
}