({
    getHCPInfo: function(cmp) {
        // Load all contact data
        console.log("Inside getHCPInfo");
        var contactRecordId = cmp.get("v.recordId");
        console.log("contactRecordId-" + contactRecordId);
        var getHCPProfileAction = cmp.get("c.getHCPProfile");
        getHCPProfileAction.setParams({"hcpId" : contactRecordId})
        getHCPProfileAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.hcpProfile", response.getReturnValue());
                console.log("HCPPRofile:" + response.getReturnValue());
            } else if (state === "INCOMPLETE") {
                console.log("Incomplete error");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(getHCPProfileAction);
    }
})