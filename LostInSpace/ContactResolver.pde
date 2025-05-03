import java.util.Iterator;

class ContactResolver {

  void resolveContacts(ArrayList contacts) {
    Iterator itr = contacts.iterator();
    while (itr.hasNext()) {
      Contact contact = (Contact)itr.next();
      contact.resolve();
    }
  }
}
