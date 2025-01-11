@isTest
public class DriverControllerTest {
    @isTest
    static void testGetActiveDrivers() {
  
        Account sponsor = new Account(
            Name = 'Test Sponsor',
            Sector__c = 'Private',
            Industry = 'Agriculture',
            Total_Value__c = 10000000
        );
        insert sponsor;


        Contact driver = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            Active__c = true,
            Team__c = 'Williams Racing' 
        );
        insert driver;


        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = sponsor.Id,
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 10000
        );
        insert opp;

        Sponsorship__c sponsorship1 = new Sponsorship__c(
            Sponsor__c = sponsor.Id,
            Opportunity__c = opp.Id,
            Driver__c = driver.Id,
            Value__c = 5000,
            Active__c = true
        );
        insert sponsorship1;

        Test.startTest();
        List<Map<String, Object>> drivers = DriverController.getActiveDrivers();
        Test.stopTest();

        System.assertEquals(1, drivers.size(), 'Must return 1 active drivers.');
    }
}