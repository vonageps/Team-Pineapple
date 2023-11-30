// import createCase from '@salesforce/apex/VonageCaseController.createCase';
import { LightningElement, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { CurrentPageReference } from 'lightning/navigation';

import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import USER_ID_FIELD from '@salesforce/schema/User.Id';
import IS_AUTHORIZED from '@salesforce/schema/User.Is_authorized__c';

import Id from "@salesforce/user/Id";


export default class CreateCaseComponent extends LightningElement {
    userId = Id;
    userName = USER_NAME_FIELD;
    isAuthorized = IS_AUTHORIZED;
    subject = '';
    description = '';

    // Use CurrentPageReference to get page attributes, including user Id
    @wire(CurrentPageReference) pageRef;

    // Fetch user information based on the user Id
    @wire(getRecord, { recordId: '$userId', fields: [USER_NAME_FIELD,IS_AUTHORIZED] })
    wiredUser({ data, error }) {
        if (data) {
            console.log('TEST: data', JSON.stringify(data));
            this.userName = getFieldValue(data, USER_NAME_FIELD);
            this.isAuthorized = getFieldValue(data, IS_AUTHORIZED);
        } else if (error) {
            console.log('TEST: error', JSON.stringify(error));
            console.error('Error fetching user information: ', error);
        }
    }

    connectedCallback() {
        // Set the user Id dynamically from the current page
        console.log('TEST: this.pageRef', JSON.stringify(this.pageRef));

        if (this.pageRef) {
            const state = this.pageRef.state;
            console.log('TEST: this.state', JSON.stringify(state));

            if (state && state.userId) {
                this.userId = state.userId;
            }
        }
    }

    handleSubjectChange(event) {
        this.subject = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }
}