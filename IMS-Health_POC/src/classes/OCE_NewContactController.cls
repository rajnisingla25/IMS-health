/**
 * Created Date		: Nov 28, 2016
 * Developed By		: Scott Warren, Comity Designs, Inc.
 *
 * Function			: @description - Controller for overriden New Contact action's Visualforce page
 * Support Email 	: scott@comitydesigns.com
 * Version			: 1.0
 *
 * Modification Log
 *
 * Developer Name			User Story				Date			Version 			Description
 *____________________________________________________________________________________________________
 *
 * Scott Warren				POC-				Nov 28, 2016			1.1				@description - Initial Commit
 *
 */
public with sharing class OCE_NewContactController {
    private ApexPages.StandardController c;
    
    // HCP Name to search
    public static String searchString {get;set;}
    
    // List of HCP contact records to be returned from a search
    public static List<Contact> hcpContacts {get;set;}
    
    // Boolean value to determine whether a search has been performed
    public static Boolean ranSearch {get;set;}

    public OCE_NewContactController(ApexPages.StandardController stdController){
        c = stdController;
    }
    
    /**
	 * @description				Search for the name of an HCP and return the results
     * @return					List of contact records
     */	    
    public PageReference searchHCPs(){                
        // List of Contact records to return
		hcpContacts = new List<Contact>();
        
        // SOSL result list of lists
        List<List<SObject>> soslResult = new List<List<SObject>>();

        // SOSL requires search string to be greater than 1. Using 2 here to ensure performance 
        if(searchString.length() > 2){            
            // Note: SOSL used here instead of SOQL as it produces better results for Asian characters and similar results for European characters
            // Search for the string entered by the user in the Name field of the Contact object. Record type might also need to be added as a parameter in the future. 
            soslResult = [FIND :searchString IN NAME FIELDS RETURNING Contact(Id, Name, Title, Image_URL__c)];
            
            // Retrieve contact list from SOSL results
            hcpContacts = soslResult[0];

            // Set search boolean
			ranSearch = true;
        }
        else{
            // Search boolean remains false
			ranSearch = false;
            
            // Return an empty list for searches less than 2 characters. In practice, this should be a warning message returned to the user. 
            hcpContacts = new List<Contact>();
        }
        return null;
    }

    /**
	 * @description	 			
     * @param newRecords 		
     * @return 
     */	    
    public void createDCR(){
        // Initialize class variables
        searchString = '';
    }
    
}