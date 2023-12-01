@RestResource(urlMapping='/Authorize/*')
global with sharing class VonageAuthorizationWebservice{
  
  @HttpPost
    global static String doAuthorization(String name) {
        return '';
    }
}