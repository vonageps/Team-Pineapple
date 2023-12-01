public with sharing class VonageCaseController {
    @AuraEnabled
    public static Id createCase(String subject, String description) {
        Case newCase = new Case();
        newCase.Subject = subject;
        newCase.Description = description;
        insert newCase;

        return newCase.Id;
    }
}