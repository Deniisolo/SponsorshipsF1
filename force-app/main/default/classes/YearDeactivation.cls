public class YearDeactivation implements Schedulable {
    public void execute(SchedulableContext context) {

        List<Sponsorship__c> sponsorshipsToUpdate = [
            SELECT Id, Active__c, CreatedDate, Value__c, Sponsor__c
            FROM Sponsorship__c
            WHERE Active__c = TRUE AND CreatedDate <= :System.today().addYears(-1)
        ];

        Map<Id, Decimal> sponsorValueMap = new Map<Id, Decimal>();

        for (Sponsorship__c sponsorship : sponsorshipsToUpdate) {
            sponsorship.Active__c = false;

            if (sponsorship.Sponsor__c != null) {
                if (!sponsorValueMap.containsKey(sponsorship.Sponsor__c)) {
                    sponsorValueMap.put(sponsorship.Sponsor__c, 0);
                }
                sponsorValueMap.put(sponsorship.Sponsor__c, sponsorValueMap.get(sponsorship.Sponsor__c) + sponsorship.Value__c);
            }
        }

        if (!sponsorshipsToUpdate.isEmpty()) {
            update sponsorshipsToUpdate;
        }

        List<Account> sponsorsToUpdate = [
            SELECT Id, Total_Value__c
            FROM Account
            WHERE Id IN :sponsorValueMap.keySet()
        ];


        for (Account sponsor : sponsorsToUpdate) {
            sponsor.Total_Value__c += sponsorValueMap.get(sponsor.Id);
        }

        if (!sponsorsToUpdate.isEmpty()) {
            update sponsorsToUpdate;
        }
    }
}