public class VonageConversationApi {

    private static final String CONVERSATION_API_ENDPOINT = 'https://api.nexmo.com/v0.3/conversations';
    private static final String JWT_TOKEN = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbl9pZCI6IjVhNmZmMTc1LTA3ZGUtNDc2NS05MTdmLTIxMWYwMGY5ZjcyNiIsImlhdCI6MTcwMTM3NjU2NywianRpIjoiMzgxZGI5YWItMDcyYi00YWMyLWIxZWEtMjU3MWUzMGIxODNjIiwiZXhwIjoxNzAxMzc3NDY3fQ.cHuaaAPqB3qqas_ki8ij2PIb9zacsJ6TmHWeQWW99b5YOqtLrhrQKLHXsgbgOOlb2RIaJ0az-qiOYPuwIxtH3z8Xndrmp8IExf25OHm1m4zhlmEFM26St6GOOhijoRJpH2HqFFT5Jo4LVac52po5KDw6uEgSlgrWWLcYEUmjSH3oEYm6ZV-q7d-lnTIHoe2K0TAF7qQEw80U3saH1Oyl3niLJ9Ma2EmWnlC_ziDmVprBTnALFKEwM91WX9W6SjHeHMVgCVCPwW6dtUjcMjE8jJfVSg7zOft50tby2_hhrewwrqKhRJHaxNDiEjIYhbXXZ83SC26m6kfOWBRhxZQ4yQ'; 

    @AuraEnabled(cacheable=true)
    public static String createConversation(String caseRecordId) {
        Vonage_Integration_Data__mdt meta = VonageAuthorizationHelper.getVonageMainAppMetadataInfo();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CONVERSATION_API_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + meta.JWT_token__c);

        String requestBody = '{"display_name": "' + caseRecordId + '"}';
        req.setBody(requestBody);

        System.debug('Request body: ' + requestBody);

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(req);

        if (res.getStatusCode() == 201) {
            System.debug('conversation created successfully: ' + res.getBody());
            return res.getBody();
        } else {
            System.debug('error creating conversation: ' + res.getStatusCode());
            System.debug('response: ' + res.getBody());
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static String updateConversation(String conversationId,  String additionalProperty1) {
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CONVERSATION_API_ENDPOINT + '/' + conversationId);
        req.setMethod('PUT');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + JWT_TOKEN);
    
        String requestBody = '{ "properties": { "ttl": 60, "type": "string", "custom_data": { "property1": "' + additionalProperty1 + '" }}}';
        req.setBody(requestBody);
    
        System.debug('request Body: ' + requestBody);
    
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(req);
    
        if (res.getStatusCode() == 200) {
            System.debug('conversation updated successfully: ' + res.getBody());
            return res.getBody();
        } else {
            System.debug('error updating conversation: ' + res.getStatusCode());
            System.debug('response: ' + res.getBody());
            return null; 
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getConversationById(String conversationId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CONVERSATION_API_ENDPOINT + '/' + conversationId);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + JWT_TOKEN);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            System.debug('conversation retrieved successfully: ' + res.getBody());
            return res.getBody();
        } else {
            System.debug('error retrieving conversation: ' + res.getStatusCode());
            System.debug('response: ' + res.getBody());
            return null;
        }
    }


}