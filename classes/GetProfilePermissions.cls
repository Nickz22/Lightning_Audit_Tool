public with sharing class GetProfilePermissions {

	@AuraEnabled
	public static List<User_Permissions_Snapshot__c> returnPermissions(){

		// find existing UarUsers with active Audit
		Set<String> uarUsers = findUarUsers();

		return getPermissionSnapshots(uarUsers);

	}

	/*
   * @author          Nick Zozaya
     * @description     Method to find Reviewer's UAR reviewees based on $User.Id
   * @return          Set<String>
     * @param           
     */
	public static Set<String> findUarUsers(){

		// init return Set
		Set<String> userIds = new Set<String>();

		// get logged-in user's Id
		String reviewerUserId = UserInfo.getUserId();

		// find all relevant uarUsers via reviewer Id
		for(UAR_User__c uarUser : [SELECT Id, Review__r.Audit__r.Active__c, Reviewer__r.User__r.Id FROM UAR_User__c WHERE Review__r.Audit__r.Active__c = true AND Reviewer__r.User__r.Id =: reviewerUserId]){

			// add uarUser.User to return set
			userIds.add(uarUser.Id);

		}

		//return list of UserIds to main method
		return userIds;
	}

	/*
   * @author          Nick Zozaya
     * @description     Method to retrive current reviewer's reviewee snapshots
   * @return          List<User_Permissions_Snapshot__c>
     * @param           Set<String>
     */
	public static List<User_Permissions_Snapshot__c> getPermissionSnapshots(Set<String> uarUserIds){

		// return filtered list of permission snapshots
		return [SELECT Name, Uar_User__r.Reviewer__r.User__r.Id, Uar_User__c, Read_Access__c, Edit_Access__c, Delete_Access__c, View_All_Access__c, Modify_All_Access__c, System_Permissions__c FROM User_Permissions_Snapshot__c WHERE Uar_User__c IN: uarUserIds];

	}
}