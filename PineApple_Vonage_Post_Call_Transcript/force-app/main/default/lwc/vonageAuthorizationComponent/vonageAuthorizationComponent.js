// AuthorizationComponent.js
import { LightningElement, api, track, wire } from 'lwc';
import { VonageAuthorizationHelper } from '@salesforce/apex';
import initiateVerification from '@salesforce/apex/VonageAuthorizationHelper.initiateVerification';

export default class AuthorizationComponent extends LightningElement {
    @api userRecord;
    @track verificationCode = '';
    phoneNumber = '48668479560';

    @wire(initiateVerification, { parameter: '$phoneNumber' })
    wiredData({ error, data }) {
        if (data) {
            // Process the data from the Apex method
            console.log('Apex Data:', data);
        } else if (error) {
            console.error('Error fetching data:', error);
        }
    }

    handleCodeChange(event) {
        this.verificationCode = event.target.value;
    }

    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    handleSend() {
        // Call the server-side method to verify the code
        // Replace 'yourApexMethod' with the actual name of your Apex method
        // and 'yourObjectName' with the actual API name of your object
        // Make sure your Apex method returns a response with status (true/false)
        // Example: { status: true, message: 'Verification successful' }
        // or { status: false, message: 'Verification failed' }

        // Call the Apex method
        VonageAuthorizationHelper.checkVerificationCallStatus({ code: this.verificationCode })
            .then(result => {
                if (result.status) {
                    this.dispatchEvent(new CustomEvent('success', { detail: result.message }));
                } else {
                    this.dispatchEvent(new CustomEvent('failure', { detail: result.message }));
                }
            })
            .catch(error => {
                console.error('Error calling Apex method:', error);
            });
    }
}