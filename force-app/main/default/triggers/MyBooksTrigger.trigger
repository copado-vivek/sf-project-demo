trigger MyBooksTrigger on Book__c (before insert) {
    
    Book__c[] books = Trigger.new;

   MyBooks.applyDiscount(books);

}