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
}