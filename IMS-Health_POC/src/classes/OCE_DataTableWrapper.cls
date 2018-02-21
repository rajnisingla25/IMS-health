/**
* @description This apex class is a wrapper class for response returned by getRecords() method
* 
* @Author  Binod Kumar 
* @version 1.0
* @since   2016-12-03
*/
global class OCE_DataTableWrapper {
	@AuraEnabled
    public Integer page {get; set;}

    @AuraEnabled
    public Integer total {get; set;}

    @AuraEnabled
    public List<sObject> sObjectRecords  {get; set;}
}