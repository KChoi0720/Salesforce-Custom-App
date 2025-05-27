trigger CaseTrigger on Case (before insert, before update) {

    // Query Queue IDs once
    List<Group> queues = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name IN ('High Urgency Queue', 'Medium Urgency Queue', 'Low Urgency Queue')];
    Id highUrgencyQueueId;
    Id mediumUrgencyQueueId;
    Id lowUrgencyQueueId;

    for (Group q : queues) {
        if (q.Name == 'High Urgency Queue') {
            highUrgencyQueueId = q.Id;
        } else if (q.Name == 'Medium Urgency Queue') {
            mediumUrgencyQueueId = q.Id;
        } else if (q.Name == 'Low Urgency Queue') {
            lowUrgencyQueueId = q.Id;
        }
    }

    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    for (Case c : Trigger.new) {
        // Assign OwnerId based on Urgency and Issue Type
        if (c.Issue_Type__c == 'Onboarding Issues') {
            if (c.Urgency__c == 'High') {
                c.OwnerId = highUrgencyQueueId;
            } else if (c.Urgency__c == 'Medium') {
                c.OwnerId = mediumUrgencyQueueId;
            } else if (c.Urgency__c == 'Low') {
                c.OwnerId = lowUrgencyQueueId;
            }
        }

        // Prepare email for high urgency cases
        if (c.Urgency__c == 'High') {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] {'jipingcui0908@gmail.com'});
            email.setSubject('High Urgency Case Created: ' + c.CaseNumber);
            email.setPlainTextBody('A high urgency case has been created.\nCase ID: ' + c.Id +
                '\nLink: ' + System.URL.getOrgDomainUrl().toExternalForm() + '/' + c.Id);
            emails.add(email);
        }
    }

    // Send all emails
    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
    }
}