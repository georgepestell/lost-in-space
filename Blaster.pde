public final class Blaster extends Weapon {

    float cooldown;
    float currentCooldown = 0;

    float lifespan = 6000;

    public Blaster(PVector relativePosition, PVector relativeAngle, float cooldown, float damage, float speed) {
        super(relativePosition, relativeAngle);
        this.speed = speed;
        this.cooldown = cooldown;
        this.damage = damage;
    }

    public void fire() {

        // Skip if not owned by a parent
        if (this.parent == null) {
            return;
        }

        // Skip if on cooldown
        if (currentCooldown > 0) {
            return;
        }

        currentCooldown = 1;

        PVector position = this.relativePosition.get();
        position.rotate(parent.angle);
        position.add(parent.position);

        PVector velocity = new PVector(0, -speed);
        velocity.rotate(parent.angle);
        velocity.add(parent.velocity);

        projectiles.add(new Projectile(position, velocity));
    }

    public void draw() {
        for (Projectile projectile : projectiles) {
            projectile.draw();
        }

        if (currentCooldown > 0) {
            currentCooldown += 1;

            if (floor(currentCooldown / 60) > cooldown) {
                currentCooldown = 0;
            }

        }

        for (int i = projectiles.size() - 1; i >= 0; i--) {
            if (frameCount - projectiles.get(i).startFrame > lifespan) {
                projectiles.remove(i);
            }
        }


    }

    public void integrate() {
        for (Projectile projectile : projectiles) {
            projectile.integrate();
        }
    }

    void clear() {
        projectiles.clear();
    }

}