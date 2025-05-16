import { LightningElement, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';

export default class ContactList extends LightningElement {
    @track searchKey = '';
    @track allContacts = [];
    @track filteredContacts = [];

    @wire(getContacts)
    wiredContacts({ error, data }) {
        if (data) {
            this.allContacts = data;
            this.filteredContacts = data;
        } else if (error) {
            console.error('Error retrieving contacts:', error);
        }
    }

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value.toLowerCase();
        this.filteredContacts = this.allContacts.filter(contact =>
            contact.Name.toLowerCase().includes(this.searchKey)
        );
    }
}
