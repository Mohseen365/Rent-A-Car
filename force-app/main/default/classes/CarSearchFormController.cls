public class CarSearchFormController {
    @AuraEnabled(cacheable=true)
    public static List<Car_Type__c> getCarTypesDB(){
        try {
            return [SELECT Id, Name FROM Car_Type__c];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}