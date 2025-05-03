public abstract class Weapon {

    ForceRegistry fr;

    PhysicsObject parent;
    PVector relativePosition;
    PVector relativeAngle;

    float damage;

    float speed = 10;

    ArrayList<Projectile> projectiles = new ArrayList<Projectile>();

    Weapon(PVector relativePosition, PVector relativeAngle) {
        this.relativePosition = relativePosition;
        this.relativeAngle = relativeAngle;
    }

    public void setParent(PhysicsObject parent) {
        this.parent = parent;
    }

    public abstract Projectile fire();

    public abstract void draw();

    public abstract void integrate();

    public abstract void clear();

}