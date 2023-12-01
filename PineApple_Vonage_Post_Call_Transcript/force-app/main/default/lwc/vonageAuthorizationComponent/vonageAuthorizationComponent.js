import { LightningElement, api, track, wire } from 'lwc';
import initiateVerification from '@salesforce/apex/VonageAuthorizationHelper.initiateVerification';
import checkVerificationCallStatus from '@salesforce/apex/VonageAuthorizationHelper.checkVerificationCallStatus';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import updateUser from '@salesforce/apex/VonageAuthorizationHelper.updateUser'; // Add the actual path to your updateUser method


const FIELDS = ['User.MobilePhone'];

export default class AuthorizationComponent extends LightningElement {
    @api userRecord;
    @track verificationCode = '';
    phoneNumber;
    requestId;

    connectedCallback() {
        this.startVerification(this.phoneNumber);
    }

    @wire(getRecord, { recordId: USER_ID, fields: FIELDS })
    wiredUser({ error, data }) {
        if (data) {
            console.log('user phone: ', data.fields.MobilePhone);
            const phone = data.fields.MobilePhone.value.replace('+','').replace(' ','');
            console.log('user phone: ', phone);
            this.phoneNumber = phone;
        } else if (error) {
            console.error('Error fetching user data:', error);
        }
    }

    @wire(initiateVerification, { phoneNumber: '$phoneNumber' })
    wiredData({ error, data }) {
        console.log('initiateVerification: ');

        if (data) {
            // Process the data from the Apex method
            console.log('Apex Data:', data);
            this.requestId = data;
        } else if (error) {
            console.error('Error fetching data:', error);
        }
    }

    startVerification(parameter1) {
        initiateVerification({ parameter1})
            .then(result => {
                console.log('Apex data retrieved with parameters:', result);
            })
            .catch(error => {
                console.error('Error calling Apex method:', error);
            });
    }

    handleCodeChange(event) {
        this.verificationCode = event.target.value;
    }

    handleResend() {
        // this.dispatchEvent(new CustomEvent('cancel'));
    }

    handleSend() {
        const requId = this.requestId;
        const providedCode = this.verificationCode;
        console.log('TEST: send', providedCode);
        console.log('TEST: requestid', requId);
        checkVerificationCallStatus({requestId : requId, providedCode : providedCode})
            .then(result => {
                console.log('TEST: result', result);

                if (result === 'completed') {
                    this.updateUser();
                    this.dispatchEvent(new CustomEvent('success', { detail: result.message }));
                } else {
                    this.dispatchEvent(new CustomEvent('failure', { detail: result.message }));
                }
            })
            .catch(error => {
                console.error('Error calling Apex method:', error);
            });
    }

    updateUser() {
        const userId = USER_ID;

        updateUser({ passedId: userId })
            .then(updateResult => {
                console.log('User updated successfully:', updateResult);
            })
            .catch(updateError => {
                console.error('Error updating user:', updateError);
            });
    }
}