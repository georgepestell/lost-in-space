/**
 * Rods link a pair of particles, generating a contact if they stray too far
 * apart or too close
 */
public class Rod extends ContactGenerator {
  // The pair of particles connected by this rod
  Particle p1, p2 ;
  
  // Holds the length of the rod
  float len ; 
  
  // Construct a new Rod from the given parameters
  public Rod(Particle p1, Particle p2, float len) {
    this.p1 = p1 ;
    this.p2 = p2 ;
    this.len = len ;
  }  

  // Calculate the current distance between the two particles
  float currentLength() {
    PVector relativePos = p1.position.get() ;
    relativePos.sub(p2.position) ;
    return relativePos.mag() ; 
  }
  
  // Returns a contact needed to keep the rod from overextending or compressing
  Contact addContact() {
     // Find the length of the rod
     float cLen = currentLength() ;
     
     // Overextended or compressed?
     if (cLen == len) 
       return null ;
       
     // Otherwise return the contact.
     // Calculate the normal. 
     PVector contactNormal = p2.position.get() ;
     contactNormal.sub(p1.position) ;
     contactNormal.normalize() ;
     // Direction depends on whether we are extending or compressing
     if (cLen > len)
       contactNormal.mult(-1) ;   
     
     return new Contact(p1, p2, 0, contactNormal) ;
  }  
  
}
