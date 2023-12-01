public class vonageNaturalLanguageAPI {
    private static String API_KEY = 'AIzaSyDbPWrRqsHEhedeLtkpcZZF6Yk08B-ldT8';  

    public class SentimentResult {
        public Double score { get; set; }
        public Double magnitude { get; set; }
    }

    public static SentimentResult analyzeSentiment(String text) {
        String API_URL = 'https://language.googleapis.com/v1/documents:analyzeSentiment?key=' + API_KEY;
        String sentimentAnalysisResult = makeApiRequest(API_URL, text);

        if (sentimentAnalysisResult != null) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(sentimentAnalysisResult);
            Map<String, Object> sentimentMap = (Map<String, Object>) result.get('documentSentiment');
            
            SentimentResult sentimentResult = new SentimentResult();
            sentimentResult.score = (Double) sentimentMap.get('score');
            sentimentResult.magnitude = (Double) sentimentMap.get('magnitude');
            
            return sentimentResult;
        } else {
            return null;
        }
    }

    @future(callout=true)
    public static void analyzeSentimentAsync(String text, Id callId) {
        SentimentResult sentimentResult = analyzeSentiment(text);

        if (sentimentResult != null) {
            VonageCall__c callToUpdate = new VonageCall__c(Id = callId, Evaluation__c = String.valueOf(sentimentResult.score));
            update callToUpdate;
        }
    }

    private static String makeApiRequest(String apiUrl, String text) {
        String requestBody = '{"document": {"content": "' + text + '", "type": "PLAIN_TEXT"}}';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(requestBody);

        HttpResponse response = new Http().send(request);

        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            System.debug('Error Response: ' + response.getBody());
            return null;
        }
    }
}