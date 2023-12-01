public with sharing class VonageMessageApiIntegration {
    
    private static final String API_ENDPOINT = 'https://rest.nexmo.com/sms/json';  

    @InvocableMethod(label='Vonage Send SMS Summary' description='Send sms summary to customer after call' category='Call')
    public static void sendSummaryMessage(List<Id> callIds){
        List<VonageCall__c> callRecords = VonageCallSelector.selectMultipleCallsByIds(callIds);
        for(VonageCall__c c: callRecords){
            String message = createSummaryMessage(c);
            createMessageHTTPRequest('Vonage APIs', c.Case__r.ContactPhone, message);
        }
    }

    @Future(callout=true)
    public static void createMessageHTTPRequest(String fromMessage, String toMessage, String message){
        Vonage_Integration_Data__mdt meta = VonageAuthorizationHelper.getVonageMainAppMetadataInfo();
  System.debug('API Endpoint: ' + meta.Sms_endpoint__c);
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(meta.Sms_endpoint__c);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    
        String requestBody = 'from=' + fromMessage + '&text=' + message + '&to=' + toMessage + '&api_key=' + meta.Api_Key__c + '&api_secret=' + meta.Vonage_Api_Secret__c;
        req.setBody(requestBody);
        
        System.debug('Request Body: ' + requestBody);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(req);
    
        if (res.getStatusCode() == 200) {
            System.debug('Successfully send.');
        } else {
            System.debug('Error : ' + res.getStatusCode());
            System.debug('Response: ' + res.getBody());
        }
    }
    
    public static string createSummaryMessage(VonageCall__c selectedCall){
        String summaryMessage = 
        'Summary for your call about case with number: ' + selectedCall.Case__r.CaseNumber + 
        '%0A%0ASubject: ' + selectedCall.Case__r.Subject +
        '%0A%0ACall transcript: ' + selectedCall.Transcript__c +
        '%0A%0AProblem type: ' + selectedCall.Case__r.Type + 
        '%0A%0AProblem description: ' + selectedCall.Case__r.Description +
        '%0A%0ALink to your case: ' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+selectedCall.Case__c;
        return summaryMessage;
    }
}