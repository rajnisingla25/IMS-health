/**
 * Created Date		: Nov 16, 2016
 * Developed By		: Scott Warren, Comity Designs, Inc.
 *
 * Function			: @description - Trigger Manager for the OCE Project
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
global with sharing class OCE_TriggerManager {
	
	public interface ITriggerHandler {
        void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap);
        void onAfterUpdate(List<sObject> oldRecords, List<sObject> newRecords, Map<ID, sObject> oldRecordsMap, Map<ID, sObject> newRecordsMap);
        void onAfterDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap);
        void onAfterUnDelete(List<sObject> newRecords);

	    void onBeforeInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap);
	    void onBeforeUpdate(List<sObject> oldRecords, List<sObject> newRecords, Map<ID, sObject> oldRecordsMap, Map<ID, sObject> newRecordsMap);
	    void onBeforeDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap);
    }
    
    public abstract class TriggerHandler implements ITriggerHandler {
	   
	    public virtual void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {}
	    public virtual void onAfterUpdate(List<sObject> oldRecords, List<sObject> newRecords, Map<ID, sObject> oldRecordsMap, Map<ID, sObject> newRecordsMap) {}
	    public virtual void onAfterDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap) {}
	    public virtual void onAfterUnDelete(List<sObject> newRecords)	{}

	    public virtual void onBeforeInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {}
	    public virtual void onBeforeUpdate(List<sObject> oldRecords, List<sObject> newRecords, Map<ID, sObject> oldRecordsMap, Map<ID, sObject> newRecordsMap) {}
	    public virtual void onBeforeDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap) {}

       	private void invoke(
                Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUnDelete,
                List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap) 
       	{
            	if(isBefore) 
                {
                	if (isInsert) 
                	{
                 		onBeforeInsert(newRecords, newRecordsMap);
                	}
                	else if (isUpdate) 
                	{
                 		onBeforeUpdate(oldRecords, newRecords, oldRecordsMap, newRecordsMap);
                	}
                	else if (isDelete) 
                	{
                		onBeforeDelete(oldRecords, oldRecordsMap);
                	}

            	}
            	if(isAfter) 
                {
                	if (isInsert) 
                	{
                 		onAfterInsert(newRecords, newRecordsMap);
                	}
                	else if (isUpdate) 
                	{
                 		onAfterUpdate(oldRecords, newRecords, oldRecordsMap, newRecordsMap);
                	}
                	else if (isDelete) 
                	{
                		onAfterDelete(oldRecords, oldRecordsMap);
                	}
                	else if (isUnDelete) 
                	{
                		onAfterUnDelete(newRecords);
                	}
            	}
        	}
    	}
	
	/**
     * @description  Invoke trigger handler by type Usage: in trigger make call like  TriggerManager.invoke(ContactTriggerhandler.class);
     */
	public static void invoke(Type type) {
        Object handler = type.newInstance();
        if (handler instanceof TriggerHandler) {
            invoke((TriggerHandler) handler);
        }              
    } 
    	
	/**
     * @description  Invoke trigger handler by type Usage: in trigger make call like  TriggerManager.invoke(ContactTriggerhandler.class);
     */
	global static void invoke(String typeName) {
		Type typeObj = type.forName(typeName);
        Object handler = typeObj.newInstance();
        if (handler instanceof TriggerHandler) {
            invoke((TriggerHandler) handler);
        }
    }
 
  	/**
     * @description  Invoke trigger handler by existing instance. Usage: in trigger make call like  TriggerManager.invoke(new ContactTriggerhandler());
     */
    public static void invoke(TriggerHandler handler) {
        handler.invoke(
            Trigger.isBefore, 
            Trigger.isAfter, 
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete,
            Trigger.isUnDelete,
            Trigger.old, 
            Trigger.new, 
            Trigger.oldMap,
            Trigger.newMap);
    }
}