@isTest
public class CaseTriggerTest {

    @testSetup
    static void setupQueues() {
        // Create 3 dummy queues (Groups) with known IDs for testing
        Group highQueue = new Group(Name = 'High Urgency Queue', Type = 'Queue');
        Group mediumQueue = new Group(Name = 'Medium Urgency Queue', Type = 'Queue');
        Group lowQueue = new Group(Name = 'Low Urgency Queue', Type = 'Queue');
        insert new List<Group>{highQueue, mediumQueue, lowQueue};

        // Can manually assign the IDs if you use hardcoded ones for testing
        System.debug('Setup complete');
    }

    @isTest
    static void testHighUrgencyOnboardingCase() {
        Case highCase = new Case(
            Subject = 'Test High Urgency',
            Urgency__c = 'High',
            Issue_Type__c = 'Onboarding'
        );

        Test.startTest();
        insert highCase;
        Test.stopTest();

        // Reload the case from DB
        Case inserted = [SELECT Id, OwnerId, Urgency__c FROM Case WHERE Id = :highCase.Id];
        System.assertEquals('High', inserted.Urgency__c);
        System.assertEquals('00GdL00000CeOPh', inserted.OwnerId); // Your actual High queue ID
    }

    @isTest
    static void testMediumUrgencyOnboardingCase() {
        Case mediumCase = new Case(
            Subject = 'Test Medium Urgency',
            Urgency__c = 'Medium',
            Issue_Type__c = 'Onboarding'
        );

        insert mediumCase;

        Case inserted = [SELECT Id, OwnerId FROM Case WHERE Id = :mediumCase.Id];
        System.assertEquals('00GdL00000CeORJ', inserted.OwnerId); // Medium queue ID
    }

    @isTest
    static void testLowUrgencyOnboardingCase() {
        Case lowCase = new Case(
            Subject = 'Test Low Urgency',
            Urgency__c = 'Low',
            Issue_Type__c = 'Onboarding'
        );

        insert lowCase;

        Case inserted = [SELECT Id, OwnerId FROM Case WHERE Id = :lowCase.Id];
        System.assertEquals('00GdL00000CeSWX', inserted.OwnerId); // Low queue ID
    }

    @isTest
    static void testNonOnboardingCaseNoAssignment() {
        Case c = new Case(
            Subject = 'General Issue',
            Urgency__c = 'Medium',
            Issue_Type__c = 'Other'
        );

        insert c;

        Case inserted = [SELECT Id, OwnerId FROM Case WHERE Id = :c.Id];
        // OwnerId will not be updated if Issue_Type__c ≠ 'Onboarding'
        System.assertNotEquals('00GdL00000CeORJ', inserted.OwnerId);
    }

    @isTest
    static void testEmailSendForHighUrgency() {
        // Set up email sending mock
        Test.startTest();

        Case highCase = new Case(
            Subject = 'High Urgency Email Test',
            Urgency__c = 'High',
            Issue_Type__c = 'Onboarding'
        );
        insert highCase;

        Test.stopTest();

        // System debug can be used to confirm or use Limits.getEmailInvocations()
        System.assertEquals(1, Limits.getEmailInvocations(), 'Expected 1 email to be sent');
    }
}
