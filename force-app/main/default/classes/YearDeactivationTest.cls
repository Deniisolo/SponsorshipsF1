@isTest
public class YearDeactivationTest {

    @testSetup
    static void setup() {
        // Crear un patrocinador (Account)
        Account sponsor = new Account(Name = 'Test Sponsor', Total_Value__c = 1000);
        insert sponsor;

        // Crear un patrocinio (Sponsorship), con más de un año de antigüedad
        Sponsorship__c sponsorship = new Sponsorship__c(
            Sponsor__c = sponsor.Id,
            Active__c = true,
            Value__c = 500
        );
        insert sponsorship;

        // Crear otro patrocinio (Sponsorship), con menos de un año de antigüedad
        Sponsorship__c recentSponsorship = new Sponsorship__c(
            Sponsor__c = sponsor.Id,
            Active__c = true,
            Value__c = 300
        );
        insert recentSponsorship;
    }

    @isTest
    static void testYearDeactivation() {
        // Ejecutar la clase de desactivación
        Test.startTest();
        YearDeactivation yearDeactivation = new YearDeactivation();
        String cronExpression = '0 0 0 1 1 ? 2025'; // Se puede ejecutar en cualquier momento
        System.schedule('Test Deactivation Job', cronExpression, yearDeactivation);
        Test.stopTest();

        // Verificar que el patrocinio con más de un año ha sido desactivado
        Sponsorship__c updatedSponsorship = [SELECT Active__c FROM Sponsorship__c WHERE Active__c = TRUE LIMIT 1];
        System.assertEquals(false, updatedSponsorship.Active__c, 'El patrocinio debería estar desactivado');

        // Verificar que el patrocinio con menos de un año NO ha sido desactivado
        Sponsorship__c recentSponsorship = [SELECT Active__c FROM Sponsorship__c WHERE Active__c = TRUE LIMIT 1];
        System.assertEquals(true, recentSponsorship.Active__c, 'El patrocinio reciente no debería haber sido desactivado');

        // Verificar que el valor del patrocinador ha aumentado
        Account updatedSponsor = [SELECT Total_Value__c FROM Account WHERE Id = :updatedSponsorship.Sponsor__c LIMIT 1];
        System.assertEquals(1500, updatedSponsor.Total_Value__c, 'El valor del patrocinador debería haber aumentado en 500');
    }

    @isTest
    static void testNoSponsorshipsToDeactivate() {
        // Crear un patrocinador (Account) con un patrocinio reciente
        Account sponsor = new Account(Name = 'Test Sponsor', Total_Value__c = 1000);
        insert sponsor;

        Sponsorship__c sponsorship = new Sponsorship__c(
            Sponsor__c = sponsor.Id,
            Active__c = true,
            Value__c = 500
        );
        insert sponsorship;

        // Ejecutar la clase de desactivación
        Test.startTest();
        YearDeactivation yearDeactivation = new YearDeactivation();
        String cronExpression = '0 0 0 1 1 ? 2025'; // Se puede ejecutar en cualquier momento
        System.schedule('Test Deactivation Job', cronExpression, yearDeactivation);
        Test.stopTest();

        // Verificar que no se ha desactivado el patrocinio
        Sponsorship__c updatedSponsorship = [SELECT Active__c FROM Sponsorship__c WHERE Id = :sponsorship.Id LIMIT 1];
        System.assertEquals(true, updatedSponsorship.Active__c, 'El patrocinio no debería haber sido desactivado');

        // Verificar que el valor del patrocinador no ha cambiado
        Account updatedSponsor = [SELECT Total_Value__c FROM Account WHERE Id = :sponsor.Id LIMIT 1];
        System.assertEquals(1000, updatedSponsor.Total_Value__c, 'El valor del patrocinador no debería haber cambiado');
    }

    @isTest
    static void testSponsorshipWithoutSponsor() {
        // Crear un patrocinio sin un patrocinador asignado
        Sponsorship__c sponsorship = new Sponsorship__c(
            Active__c = true,
            Value__c = 500
        );
        insert sponsorship;

        // Ejecutar la clase de desactivación
        Test.startTest();
        YearDeactivation yearDeactivation = new YearDeactivation();
        String cronExpression = '0 0 0 1 1 ? 2025'; // Se puede ejecutar en cualquier momento
        System.schedule('Test Deactivation Job', cronExpression, yearDeactivation);
        Test.stopTest();

        // Verificar que el patrocinio fue desactivado
        Sponsorship__c updatedSponsorship = [SELECT Active__c FROM Sponsorship__c WHERE Id = :sponsorship.Id LIMIT 1];
        System.assertEquals(false, updatedSponsorship.Active__c, 'El patrocinio debería haber sido desactivado');

        // Verificar que no se haya actualizado ningún valor en Account (sin patrocinador)
        List<Account> accounts = [SELECT Total_Value__c FROM Account WHERE Id IN (SELECT Sponsor__c FROM Sponsorship__c WHERE Id = :sponsorship.Id)];
        System.assertEquals(0, accounts.size(), 'No debería haber actualizado ninguna cuenta porque no tiene patrocinador');
    }
}