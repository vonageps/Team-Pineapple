public with sharing class VonageCaseController {
    @AuraEnabled
    public static Id createCase(String subject, String description, String phoneNumber) {
        User currentUser = [SELECT Id, ContactId, AccountId, MobilePhone FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Id accountId = currentUser.AccountId;
        Id contactId = currentUser.ContactId;

        Case newCase = new Case(
            Subject = subject,
            Description = description,
            AccountId = accountId,
            ContactId = contactId,
            PhoneNumberVonage__c = currentUser.MobilePhone
        );

        insert newCase;

        return newCase.Id;
    }

    @AuraEnabled(cacheable=true)
    public static String getCurrentUserId() {
        return UserInfo.getUserId();
    }
}