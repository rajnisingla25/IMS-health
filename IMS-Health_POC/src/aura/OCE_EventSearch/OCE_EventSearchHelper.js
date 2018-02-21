({
	// get the list of nearby events
    getEventRecords : function(component, page) {
		var page = page || 1;
        var action = component.get("c.getRecords");
        action.setParams({
            contactId : component.get("v.recordId"),
            pageNumber : page,
            pageSize : component.get("v.pageSize"),
            radius : component.get("v.radius")
        });
        // callback handler for getRecords
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var retResponse = JSON.parse(response.getReturnValue());
                // set the latestRecords to the view
                component.set("v.latestRecords", retResponse.sObjectRecords);
                // set the page in context to the view
                component.set("v.page", page);
                // set the total records returned to the view
                component.set("v.total", (retResponse.total) ? retResponse.total : 0);   
                // set the total no. of pages to the view
                component.set("v.pages", Math.ceil(retResponse.total/component.get("v.pageSize")));
             } else if (state === "ERROR") {
                this.showToast(component, false, $A.get("$Label.c.OCE_REGISTER_EVENT_ERROR"));
            }
        });
        $A.enqueueAction(action);
    },
    
    // register for the selected event
    addEvent : function(component, page) {
        var action = component.get("c.addToEventAttendee");
        action.setParams({
            contactId : component.get("v.recordId"),
            eventId : component.get("v.selectedEventId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var retResponse = JSON.parse(response.getReturnValue());
                this.showToast(component, retResponse.status, retResponse.displayMsg);
                this.getEventRecords(component, page);
            } else {
                this.showToast(component, false, $A.get("$Label.c.OCE_REGISTER_EVENT_ERROR"));
            }
        });
        $A.enqueueAction(action);
    },
    
    // Displays a toast notification with a message
    showToast : function(component, isSuccess, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": (isSuccess) ? "success" : "error",
            "title": (isSuccess) ? $A.get("$Label.c.OCE_SUCCESS_STR") : $A.get("$Label.c.OCE_SUCCESS_STR"),
            "message": message
        });
        toastEvent.fire();
    }
})