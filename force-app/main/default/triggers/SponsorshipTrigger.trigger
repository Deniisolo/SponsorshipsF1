trigger SponsorshipTrigger on Sponsorship__c (before insert, before update) {
    for (Sponsorship__c sponsorship : Trigger.new) {
        if (sponsorship.Active__c) {
            List<Sponsorship__c> existingSponsorships = [
                SELECT Id 
                FROM Sponsorship__c 
                WHERE Driver__c = :sponsorship.Driver__c 
                AND Active__c = TRUE
                AND Id != :sponsorship.Id
            ];
            
            if (!existingSponsorships.isEmpty()) {
                sponsorship.addError('The driver already has an active sponsorship.');
            }
        }
    }
}