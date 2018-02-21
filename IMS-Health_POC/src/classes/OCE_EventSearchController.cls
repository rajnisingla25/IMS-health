/**
* @description This apex class is a controller for EventSearch Lightning component
* 
* @Author  Binod Kumar 
* @version 1.0
* @since   2016-12-01
*/ 
public with sharing class OCE_EventSearchController {
	
    /**
     * @description This method retrieves upcoming nearby events
     * @param Id contactId
     * @param Decimal pageNumber
     * @param String pageSize
     * @param String radius
     * @return String as json response
     */
    @AuraEnabled 
    public static String getRecords(Id contactId, Decimal pageNumber, String pageSize, String radius) {
        OCE_DataTableWrapper dtw = new OCE_DataTableWrapper();
        
        try {
            // get the GeoLocation: Latitude & Longitude for the contact in context
            List<Contact> contacts = [SELECT MailingLatitude, MailingLongitude 
                                      FROM Contact
                                      WHERE Id = :contactId];
            
            if(contacts != null && !contacts.isEmpty()
                && contacts[0].MailingLatitude != null
                && contacts[0].MailingLongitude != null) {
                String units = 'mi';
                
                // calculate the offset for query
                Integer offset = (integer.valueOf(pageNumber) - 1) * integer.valueof(pageSize);
                
                // prepare query string
                String queryStr = 'SELECT Id, Name , Speaker__r.Name, Start_Date__c, End_Date__c, Location__r.Geo_Location__c, Location__r.Name' +
                    ' FROM Event__c '+
                    ' WHERE DISTANCE(Location__r.Geo_Location__c, GEOLOCATION('+contacts[0].MailingLatitude+', '+contacts[0].MailingLongitude+'), \''+String.escapeSingleQuotes(units)+'\') < ' + String.escapeSingleQuotes(radius) +
                    //' AND Start_Date__c >= TODAY' +
                    ' AND Id NOT IN (SELECT Event__c FROM Event_Attendees__c WHERE Contact__c = \''+String.escapeSingleQuotes(contactId)+'\')' +
                    ' ORDER BY Start_Date__c' +
                    ' LIMIT ' + String.escapeSingleQuotes(pageSize) + ' Offset ' + offset;
                
                String countQueryStr = 'SELECT count()' +
                    ' FROM Event__c '+
                    ' WHERE DISTANCE(Location__r.Geo_Location__c, GEOLOCATION('+contacts[0].MailingLatitude+', '+contacts[0].MailingLongitude+'), \''+String.escapeSingleQuotes(units)+'\') < ' + String.escapeSingleQuotes(radius) +
                    ' AND Id NOT IN (SELECT Event__c FROM Event_Attendees__c WHERE Contact__c = \''+String.escapeSingleQuotes(contactId)+'\')';
                    //' AND Start_Date__c >= TODAY';
                
                dtw.total = Database.countQuery(countQueryStr);
                dtw.page = Integer.valueOf(pageNumber);
                dtw.sObjectRecords = Database.query(queryStr);
            }
        } catch(Exception ex) {
            system.debug('Error: ' + ex.getMessage());
        }
        
        return JSON.serialize(dtw);
    }
    
    /**
     * @description This method registers the Contact as an event attendee
     * @param Id contactId
     * @param Id eventId
     * @return String as json response
     */
    @AuraEnabled 
    public static String addToEventAttendee(Id contactId, Id eventId) {
        Response resp = new Response();
        resp.status = false;
        try {
            if(String.isNotBlank(contactId) && String.isNotBlank(eventId)) {
                // create Event_Attendees__c record
                Event_Attendees__c ea = new Event_Attendees__c ();
                ea.Contact__c = contactId;
                ea.Event__c = eventId;
                
                // insert Event_Attendees__c record
                Database.SaveResult sr = Database.insert(ea, false);
                if(sr != null && sr.isSuccess()) {
                    resp.status = true;
                    resp.displayMsg = Label.OCE_REGISTER_EVENT_SUCCESS;
                }
            }
            
            if(!resp.status) {
               resp.displayMsg = Label.OCE_REGISTER_EVENT_ERROR; 
            }
        } catch(Exception ex) {
            resp.displayMsg = ex.getMessage();
        }
        
        return JSON.serialize(resp);
    }
    
    /**
     * @description This is a wrapper class for event registration response
     */
    public class Response {
        public Boolean status {get; set;}
        public String displayMsg {get; set;}
    }
}