@isTest
public class SomeTestQTest {
    
	@isTest
    private Static void someTestQExecuteTest() {
        
        SomeTestQ someTestQ = new SomeTestQ('Some Test Spec');
        
        Test.startTest();
        Test.stopTest();
        System.enqueueJob(someTestQ);
    }
    
}