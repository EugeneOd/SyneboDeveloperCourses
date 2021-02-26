@isTest
public class SomeTestSchedulableBatchTest {
    
    @isTest
    private static void scheduleBatchRunTest() {
        test.startTest();
        string sch = '0 1 1 * * ?';
        system.schedule ('NewUniqueBatch', sch, new SomeTestSchedulableBatch());
        List<Task> lt = [SELECT Id
                         FROM Task];
        System.assertEquals(0, lt.size(), 'Tasks exist before job has run');
        test.stopTest();
    }
    
    @isTest
    private static void someTestSchedulableBatchTest() {
        Group__c extraCoolGroup = new Group__c(Name = 'Extra Super Group');
        insert extraCoolGroup;
        
        test.startTest();
        SomeTestSchedulableBatch myBatchObject = new SomeTestSchedulableBatch();
        Id batchId = Database.executeBatch(myBatchObject);
        AsyncApexJob job = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchId ];
        System.assertEquals(batchId, job.Id);
        test.stopTest();
        
        extraCoolGroup = [SELECT Group_Leader__c FROM Group__c WHERE Name = 'Extra Super Group' LIMIT 1];
        System.assertEquals('Petr Semyonich', extraCoolGroup.Group_Leader__c);
    }
}