public class ClaimSubmissionController {

    public String claimantName {get; set;}
    public String claimantAddress {get; set;}
    public String claimantEmail {get; set;}
    public String claimType {get; set;}
    public String carMake {get; set;}
    public String carModel {get; set;}
    public String propertyAddress {get; set;}
    public String damageDescription {get; set;}
    public Blob fileToUpload {get; set;}
    
    public List<SelectOption> claimTypeOptions {get; set;}

    // Constructor: initialize claim type options
    public ClaimSubmissionController() {
        claimTypeOptions = new List<SelectOption>{
            new SelectOption('Car', 'Car'),
            new SelectOption('Home', 'Home')
        };
    }

    // Method to handle the claim submission
    public PageReference submitClaim() {
        // Basic validation
        if (String.isBlank(claimantName) || String.isBlank(claimantAddress) || String.isBlank(claimantEmail)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Personal details are required.'));
            return null;
        }

        // Handle file upload logic
        if (fileToUpload != null) {
            // Save the uploaded file (this could be stored in a custom object or as an Attachment)
            Attachment attachment = new Attachment();
            attachment.Body = fileToUpload;
            attachment.Name = 'Supporting Document';
            attachment.ParentId = UserInfo.getUserId();  // Example: Attach to the current user
            insert attachment;
        }

        // Reimbursement estimate calculation based on claim type
        Decimal reimbursementEstimate = calculateReimbursement();

        // Insert Claim Record (create a custom Claim object as needed)
        Claim__c newClaim = new Claim__c(
            Claimant_Name__c = claimantName,
            Claimant_Address__c = claimantAddress,
            Claimant_Email__c = claimantEmail,
            Claim_Type__c = claimType,
            Reimbursement_Estimate__c = reimbursementEstimate
        );
        insert newClaim;

        // Show success message
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Claim submitted successfully!'));

        return null;
    }

    // Method to calculate reimbursement estimate (this can be enhanced)
    private Decimal calculateReimbursement() {
        Decimal estimate = 0;

        if (claimType == 'Car') {
            estimate = 5000; // Example value for car claim
        } else if (claimType == 'Home') {
            estimate = 10000; // Example value for home claim
        }

        return estimate;
    }
}
