({
	doInit: function(component, event, helper) {
		var auditSobjectType = "Audit__c";
		var auditSystemFieldName = "System__c";
        // Prepare a new LDS record from Audit__c template
        component.find("auditCreator").getNewRecord(
            auditSobjectType, // sObject type (objectApiName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
            	// record template init callback
                var rec = component.get("{!v.newAudit}");
                var error = component.get("{!v.createAuditError}");
                if(error || (rec === null)) {
                    return;
                }
            })
        );
    },

	buttonDispatcher : function(component, event, helper) {
		// get aura:id from button clicked
		var buttonId = event.getSource().getLocalId();
		// create Audit, Review, Uar Users, Reviewers, Reviewer Lines
		helper.handleButtonClick(component, buttonId);
	},
})