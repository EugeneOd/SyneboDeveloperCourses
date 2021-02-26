public class AnimalsDeleteHandler {

    public static String deleteRecords(){
        String status;
        try{
        List<Animal__c> selectListForDeleteRecords = [SELECT Id FROM Animal__c];
		delete selectListForDeleteRecords;
       	status = 'success delete';
        }catch(Exception ex) {
            status = ex.getMessage();
        }
        return status;
    } 
}