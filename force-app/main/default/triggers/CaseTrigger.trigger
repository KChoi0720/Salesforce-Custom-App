trigger CaseTrigger on Case (before insert, before update) {

    // Query the IDs of the Case queues once and store them for use
    List<Group> queues = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name IN ('High Urgency Queue', 'Medium Urgency Queue', 'Low Urgency Queue')];
    
    // Variables to hold specific Queue IDs
    Id highUrgencyQueueId;
    Id mediumUrgencyQueueId;
    Id lowUrgencyQueueId;

    // Loop through each retrieved queue and assign IDs based on the queue name
    for (Group q : queues) {
        if (q.Name == 'High Urgency Queue') {
            highUrgencyQueueId = q.Id;
        } else if (q.Name == 'Medium Urgency Queue') {
            mediumUrgencyQueueId = q.Id;
        } else if (q.Name == 'Low Urgency Queue') {
            lowUrgencyQueueId = q.Id;
        }
    }
    // Prepare a list to hold email messages that will be sent for high urgency cases
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    // Loop through each Case in the trigger context (i.e., newly inserted or updated Cases)
    for (Case c : Trigger.new) {
        // AAssign the Case OwnerId to a specific Queue based on Urgency and Issue Type
        if (c.Issue_Type__c == 'Onboarding Issues') {
            if (c.Urgency__c == 'High') {
                c.OwnerId = highUrgencyQueueId;
            } else if (c.Urgency__c == 'Medium') {
                c.OwnerId = mediumUrgencyQueueId;
            } else if (c.Urgency__c == 'Low') {
                c.OwnerId = lowUrgencyQueueId;
            }
        }

        // If the Case has high urgency, prepare an email notification
        if (c.Urgency__c == 'High') {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] {'jipingcui0908@gmail.com'});
            email.setSubject('High Urgency Case Created: ' + c.CaseNumber);
            email.setPlainTextBody('A high urgency case has been created.\nCase ID: ' + c.Id +
                '\nLink: ' + System.URL.getOrgDomainUrl().toExternalForm() + '/' + c.Id);
            emails.add(email);
        }
    }

    // Send all the prepared emails if any were added
    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
    }
}