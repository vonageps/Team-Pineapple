public with sharing class VonageWebServiceHelper
{
    public static String processRequest(String requestBody)
    {
        responseWrapper resp;
        //Process Request, split parameters

        System.debug(requestBody);
        Map<String,Object> reqBodyMap = (Map<String,Object>)JSON.deserializeUntyped(requestBody);
        //set uuid
        String uuid = reqBodyMap.get('uuid').toString();
        //get speach
        Map<String,Object> speachMap = (Map<String,Object>)reqBodyMap.get('speech');
        List<Object> resultArray = (List<Object>)speachMap.get('results');
        if(resultArray.size()>0)
        {
            //find Case and set proper values for technical fields
            Case cs = [
                    SELECT
                            Id
                            ,VonageCurrentUUID__c
                            ,vonageCallToCustomerInProgress__c
                    FROM
                            Case
                    WHERE
                            vonageCallToCustomerInProgress__c = TRUE
                            AND
                            VonageCurrentUUID__c = :uuid
            ];
            cs.VonageCurrentUUID__c = '';
            cs.vonageCallToCustomerInProgress__c = false;

            //create VC record which store data about current call
            Map<String, Object> firstRecord = (Map<String,Object>)resultArray[0];
            VonageCall__c vcRecord = new VonageCall__c(
                    Case__c = cs.Id
                    ,Transcript__c = firstRecord.get('text').toString()
                    ,UUID__c = uuid
            );
            for(Object rsObj : resultArray)
            {
                Map<String, Object> tempRec = (Map<String,Object>)rsObj;
                vcRecord.Full_Transcript__c += tempRec.get('text').toString()+'       ';
            }

            //update case record and insert VC record
            update cs;
            insert vcRecord;

            resp = new responseWrapper('success','Its ok',200);

        }
        else
        {
            resp = new responseWrapper('error','Something went wrong, no transcript in payload',200);
        }
        String response = resp.toString();
        return response;
    }

    public class responseWrapper
    {
        String status;
        String message;
        Integer statusCode;
        responseWrapper(String status, String msg, Integer statCode)
        {
            this.status = status;
            this.message = msg;
            this.statusCode = statCode;
        }
    }
}