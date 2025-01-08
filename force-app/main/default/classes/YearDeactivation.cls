public class YearDeactivation implements Schedulable {
    public void execute(SchedulableContext Context) {
        List<Sponsorship__c> sponsorshipsToUpdate = [
            SELECT Id, Active__c, CreatedDate
            FROM Sponsorship__c
            WHERE Active__c = TRUE
        ]; 

        for (Sponsorship__c sponsorship : sponsorshipsToUpdate) {
            if (sponsorship.Active__c == TRUE) {
                sponsorship.Active__c = false;
            }
        }

        // Solo actualiza si la lista no está vacía
        if (!sponsorshipsToUpdate.isEmpty()) {
            update sponsorshipsToUpdate;
        }
    }
}