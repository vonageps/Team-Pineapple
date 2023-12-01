/**
 * Created by Tomasz
 */

public class vonageApiIntegration {

    //private static final String API_ENDPOINT = 'https://api.nexmo.com/v1/calls';
    //private static final String JWT_TOKEN = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbl9pZCI6IjVhNmZmMTc1LTA3ZGUtNDc2NS05MTdmLTIxMWYwMGY5ZjcyNiIsImlhdCI6MTcwMTQyMTI2OSwianRpIjoiYTU2ZTcyYWItMDQzZS00MDlmLThkZTctYmI0NjlmMWI0NjhkIiwiZXhwIjoxNzAxNDIyMTY5fQ.hc9HdhTRV7wp16r0sW7C6rme1Ue0pLXpll0IrYBmfMgFh9Nv3CTblq_Jl306HtpUNfdl4plSE_Bag-cXOT31oTrinf5LtDHtpeY04nWM3HaHwC_WV1sy7nhKBXJC4nmOngRZuGFnxnaV7u37zQPAAYZHiOgeNHWOV-qWPWKlBW3DIRTY1NcywOBMn-BI_oGGvvMo0c8bEOXIyNafJgi8BQMQXzGzKK3_L01_LIsDujOeE8nwkM_AyW99FczfwWxd5d46EdNkfzUNeVbf0nrZd05s3BXQ3LFXTPlc_Ska_CANpEOHxTvfDyAHlJ1bJmAX-LKA9d2mPP38SafDxrZYFQ';
    private static final String FROM_NUMBER = '447441443825';  
    private static final String TO_NUMBER = '48577370998';  


    @AuraEnabled
    public static void makeOutboundCall(String phoneNumber,String caseNumber, String question) {
        Vonage_Integration_Data__mdt meta = VonageAuthorizationHelper.getVonageMainAppMetadataInfo();
        System.debug('JWT Token: ' + meta.JWT_token__c);
        System.debug('API Endpoint: ' + meta.Vonage_calls_API_endpoint__c);
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(meta.Vonage_calls_API_endpoint__c);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + meta.JWT_token__c);
    
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
        Vonage_Integration_Data__mdt meta = VonageAuthorizationHelper.getVonageMainAppMetadataInfo();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(meta.Vonage_calls_API_endpoint__c + callUUID);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + meta.JWT_token__c);
    
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