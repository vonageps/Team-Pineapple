/**
 * Created by Tomasz
 */

public class vonageApiIntegration {
    private static final String API_ENDPOINT = 'https://api.nexmo.com/v1/calls';
    private static final String JWT_TOKEN = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbl9pZCI6IjVhNmZmMTc1LTA3ZGUtNDc2NS05MTdmLTIxMWYwMGY5ZjcyNiIsImlhdCI6MTcwMTM3NzkwMiwianRpIjoiZjYyNTUxZjEtZWUyYS00ZDUxLThmNWItNTA2NjE4NGUxMTU0IiwiZXhwIjoxNzAxMzc4ODAyfQ.gEWFxgCvAlYD4ioeNhVahRJkuBfcMPSk4FLZVevUZSrEt5OHpz2XsGFRUKad6mcrGzwHdX80K-gzo9gQVghcIc8QIDZQRlsMwnfJZS5f_9H0Xbv67oL2DD_zKmczwzqJ3N063Hy85fqIksquPnyNccQX0PvOKA6ZcMZKACPr6tiEMHrXu90MWGkAgT68E8QPjWLgth570mhMiZ5w8USw4ZNuHvs5NVw_I1erdoMc6gSJoMxKbxwgSEyrMzxvuM68HQqJRY2qrDksbfs-atz0lnbCw8hEeigP2WUxCCGAos9v9k1G1SBr3tCgJBotmwU5_MxWaLDdkWpYBmDvsjEeog';
    private static final String FROM_NUMBER = '447441443825';  
    private static final String TO_NUMBER = '48577370998';  


    @AuraEnabled
    public static void makeOutboundCall(String phoneNumber,String caseNumber, String question) {
        System.debug('JWT Token: ' + JWT_TOKEN);
        System.debug('API Endpoint: ' + API_ENDPOINT);
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(API_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + JWT_TOKEN);
    
        String ncco = '[ { "action": "talk", "text": "Hello!" }, { "action": "talk", "text": "'+ question +'", "bargeIn": true }, { "eventUrl": [ "https://webhook.site/e5c6076d-5ef1-449b-809d-3b6c3c408631"], "eventMethod": "POST", "action": "input", "type": [ "speech" ], "speech": { "language": "en-gb", "context": [ "support", "buy", "credit", "account" ], "endOnSilence": 0.5, "saveAudio": true, "sensitivity": "90" } } ]';
        String requestBody = '{"to": [{"type": "phone", "number": "' + phoneNumber + '"}], "from": {"type": "phone", "number": "' + FROM_NUMBER + '"}, "ncco": ' + ncco + '}';
        req.setBody(requestBody);
        
        System.debug('Request Body: ' + requestBody);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(req);

        if (res.getStatusCode() == 201){

            Case cs = VonageCaseSelector.selectCaseById(caseNumber);

            Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            cs.VonageCurrentUUID__c = resMap.get('uuid').toString();
            cs.vonageCallToCustomerInProgress__c = true;
            update cs;
            System.debug('Successfully initiated.');
        } else {
            System.debug('Error : ' + res.getStatusCode());
            System.debug('Response: ' + res.getBody());
        }
    }

    public static void getCallStatus(String callUUID) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.nexmo.com/v1/calls/' + callUUID);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + JWT_TOKEN);
    
        Http http = new Http();
        HttpResponse res = http.send(req);
    
        if (res.getStatusCode() == 200) {
            System.debug('Call Status Response: ' + res.getBody());
        } else {
            System.debug('Error getting call status: ' + res.getStatusCode());
            System.debug('Response: ' + res.getBody());
        }
    }
    
}