@RestResource(urlMapping='/ET_RestCallout/*')
global with sharing class ET_RestCallout {
    
    /*@HttpGet
    global static void getQuestionById() {
        RestRequest request = RestContext.request;
        String questionId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        QuestionData__c result =  [SELECT Id,Name
                                   FROM QuestionData__c
                                   WHERE Name = :questionId];
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();
        gen.writeStringField('name', result.Name);
        gen.writeEndObject();
        String retVal;
        retVal = gen.getAsString();
        system.debug('Rest Request: ' + RestContext.request);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(retVal);
    }*/
    
    @HttpGet
    global static void getPrefData() {
        Datetime x =  Datetime.now();
		Integer m = x.millisecond();
        system.debug(m);
        RestRequest request = RestContext.request;
        /*QuestionData__c result =  [SELECT Id,Name
                                   FROM QuestionData__c
                                   WHERE Name = 'Q-000001'];*/
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();
        gen.writeStringField('name', 'test2');
        gen.writeEndObject();
        String retVal;
        retVal = gen.getAsString();
        system.debug('Rest Request: ' + RestContext.request);
        ET_Callout.calloutRESTUpdate();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(retVal);
       Datetime x1 =  Datetime.now();
		Integer m1 = x1.millisecond();
        system.debug(m1);
    }
}