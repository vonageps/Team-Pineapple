/**
 * Created by Szymon on 01/12/2023.
 */
@RestResource(urlMapping='/v2/VonageService/*')
global with sharing class WebService2
{
    @HttpPost
    global static String doPost()
    {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String requestBody = req.requestBody.toString();
        return VonageWebServiceHelper.processRequest(requestBody);
    }
}