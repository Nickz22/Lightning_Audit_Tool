public class initAuditReview {

	public class initAuditReviewException extends Exception {}

	// initialize some text variables
	static final String REVIEW_NAME = ' User Access Review';
	static final String NO_USER_ERROR = 'no Active Users found';
	static final String NO_REVIEWER_USER_ERROR = 'Couldn\'t find Reviewers on UAR_User records';
	static final String NO_AUDIT_ERROR = 'there doesn\'t seem to be an active audit';
	static final String AUTO_PROC_EMAIL = initAuditUtility.getAutoProcUserEmail();
	static final String EMPTY_UAR_USER_LIST_ERROR = 'no UAR Users passed to Review Lines method';
	
	/*
   * @author          Nick Zozaya
     * @description     Dispatch DML operations as a result of Audit__c creation.
   * @return          void
     * @param           String auditId
     */
	@AuraEnabled
	public static void createAuditObjects(String auditId){
/*
 * init records associated with new audit
*/

		// create Review__c
		String reviewId = createAuditReview(auditId);

		// create Reviewer__c records
		List<Reviewer__c> newReviewers = createReviewers(reviewId);

		// create Uar_User__c records, return their Ids and related PermissionSetAssignments
		Map<List<String>, List<PermissionSetAssignment>> idToPermSetMap = createUARUsers(reviewId);

		// keep map key here
		Set<String> userIds = new Set<String>();

		// access singleton list map key
		for(List<String>  newUarUserIds : idToPermSetMap.keyset()){	

			if(!Test.isRunningTest()){

				for(UAR_User__c uarUser : [SELECT Id, User__c FROM UAR_User__c WHERE Id IN: newUarUserIds]){
					userIds.add(uarUser.User__c);
				}
			}else{

				// lower user list size for test class
				for(UAR_User__c uarUser : [SELECT Id, User__c FROM UAR_User__c WHERE Id IN: newUarUserIds LIMIT 1]){
					userIds.add(uarUser.User__c);
				}

			}

			// create Review_Line_Item__c for each uar user
			createReviewLines(newUarUserIds);
		}

/*
 * end init records associated with new audit
*/

/*
 * get ObjectPermissions and PermissionSetAssignments 
*/
		// get uar user ObjectPermissions
		List<ObjectPermissions> allObjectPermissions = initAuditUtility.getAllObjectPermissions(userIds);

/*
 * end get ObjectPermissions and Permission Set Assignments
*/

		Map<Map<String, String>, List<Map<String, String>>> nameToPermissionMap = new Map<Map<String, String>, List<Map<String, String>>>();

		if(!Test.isRunningTest()){

			// aggregate object-permissions at user level
			System.enqueueJob(new aggregateObjectPermissions(allObjectPermissions, idToPermSetMap.values()[0], nameToPermissionMap));

		}else{

			/*
			 * only runs during test
			*/

			// aggregate object-permissions at user level
			System.enqueueJob(new aggregateObjectPermissions(allObjectPermissions, idToPermSetMap.values()[0], nameToPermissionMap));

			nameToPermissionMap = initAuditUtility.findUarUserAccess(allObjectPermissions, idToPermSetMap.values()[0], nameToPermissionMap);

			// create permission snapshot records
        	System.enqueueJob(new initPermissionSnapshots(nameToPermissionMap));
        	// to update System_Permissions__c, return new User Permission Snapshots    
	        Map<Id, User_Permissions_Snapshot__c> newSnapshots = initAuditUtility.newSnapshotPermissions(nameToPermissionMap);
	        // init batch container
			Map<Id, User_Permissions_Snapshot__c> batchedSnapshots = new Map<Id, User_Permissions_Snapshot__c>();	        
			// queue batch update
	        System.enqueueJob(new getSnapshotSystemPermissions(batchedSnapshots, newSnapshots));

		}
	}

	/*
   * @author          Nick Zozaya
     * @description     Create Review__c record
   * @return          String
     * @param           String auditId
     */
	public static String createAuditReview(String auditId) {
		
		// find Audit created by audit preparer
		Audit__c parentAudit = [SELECT Id, Name, System__c FROM Audit__c WHERE Id=: auditId AND Active__c = true];
		
		// sanity check to ensure there is an audit
		if(parentAudit != null){

			// init new Review
			Review__c newReview = new Review__c(
										Audit__c = parentAudit.Id,
										Name = parentAudit.Name+REVIEW_NAME,
										System_List_Generated_Date__c = Date.today()
										);

			insert newReview;
			return newReview.Id;

		}else{

			// audit wasnt initiated correctly
			throw new initAuditReviewException(NO_AUDIT_ERROR);

		}
	}

	/*
   * @author          Nick Zozaya
     * @description     Create Reviewer__c records
   * @return          void
     * @param           String auditId
     */
	public static List<Reviewer__c> createReviewers(String reviewId){

			// isolate unique manager Ids 
			Set<Id> reviewerUserIds = new Set<Id>();

			// find manager ids
			for (User revUser : [SELECT ManagerId FROM User WHERE IsActive = TRUE AND ManagerId != null]){

				reviewerUserIds.add(revUser.ManagerId);
			}

			// init Reviewer__c insert list
			List<Reviewer__c> newReviewers = new List<Reviewer__c>();

			Reviewer__c newReviewer = new Reviewer__c();

			if(!Test.isRunningTest()){
				// loop through all Reviewer Users
				for(User reviewer : [SELECT FirstName, LastName, Email, Id FROM User WHERE Id IN: reviewerUserIds]){

					newReviewer = new Reviewer__c(
										Name = reviewer.FirstName + ' ' + reviewer.LastName,
										User__c = reviewer.Id,
										Review__c = reviewId,
										Email__c = reviewer.Email
										); 

					// add the new Reviewer__c to insert list
					newReviewers.add(newReviewer);
				}
			}else{
				// loop through all Reviewer Users
				for(User reviewer : [SELECT FirstName, LastName, Email, Id FROM User WHERE Id IN: reviewerUserIds LIMIT 1]){

					newReviewer = new Reviewer__c(
										Name = reviewer.FirstName + ' ' + reviewer.LastName,
										User__c = reviewer.Id,
										Review__c = reviewId,
										Email__c = reviewer.Email
										); 
					}

				// add the new Reviewer__c to insert list
				newReviewers.add(newReviewer);

			}
			insert newReviewers;
			return newReviewers;
	}

	/*
   * @author          Nick Zozaya
     * @description     Create Uar_User__c records
   * @return          Map<List<String>, List<PermissionSetAssignment>>
     * @param           String reviewId
     */
	public static Map<List<String>, List<PermissionSetAssignment>> createUARUsers(String reviewId){

		// grab review for uar user creation
		Review__c currentReview = [SELECT Id, Audit__r.Active__c FROM Review__c WHERE Id=: reviewId AND Audit__r.Active__c = true LIMIT 1];

		Map<Id, User> activeUsers = new Map<Id, User>();

		if(!Test.isRunningTest()){

			// find active Users
			activeUsers = new Map<Id, User>([SELECT Id, Email, EmployeeNumber, FirstName, LastName, ManagerId, LastLoginDate FROM User WHERE IsActive = TRUE AND Email !=: AUTO_PROC_EMAIL AND FirstName != null]);

		}else{
		   /*
			 * when testing, only query 300 Users
			*/
			activeUsers = new Map<Id, User>([SELECT Id, Email, EmployeeNumber, FirstName, LastName, ManagerId, LastLoginDate FROM User WHERE IsActive = TRUE AND Email !=: AUTO_PROC_EMAIL AND FirstName != null LIMIT 300]);

		}

		// use a set for apex bind var
		Set<Id> reviewerIds = activeUsers.keyset();

		// ensure we found users
		if(reviewerIds.size()>0){

			List<Reviewer__c> allReviewers = new List<Reviewer__c>();

			if(!Test.isRunningTest()){

				// get active reviewers
				allReviewers = [SELECT Id, User__c FROM Reviewer__c WHERE User__c IN: reviewerIds AND Review__r.Audit__r.Active__c = true];

			}else{

				allReviewers = [SELECT Id, User__c FROM Reviewer__c WHERE Review__r.Audit__r.Active__c = true LIMIT 1];
			}

			// map {Reviewer.User__c => Reviewer.Id}
			Map<Id, Id> userToReviewer = new Map<Id, Id>();

			// loop thru found reviewers
			for(Reviewer__c reviewer : allReviewers){

				userToReviewer.put(reviewer.User__c, reviewer.Id);

			}

			// initialize UAR User insert list
			List<UAR_User__c> uarUsers = new List<UAR_User__c>();

			// init key of return map
			List<String> uarUserIds = new List<String>();

			// hold user Ids for apex bind var
			List<String> uar_UserIds = new List<String>();

			// create a UAR_User for every User
			for(User u : activeUsers.values()){

				UAR_User__c uarUser = new Uar_User__c();
				if(!Test.isRunningTest()){

					// init the UAR_User record
					uarUser = new UAR_User__c(
									User__c = u.Id,
									Email__c = u.Email,
									Employee_Number__c = u.EmployeeNumber,
									First_Name__c = u.FirstName,
									Last_Name__c = u.LastName,
									Name = u.FirstName + ' ' + u.LastName,
									Review__c = reviewId,
									Reviewer__c = userToReviewer.get(u.ManagerId) 
									);
				}else{

					// test scenario
					uarUser = new UAR_User__c(
												User__c = u.Id,
												Email__c = u.Email,
												Employee_Number__c = u.EmployeeNumber,
												First_Name__c = u.FirstName,
												Last_Name__c = u.LastName,
												Name = u.FirstName + ' ' + u.LastName,
												Review__c = reviewId,
												Reviewer__c = allReviewers[0].Id 
												);
				}

				// add UAR_User to list
				uarUsers.add(uarUser);
			}
			insert uarUsers;

			/*
			 * to filter PermissionSetAssignments, take some info from uar users
			*/
			for(UAR_User__c u : uarUsers){
				uar_UserIds.add(u.User__c);
				uarUserIds.add(u.Id);
			}

			// find PermissionSetAssignments for uar users
			List<PermissionSetAssignment> revieweePermissionSetAssignments = [SELECT AssigneeId, PermissionSetId, Assignee.Name FROM PermissionSetAssignment WHERE Assignee.Id IN: uar_UserIds ORDER BY PermissionSetId];

			// init return map
			Map<List<String>, List<PermissionSetAssignment>> uarUserIdsToPermSetAssignment = new Map<List<String>, List<PermissionSetAssignment>>{uarUserIds => revieweePermissionSetAssignments};
			
			return uarUserIdsToPermSetAssignment;

		}else{

			// didn't find any Active Users
			throw new initAuditReviewException(NO_USER_ERROR);

			}
	}

	/*
   * @author          Nick Zozaya
     * @description     Create Review_Line_Item__c records
   * @return          Map<List<String>, List<PermissionSetAssignment>>
     * @param           String reviewId
     */
	public static List<Review_Line__c> createReviewLines(List<String> uarUserIds){

		// get uar users
		List<UAR_User__c> uarUsers = [SELECT Id, Reviewer__c, Reviewer__r.User__c, Review__c, User__r.LastLoginDate FROM UAR_User__c WHERE Id IN: uarUserIds];

		User preparer = [SELECT Id FROM User WHERE Id=: System.Label.Audit_Preparer_Id];
		// ensure non-empty list
		if(uarUsers.size()>0){

			// isolate reviewerIds -----> don't know what this is doing here
			Set<Id> reviewerIds = new Set<Id>();
			for(UAR_User__c uarUser : uarUsers){
				reviewerIds.add(uarUser.Reviewer__c);
			}

			// init return list
			List<Review_Line__c> newReviewLines = new List<Review_Line__c>();

			// loop thru uar users
			for(UAR_User__c uarUser : uarUsers){

				// init Review Line last login date
       			Date lastLoginDate;

       			// if there's a last login date, populate lastLoginDate
				if(uarUser.User__r.LastLoginDate != null) lastLoginDate = date.newInstance(uarUser.User__r.LastLoginDate.year(), uarUser.User__r.LastLoginDate.month(), uarUser.User__r.LastLoginDate.day());

				// create review line
				Review_Line__c newReviewLine = new Review_Line__c(
													Name        = 'x', // will be set via Review Line Handler Process Builder
													Employee__c = uarUser.Id,
													Reviewer__c = uarUser.Reviewer__c,
													Review__c = uarUser.Review__c,
													Last_Login_Date__c = lastLoginDate, 
													OwnerId = uarUser.Reviewer__r.User__c
													);
				if(newReviewLine.OwnerId == null){ 

					newReviewLine.OwnerId = preparer.Id;
				}

				// add new review line to return list
					newReviewLines.add(newReviewLine);

			}

			insert newReviewLines;
			return newReviewLines;

		}else{

			// there are no uar users to create review lines from
			throw new initAuditReviewException(EMPTY_UAR_USER_LIST_ERROR);
		
		}
	}
}