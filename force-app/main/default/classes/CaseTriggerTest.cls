@isTest
private class CaseTriggerTest {

    @TestSetup
    static void setup() {
        // Create test queues
        List<Group> queues = new List<Group>{
            new Group(Name='High Urgency Queue', Type='Queue'),
            new Group(Name='Medium Urgency Queue', Type='Queue'),
            new Group(Name='Low Urgency Queue', Type='Queue')
        };
        insert queues;

        // Link queues to Case object
        List<QueueSObject> queueSObjects = new List<QueueSObject>();
        for (Group q : queues) {
            queueSObjects.add(new QueueSObject(
                SobjectType = 'Case',
                QueueId = q.Id
            ));
        }
        insert queueSObjects;
    }

    @isTest
    static void testHighUrgencyOnboardingCase() {
        Group highQueue = [SELECT Id FROM Group WHERE Name = 'High Urgency Queue' LIMIT 1];
        
        Test.startTest();
        Case testCase = new Case(
            Issue_Type__c = 'Onboarding',
            Urgency__c = 'High',
            Subject = 'High Urgency Test'
        );
        insert testCase;
        Test.stopTest();

        Case insertedCase = [SELECT OwnerId FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(highQueue.Id, insertedCase.OwnerId, 'Case should be assigned to High Urgency Queue');
        System.assertEquals(1, Limits.getEmailInvocations(), 'An email should be sent for High Urgency');
    }

    @isTest
    static void testMediumUrgencyOnboardingCase() {
        Group mediumQueue = [SELECT Id FROM Group WHERE Name = 'Medium Urgency Queue' LIMIT 1];
        
        Case testCase = new Case(
            Issue_Type__c = 'Onboarding',
            Urgency__c = 'Medium',
            Subject = 'Medium Urgency Test'
        );
        insert testCase;

        Case insertedCase = [SELECT OwnerId FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(mediumQueue.Id, insertedCase.OwnerId, 'Case should be assigned to Medium Urgency Queue');
    }

    @isTest
    static void testLowUrgencyOnboardingCase() {
        Group lowQueue = [SELECT Id FROM Group WHERE Name = 'Low Urgency Queue' LIMIT 1];
        
        Case testCase = new Case(
            Issue_Type__c = 'Onboarding',
            Urgency__c = 'Low',
            Subject = 'Low Urgency Test'
        );
        insert testCase;

        Case insertedCase = [SELECT OwnerId FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(lowQueue.Id, insertedCase.OwnerId, 'Case should be assigned to Low Urgency Queue');
    }

    @isTest
    static void testNonOnboardingCase() {
        // Assuming default owner is a user (e.g., current user)
        User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        Case testCase = new Case(
            Issue_Type__c = 'Other',
            Urgency__c = 'High',
            Subject = 'Non-Onboarding Test'
        );
        insert testCase;

        Case insertedCase = [SELECT OwnerId FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(currentUser.Id, insertedCase.OwnerId, 'Non-Onboarding Case should retain default owner');
    }

    @isTest
    static void testUpdateCaseUrgency() {
        Group highQueue = [SELECT Id FROM Group WHERE Name = 'High Urgency Queue' LIMIT 1];
        Group mediumQueue = [SELECT Id FROM Group WHERE Name = 'Medium Urgency Queue' LIMIT 1];
        
        Case testCase = new Case(
            Issue_Type__c = 'Onboarding',
            Urgency__c = 'Medium',
            Subject = 'Update Test'
        );
        insert testCase;
        System.assertEquals(mediumQueue.Id, [SELECT OwnerId FROM Case WHERE Id = :testCase.Id].OwnerId);

        Test.startTest();
        testCase.Urgency__c = 'High';
        update testCase;
        Test.stopTest();

        Case updatedCase = [SELECT OwnerId FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(highQueue.Id, updatedCase.OwnerId, 'Updated Case should be assigned to High Urgency Queue');
        System.assertEquals(1, Limits.getEmailInvocations(), 'Email should be sent after update to High Urgency');
    }
}