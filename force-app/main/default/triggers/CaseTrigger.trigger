trigger CaseTrigger on Case (before insert, before update) {
    
    // define each queue I
    Id highUrgencyQueueId = '00GdL00000CeOPh';
    Id mediumUrgencyQueueId = '00GdL00000CeORJ';
    Id lowUrgencyQueueId = '00GdL00000CeSWX';
    
    for (Case c : Trigger.new) {
        if (c.Urgency__c == 'High' && c.Issue_Type__c = 'Onboarding') {
            c.OwnerId = highUrgencyQueueId;
        } else if (c.Urgency__c == 'Medium' && c.Issue_Type__c = 'Onboarding') {
            c.OwnerId = mediumUrgencyQueueId;
        } else (c.Urgency__c == 'Low' && c.Issue_Type__c = 'Onboarding') {
            c.OwnerId = lowUrgencyQueueId;
        }

        // Send email reminder if urgency is high
        if (c.Urgency__c == 'High') {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] {'jipingcui0908@gmail.com'});
            email.setSubject('High Urgency Case Created');
            email.setPlainTextBody('A high urgency case has been created.\nCase ID: ' + c.Id +
                                   '\nLink: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
}