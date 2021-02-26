@isTest
public class ApexRestCallTest {
     
    @isTest private static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new ApexRestCallMock('{"animal":{"id":1,"name":"chicken","eats":"chicken food","says":"cluck cluck"}}', 200));
        Animal__c animal1 = new Animal__c(ExtraID__c = '1');
        insert animal1;
        Animal__c animal2 = [select id from Animal__c];
        Test.startTest();
        ApexRestCall.mainGetAnimal(new Set<Id>{animal2.id});
        Test.stopTest();
        animal2 = [select Name, Says__c, Eats__c, ExtraID__c from Animal__c where id = :animal2.id];
        System.assertEquals('chicken', animal2.Name);

    }
}