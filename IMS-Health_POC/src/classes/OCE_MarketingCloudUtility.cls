/**
 * Created Date		: Nov 29, 2016
 * Developed By		: Scott Warren, Comity Designs, Inc.
 *
 * Function			: @description - Provides functionality to interact with Salesforce Marketing Cloud
 * Support Email 	: scott@comitydesigns.com
 * Version			: 1.0
 *
 * Modification Log
 *
 * Developer Name			User Story				Date			Version 			Description
 *____________________________________________________________________________________________________
 *
 * Scott Warren				POC-				Nov 29, 2016			1.1				@description - Initial Commit
 *
 */
public with sharing class OCE_MarketingCloudUtility {

	public static Marketing_Cloud_App_Credentials__c mcCreds;
	public static String apiToken;
	
    /**
	 * @description 		Authenticates with Marketing Cloud app
     * @return 				A description of the return value from the method
     * @example 			Example code usage. This will be wrapped in tags to preserve whitespace
     */
	public static void login(){
		// Get the API Token required for REST service
		if(String.isEmpty(apiToken)){
			// Get the Client ID and Client Secret for our Marketing Cloud App
			if(mcCreds == null){
				mcCreds = Marketing_Cloud_App_Credentials__c.getInstance();
			}
			
			// Create HTTP Request for callout
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint(mcCreds.Auth_Endpoint__c);
			request.setMethod(OCE_Constants.REST_POST);
			request.setHeader(OCE_Constants.REST_CONTENT_TYPE, OCE_Constants.REST_APPLICATION_JSON);
			
            // Populate the Auth Request Wrapper variables
            AuthRequestWrapper arw = new AuthRequestWrapper();
            arw.clientId = mcCreds.Client_Id__c;
            arw.clientSecret = mcCreds.Client_Secret__c;
            String authBody = json.serialize(arw);
            
			// Set JSON Body
			request.setBody(authBody);
			
			// Get HTTP Response
			HttpResponse response = http.send(request);
			
			// Parse the JSON response
			System.debug(response.getBody());
            
            JSONParser parser = JSON.createParser(response.getBody());
			while (parser.nextToken() != null) {
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == OCE_Constants.MC_ACCESS_TOKEN)){
                    parser.nextToken();
                    apiToken = parser.getText();
            	}                			
            }
		}
	}

    /**
	 * @description 		Retrieves a list of journeys from Marketing Cloud
     * @return 				List of Journey Wrappers for display purposes
     */
	public static void getJourneys(){
		// Be sure we have a token for Marketing Cloud App
        login();
		System.debug(apiToken);

		// Create HTTP Request for callout
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(mcCreds.General_Endpoint__c + OCE_Constants.MC_INTERACTIONS_URL);
        request.setMethod(OCE_Constants.REST_GET);
        request.setHeader(OCE_Constants.REST_CONTENT_TYPE, OCE_Constants.REST_APPLICATION_JSON);
        request.setHeader(OCE_Constants.REST_AUTHORIZATION, OCE_Constants.REST_BEARER + apiToken);

        // Get HTTP Response
        HttpResponse response = http.send(request);
        
        // @TODO - remove debug
        System.debug(request.getBody());
        System.debug(response.getBody());

        List<JourneyItemWrapper> journeyItems = new List<JourneyItemWrapper>();
        
        // Parse the JSON response
		JSONParser parser = JSON.createParser(response.getBody());   
        while (parser.nextToken() != null) {
	        if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == OCE_Constants.MC_ITEMS)){
                parser.nextToken();
                while (parser.nextToken() != null) {
                    JourneyItemWrapper item = (JourneyItemWrapper)parser.readValueAs(JourneyItemWrapper.class);
                    journeyItems.add(item);
                }
            }
        }
        
        // @TODO - remove debug        
        System.debug(journeyItems);
        
	}
	
    public class AuthRequestWrapper{
        public String clientId {get;set;}
        public String clientSecret {get;set;}
    }	
    
    public class JourneyItemWrapper{
        public String id;
        public String name;
        public DateTime lastPublishedDate;
        public String description;
        public String version;
        public String workflowApiVersion;
        public DateTime createdDate;
        public DateTime modifiedDate;
        public String status;
        public String entryMode;
        public String executionMode;
        public String key;
        public String definitionId;
    }
    
    
    
    
    
    
}