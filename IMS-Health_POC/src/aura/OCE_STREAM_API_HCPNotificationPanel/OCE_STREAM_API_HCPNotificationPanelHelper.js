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
    	//var ns = component.getDef().getDescriptor().getNamespace();
        var ns = 'c';
        var topic = 'HCP_Notification';
        var topicPath = '/topic/'+topic;
        //this is a custom streaming channel
        if(topic.indexOf('/') >= 0){
            topicPath = topic;
        }
        
        $.cometd.subscribe(topicPath, function(message) {
            console.log('Inside Subscribe');
            var com =  component.getEvent("notificationEvent");
            com.setParams({
                        topic: topic,
                        data: message.data.sobject,
                        event: message.data.event,
            }).fire();
        });
    },
    
    displayNotificaiton: function(component, notify){
    	console.log('Send to Apex'+notify);
        var  hcpNotification = component.get("c.verifyHCPNotifications");
        hcpNotification.setParams({"notifyId" : notify,
                                   "hcpId" : '0034100000BBaYZAA1'});
        hcpNotification.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("HCP Notification :" + response);
                component.set("v.hcpNotif", response.getReturnValue())
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
})