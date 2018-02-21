@isTest
public class OCE_AccountTriggerHandlerTest {
    
    // Single Account Test
    static testMethod void insertSingleAccountTest(){
        Test.startTest();
        List<Account> newAccounts = createAccounts(1);
        Database.insert(newAccounts);
		
        // Locations created for each account inserted
		List<Location__c> locations = [SELECT Id FROM Location__c];
		System.assert(locations != null);
        System.assert(locations.size() > 0);
        
        // Account Locations to link Account records and Location records (1:1)
        List<Account_Location__c> accLocations = [SELECT Id FROM Account_Location__c];
        System.assert(accLocations != null);
        System.assert(accLocations.size() > 0);
		
		// 1:1 relationship between account, location, and account locations for this POC        
        System.assertEquals(newAccounts.size(), locations.size());
        System.assertEquals(newAccounts.size(), accLocations.size());
        System.assertEquals(locations.size(), accLocations.size());
        Test.stopTest();
    }
    
    // Bulk Account Test
    static testMethod void insertMultipleAccountTest(){
        Test.startTest();
        List<Account> newAccounts = createAccounts(1000);
        Database.insert(newAccounts);
		
        // Locations created for each account inserted
		List<Location__c> locations = [SELECT Id FROM Location__c];
		System.assert(locations != null);
        System.assert(locations.size() > 0);
        
        // Account Locations to link Account records and Location records (1:1)
        List<Account_Location__c> accLocations = [SELECT Id FROM Account_Location__c];
        System.assert(accLocations != null);
        System.assert(accLocations.size() > 0);
		
		// 1:1 relationship between account, location, and account locations for this POC        
        System.assertEquals(newAccounts.size(), locations.size());
        System.assertEquals(newAccounts.size(), accLocations.size());
        System.assertEquals(locations.size(), accLocations.size());        
        Test.stopTest();
    }
    
    // Negative Account Test
    // Multiple negative tests should be written to force exceptions. The POC data model is very simplistic, so these exceptions are unlikely to occur and difficult to force.
    static testMethod void insertInvalidAccountTest(){        
        Test.startTest();
        OCE_AccountTriggerHandler ath = new OCE_AccountTriggerHandler();        
        List<Account> invalidAccs = createAccounts(1);
        ath.onAfterInsert(invalidAccs, null);
        
        // No additional records should be created for failed insertions
        List<Account> queryAccs = [SELECT Id FROM Account];
        System.assert(queryAccs.size() == 0);
        Test.stopTest();
    }
    
    // Negative Location Test
    // Multiple negative tests should be written to force exceptions. The POC data model is very simplistic, so these exceptions are unlikely to occur and difficult to force.
    static testMethod void insertInvalidLocationTest(){        
        Test.startTest();
        OCE_AccountTriggerHandler ath = new OCE_AccountTriggerHandler();        
        List<Account> invalidAccs = createAccounts(1);
        ath.insertLocations(new List<Location__c>{new Location__c(Postal_Code__c = '123456789012345678901234567890')});
        
        // No additional records should be created for failed insertions
		List<Location__c> locations = [SELECT Id FROM Location__c];
        System.assert(locations.size() == 0);
        Test.stopTest();        
    }    

    // Negative Task Test
    // Multiple negative tests should be written to force exceptions. The POC data model is very simplistic, so these exceptions are unlikely to occur and difficult to force.
    static testMethod void insertInvalidTaskTest(){        
        Test.startTest();
        OCE_AccountTriggerHandler ath = new OCE_AccountTriggerHandler();        
        List<Account> invalidAccs = createAccounts(1);
        ath.insertTasks(new List<Task>{new Task(WhatId = UserInfo.getUserId())});
        // No additional records should be created for failed insertions
		List<Task> tasks = [SELECT Id FROM Task];
        System.debug('tasks: ' + tasks);
        System.assert(tasks.size() == 0);
        Test.stopTest();        
    }    
    
    // Create Test Account Data
    // For most use cases test data creation is relegated to its own class. 
    // For purposes of the POC, we are including it here. 
    private static List<Account> createAccounts(Integer accCount){
        List<Account> returnList = new List<Account>();
        for(Integer i = 1; i <= accCount; i++){
            returnList.add(new Account(Name = 'Test Account - ' + accCount, 
                                       BillingStreet = '123 Test Drive', 
                                       BillingCity = 'Atlanta', 
                                       BillingState = 'Georgia',
                                       BillingCountry = 'United States',
                                       BillingPostalCode = '30308'
                                      ));            
        }
        
        return returnList;
    }
}