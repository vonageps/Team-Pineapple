// CommunityCaseComponentContainer.js
import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { CurrentPageReference } from 'lightning/navigation';

import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import IS_AUTHORIZED from '@salesforce/schema/User.Is_authorized__c';

import Id from "@salesforce/user/Id";
export default class CommunityCaseComponentContainer extends LightningElement {
    @api userId = Id;
    @api userRecord;
    userId ;
    userName = USER_NAME_FIELD;
    isAuthorized;

    @wire(CurrentPageReference) pageRef;

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

    handleSuccess (event) {
        console.log('TEST: parent event', event);
            this.isAuthorized = event.type === 'success';
        
    }
}