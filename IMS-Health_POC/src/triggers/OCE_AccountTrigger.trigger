/**
 * Created Date		: Nov 16, 2016
 * Developed By		: Scott Warren, Comity Designs, Inc.
 *
 * Function			: @description - OCE Trigger for the Account object
 * Support Email 	: scott@comitydesigns.com
 * Version			: 1.0
 *
 * Modification Log
 *
 * Developer Name			User Story				Date			Version 			Description
 *____________________________________________________________________________________________________
 *
 * peng1					POC-37				Nov 16, 2016			1.1					@description - Initial commit
 *
 */
trigger OCE_AccountTrigger on Account (after insert, after update, before insert, before update) {
	// Retrieve Data Enablement Custom Setting Instance
    OCE_TriggerEnablement__c  triggerConfig = OCE_TriggerEnablementDataAccess.getOCETriggerEnablement();
	
	// Invoke trigger manager 
	if (triggerConfig == null || triggerConfig.id == null || triggerConfig.OCE_AccountTrigger__c == true){
		OCE_TriggerManager.invoke(OCE_AccountTriggerHandler.class);
	}
}