trigger GroupTrigger on Group__c (before insert) {
 GroupsClass.updateRequiredField(Trigger.new);
 GroupsClass.updateParentRequiredField(Trigger.new);
}