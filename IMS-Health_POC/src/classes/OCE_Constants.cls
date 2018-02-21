/**
 * Created Date		: Nov 17, 2016
 * Developed By		: Scott Warren, Comity Designs, Inc.
 *
 * Function			: @description - Constants class for storing static string values across objects
 * Support Email 	: scott@comitydesigns.com
 * Version			: 1.0
 *
 * Modification Log
 *
 * Developer Name			User Story				Date			Version 			Description
 *____________________________________________________________________________________________________
 *
 * Scott Warren				POC-37				Nov 17, 2016			1.1				@description - Initial Commit
 *
 */
public with sharing class OCE_Constants {
	// Task Constants
	public static String TASK_STATUS_NOT_STARTED = 'Not Started';
	public static String TASK_STATUS_IN_PROGRESS = 'In Progress';
	public static String TASK_STATUS_COMPLETED = 'Completed';
	public static String TASK_STATUS_WAITING = 'Waiting on Someone Else';
	public static String TASK_STATUS_DEFERRED = 'Deferred';
	public static String TASK_PRIORITY_HIGH = 'High';
	public static String TASK_PRIORITY_NORMAL = 'Normal';
	public static String TASK_PRIORITY_LOW = 'Low';
	public static String TASK_SUBJECT_FOLLOW_UP_CALL = 'Initial call with HCP';
	
	// REST Constants
	public static String REST_POST = 'POST';
    public static String REST_GET = 'GET';
	public static String REST_CONTENT_TYPE = 'Content-Type';
	public static String REST_APPLICATION_JSON = 'application/json';
    public static String REST_AUTHORIZATION = 'Authorization';
    public static String REST_BEARER = 'Bearer ';
	
	// Marketing Cloud API Constants
	public static String MC_CLIENT_ID = 'clientId';
	public static String MC_CLIENT_SECRET = 'clientSecret';
    public static String MC_ACCESS_TOKEN = 'accessToken';
    public static String MC_INTERACTIONS_URL = '/interaction/v1/interactions';
    public static String MC_ITEMS = 'items';
        
}