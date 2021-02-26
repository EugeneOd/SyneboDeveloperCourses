public class SomeTestF { 
    @future
    public static void createSpecs(List<String> specsNames) {
        List<Specialty__c> speciality = new List<Specialty__c>();
        for (String str : specsNames) {
            speciality.add(new Specialty__c(Name = str));
        }
        insert speciality;
    }
}