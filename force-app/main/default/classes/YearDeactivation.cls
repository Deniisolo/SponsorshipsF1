public class YearDeactivation implements Schedulable {
    public void execute(SchedulableContext context) {
        List<Sponsorship__c> sponsorshipsToUpdate = [
            SELECT Id, Active__c, CreatedDate, Value__c, Sponsor__c
            FROM Sponsorship__c
            WHERE Active__c = TRUE AND CreatedDate <= :System.today().addYears(-1)
        ];
        for (Sponsorship__c sponsorship : sponsorshipsToUpdate) {
            sponsorship.Active__c = false;
        }

        if (!sponsorshipsToUpdate.isEmpty()) {
            update sponsorshipsToUpdate;
        }

    }
}