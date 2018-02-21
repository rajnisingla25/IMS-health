({	
    doInit : function(component, event, helper) {
        // get the nearby events
        helper.getEventRecords(component);
	},
    pageChange: function(component, event, helper) {
        // get the params for pagination
        var page = component.get("v.page") || 1;
        var pages = component.get("v.pages") || 1;
        var direction = event.getParam("direction");
        page = (direction === "previous") ? (page - 1) : (page + 1);
        
        // get the next set of nearby events
        if(page > 0 && page <= pages) {
        	helper.getEventRecords(component, page);
        }
    },
    onSelectChange : function(component, event, helper) {
        // set the value of the select option
        component.set("v.radius", event.target.value);
        // get the nearby events
        helper.getEventRecords(component);
    },
    registerForEvent : function(component, event, helper) {
        // Prevent the form from getting submitted
        event.preventDefault();
        // Get the selected event id from the field that's in the form
        component.set("v.selectedEventId", event.target.getElementsByClassName('event-id')[0].value);
        // get the current page
        var page = component.get("v.page") || 1;
        // add the contact to the event 
        helper.addEvent(component, page);
    }
})