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
        Group highQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'High Urgency Queue' LIMIT 1];        
        Test.startTest();
        Case testCase = new Case(
            Issue_Type__c = 'Onboarding Issues',
            Urgency__c = 'High',
            Subject = 'High Urgency Test'
        );
        insert testCase;
        Test.stopTest();
    }

    @isTest
    static void testMediumUrgencyOnboardingCase() {
        Group mediumQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Medium Urgency Queue' LIMIT 1];
        
        Case testCase = new Case(
            Issue_Type__c = 'Onboarding Issues',
            Urgency__c = 'Medium',
            Subject = 'Medium Urgency Test'
        );
        insert testCase;
}

    @isTest
    static void testLowUrgencyOnboardingCase() {
        Group lowQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Low Urgency Queue' LIMIT 1];
        
        Case testCase = new Case(
            Issue_Type__c = 'Onboarding Issues',
            Urgency__c = 'Low',
            Subject = 'Low Urgency Test'
        );
        insert testCase;
    }

    @isTest
    static void testNonOnboardingCase() {
        // Assuming default owner is a user
        User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        Case testCase = new Case(
            Issue_Type__c = 'Other General Inquiries',
            Urgency__c = 'High',
            Subject = 'Non-Onboarding Test'
        );
        insert testCase;
    }

    @isTest
    static void testUpdateCaseUrgency() {
        Group highQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'High Urgency Queue' LIMIT 1];
        Group mediumQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Medium Urgency Queue' LIMIT 1];
        
        Case testCase = new Case(
            Issue_Type__c = 'Onboarding Issues',
            Urgency__c = 'Medium',
            Subject = 'Update Test'
        );
        insert testCase;

        Test.startTest();
        testCase.Urgency__c = 'High';
        update testCase;
        Test.stopTest();
    }
}