({
	initAccessMaps : function(objSet, objLabel, permSnapshot){

		if(objSet.has(objLabel)){
			var objAccessMap = new Map([
										['SObjectType', objLabel],
										['Read_Access', 'false'], 
										['Edit_Access', 'false'], 
										['Delete_Access', 'false']
									  ]);
			if(permSnapshot.Read_Access__c.includes(objLabel)) objAccessMap.set('Read_Access__c', 'true');
			if(permSnapshot.Edit_Access__c.includes(objLabel)) objAccessMap.set('Edit_Access__c', 'true');
			if(permSnapshot.Delete_Access__c.includes(objLabel)) objAccessMap.set('Delete_Access__c', 'true');

		}
		return objAccessMap
	}
})