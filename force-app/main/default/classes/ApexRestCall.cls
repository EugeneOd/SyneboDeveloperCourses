public class ApexRestCall {
    
    @Future(callout=true)
    public static void mainGetAnimal(Set<Id> id_s){
        
        Http http = new Http();
        List<Animal__c> animals = [SELECT Name, Says__c, Eats__c, ExtraID__c
                                   FROM animal__c
                                   WHERE Id = :id_s
                                   AND ExtraID__c != null];
        for(Animal__c an : animals){
            String extid = an.ExtraID__c;
            Map<String, Object> animalsMap = getAnimalById(extid, http);
            if(!animalsMap.isEmpty()) {
                an.Name = String.valueOf(animalsMap.get('name'));
                an.Says__c = String.valueOf(animalsMap.get('says'));
                an.Eats__c = String.valueOf(animalsMap.get('eats'));
            }
        }
        System.debug('animals ===>' + animals);
        update animals;
    }
    
    
    public static HttpRequest getRequestId(String Ids){
        
        HttpRequest result = new HttpRequest();
        String endPoint = 'https://th-apex-http-callout.herokuapp.com/animals/';
        result.setEndpoint(endPoint + Ids);
        result.setMethod('GET');
        return result;
    }
    
    public static Map<String, Object> getAnimalById(String Ids, Http http){
        Map<String, Object> animalsMap  = new Map<String, Object>();
        HttpResponse response = http.send(getRequestId(Ids));
        if(response.getStatusCode() == 200) {
            String body = response.getBody();
            animalsMap = (Map<String, Object>) JSON.deserializeUntyped(body);
            animalsMap = (Map<String, Object>)animalsMap.get('animal');
        } else {
            throw new CalloutException('Status code: ' + response.getStatusCode());
        }
        return animalsMap;
        
    } 
    
    @AuraEnabled(cacheable=false)
    public static Object getAnimalsByRange(String startRange, String endRange) {
        Object returnObj;
        List<Map<String, Object>> animalsMapList = new List<Map<String, Object>>(); 
        try{
            if(startRange != null && endRange != null){
                Integer startRangeInt = Integer.valueOf(startRange);
                Integer endRangeInt = Integer.valueOf(endRange);
                
                Http http = new Http();
                for(Integer i = startRangeInt; i<=endRangeInt; i++){
                    animalsMapList.add(getAnimalById(String.valueOf(i), http));
                    
                }
                System.debug(animalsMapList);
            }
            returnObj = new ReturnWrapper(true, animalsMapList);
        } catch(Exception ex) {
            returnObj = new ReturnWrapper(false, ex.getMessage());
        }
        return returnObj;
    }
    
    @AuraEnabled
    public static Object saveRecords(List<Map<String, String>> dataToSave) {
        Object returnObj;
        String responseMsg;
        Integer successedCreated = 0;
        Integer unsuccessedCreated = 0;
        Boolean isSuccess = true;
        System.debug('datatoSave' + dataToSave);
        List<Animal__c> animalList = new List<Animal__c>();
        for (Map<String, String> i:dataToSave) {
            system.debug('i' + i);
            Animal__c animal = new Animal__c();
            animal.Says__c = i.get('says');
            animal.Eats__c = i.get('eats');
            animal.Name = i.get('name');
            animalList.add(animal);  
        }
        Database.SaveResult[] srList = Database.insert(animalList, false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                successedCreated++;
                System.debug('Successfully inserted animals.' + sr.getId());
            }
            else {
                isSuccess = false;
                unsuccessedCreated++;
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
        
        if(successedCreated > 0 && unsuccessedCreated == 0) {
            responseMsg = 'Successfuly inserted ' + successedCreated + ' animals.';
        } else if(successedCreated > 0 && unsuccessedCreated > 0) {
            responseMsg = 'Successfuly inserted ' + successedCreated + ' unsuccessfuly inserted ' + unsuccessedCreated + ' animals.';
        }else if (successedCreated == 0 && unsuccessedCreated > 0){
            responseMsg = 'Unsuccessfuly inserted ' + unsuccessedCreated + ' animals.';
        } else {
            isSuccess = false;
            responseMsg = 'Something went wrong';
        }
        
        returnObj = new ReturnWrapper(isSuccess, responseMsg);
        if (isSuccess) {
             sendEmail(responseMsg);
        }

        return returnObj;
    }
    
    public static void sendEmail(String msg){
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmail = activeUser.Email;
        System.debug('check activeUser email' + userEmail);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> adresses = new List<String>{userEmail};
        mail.setToAddresses(adresses);
        
        mail.setSubject('Saved animals.');
        mail.setHtmlBody('Hello, <br/><br/>This message was generated automatically.. <br/>'+msg+'<br/><br/>Regards<br/>Synebo Developer Courses');
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(exception e){
            System.debug('Error' + e);
        }
    }
    
    
    public class ReturnWrapper{
        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public Object returnObj;
        public ReturnWrapper(Boolean isSuccess, Object returnObj){
            this.isSuccess = isSuccess;
            this.returnObj = returnObj;
        } 
    }
    
    
}