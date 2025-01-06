public with sharing class DriverController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getActiveDrivers() {
        List<Contact> contacts = [
            SELECT Id, Name, Team__c
            FROM Contact
            WHERE Active__c = true
        ];
        Map<Id, Contact> contactMap = new Map<Id, Contact>(contacts);
        
        List<Sponsorship__c> sponsorships = [
            SELECT Driver__c,  Value__c, Sponsor__r.Name
            FROM Sponsorship__c
            WHERE Driver__c IN :contactMap.keySet()
        ];
      

        Map<Id, String> mainSponsorMap = new Map<Id, String>();
        Map<Id, Decimal> mainAmountMap = new Map<Id, Decimal>();
        for (Sponsorship__c sponsorship : sponsorships) {
            Id contactId = sponsorship.Driver__c;
            String sponsorName = sponsorship.Sponsor__r.Name;
            Decimal amount = sponsorship.Value__c;
          
            if (!mainAmountMap.containsKey(contactId) || amount > mainAmountMap.get(contactId)) {
                mainAmountMap.put(contactId, amount);
                mainSponsorMap.put(contactId, sponsorName);
            }
        }


        List<Map<String, Object>> drivers = new List<Map<String, Object>>();
        String imageUrl = '/resource/User'; 

        for (Contact contact : contacts) {
            Map<String, Object> driver = new Map<String, Object>();
            driver.put('Id', contact.Id);
            driver.put('Name', contact.Name);
            driver.put('Team', contact.Team__c);
            driver.put('MainSponsor', mainSponsorMap.get(contact.Id));
            driver.put('ImageUrl', imageUrl); 
            drivers.add(driver);
        }
        
        return drivers;
    }
}