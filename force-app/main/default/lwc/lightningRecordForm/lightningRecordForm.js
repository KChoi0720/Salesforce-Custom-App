import { LightningElement } from 'lwc';

export default class CustomForm extends LightningElement {
    name = '';
    email = '';
    phone = '';

    handleNameChange(event) {
        this.name = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handlePhoneChange(event) {
        this.phone = event.target.value;
    }

    handleSubmit() {
        // You can replace this with Apex callout or validation
        console.log('Submitted:', {
            Name: this.name,
            Email: this.email,
            Phone: this.phone
        });

        alert(`Submitted:\nName: ${this.name}\nEmail: ${this.email}\nPhone: ${this.phone}`);
    }
}
