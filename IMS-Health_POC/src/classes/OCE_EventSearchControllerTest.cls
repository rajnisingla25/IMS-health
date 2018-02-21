/**
* @description This apex class is a unit test for OCE_EventSearchController class
* 
* @Author  Binod Kumar 
* @version 1.0
* @since   2016-12-04
*/ 
@isTest
private class OCE_EventSearchControllerTest {
	
    private static String resp;
    private static Contact con;
    
    @testSetup static void setupTestData() {
        // Create test account
        Account testAcct = new Account(Name = 'TestAcct');
        Database.SaveResult sr = Database.insert(testAcct, false);
        // ensure that the Account record has an Id
        system.assertNotEquals(null, sr.getId());
        
        // Create test contact
        Contact testContact = new Contact(FirstName = 'TestFirst',
                                          LastName = 'TestLast',
                                          AccountId = sr.getId(),
                                          MailingStreet = '200 Campus Drive Collegeville',
                                          MailingCity = 'Collegeville',
                                          MailingState = 'Pennsylvania',
                                          MailingPostalCode = '19426',
                                          MailingLatitude = 40.157737,
                                          MailingLongitude = -75.469261);
        
        sr = Database.insert(testContact, false);
        // ensure that the Contact record has an Id
        system.assertNotEquals(null, sr.getId());
        Id contactId = sr.getId();
        
		// Create test location
		Location__c testLoc = new Location__c(Name = 'TestLoc',
                                              Address_Street_1__c = '1201 Market Street',
                                              City__c = 'Philadelphia',
                                              State__c = 'Pennsylvania',
                                              Postal_Code__c = '19107',
                                              Geo_Location__Latitude__s = 39.952509,
                                              Geo_Location__Longitude__s = -75.160616);
        
        sr = Database.insert(testLoc, false);
        // ensure that the Location__c record has an Id
        system.assertNotEquals(null, sr.getId());
        
        // create test event
        Event__c testEvent = new Event__c(Name='Thrive Yoga',
                                          Start_Date__c = Date.today(),
                                          End_Date__c = Date.today(),
                                          Speaker__c = contactId,
                                          Location__c = sr.getId());
        
        sr = Database.insert(testEvent, false);
        // ensure that the Event__c record has an Id
        system.assertNotEquals(null, sr.getId());
    }
    
    private static testMethod void testEventSearch() {
        con = [SELECT Id FROM Contact WHERE Name='TestFirst TestLast' LIMIT 1];
        system.assertNotEquals(null, con.Id);
        
        Test.startTest();
        resp = OCE_EventSearchController.getRecords(con.Id, 1, '5', '50');
        OCE_DataTableWrapper dtw = (OCE_DataTableWrapper)JSON.deserialize(resp, OCE_DataTableWrapper.class);
        system.assertNotEquals(null, dtw.sObjectRecords);
        system.assertEquals(dtw.total, dtw.sObjectRecords.size());
        Test.stopTest();
    }
    
    private static testMethod void testRegisterEvent() {
        con = [SELECT Id FROM Contact WHERE Name='TestFirst TestLast' LIMIT 1];
        system.assertNotEquals(null, con.Id);
        
        Event__c evt = [SELECT Id FROM Event__c WHERE Name='Thrive Yoga' LIMIT 1];
        system.assertNotEquals(null, evt.Id);
        
        Test.startTest();
        resp = OCE_EventSearchController.addToEventAttendee(con.Id, evt.Id);
        OCE_EventSearchController.Response respObj = (OCE_EventSearchController.Response)JSON.deserialize(resp, OCE_EventSearchController.Response.class);
    	system.assertEquals(true, respObj.status);
        Test.stopTest();
    }
    
    private static testMethod void testRegisterEventWithNoEventId() {
        con = [SELECT Id FROM Contact WHERE Name='TestFirst TestLast' LIMIT 1];
        system.assertNotEquals(null, con.Id);
        
        Test.startTest();
        resp = OCE_EventSearchController.addToEventAttendee(con.Id, null);
        OCE_EventSearchController.Response respObj = (OCE_EventSearchController.Response)JSON.deserialize(resp, OCE_EventSearchController.Response.class);
    	system.assertEquals(false, respObj.status);
        Test.stopTest();
    }
}