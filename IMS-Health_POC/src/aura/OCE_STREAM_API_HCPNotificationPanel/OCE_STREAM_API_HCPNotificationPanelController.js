({
	init : function(component, event, helper) {
        console.log('Inside Init');
        helper.openCometDConnection(component, event);
	},
    handleEvent : function(component, event, helper) {
        var sobjData = event.getParam("data");
        helper.displayNotificaiton(component, sobjData);
       // component.set("v.hcpNotif", sobjData)
       // var cmpTarget = component.find("notifPanel");
       // $A.util.removeClass(cmpTarget, "slds-hide");
       // console.log('Event Handled'+ sobjData.Title__c);
	} 
})