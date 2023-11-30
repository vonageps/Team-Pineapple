public class VonageAuthorizationHelper {

    private static final String API_AUTHORIZATION_ENDPOINT = 'https://api.nexmo.com/v2/verify';
    private static final String JWT_TOKEN = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE3MDEzNDI1ODcsImV4cCI6MTcwMTUxNTM4NywianRpIjoiRWQ5NEhUV2RKM1JEIiwiYXBwbGljYXRpb25faWQiOiIwNmU2MTQzYS1jN2YxLTRjMjYtOWMzNy1iNTgzM2RkNWRiYzUiLCJzdWIiOiIiLCJhY2wiOiIifQ.WtzNrFsEKktw92FkOjkGcUsgpgmfleUyVY6CeZSH33edIiPt2ytMIbKcMjjDpo7sW32iWUc2TCubt1D-vDA36Bhl_O7gkWdJH3qm4zMpKm1mEjgXyYuGFn5yCUlZ3WVnXMQ3yR_mxXG4JzHdG9ArHxHSOIQh5594dGcIz3ldEdzyp_uvg0K-uFZzEyQR5FPD_SgrmdJH3PE_h-JybsB2EZIfG9NgPhuRywNfQDD9TPQ2hraU-4rpD7Ll4fsP5l3QGzA4dxNTEydIrfnVR6YLHrt_ed0CmoNJIo7mi89NhUBOUZlaerJiSjNPojxL-jLxuXVRRTsJNxkUmeujGWYzKw'; 
    private static final String FROM_NUMBER = '48459050204';  
    private static final String TO_NUMBER = '48459050203';  
    private static final String VONAGE_API_KEY = '6d32af05';
    private static final String VONAGE_API_SECRET = 'iGW2pRcmefNf1shT';

    @AuraEnabled(cacheable=true)
    public static String initiateVerification(String phoneNumber) {
        System.debug('TEST: initiateVerification' + phoneNumber);
        if (String.isblank(phoneNumber)) {
            return null;
        }

        String verificationCode = generateRandomCode();
        String body = '{"brand" : "PineApple INC", "code": "' + verificationCode + '", "workflow": [{"channel": "voice","to": "' + phoneNumber + '"}, {"channel": "email","to": "adamredlinski@gmail.com"}]}';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(API_AUTHORIZATION_ENDPOINT);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + JWT_TOKEN);
        request.setBody(body);

        System.debug('TEST: request' + request);
        System.debug('TEST: request.body' + request.getBody());

        HttpResponse response = new Http().send(request);
        System.debug('TEST: response' + response);

        if (response.getStatusCode() == 202) {
            System.debug('TEST: response' + response);

            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            return (String) results.get('request_id');
        } else {
            System.debug('Verification initiation failed. Response: ' + response.getBody());
            return null;
        }
    }

        @AuraEnabled(cacheable=true)
        public static String checkVerificationCallStatus(String requestId, String providedCode) {
            if (String.isBlank(requestId) || String.isBlank(providedCode)) {
                return 'Missing parameters. Provided code: ' + providedCode + ' requestId ' + requestId;
            }
            
            String body = '{"code" : "' + providedCode + '"}';
    
            HttpRequest request = new HttpRequest();
            request.setEndpoint(API_AUTHORIZATION_ENDPOINT + '/' + requestId);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + JWT_TOKEN);
            request.setBody(body);
    
            System.debug('TEST: request' + request);
            System.debug('TEST: request.body' + request.getBody());
    
            HttpResponse response = new Http().send(request);
            System.debug('TEST: response' + response);
    
            if (response.getStatusCode() == 202) {
                System.debug('Verification  successfull');
                return 'Success';
            } else {
                System.debug('Verification failed. Response: ' + response.getBody());
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                System.debug('TEST: results' + results);

            return (String) results.get('status');            }
        }

    private static String generateRandomCode() {
        Integer randomCode = Integer.valueOf(Math.floor(Math.random() * 9000) + 1000);
        return String.valueOf(randomCode);
    }
    
}