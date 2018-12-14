({
	handleButtonClick : function(component, string) {

		var buttonId = string;

		// dont run code on Launch Audit Wizard
		if(buttonId == "saveButton" || buttonId == "cancelButton"){

			// set attribute to remove modal container
			component.set("{!v.isButtonClicked}", false);

			// run save action
			if(buttonId =="saveButton"){

				// call method
				this.handleSaveAudit(component);
			}else{
				// do nothing on cancel
			}
		}else{
			
			// User clicked Create Audit button, expose modal window
			component.set("{!v.isButtonClicked}", true);
		}

		
	}, 

	handleSaveAudit : function(component, event, helper) {

		var startDate = new Date(component.get("{!v.newAudit.Obtain_System_Lists_by__c}")+'T00:00:00');
		console.log('startDate: '+ startDate);
		// startDate = component.get("{!v.newAudit.Obtain_System_Lists_by__c}");
		// set Audit name before saving
		var auditQuarter;
		startDate.getMonth() > 1 && startDate.getMonth() < 4 ? auditQuarter = 1 : 
		startDate.getMonth() > 3 && startDate.getMonth() < 7 ? auditQuarter = 2 : 
		startDate.getMonth() > 6 && startDate.getMonth() < 10 ? auditQuarter = 3 : 
		startDate.getMonth() > 9 && startDate.getMonth() <= 12 ? auditQuarter = 4 : ""

		component.set("{!v.newAudit.Name}", "Q"+auditQuarter+" Compliance Audit");
		/*
		** can't understand why this enables force:recordEditForm to save successfully.
		** This was originally here for LDS, but have since replaced with above.
		** Leaving here because it sends toast message, but honestly haven't
		** investigated what relationship is between LDS .saveRecord method
		** and force:recordEditForm component
		*/
        component.find("auditCreator").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" ) {
                // record is saved successfully, fire toast
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "The audit was successfully initiated.",
                    "type": "SUCCESS"
                });
                resultsToast.fire();
                // initialize apex controller method with new Audit id
                var action = component.get("c.createAuditObjects");
		        action.setParams({ auditId : saveResult.recordId });
		        // callback actions
		        action.setCallback(this, function(response) {
		            var state = response.getState();
		            if (state === "SUCCESS") {
		                
		            }
		            else if (state === "INCOMPLETE") {
		                console.log('state is incomplete');
		            }
		            else if (state === "ERROR") {
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
		        // queue @AuraEnabled method
		        $A.enqueueAction(action);

            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                window.alert("Audit wasn't created, please email salesforcetaskforce@ for resolution");
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                window.alert('Problem saving audit, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        });
    },
})