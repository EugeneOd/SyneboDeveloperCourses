public class SomeTestQ implements Queueable{
    String nameOfSpeciality;
    Id specId;
    String groupName;
    public SomeTestQ(String nameOfSpeciality){
        this.nameOfSpeciality = nameOfSpeciality;
    }
    
    public SomeTestQ(Id specId, String groupName){
        this.specId = specId;
        this.groupName = groupName;
    }
    
    public void execute(QueueableContext context) {
        if(groupName == null){
            Specialty__c spec = new Specialty__c(Name = nameOfSpeciality); 
            insert spec;
            System.enqueueJob(new SomeTestQ(spec.Id, 'TestNameOfGroup'));
        }else if(specId != null){
            Group__c newGroup = new Group__c(Name = groupName, Specialty__c = specId);
            insert newGroup;
        }
    }
}