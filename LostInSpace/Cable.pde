public final class Cable extends ContactGenerator {
  
  Particle p1, p2;
  
  float maxLength;
  
  float restitution;
  
  public Cable(Particle p1, Particle p2, float restitution) {
    this.p1 = p1;
    this.p2 = p2;
    this.maxLength = currentLength();
    this.restitution = restitution;
  }
  
  float currentLength() {
    PVector relativePos = p1.position.get();
    relativePos.sub(p2.position);
    return relativePos.mag();
  } 
  
  Contact addContact() {
    float len = currentLength();
    
    if (len < maxLength) return null;
    
    PVector contactNormal = p2.position.get();
    contactNormal.sub(p1.position);
    contactNormal.normalize();
    
    return new Contact(p1, p2, restitution, contactNormal);
    
  }
  
}
