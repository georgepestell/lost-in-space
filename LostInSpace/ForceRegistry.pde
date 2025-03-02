import java.util.Iterator;

class ForceRegistry {
 
  class ForceRegistration {
    public final PhysicsObject object;
    public final ForceGenerator forceGenerator;
    ForceRegistration(PhysicsObject o, ForceGenerator fg) {
      object = o;
      forceGenerator = fg;
    }
  }
 
 ArrayList<ForceRegistration> registrations = new ArrayList();
 
 void register(PhysicsObject o, ForceGenerator fg) {
   registrations.add(new ForceRegistration(o, fg));
 }
 
 void clear() {
   registrations.clear();
 }
 
 void updateForces() {
   Iterator<ForceRegistration> itr = registrations.iterator();
   while (itr.hasNext()) {
     ForceRegistration fr = itr.next();
     fr.forceGenerator.updateForce(fr.object);
   } 
 }
  
}
