@isTest
public class GroupsClassTest {
    
    public static Datetime requiredDatetime = Datetime.newInstance(1996,11,15,9,30,0); 
    
	@testSetup
    private static void makeData() {
        Specialty__c extraCoolSpeciality = new Specialty__c(Name = 'Extra Cool Speciality');
        insert extraCoolSpeciality;
    }
    
    @isTest
    private static void updateRequiredFieldTest() {
        Group__c extraCoolGroup = new Group__c(Name = 'Extra Cool Group');
        test.startTest();
        insert extraCoolGroup;
        test.stopTest();
        
       	Group__c groupTest = [SELECT Id, Date_of_the_creation__c FROM Group__c WHERE Name =: extraCoolGroup.Name LIMIT 1];
        System.assertEquals(requiredDatetime, groupTest.Date_of_the_creation__c);
    }
    
    @isTest
    private static void updateParentRequiredFieldTest() {
        Specialty__c specTest = [SELECT Id FROM Specialty__c WHERE Name = 'Extra Cool Speciality' LIMIT 1];
        Group__c extraCoolGroup = new Group__c(Name = 'Extra Cool Group', Specialty__c = specTest.Id);
        test.startTest();
        insert extraCoolGroup;
        test.stopTest();
        
        specTest = [SELECT Date_of_creation_Spec__c FROM Specialty__c WHERE Name = 'Extra Cool Speciality' LIMIT 1];
        System.assertEquals(requiredDatetime, specTest.Date_of_creation_Spec__c);
    }
}