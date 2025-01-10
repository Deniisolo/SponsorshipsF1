@isTest
public class SponsorshipTriggerTest {
    @isTest
    static void testSponsorshipValidation() {

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

  
        Sponsorship__c sponsorship2 = new Sponsorship__c(
            Sponsor__c = sponsor.Id,
            Opportunity__c = opp.Id,
            Driver__c = driver.Id,
            Value__c = 3000,
            Active__c = true
        );

        Test.startTest();
        try {
            insert sponsorship2;
            System.assert(false, 'Expected a DMLException due to duplicate active sponsorships.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('El piloto ya tiene un patrocinio activo.'));
        }
        Test.stopTest();
    }
}