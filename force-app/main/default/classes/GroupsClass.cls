public class GroupsClass {
    
    public static Datetime requiredDatetime = Datetime.newInstance(1996,11,15,9,30,0); 
    
    public static void updateRequiredField(List<Group__c> newList) {
        for(Group__c group_i : newList) {
            group_i.Date_of_the_creation__c = requiredDatetime;
        }   
    }
    
    public static void updateParentRequiredField(List<Group__c> newList) {
        Set<Id> idSetGroup = new Set <Id>();
        for (Group__c group_i : newList) {
            idSetGroup.add(group_i.Specialty__c);
        }
        
        List <Specialty__c> specList = [SELECT Id, Date_of_creation_Spec__c FROM Specialty__c WHERE Id IN : idSetGroup];
        if(!specList.isEmpty()) {
            for (Specialty__c spec_i : specList) {
                spec_i.Date_of_creation_Spec__c = requiredDatetime;
            }
            update specList;
        }
    }
}