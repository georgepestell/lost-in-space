public final class Asteroid extends Object {

    public float size;
    public boolean split = false;

    Asteroid(int x, int y, PVector velocity, float size) {
        this.position = new PVector(x, y);
        this.velocity = velocity;

        this.size = size;

        // Calculate invMass so that mass is proportional to size
        this.invMass = 1 / size;

    }
    
    public void draw() {
        // Draw a circle with the size of the asteroid and shade with invMass
        fill(255 * (1 - this.invMass));
        ellipse(this.position.x, this.position.y, this.size, this.size);
    }
    
    public void damage(float damage) {
        this.split = true;
    }

    public ArrayList<Asteroid> createChildren(float minSize) {
        // If the size is below a certain size, don't split
        if (this.size / 2 < minSize) {
            return new ArrayList<Asteroid>();
        }

        ArrayList<Asteroid> children = new ArrayList<Asteroid>();
        
        // Make 2 or 3 children
        boolean split2;
        if (this.size / 3 < minSize) {
            split2 = true;
        } else {
            split2 = random(1) > 0.25;
        }

        final float MIN_VELOCITY = -1;
        final float MAX_VELOCITY = 1;

        // Create children with the same lower bound, but just slightly smaller
        if (split2) {           

            // Calculate the mass of the asteroids
            float size1 = random(minSize, this.size / 2);
            float size2 = this.size - minSize;
    
            children.add(new Asteroid((int) this.position.x, (int) this.position.y, new PVector(random(MIN_VELOCITY, MAX_VELOCITY), random(MIN_VELOCITY, MAX_VELOCITY)), size1));
            children.add(new Asteroid((int) this.position.x, (int) this.position.y, new PVector(random(MIN_VELOCITY, MAX_VELOCITY), random(MIN_VELOCITY, MAX_VELOCITY)), size2));
        } else {

            // Calculate the mass of the asteroids
            float size1 = random(minSize, this.size / 3);
            float size2 = random(minSize, this.size / 3);
            float size3 = size - size1 - size2;
            
            children.add(new Asteroid((int) this.position.x, (int) this.position.y, new PVector(random(MIN_VELOCITY, MAX_VELOCITY), random(MIN_VELOCITY, MAX_VELOCITY)), size1));
            children.add(new Asteroid((int) this.position.x, (int) this.position.y, new PVector(random(MIN_VELOCITY, MAX_VELOCITY), random(MIN_VELOCITY, MAX_VELOCITY)), size2));           
            children.add(new Asteroid((int) this.position.x, (int) this.position.y, new PVector(random(MIN_VELOCITY, MAX_VELOCITY), random(MIN_VELOCITY, MAX_VELOCITY)), size3));
        }

        return children;

    }

}