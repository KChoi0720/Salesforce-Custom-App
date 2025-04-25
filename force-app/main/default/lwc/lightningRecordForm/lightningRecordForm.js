import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LightningRecordForm extends LightningElement {
    fields = ['Name', 'Amount', 'ContactId', 'StageName', 'CloseDate', 'Phone', 'Email'];

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Success!",
            message: "Record has been saved successfully.",
            variant: "success"
        });
        this.dispatchEvent(evt);
    }

    handleCancel() {
        // Define your cancel logic here (e.g., navigate away or reset the form)
        console.log('Cancel clicked');
    }

    handleSave() {
        // Handle save logic if necessary
        console.log('Save clicked');
    }
}
