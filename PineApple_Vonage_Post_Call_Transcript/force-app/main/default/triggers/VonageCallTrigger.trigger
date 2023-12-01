trigger VonageCallTrigger on VonageCall__c (after insert, after update) {
    List<VonageCall__c> callsToUpdate = new List<VonageCall__c>();
    
    for (VonageCall__c call : Trigger.new) {
        if (Trigger.isInsert || (Trigger.isUpdate && call.Transcript__c != Trigger.oldMap.get(call.Id).Transcript__c)) {
            callsToUpdate.add(call);
        }
    }

    if (!callsToUpdate.isEmpty()) {
        for (VonageCall__c call : callsToUpdate) {
            vonageNaturalLanguageAPI.analyzeSentimentAsync(call.Transcript__c, call.Id);
        }
    }
}