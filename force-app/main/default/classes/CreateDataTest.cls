/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CreateDataTest {

    @isTest
    static void testCreateCarTypes() {
        
        List<String> typeNames = new List<String>{'SUV', 'Sedan', 'Hatchback'};
        
        Test.startTest();
        List<Car_Type__c> carTypes = RentACarTestFactory.createCarTypes(typeNames);
        Test.stopTest();
        
        System.assertEquals(3, carTypes.size());
        System.assertEquals('SUV', carTypes[0].Name);
        
        // Verify inserted in DB
        List<Car_Type__c> inserted = [SELECT Id, Name FROM Car_Type__c];
        System.assertEquals(3, inserted.size());
    }
    
    
    @isTest
    static void testCreateContacts() {
        
        List<String> contactNames = new List<String>{'Smith', 'Johnson'};
        
        Test.startTest();
        List<Contact> contacts = RentACarTestFactory.createContacts(contactNames);
        Test.stopTest();
        
        System.assertEquals(2, contacts.size());
        System.assertEquals('Smith', contacts[0].LastName);
        
        List<Contact> inserted = [SELECT Id, LastName FROM Contact];
        System.assertEquals(2, inserted.size());
    }
    
    
    @isTest
    static void testCreateCars() {
        
        // First create required parent data
        Car_Type__c ct = new Car_Type__c(Name = 'SUV');
        insert ct;
        
        Contact con = new Contact(LastName = 'TestContact');
        insert con;
        
        Test.startTest();
        List<Car__c> cars = RentACarTestFactory.createCars(3, ct, con);
        Test.stopTest();
        
        System.assertEquals(3, cars.size());
        
        // Verify field values
        System.assertEquals(100, cars[0].Per_Day_Rent__c);
        System.assertEquals(2000, cars[0].Build_Year__c);
        System.assertEquals(ct.Id, cars[0].Car_Type__c);
        System.assertEquals(con.Id, cars[0].Contact__c);
        
        // Verify database insert
        List<Car__c> insertedCars = [
            SELECT Id, Name, Per_Day_Rent__c, Build_Year__c 
            FROM Car__c
        ];
        
        System.assertEquals(3, insertedCars.size());
    }
}