({
    openCometDConnection : function(component, event) {
        var action = component.get("c.getSessionId");
        console.log('Session ID' + action);
        action.setCallback(this, function(a) {
            var sid = a.getReturnValue();
            var topics =  'HCP_Notification';
            var apiVersion =  '37';

            //init connection
            $.cometd.init({
               url: '/cometd/'+apiVersion+'.0',
               requestHeaders: { Authorization: 'OAuth '+sid},
               appendMessageTypeToURL: false,
            });
            
            this.subscribeTopic(component, topics);
            
            //closes connection of window close
            window.onbeforeunload = function(){
                $.cometd.disconnect();
            };

        });
        
        $A.enqueueAction(action);
        
	},

    //creates subscription to a given topic
    subscribeTopic: function(component, topic){
        
        console.log('inside subscribe');
    	//var ns = component.getDef().getDescriptor().getNamespace();
        var ns = 'c';
        var topic = 'HCP_Notification';
        var topicPath = '/topic/'+topic;
        //this is a custom streaming channel
        if(topic.indexOf('/') >= 0){
            topicPath = topic;
        }
        
        $.cometd.subscribe(topicPath, function(message) {
            console.log('Subscribing to HCP Notifications');
            var com =  component.getEvent("notificationEvent");
            com.setParams({
                        topic: topic,
                        data: message.data.sobject,
                        event: message.data.event,
            }).fire();
        });
    },
    
    displayNotificaiton: function(component, notify) {
        // Load all contact data
        var contactRecordId = component.get("v.recordId");
        console.log("contactRecordId-" + contactRecordId);
        var  hcpNotification = component.get("c.verifyHCPNotifications");
        hcpNotification.setParams({"notifyId" : notify,
                                   "hcpId" : contactRecordId});
        
        hcpNotification.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.hcpNotif", response.getReturnValue());
                console.log("HCP Notification :" + response);
                 var cmpTarget = component.find("notifPanel");
                 $A.util.removeClass(cmpTarget, "slds-hide");
            } else if (state === "INCOMPLETE") {
                console.log("Incomplete error");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                      var cmpTarget = component.find("notifPanel");
                      $A.util.addClass(cmpTarget, "slds-hide");
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(hcpNotification);
    },
    updateNotification : function(cmp) {
        var notificationId = cmp.get("v.hcpNotif");
        console.log("NotificationRecordId-" + notificationId);
        var  hcpNotificationUpdate = cmp.get("c.updateHCPNotifications");
        hcpNotificationUpdate.setParams({"notifyId" : notificationId})
        
        var cmpTarget = cmp.find("notifPanel");
        $A.util.addClass(cmpTarget, "slds-hide");
        $A.enqueueAction(hcpNotificationUpdate);
    }
    
})