({
	handleSysPermClick : function(component, event, helper) {
		
		var sysPermsExposed = component.get("{!v.getSysPermissions}");

		if(sysPermsExposed) {

			component.set("{!v.getSysPermissions}", false);
			component.set("{!v.sideCardText}", 'Object Permissions')	
		}
		
		if(!(sysPermsExposed)){

			var snapshot = component.get("{!v.permissionSnapshot}");
			var truePermissions;

			if(snapshot.System_Permissions__c != null) truePermissions = snapshot.System_Permissions__c.split(';');

			var returnMap = [];

			if(truePermissions != null){

				for(var perm of truePermissions){

					returnMap.push({key:perm});
				}
			}

			component.set("{!v.sysPermissionsList}", returnMap);
			component.set("{!v.getSysPermissions}", true);
			component.set("{!v.sideCardText}", 'System Permissions');
		}

	},

	handleMouseOver : function(component, event, helper){

		$A.util.removeClass(component.find("titleDiv"), "mouseout");
		$A.util.addClass(component.find("titleDiv"), "mouseover");
	}, 

	handleMouseOverAccessCard : function(component, event, helper){

		$A.util.removeClass(component.find("vertical-text"), "vertical-text");
		$A.util.addClass(component.find("vertical-text"), "mouseover-vertical-text");
	},

	handleMouseOffAccessCard : function(component, event, helper){

		$A.util.removeClass(component.find("vertical-text"), "mouseover-vertical-text");
		$A.util.addClass(component.find("vertical-text"), "vertical-text");
	},

	handleMouseOff : function(component, event, helper){

		$A.util.addClass(component.find("titleDiv"), "mouseout");
	}
})