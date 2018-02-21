/**
 * Created Date		: Nov 21st, 2016
 * Developed By		: Piyush Pandya, Comity Designs, Inc.
 *
 * Function			: This class sends the HCP profile information and HCP notifications on contact record
 * Support Email 	: piyush@comitydesigns.com
 * Version			: 1.0
 *
 * Modification Log
 *
 * Developer Name			User Story				Date			Version 			Description
 *____________________________________________________________________________________________________
 *
 * Piyush Pandya			    			    Nov 21st, 2016		 1.0				 Inital Version
 * Anil Pilaka									Dec 30th, 2016       1.1                Added HCP notifications
 */

public with sharing class OCE_HCPController {
    
    @AuraEnabled
	public static Contact getHCPProfile(String hcpId) {
        system.debug(system.LoggingLevel.DEBUG, 'HcpID: ' + hcpId);
		List <Contact> hcpList = [select id, Salutation , Title, Name, Email, Speciality__c, Phone , Level__c, Account.Name, MailingStreet, MailingState, MailingCity, MailingStateCode, MailingPostalCode, Image_URL__c, Expertise__c, Writer_Level__c  from Contact where id =: hcpId];
		// TODO: Add CRUD/FLS check before returning data
        return hcpList[0];
	}
    
    @AuraEnabled
	public static HCP_Notifications__c getHCPNotifications(String hcpId) {
        system.debug(system.LoggingLevel.DEBUG, 'HcpID: ' + hcpId);
		List <HCP_Notifications__c> hcpNotificationList = [select id, Title__c,Description__c from HCP_Notifications__c where HCP__c =: hcpId and Acknowledge__c = false and ownerId=:userinfo.getUserId()];
		// TODO: Add CRUD/FLS check before returning data
        return hcpNotificationList[0];
    }
    
    
    @AuraEnabled
	public static HCP_Notifications__c verifyHCPNotifications(HCP_Notifications__c notifyId,String hcpId) {
        system.debug(system.LoggingLevel.DEBUG, 'HcpID: ' + hcpId);
        system.debug(system.LoggingLevel.DEBUG, 'Notificaiton : ' + notifyId);
        //Verify if the HCP notification should be displayed for a specific HCP or not. 
        //There should also be a filter criteria to show the notifications based on the owner.This will be added as part of the product
        List <HCP_Notifications__c> hcpNotificationList = [select id, Title__c,Description__c from HCP_Notifications__c where id=:notifyId.ID and HCP__c=:hcpId and Acknowledge__c = false];
		// TODO: Add CRUD/FLS check before returning data
        return hcpNotificationList[0];
    }
    
    @AuraEnabled
	public static void updateHCPNotifications(HCP_Notifications__c notifyId) {
        system.debug(system.LoggingLevel.DEBUG, 'notifyId: ' + notifyId);
        try{
            HCP_Notifications__c notification = new HCP_Notifications__c(Id = notifyId.id);
            notification.Acknowledge__c = true;
            // TODO: Add CRUD/FLS check before returning data
            update notification;
        }catch(Exception ex){
          // Log Exception  
          system.debug(system.LoggingLevel.DEBUG, 'Exception : ' + ex);
        }
    }
    
    @AuraEnabled
    public static String getSessionId(){
        return UserInfo.getSessionId();
    }
}