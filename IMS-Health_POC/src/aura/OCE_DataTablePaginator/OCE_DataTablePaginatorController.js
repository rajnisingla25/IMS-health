({
	// gets the previous set of nearby events
    previousPage : function(component, event, helper) {
        // get the application level event and set the previous direction
        var appEvt = $A.get("e.c:OCE_DataTablePageChange");
        appEvt.setParams({ "direction": "previous"});
        appEvt.fire();
	},
	// gets the next set of nearby events
    nextPage : function(component, event, helper) {
        // get the application level event and set the next direction
        var appEvt = $A.get("e.c:OCE_DataTablePageChange");
        appEvt.setParams({ "direction": "next"});
        appEvt.fire();
	}
})