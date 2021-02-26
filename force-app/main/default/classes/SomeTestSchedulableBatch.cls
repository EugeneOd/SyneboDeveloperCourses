global class SomeTestSchedulableBatch implements Database.Batchable<sObject>, Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Name, Group_Leader__c FROM Group__c ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Group__c> arr){
        for (Group__c grp : arr){
            
            if(String.isBlank(grp.Group_Leader__c)){
                grp.Group_Leader__c = 'Petr Semyonich';
            }
            update arr;  
        }
    }  
    global void finish(Database.BatchableContext BC){
    }
    
    
    
    global void execute (SchedulableContext SC){
        SomeTestSchedulableBatch ourBatch = new  SomeTestSchedulableBatch();
        database.executeBatch(ourBatch);
    }
    
    
    global void scheduleBatchRun() {
        String sch = '0 1 1 * * ?';
        system.schedule ('Batch', sch, new SomeTestSchedulableBatch());
    }
}