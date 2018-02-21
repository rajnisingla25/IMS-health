/**
 * Created Date		: Nov 16, 2016
 * Developed By		: Scott Warren, Comity Designs, Inc.
 *
 * Function			: @description - Allows each trigger to be enabled/disabled via custom setting
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
public with sharing class OCE_TriggerEnablementDataAccess {
    
    /**
	 * @description One or more lines that provide an overview of the method
     * @return An instance of the trigger config custom setting, OCE_TriggerEnablement__c
     * @example Example code usage. This will be wrapped in tags to preserve whitespace
     */
	public static OCE_TriggerEnablement__c getOCETriggerEnablement(){
		OCE_TriggerEnablement__c triggerConfig = OCE_TriggerEnablement__c.getInstance(UserInfo.getUserId());
		
		if(triggerConfig == null || triggerConfig.id == null){
			System.debug('Get Organization Wide Default Setting ~~~');
			triggerConfig = OCE_TriggerEnablement__c.getOrgDefaults();
		}
		return triggerConfig;
	}
}