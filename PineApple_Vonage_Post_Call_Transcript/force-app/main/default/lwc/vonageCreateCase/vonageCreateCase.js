import { LightningElement, track, wire } from 'lwc';
import getCurrentUserId from '@salesforce/apex/VonageCaseController.getCurrentUserId';
import createVonageCase from '@salesforce/apex/VonageCaseController.createCase';

export default class CreateCaseComponent extends LightningElement {

    @track subject;
    @track description;
    @track phoneNumber;
    @track successMessage;

    @wire(getCurrentUserId) currentUserId;

    handleSubjectChange(event) {
        this.subject = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    handlePhoneNumberChange(event) {
        this.phoneNumber = event.target.value;
    }

    createCase() {
         createVonageCase({ subject: this.subject, description: this.description, phoneNumber: this.phoneNumber })
         .then(result => {
            // Set success message
            this.successMessage = 'Vonage Case created successfully. Case Id: ' + result;

            // Navigate to the newly created Case record page
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: result, // Assumes that the Apex method returns the Case Id
                    objectApiName: 'Case',
                    actionName: 'view'
                }
            }).then(url => {
                window.location.assign(url);
            });
        })
        .catch(error => {
            console.error('Error creating Vonage case:', error);
            // Add logic to display an error message to the user if needed
        });
    }
}