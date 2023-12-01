public inherited sharing class VonageCaseSelector {
    public static Case selectCaseById(String caseNumber){
        return selectMultipleCasesByIds(new Set<String>{caseNumber})[0];
    }
    public static List<Case> selectMultipleCasesByIds(Set<String> caseNumbers){
        return [SELECT Id, vonageCallToCustomerInProgress__c, VonageCurrentUUID__c FROM Case WHERE CaseNumber IN : caseNumbers];
    }
}