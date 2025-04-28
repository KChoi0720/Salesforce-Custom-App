import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateAccountForm extends LightningElement {

    handleSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: "Account Created",
                message: "Record ID: " + event.detail.id,
                variant: "success"
            })
        );
    }
}
