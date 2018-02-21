/**
 * Created Date		: Nov 16, 2016
 * Developed By		: Scott Warren, Comity Designs, Inc.
 *
 * Function			: @description - Trigger Handler for Account Trigger
 * Support Email 	: scott@comitydesigns.com
 * Version			: 1.0
 *
 * Modification Log
 *
 * Developer Name			User Story				Date			Version 			Description
 *____________________________________________________________________________________________________
 *
 * Scott Warren				POC-37				Nov 16, 2016			1.1				@description - Initial Commit
 *
 */
public with sharing class OCE_AccountTriggerHandler extends OCE_TriggerManager.TriggerHandler {
    
    /**
	 * @description	 			Override methods for Trigger context AfterInsert
     * @param newRecords 		List of new records
     * @param newRecordsMap 	Map of new records
     */	
    public override void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap){
    	try{
    		// For the purposes of the POC, the DML operation will be contained in the handler class. 
    		// Generally, best practices would dictate that CRUD / FLS permissions are assessed prior to these operations
    		// and that the DML operations be referenced from a Object Data Access class. 
    		
    		// CRUD lists for subsequent insertion
    		List<Account_Location__c> accLocations = new List<Account_Location__c>();
    		List<Task> tasks = new List<Task>();
    		Map<String, Location__c> accIdToLocationMap = new Map<String, Location__c>();
    		
    		// Loop over account records and populate DML collections and setup collections
    		for(Account acc : (List<Account>)newRecords){
    			Location__c loc = new Location__c(Address_Street_1__c = acc.BillingStreet, City__c = acc.BillingCity,
    												State__c = acc.BillingState, Postal_Code__c = acc.BillingPostalCode);			
				
				// Populate the Account ID to Location record map with the newly created location
				accIdToLocationMap.put(acc.Id, loc);
				
				// The Assignment logic is hard coded inside the trigger. In a real-world scenario, some combination of Territory Management,
				// Assignment Rules, etc would drive this task assignment for newly created HCPs. Sales user will be hard coded to '00541000001YHLXAA4' for the POC				
				Date dueDate = Date.today() + 7; // Setting the task due date to 1 week in the future.
				tasks.add(new Task(OwnerId = '00541000001YHLXAA4', ActivityDate = dueDate, Status = OCE_Constants.TASK_STATUS_NOT_STARTED, 
									Subject = OCE_Constants.TASK_SUBJECT_FOLLOW_UP_CALL));
    		}
    		
    		// Insert Location records by reference from map values
    		insertLocations(accIdToLocationMap.values());
    		
    		// Insert Task records
    		insertTasks(tasks);
    		
    		// Create Junction Object Records and add to collection for insertion    		
    		for(String accId : accIdToLocationMap.keySet()){
    			accLocations.add(new Account_Location__c(Account__c = accId, Location__c = accIdToLocationMap.get(accId).Id));
    		}

    		// Insert junction records
    		accLocations = insertAccountLocations(accLocations);
    		
    	}
    	catch(Exception ex){
            if (!newRecords.isEmpty()){
            	// Add error messages to failed records
                for (Integer i = 0; i < newRecords.size(); i++)
                {
                    newRecords[i].addError(ex.getMessage());
                } 
            }    		
    	}
    }

    /**
	 * @description 	Inserts collections of Location__c object records
     * @param locs 		A collection of Location__c object records to be inserted
     * @return 			The collection of Location__c object records which have been inserted
     */    
    public List<Location__c> insertLocations(List<Location__c> locs){
    	// The DML logic should be housed in an object data access class. For POC purposes, it is included in the handler class. 
        try{
        	Database.insert(locs);
            return locs;
        }
        catch(DMLException e){
            return locs;
        }
    }

    /**
	 * @description 	Inserts collections of Account_Location__c object records
     * @param locs 		A collection of Account_Location__c object records to be inserted
     * @return 			The collection of Account_Location__c object records which have been inserted
     */        
    public List<Account_Location__c> insertAccountLocations(List<Account_Location__c> accLocations){
    	// The DML logic should be housed in an object data access class. For POC purposes, it is included in the handler class. 
        try{
            Database.insert(accLocations);
            return accLocations;    	
        }
        catch(DMLException e){
            return accLocations;    	
        }
    }

    /**
	 * @description 	Inserts collections of Task object records
     * @param locs 		A collection of Task object records to be inserted
     * @return 			The collection of Task object records which have been inserted
     */    
    public List<Task> insertTasks(List<Task> tasks){
    	// The DML logic should be housed in an object data access class. For POC purposes, it is included in the handler class. 
        try{
            Database.insert(tasks);
            return tasks;    	
        }
        catch(DMLException e){
        	return tasks;    	   
        }    	
    }
    
}