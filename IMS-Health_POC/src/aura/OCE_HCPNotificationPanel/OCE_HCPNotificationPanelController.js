({
	init : function(component, event, helper) {
         // Retrieve notifications during component initialization
       helper.openCometDConnection(component, event);
    },
    handleEvent : function(component, event, helper) {
        var sobjData = event.getParam("data");
        helper.displayNotificaiton(component, sobjData);
    },
    updateNotifications : function(component, event, helper) {
       // Update HCP notification once viewed
         helper.updateNotification(component);
    }
})