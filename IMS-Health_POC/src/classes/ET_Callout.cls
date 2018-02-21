public class ET_Callout {
    
    public static void calloutSoap()
    {
        String uri = 'https://auth.exacttargetapis.com/v1/requestToken';
        String clientId = EncodingUtil.urlEncode('vbak76b6b3rsom530434zgty','UTF-8');
        String clientSecret = EncodingUtil.urlEncode('4iekC1njMTnVXUvXF8a1Hqrm','UTF-8');
        
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();      
        gen.writeStringField('clientId', clientId);
        gen.writeStringField('clientSecret',clientSecret);
        gen.writeEndObject();    
        String jsonS = gen.getAsString();
        System.debug('jsoninput'+jsonS);
        
        HttpRequest req= new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonS);
        req.setEndpoint(uri);
        req.setMethod('POST');
        
        Http h = new Http(); 
        HttpResponse hRes = h.send(req);
        system.debug(hres.getBody());
        system.debug(hres.getStatusCode());
        
        string accessTokenRes;
        JSONParser parser = JSON.createParser(hRes.getBody());  
        while (parser.nextToken() != null) {  
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'accessToken') {
                    accessTokenRes = parser.getText();
                    system.debug('accessToken Text() => ' + accessTokenRes);
                }
            }
        }
        
        
        exacttargetComWsdlPartnerapi.Soap soapRequest = new exacttargetComWsdlPartnerapi.Soap();
        exacttargetComWsdlPartnerapi.RetrieveRequest retrieveRequest = new exacttargetComWsdlPartnerapi.RetrieveRequest();
        
        exacttargetComWsdlPartnerapi.SimpleFilterPart filterPart = new exacttargetComWsdlPartnerapi.SimpleFilterPart();
        
        /*  retrieveRequest.ObjectType = 'DataExtension';
retrieveRequest.Properties = new String[]{'CustomerKey'};
filterPart.Property = 'CustomerKey';
filterPart.SimpleOperator = 'equals';
filterPart.Value = new String[]{'RLM Segment Members_0'};

retrieveRequest.Filter = filterPart; 
system.debug(retrieveRequest);*/
        retrieveRequest.ObjectType = 'DataExtensionObject[RLM Segment Members]';
        retrieveRequest.Properties = new String[]{'Name','Primary_Contact__c','Opportunity__c'};
            filterPart.Property = 'Name';
        filterPart.SimpleOperator = 'equals';
        filterPart.Value = new String[]{'SM-000102'};
            
            retrieveRequest.Filter = filterPart; 
        system.debug(retrieveRequest);
        
        exacttargetComWsdlPartnerapi.RetrieveResponseMsg_element response = soapRequest.Retrieve_x(retrieveRequest);
        system.debug('SOAP: '+response.Results[0].PartnerProperties.Property[0].Name);
        system.debug('SOAP: '+response.Results[0].PartnerProperties.Property[0].Value);
        system.debug('SOAP: '+response.Results[0].PartnerProperties.Property[1].Name);
        system.debug('SOAP: '+response.Results[0].PartnerProperties.Property[1].Value);
        system.debug('SOAP: '+response.Results[0].PartnerProperties.Property[2].Name);
        system.debug('SOAP: '+response.Results[0].PartnerProperties.Property[2].Value);
    }
    public static void calloutSoapUpdate()
    {
        exacttargetComWsdlPartnerapi.Soap soapRequest = new exacttargetComWsdlPartnerapi.Soap();
        exacttargetComWsdlPartnerapi.UpdateOptions uo = new exacttargetComWsdlPartnerapi.UpdateOptions() ;
        exacttargetComWsdlPartnerapi.APIObject[] Objects = new exacttargetComWsdlPartnerapi.APIObject[]{};
            uo.Action = 'UpdateAdd';
        exacttargetComWsdlPartnerapi.APIObject obj = new exacttargetComWsdlPartnerapi.APIObject();
        obj.Type='DataExtensionObject';
        obj.CustomerKey='RLM Segment Members_0';
        obj.PartnerProperties = new exacttargetComWsdlPartnerapi.Properties_element();
        obj.PartnerProperties.Property = new exacttargetComWsdlPartnerapi.APIProperty[]{};
            exacttargetComWsdlPartnerapi.APIProperty prop1= new exacttargetComWsdlPartnerapi.APIProperty();
        prop1.Name='Id';
        prop1.Value='a0f41000000UVx7 ';
        exacttargetComWsdlPartnerapi.APIProperty prop2= new exacttargetComWsdlPartnerapi.APIProperty();
        prop2.Name='a0f41000000UVx7 ';
        prop2.Value='Black';
        
        obj.PartnerProperties.Property.add(prop1);
        obj.PartnerProperties.Property.add(prop2);
        Objects.add(obj);
        
        
        
        exacttargetComWsdlPartnerapi.UpdateResponse_element response = soapRequest.Update_x(uo,Objects);
        system.debug('SOAP: '+response);
        system.debug(response.Results[0].StatusMessage);
        
    }
    public static void calloutSoapUpdateStatus()
    {
        exacttargetComWsdlPartnerapi.Soap soapRequest = new exacttargetComWsdlPartnerapi.Soap();
		exacttargetComWsdlPartnerapi.ExecuteRequest request= new exacttargetComWsdlPartnerapi.ExecuteRequest();
        request.Client = new exacttargetComWsdlPartnerapi.ClientID();
        request.Name='LogUnsubEvent';
        request.Parameters = new exacttargetComWsdlPartnerapi.APIProperty[4];
    request.Parameters[0] = new exacttargetComWsdlPartnerapi.APIProperty();
    request.Parameters[0].Name = 'SubscriberKey';
    request.Parameters[0].Value = 'rajni+BBTest@gmail.com';
    request.Parameters[1] = new exacttargetComWsdlPartnerapi.APIProperty();
    request.Parameters[1].Name = 'EmailAddress';
    request.Parameters[1].Value = 'rajni+BBTest@gmail.com';
    request.Parameters[2] = new exacttargetComWsdlPartnerapi.APIProperty();
    request.Parameters[2].Name = 'Reason';
    request.Parameters[2].Value = 'unknown';
    //request.Parameters[3] = new exacttargetComWsdlPartnerapi.APIProperty();
    //request.Parameters[3].Name = 'ListID';
    //request.Parameters[3].Value = '120334';
    request.Parameters[3] = new exacttargetComWsdlPartnerapi.APIProperty();
    request.Parameters[3].Name = 'ClientID';
    request.Parameters[3].Value = '7295383';
		
        exacttargetComWsdlPartnerapi.ExecuteRequest[] Requests= new exacttargetComWsdlPartnerapi.ExecuteRequest[]{};
            Requests.add(request);
        exacttargetComWsdlPartnerapi.ExecuteResponseMsg_element response= soapRequest.Execute(Requests);
        system.debug('SOAP: '+response);
        system.debug('SOAP: '+response.OverallStatus);
    }
    public static void calloutRESTUpdate()
    {
        String uri = 'https://auth.exacttargetapis.com/v1/requestToken';
        String clientId = EncodingUtil.urlEncode('vbak76b6b3rsom530434zgty','UTF-8');
        String clientSecret = EncodingUtil.urlEncode('4iekC1njMTnVXUvXF8a1Hqrm','UTF-8');
        
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();      
        gen.writeStringField('clientId', clientId);
        gen.writeStringField('clientSecret',clientSecret);
        gen.writeEndObject();    
        String jsonS = gen.getAsString();
        System.debug('jsoninput'+jsonS);
        
        HttpRequest req= new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonS);
        req.setEndpoint(uri);
        req.setMethod('POST');
        
        Http h = new Http(); 
        HttpResponse hRes = h.send(req);
        system.debug(hres.getBody());
        system.debug(hres.getStatusCode());
        
        string accessTokenRes;
        JSONParser parser = JSON.createParser(hRes.getBody());  
        while (parser.nextToken() != null) {  
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'accessToken') {
                    accessTokenRes = parser.getText();
                    system.debug('accessToken Text() => ' + accessTokenRes);
                }
            }
        }
        //REST POST Call
        //String uriPOST = 'https://www.exacttargetapis.com/hub/v1/dataevents/EBA65B5F-2337-4EAB-B070-E67CE78F398C/rows/rajanisingla@gmail.com';
        String uriPOST = 'https://www.exacttargetapis.com/hub/v1/dataevents/key:D507990D-C9DB-40FF-84E3-EADF083E2535/rowset';
        
        JSONGenerator genPOST = JSON.createGenerator(true);    
        genPOST.writeStartObject();
        genPOST.writeFieldName('keys');
        genPOST.writeStartObject();
        
        genPOST.writeStringField('Email', 'rajni@comitydesigns.com');
        
        genPOST.writeEndObject();
        genPOST.writeFieldName('values');
        genPOST.writeStartObject();
        
        genPOST.writeStringField('Name', 'rajniSingla');
        
        genPOST.writeEndObject();
        genPOST.writeEndObject();
        String jsonPOST = genPOST.getAsString();
        jsonPOST='['+jsonPOST+']';
        System.debug('jsoninput'+jsonPOST);
        
        
        //String jsonPOST ='[{"keys":{"Email": "someone@example.com"},"values":{"Name": "rajniS"}]';
        HttpRequest reqPOST= new HttpRequest();
        reqPOST.setHeader('Content-Type', 'application/json');
        reqPOST.setBody(jsonPOST);
        reqPOST.setEndpoint(uriPOST);
        reqPOST.setMethod('POST');
        //reqPOST.setHeader('Authorization', 'Bearer ' + accessTokenRes);
        
        Http hReq = new Http(); 
        HttpResponse resPost = hReq.send(reqPOST);
        system.debug(resPost.getBody());
        system.debug(resPost.getStatusCode());
        
    }
    public static void calloutRESTInsertContact()
    {
        String uri = 'https://auth.exacttargetapis.com/v1/requestToken';
        String clientId = EncodingUtil.urlEncode('qy73rdrnux2h3ayiyy7qsqxm','UTF-8');
        String clientSecret = EncodingUtil.urlEncode('zwLGeLLRQiF9elQDUIof5mmi','UTF-8');
        
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();      
        gen.writeStringField('clientId', clientId);
        gen.writeStringField('clientSecret',clientSecret);
        gen.writeEndObject();    
        String jsonS = gen.getAsString();
        System.debug('jsoninput'+jsonS);
        
        HttpRequest req= new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonS);
        req.setEndpoint(uri);
        req.setMethod('POST');
        
        Http h = new Http(); 
        HttpResponse hRes = h.send(req);
        system.debug(hres.getBody());
        system.debug(hres.getStatusCode());
        
        string accessTokenRes;
        JSONParser parser = JSON.createParser(hRes.getBody());  
        while (parser.nextToken() != null) {  
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'accessToken') {
                    accessTokenRes = parser.getText();
                    system.debug('accessToken Text() => ' + accessTokenRes);
                }
            }
        }
        //REST POST Call
        //String uriPOST = 'https://www.exacttargetapis.com/hub/v1/dataevents/EBA65B5F-2337-4EAB-B070-E67CE78F398C/rows/rajanisingla@gmail.com';
        String uriPOST = 'https://www.exacttargetapis.com/contacts/v1/contacts';
        
        JSONGenerator genPOST = JSON.createGenerator(true);    
        genPOST.writeStartObject();
        genPOST.writeStringField('contactKey', 'rajni+BBTest1@comitydesigns.com');
        genPOST.writeFieldName('attributeSets');
        genPOST.writeStartArray();
        genPOST.writeStartObject();
        genPOST.writeStringField('name', 'Email Addresses');
        genPOST.writeFieldName('items');
        
        genPOST.writeStartArray();
        genPOST.writeStartObject();
        genPOST.writeFieldName('values');
        genPOST.writeStartArray();
        
        genPOST.writeStartObject();
        
        genPOST.writeStringField('name', 'Email Address');
        genPOST.writeStringField('value', 'rajni+BBTest1@comitydesigns.com');
        genPOST.writeEndObject();
        genPOST.writeStartObject();
        
        genPOST.writeStringField('name', 'HTML Enabled');
        genPOST.writeStringField('value', 'true');
        genPOST.writeEndObject();
        genPOST.writeEndArray();
         genPOST.writeEndObject();
        genPOST.writeEndArray();
         genPOST.writeEndObject();
        genPOST.writeEndArray();
        genPOST.writeEndObject();
        String jsonPOST = genPOST.getAsString();
        //jsonPOST='['+jsonPOST+']';
        System.debug('jsoninput'+jsonPOST);
        
        
        //String jsonPOST ='[{"keys":{"Email": "someone@example.com"},"values":{"Name": "rajniS"}]';
        HttpRequest reqPOST= new HttpRequest();
        reqPOST.setHeader('Content-Type', 'application/json');
        reqPOST.setBody(jsonPOST);
        reqPOST.setEndpoint(uriPOST);
        reqPOST.setMethod('POST');
        reqPOST.setHeader('Authorization', 'Bearer ' + accessTokenRes);
        
        Http hReq = new Http(); 
        HttpResponse resPost = hReq.send(reqPOST);
        system.debug(resPost.getBody());
        system.debug(resPost.getStatusCode());
        
        postCall(accessTokenRes);
    }
    
    private static void postCall(string accessTokenRes)
    {
        String uriPOST = 'https://www.exacttargetapis.com/hub/v1/dataevents/key:C5953F96-D257-48F0-AC17-1B1FEE034AC0/rowset';
        
        JSONGenerator genPOST = JSON.createGenerator(true);    
        genPOST.writeStartObject();
        genPOST.writeFieldName('keys');
        genPOST.writeStartObject();
        
        genPOST.writeStringField('Email', 'rajni+BBTest1@comitydesigns.com');
        
        genPOST.writeEndObject();
        genPOST.writeFieldName('values');
        genPOST.writeStartObject();
        
        genPOST.writeStringField('Name', 'testingcoding');
        
        genPOST.writeEndObject();
        genPOST.writeEndObject();
        String jsonPOST = genPOST.getAsString();
        jsonPOST='['+jsonPOST+']';
        System.debug('jsoninput'+jsonPOST);
        
        
        //String jsonPOST ='[{"keys":{"Email": "someone@example.com"},"values":{"Name": "rajniS"}]';
        HttpRequest reqPOST= new HttpRequest();
        reqPOST.setHeader('Content-Type', 'application/json');
        reqPOST.setBody(jsonPOST);
        reqPOST.setEndpoint(uriPOST);
        reqPOST.setMethod('POST');
        reqPOST.setHeader('Authorization', 'Bearer ' + accessTokenRes);
        
        Http hReq = new Http(); 
        HttpResponse resPost = hReq.send(reqPOST);
        system.debug(resPost.getBody());
        system.debug(resPost.getStatusCode());
    }
}