/**
 * Created by Szymon on 28/11/2023.
 */
@RestResource(urlMapping='/v1/VonageService/*')
global with sharing class VonageWebService
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