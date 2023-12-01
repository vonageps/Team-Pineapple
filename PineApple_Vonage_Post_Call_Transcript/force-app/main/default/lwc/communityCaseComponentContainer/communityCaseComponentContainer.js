// CommunityCaseComponentContainer.js
import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { CurrentPageReference } from 'lightning/navigation';

import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import IS_AUTHORIZED from '@salesforce/schema/User.Is_authorized__c';
import fetchUserData from '@salesforce/apex/VonageAuthorizationHelper.fetchUserData';

import Id from "@salesforce/user/Id";
export default class CommunityCaseComponentContainer extends LightningElement {
    @api userId = Id;
    @api userRecord;
    userId ;
    userName = USER_NAME_FIELD;
    isAuthorized;

    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
        // Fetch user data on component creation
        this.fetchData();
    }

    fetchData() {
        console.log('TEST: fetchData');
        fetchUserData()
            .then(result => {
                console.log('TEST: result', JSON.stringify(result));
                this.userName = result.Name;
                this.isAuthorized = result.Is_authorized__c;

                // Check if Is_authorized__c is already true
                if (this.isAuthorized) {
                    console.log('User is already authorized');
                    // Handle accordingly, e.g., show a message or take action
                }
            })
            .catch(error => {
                console.log('TEST: error', JSON.stringify(error));
                console.error('Error fetching user information: ', error);
            });
    }

    

    // @wire(getRecord, { recordId: '$userId', fields: [USER_NAME_FIELD, IS_AUTHORIZED] })
    // wiredUser({ data, error }) {
    //     if (data) {
    //         console.log('TEST: data', JSON.stringify(data));
    //         this.userName = getFieldValue(data, USER_NAME_FIELD);
    //         this.isAuthorized = getFieldValue(data, IS_AUTHORIZED);

    //         // Check if Is_authorized__c is already true
    //         if (this.isAuthorized) {
    //             console.log('User is already authorized');
    //             // Handle accordingly, e.g., show a message or take action
    //         }
    //     } else if (error) {
    //         console.log('TEST: error', JSON.stringify(error));
    //         console.error('Error fetching user information: ', error);
    //     }
    // }

    handleSuccess (event) {
        console.log('TEST: parent event', event);
            this.isAuthorized = event.type === 'success';
        
    }
}