public class GroupController {
    public String groupName {get; set;}
    public Datetime DateOfTheCreation {get; set;}
    public String GroupLeader {get; set;}
    public Decimal  NumberOfStudentsAtTheirOwnExpense {get; set;}
    public Decimal  NumberOfStudentsInTheGroup {get; set;}
    public Decimal  NumberOfStudentsOnABudget {get; set;}
    public String Specialty {get; set;}
    public String TheTeacherInChargeOfTheGroup{get; set;}
    
    public GroupController(ApexPages.StandardController controller) {
                Group__c groupData = [SELECT Name, Date_of_the_creation__c, Group_Leader__c, Number_of_students_at_their_own_expense__c, Number_of_students_in_the_group__c, Number_of_students_on_a_budget__c, Specialty__c, The_teacher_in_charge_of_the_group__c FROM Group__c 
                              WHERE id =: ApexPages.currentPage().getParameters().get('id')];
        groupName = groupData.Name;
        DateOfTheCreation = groupData.Date_of_the_creation__c;
        GroupLeader = groupData.Group_Leader__c;
        NumberOfStudentsAtTheirOwnExpense = groupData.Number_of_students_at_their_own_expense__c;
        NumberOfStudentsInTheGroup = groupData.Number_of_students_in_the_group__c;
        NumberOfStudentsOnABudget = groupData.Number_of_students_on_a_budget__c;
        Specialty = groupData.Specialty__c;
        TheTeacherInChargeOfTheGroup = groupData.The_teacher_in_charge_of_the_group__c;
    }
}