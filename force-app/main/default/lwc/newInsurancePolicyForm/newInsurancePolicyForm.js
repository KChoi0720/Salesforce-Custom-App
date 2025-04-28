import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import POLICY_OBJECT from '@salesforce/schema/Policy_c';

export default class PolicyForm extends LightningElement {
    @track policyHolder = '';
    @track policyType = '';
    @track startDate = '';
    @track endDate = '';
    @track premiumAmount = '';

    policyTypeOptions = [
        { label: 'Auto', value: 'Auto' },
        { label: 'Home', value: 'Home' },
        { label: 'Life', value: 'Life' },
        { label: 'Health', value: 'Health' }
    ];

    handlePolicyHolderChange(event) {
        this.policyHolder = event.target.value;
    }
    handlePolicyTypeChange(event) {
        this.policyType = event.target.value;
    }
    handleStartDateChange(event) {
        this.startDate = event.target.value;
    }
    handleEndDateChange(event) {
        this.endDate = event.target.value;
    }
    handlePremiumAmountChange(event) {
        this.premiumAmount = event.target.value;
    }

    handleSubmit() {
        const fields = {
            Policy_Holder__c: this.policyHolder,
            Policy_Type__c: this.policyType,
            Start_Date__c: this.startDate,
            End_Date__c: this.endDate,
            Premium_Amount__c: this.premiumAmount
        };

        const recordInput = { apiName: POLICY_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Policy created! Record ID: ' + result.id,
                        variant: 'success'
                    })
                );
                // Clear form after submit
                this.policyHolder = '';
                this.policyType = '';
                this.startDate = '';
                this.endDate = '';
                this.premiumAmount = '';
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}
