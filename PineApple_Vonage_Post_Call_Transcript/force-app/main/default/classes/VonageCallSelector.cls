public with sharing class VonageCallSelector {
    public static VonageCall__c selectCallsById(Id callId){
        return selectMultipleCallsByIds(new Set<Id>{callId})[0]; 
    }
    public static List<VonageCall__c> selectMultipleCallsByIds(Set<Id> callIds){
        return [SELECT Id, Evaluation__c, Transcript__c, Full_Transcript__c, UUID__c, Case__c, Case__r.CaseNumber, Case__r.Subject, Case__r.Type, Case__r.ContactPhone, Case__r.Description FROM VonageCall__c WHERE Id IN : callIds]; 
    }
    public static List<VonageCall__c> selectMultipleCallsByIds(List<Id> callIds){
        return [SELECT Id, Evaluation__c, Transcript__c, Full_Transcript__c, UUID__c, Case__c, Case__r.CaseNumber, Case__r.Subject, Case__r.Type, Case__r.ContactPhone, Case__r.Description FROM VonageCall__c WHERE Id IN : callIds]; 
    }
}