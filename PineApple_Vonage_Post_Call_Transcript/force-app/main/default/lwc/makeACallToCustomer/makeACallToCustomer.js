import {LightningElement, api, wire, track} from 'lwc';
import {CloseActionScreenEvent} from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';
import makeCall from '@salesforce/apex/vonageApiIntegration.makeOutboundCall';
import CASE_VONAGE_PHONE_FIELD from "@salesforce/schema/Case.ContactPhone";
import CASE_CONTACT_NAME_FIELD from "@salesforce/schema/Case.VonageCustomerName__c";
import CASE_NUMBER_FIELD from "@salesforce/schema/Case.CaseNumber";
import CASE_CALL_IN_PROGRESS_FIELD from "@salesforce/schema/Case.vonageCallToCustomerInProgress__c";
const FIELDS = [CASE_VONAGE_PHONE_FIELD,CASE_NUMBER_FIELD, CASE_CONTACT_NAME_FIELD,CASE_CALL_IN_PROGRESS_FIELD];
export default class MakeACallToCustomer extends LightningElement
{

    //Variables
    @track customerName;
    @track customerPhoneNumber;
    caseNumber;
    validationPassed = false;
    @api recordId;
    question = ''

    get options() {
        return [
            { label: 'Please provide more information about your problem', value: 'Please provide more information about your problem' },
            { label: 'What is reference number of you device', value: 'What is reference number of you device' },
            { label: 'Please describe what happened after device get broken', value: 'Please describe what happened after device get broken' },
            { label: 'Did you tried to restart your laptop?', value: 'Did you tried to restart your laptop' },
            { label: 'Did you already paid for product', value: 'Did you already paid for product' },
            { label: 'Are you satisfied with our service?', value: 'Are you satisfied with our service?' },
        ];
    }

    //cmp load actions
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    record({error,data})
    {
        if(data)
        {
            this.customerName = data.fields.VonageCustomerName__c.value;
            this.customerPhoneNumber = data.fields.ContactPhone.value;
            this.caseNumber = data.fields.CaseNumber.value;
            if(!data.fields.vonageCallToCustomerInProgress__c.value)
            {
                this.validationPassed = true;
            }
        }
        else if(error)
        {
            console.log('error: ', error);
        }
    };


    //cmp methods
    makeACall()
    {
        this.callToCustomer();
    }

    async callToCustomer()
    {
        try
        {
            await makeCall({ phoneNumber: this.customerPhoneNumber, caseNumber: this.caseNumber, question: this.question});
            this.closeQuickAction();
            // console.log(result);
        }
        catch (error)
        {
            this.closeQuickAction();
            console.error(error);
            console.log('its error')
        }
        finally
        {
        }
    }
    cancelAction()
    {
        this.closeQuickAction();
    }
    closeQuickAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    handleChange(event) {
        this.question = event.detail.value;
    }


}