({
	doInit : function(component, event, helper) {

		// call Apex controller method
		var getProfilePermissions = component.get("c.returnPermissions");

		        // callback actions
		        getProfilePermissions.setCallback(this, function(response) {

		            var state = response.getState();
		            
		            if (state === "SUCCESS") {
		              	component.set("{!v.permissionSnapshotArray}", response.getReturnValue());
		            }
		            else if (state === "INCOMPLETE") {
		            }
		            else if (state === "ERROR") {
		                var errors = response.getError();
		                if (errors) {
		                    if (errors[0] && errors[0].message) {
		                    
		                    }
		                } else {
		                    console.log("Unknown error");
		                }
		            }
		        });
		        // queue @AuraEnabled method
		        $A.enqueueAction(getProfilePermissions);
	},

	showHelpText : function(component, event, helper){

		if(!(component.get('{!v.helpTextShown}'))){

			component.set('{!v.helpTextShown}', true);

			var helpText = component.find('help-text');

			// show help text
			$A.util.removeClass(helpText, 'help-text-fade');
			$A.util.addClass(helpText, 'help-text');

			// remove help text
			var interval = setInterval(function(){ 
							$A.util.removeClass(helpText, 'help-text');
							$A.util.addClass(helpText, 'help-text-fade');
							clearInterval(interval);
							}, 3000);
		}

	}
})