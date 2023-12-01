import { LightningElement, wire, api, track } from 'lwc';
import createConversation from '@salesforce/apex/VonageConversationApi.createConversation';
import updateConversation from '@salesforce/apex/VonageConversationApi.updateConversation';
import getConversationById from '@salesforce/apex/VonageConversationApi.getConversationById';

export default class ChatComponent extends LightningElement {
    @api recordId;
    @track _data;
    @track newMessage = '';
    @track _conversationData;
    @track conversationDetails;
    @track conversationMessages = [];
    @track messages = [];
    
    
    showButton = true;
    showChat = false;

    get conversationData() {
        return this?._conversationData;
    }

    set conversationData(value) {
        this._conversationData = JSON.parse(value);
    }

    get data() {
        return this?._data;
    }

    set data(value) {
        this._data = JSON.parse(value);
    }

    removeProxies(obj) {
        return JSON.parse(JSON.stringify(obj));
    }

    handleInputChange(event) {
        this.newMessage = event.target.value;
    }

    startChat() {
      this.handleCreateConversation();
    }

    sendMessage() {
        try {
            const messageId = this.messages.length + 1;
    
            this.messages.push({
                id: messageId,
                text: this.newMessage
            });
    
            this.updateConversationDetails().then(() => {
                this.retrieveConversationDetails();
            });
    
            this.messages.forEach((element) => {
                console.log(element);
            });
    
            this.newMessage = '';
        } catch (error) {
            console.error('error in sendMessage:', error);
        }
    }


    async handleCreateConversation() {
        try {
            const result = await createConversation({ caseRecordId: `${this.recordId}` });
            console.log('createConversation' + result);
            this.data = result;
            this.showButton = false;
            this.showChat = true;
          
        } catch (error) {
            console.error('error ', error);
        }
    }

    async updateConversationDetails() {
        try {
            const additionalProperties = this.messages.map((message) => ({
                id: message.id,
                text: message.text
            }));
    
            const result = await updateConversation({
                conversationId: this?._data?.id,
                additionalProperties: additionalProperties
            });
    
            console.log('updateConversationDetails' + result);
          
        } catch (error) {
            console.error('error in updateConversationDetails:', error);
        }
    }

    async retrieveConversationDetails() {
        try {
            const result = await getConversationById({ conversationId: this?._data?.id });
            const data= JSON.parse(result)
            console.log(data.properties.custom_data)
            const message = data.properties.custom_data;
            this.conversationMessages.push(message)
    
        } catch (error) {
            console.error('error in retrieveConversationDetails:', error);
        }
    }
}