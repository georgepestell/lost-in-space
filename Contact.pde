public class Contact {
  Particle p1;
  Particle p2;
  
  float c;
  
  PVector contactNormal;
  
  public Contact (Particle p1, Particle p2, float c, PVector contactNormal) {
    this.p1 = p1;
    this.p2 = p2;
    this.c = c;
    this.contactNormal = contactNormal;
  }
  
  void resolve() {
    resolveVelocity();
  }
  
  float calculateSeparatingVelocity() {
    PVector relativeVelocity = p1.velocity.get();
    relativeVelocity.sub(p2.velocity);
    return relativeVelocity.dot(contactNormal);
  }
  
  void resolveVelocity() {
    float separatingVelocity = calculateSeparatingVelocity();
    
    float newSepVelocity = -separatingVelocity * c;
    
    float deltaVelocity = newSepVelocity - separatingVelocity;
    
    float totalInverseMass = p1.invMass;
    totalInverseMass += p2.invMass;
    
    float impulse = deltaVelocity / totalInverseMass;
    
    PVector impulsePer1Mass = contactNormal.get();
    impulsePer1Mass.mult(impulse);
    
    PVector p1Impulse = impulsePer1Mass.get();
    p1Impulse.mult(p1.invMass);
    
    PVector p2Impulse = impulsePer1Mass.get();
    p2Impulse.mult(-p2.invMass);
    
    p1.velocity.add(p1Impulse);
    p2.velocity.add(p2Impulse);
  }
  
}
