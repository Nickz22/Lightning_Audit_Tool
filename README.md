# Lightning_Audit_Tool
User Access Review tool /  Lightning Component front-end --> Apex backend.

This enterprise tool was made for the specific purpose of auditing User's Saleforce Access. It has the following features:

<ol>
  <li> Show a Logged-In Reviewer all of their report's (according to Salesforce <b>ManagerId</b> field) aggregated Salesforce access (Object <b>and</b> System Permissions). </li>


*Context*

* The current Salesforce UAR is heavily dependent on manual effort and attention, making it prone to error and difficult to scale.
* It's hard for reviewers to understand the context behind a particular Salesforce User's object-level access given the resources (https://docs.google.com/spreadsheets/d/1rpHuXkDSqEcuV2MSgm3-os4U6vwCgxnXDmmJk25zcWw/edit#gid=690162078) currently provided.

*Goals *

* Automate the Salesforce User Access Review, including:
    * UAR Kickoff Email to Reviewers
    * UAR Reviewer Reminder Emails
    * Programmatic presentation of point-in-time reviewee (https://en.oxforddictionaries.com/definition/reviewee)'s object and system permissions
* Enable a more effective security evaluation by Reviewers.
* Leverage Salesforce's existing Workday integration to maintain the most current User list, relieving the UAR preparer of VLOOKUP-ing to combine data from both systems (https://docs.google.com/spreadsheets/d/1rpHuXkDSqEcuV2MSgm3-os4U6vwCgxnXDmmJk25zcWw/edit#gid=1907152737).
* Export review results from within Salesforce. 

*Potential Challenges/Limitations*

* Not all Reviewers have Salesforce access.
    * -Preparer can remediate in the short term by exporting a filtered Review Line Item report from Salesforce at the beginning of the UAR for external review by Reviewers who aren't in Salesforce.-
    * -Query to filter by: [SELECT Id FROM Review_Line_Item__c WHERE Reviewer__c = NULL]-
    * We can also purchase *Lightning Platform Starter *licenses (cheaper than regular licenses (https://www.salesforce.com/editions-pricing/platform/)) for Users who don't have access to Salesforce.
* The dynamically filtered page layout on the home page only lists up to 15 Review Line Items at once. Reviewer should refresh the list-view to show the next batch of pending reviews.
    

Privacy & Security Review

Approver	Approved	Date
Angela Bertrand	0	
David Ortiz	0	
Julie Su	0	
Carlos Moran		
Dhiraj Makhijani		

*Specification (Functional Requirements)*

Use Cases/Job Stories

1. As a Reviewer I should receive automated updates about the beginning, middle and end of the User Access Review.
2. As a Reviewer, I should be shown a reviewee's object/system permissions in a digestible UI, so I can focus on analyzing the content rather than finding it.
3. As a UAR Preparer I should only have to initiate the Audit in Salesforce, and then export a .csv of the User Access Review into the audit workbook.

Functional requirements

See JIRA epic (https://jira.sc-corp.net/browse/SFDC-2192) containing functional tasks completed as a part of this project.

Objects

Schema

[Image: Screen Shot 2018-11-15 at 6.37.25 PM.png]
Audit Object

* Top-level object with two direct child objects; Review and UAR User. 
* Holds dates corresponding to the User Access Review lifecycle. 
* Multiple System reviews can be contained in one Audit via the *Audit System *field.
* Current Audit is designated via the *Active* field. 

Field Label	API Name	Data Type
Action Items Finalized By (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIL/view)	Action_Items_Finalized_By__c	Date
Action Items Validated By (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIM/view)	Action_Items_Validated_By__c	Date
Active (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQWD/view)	Active__c	Checkbox
Audit Name (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/Name/view)	Name	Text(80)
Audit System (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIV/view)	System__c	Picklist (Multi-Select)
Finalize/Communicate Review Listing By (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIN/view)	Finalize_Communicate_Review_Listing_By__c	Date
Generate Account and Role Listings By (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIO/view)	Generate_Account_and_Role_Listings_By__c	Date
Link to Workbook (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIP/view)	Link_to_Workbook__c	Formula (Text)
List Generation IPE Evidence (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIQ/view)	List_Generation_IPE_Evidence__c	Formula (Text)
Obtain System Lists by (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIR/view)	Obtain_System_Lists_by__c	Date
Prepared By (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIS/view)	Prepared_By__c	Lookup(User)
Review Listing Finalized by Reviewer(s) (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIT/view)	Review_Listing_Finalized_by_Reviewer_s__c	Date
Sheets Link (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIU/view)	Sheets_Link__c	URL(255)
UAR Control Process Complete (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pU/FieldsAndRelationships/00N11000001NQIW/view)	UAR_Control_Process_Complete__c	Formula (Date)

Review Object

* Child of *Audit *object.
* Parent of *Reviewer*, *UAR User *and *Review Lines*.
* Represents an instance of a User Access Review for a particular system.
    * One Audit can consist of multiple Reviews of different systems, hence the one-to-many relationship with the Audit object.

Field Label	API Name	Data Type
Audit (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pW/FieldsAndRelationships/00N11000001NQIH/view)	Audit__c	Master-Detail(Audit)
Review Name (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pW/FieldsAndRelationships/Name/view)	Name	Text(80)
System List Generated Date (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pW/FieldsAndRelationships/00N11000001NQIh/view)	System_List_Generated_Date__c	Date
Terminated Users identified by Preparer? (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pW/FieldsAndRelationships/00N11000001NQIi/view)	Terminated_Users_identified_by_Preparer__c	Checkbox

UAR User Object

* Child of *Review *object.
* Parent of *Review Line *and *User Permission Snapshot*.
* Represents a user who's access is being evaluated as a part of the parent Review.
* The Salesforce UAR Tool automatically creates one UAR User for every active Salesforce user on initialization of an Audit.
* Each user's reviewer is dictated by their *Manager *field in Salesforce.

Field Label	API Name	Data Type
Audit (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pZ/FieldsAndRelationships/00N11000001NQIK/view)	Audit__c	Master-Detail(Audit)
Email (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pZ/FieldsAndRelationships/00N11000001NQIm/view)	Email__c	Email (External ID)
Employee Job Title (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pZ/FieldsAndRelationships/00N11000001NQIn/view)	Employee_Job_Title__c	Formula (Text)
Employee Number (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pZ/FieldsAndRelationships/00N11000001NQIo/view)	Employee_Number__c	Text(10) (External ID)
Employee Profile (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pZ/FieldsAndRelationships/00N11000001NQIp/view)	Employee_Profile__c	Formula (Text)
First Name (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pZ/FieldsAndRelationships/00N11000001NQIq/view)	First_Name__c	Text(50)
Last Name (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pZ/FieldsAndRelationships/00N11000001NQIs/view)	Last_Name__c	Text(50)
Reviewer (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pZ/FieldsAndRelationships/00N11000001NQIt/view)	Reviewer__c	Lookup(Reviewer)
User (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pZ/FieldsAndRelationships/00N11000001NQIu/view)	User__c	Lookup(User)
User Name (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pZ/FieldsAndRelationships/Name/view)	Name	Text(80)

Reviewer Object

* Child of *Review *object.
* Parent of *Review Line Item *and *UAR User *object.
* Represents a user with at least one UAR User to review.
* Salesforce creates a Reviewer for every unique User in the Manager field of all Active Salesforce Users.

Field Label	API Name	Data Type
Email (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pX/FieldsAndRelationships/00N11000001NQW8/view)	Email__c	Email
Review (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pX/FieldsAndRelationships/00N11000001NQII/view)	Review__c	Master-Detail(Review)
Reviewer Name (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pX/FieldsAndRelationships/Name/view)	Name	Text(80)
User (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pX/FieldsAndRelationships/00N11000001NQIj/view)	User__c	Lookup(User)

Review Line Object

* Junction Object (https://developer.salesforce.com/forums/?id=906F000000091mrIAA) between *Reviewer* and *UAR User* objects.
* Salesforce creates a Review Line for every UAR User in the current audit.
* Reviewers will work with their Review Lines in the application through a filtered list view.

Field Label	API Name	Data Type
Approval Date (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQIX/view?0.source=alohaHeader)	Approval_Date__c	Date/Time
Comments (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQIY/view?0.source=alohaHeader)	Comments__c	Text Area(255)
Employee (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQIG/view?0.source=alohaHeader)	Employee__c	Master-Detail(UAR User)
Employee Cost Center (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQIZ/view?0.source=alohaHeader)	Employee_Cost_Center__c	Formula (Text)
Employee Job Title (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQIa/view?0.source=alohaHeader)	Employee_Job_Title__c	Formula (Text)
Employee Name (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NZGr/view?0.source=alohaHeader)	UarUserName__c	Formula (Text)
Employee Number (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQIb/view?0.source=alohaHeader)	Employee_Number__c	Formula (Text)
Employee Profile (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQIc/view?0.source=alohaHeader)	Employee_Profile__c	Formula (Text)
IA Comment (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQId/view?0.source=alohaHeader)	IA_Comment__c	Text Area(255)
Is Access Needed? (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQIe/view?0.source=alohaHeader)	Is_Access_Needed__c	Picklist
Is Reviewer and User same? (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQIf/view?0.source=alohaHeader)	Is_Reviewer_and_User_same__c	Formula (Text)
Is Reviewer Logged In? (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQWh/view?0.source=alohaHeader)	Is_Reviewer_Logged_In__c	Formula (Checkbox)
Line Name (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/Name/view?0.source=alohaHeader)	Name	Text(80)
Reviewer (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E7pV/FieldsAndRelationships/00N11000001NQIg/view?0.source=alohaHeader)	Reviewer__c	Lookup(Reviewer)


User Permissions Snapshot

* Child of *UAR User* and *Review *objects.
* Point-in-time snapshot of a User's permissions at time of Audit creation.
* Used for *Object Access Information *card lightning component.

Field Label	API Name	Data Type
Delete Access (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E93x/FieldsAndRelationships/00N11000001Nf4F/view)	Delete_Access__c	Picklist (Multi-Select)
Edit Access (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E93x/FieldsAndRelationships/00N11000001Nf4A/view)	Edit_Access__c	Picklist (Multi-Select)
Modify All Access (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E93x/FieldsAndRelationships/00N11000001Nf4P/view)	Modify_All_Access__c	Picklist (Multi-Select)
Name (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E93x/FieldsAndRelationships/Name/view)	Name	Text(80)
Read Access (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E93x/FieldsAndRelationships/00N11000001Nf45/view)	Read_Access__c	Picklist (Multi-Select)
System Permissions (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E93x/FieldsAndRelationships/00N11000001Nf4U/view)	System_Permissions__c	Picklist (Multi-Select)
UAR User (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E93x/FieldsAndRelationships/00N11000001NhUB/view)	UAR_User__c	Lookup(UAR User)
User (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E93x/FieldsAndRelationships/00N11000001NhU1/view)	User__c	Lookup(User)
View All Access (https://snapchat--nick2.lightning.force.com/lightning/setup/ObjectManager/01I11000000E93x/FieldsAndRelationships/00N11000001Nf4K/view)	View_All_Access__c	Picklist (Multi-Select)

Process Map

[Image: Screen Shot 2018-11-18 at 5.05.48 PM.png]
Code

Launch Audit Wizard

Code as of: 11/18/2018
Lightning Component (https://github.sc-corp.net/Salesforce/Salesforce/blob/feature/nov-18-cleanup/src/aura/CreateAudit/CreateAudit.cmp)
The *Launch Audit Wizard *is a simple button-launched form whose contents are used to initiate a new Audit record in Salesforce. Component visibility configuration (https://help.salesforce.com/articleView?id=lightning_page_components_visibility.htm&type=5) ensures the *Launch Audit Wizard *is hidden from non-Administrator Salesforce users. 

Saving an Audit via the *Launch Audit Wizard* triggers code (https://github.sc-corp.net/Salesforce/Salesforce/blob/feature/nov-18-cleanup/src/classes/initAuditReview.cls) responsible for creating Audit__c children records: Review__c, UAR_User__c, Reviewer__c and Review_Line__c. Then, Salesforce queues (https://github.sc-corp.net/Salesforce/Salesforce/blob/feature/stateful-permissions-changes-v2/src/classes/createPermissionSnapshots.cls)this code (https://github.sc-corp.net/Salesforce/Salesforce/blob/feature/Stateful-permissions-changes-v1/src/classes/createPermissionSnapshots.cls) to run the main permission aggregation algorithm (see findUarUserAccess method in this class (https://github.sc-corp.net/Salesforce/Salesforce/blob/feature/nov-18-cleanup/src/classes/InitAuditUtility.cls)) before queueing a second class (https://github.sc-corp.net/Salesforce/Salesforce/blob/feature/nov-18-cleanup/src/classes/initPermissionSnapshots.cls) that uses the aggregated permission state to create User_Permissions_Snapshot__c records. After creating the new snapshots, this class (https://github.sc-corp.net/Salesforce/Salesforce/blob/feature/nov-18-cleanup/src/classes/getSnapshotSystemPermissions.cls) gets queued to update those snapshots with system permissions (see System_Permissions__c in User_Permissions_Snapshot__c object description above). The last class continues to re-queue itself until all of the new snapshots are updated. 
[Image: Screen Shot 2018-11-14 at 9.07.47 PM.png][Image: Screen Shot 2018-11-14 at 9.05.12 PM.png]
Permission Information card

Code as of: Sunday, November 18
*Parent (https://github.sc-corp.net/Salesforce/Salesforce/tree/feature/refactor-session-1/src/aura/UserPermissionsView)Lightning Component (https://github.sc-corp.net/Salesforce/Salesforce/blob/feature/Stateful-permissions-changes-v1/src/aura/CreateAudit/CreateAudit.cmp) + Child Lightning Component (https://github.sc-corp.net/Salesforce/Salesforce/blob/feature/nov-18-cleanup/src/aura/ObjectPrivilege/ObjectPrivilege.cmp)*
This component triggers code (https://github.sc-corp.net/Salesforce/Salesforce/blob/feature/nov-18-cleanup/src/classes/GetProfilePermissions.cls) on initialization which queries existing User_Permission_Snapshot__c records. It filters these results to show only the snapshots belonging to reviewees of the logged-in reviewer. The reviewer can toggle between Object and System permissions by clicking the User's name.
[Image: Screen Shot 2018-11-18 at 4.14.45 PM.png][Image: Screen Shot 2018-11-18 at 4.15.39 PM.png]
Review Guide

Code as of: Wednesday, November 14
*Lightning Components (https://github.sc-corp.net/Salesforce/Salesforce/tree/feature/Stateful-permissions-changes-v1/src/aura)* (see all files appended with “AccessInfo”)
*https://snapchat.quip.com/zJfUA1aw8PlX*
This component is responsible for contextualizing in-scope objects in an effort to better inform reviewers of the object access they're approving. A reviewer can access the review guide via the lightning application's utility bar.
[Image: Screen Shot 2018-11-14 at 9.27.23 PM.png][Image: Screen Shot 2018-11-14 at 9.27.33 PM.png]
Data Access

This application will use native Salesforce security configuration (namely Sharing Settings and Profiles) to ensure Reviewers only see and access the records they need to. It should ensure that all changes made by System Administrators are tracked and logged with native Salesforce field history reporting.

Reviewer Access

Reviewers will only ever have Edit access to Review Line Items (and Read access to all other objects). Furthermore, they will only ever have access to edit their own Review Line Items. This sharing/security architecture will be implemented with a combination of Sharing Setting (https://help.salesforce.com/articleView?id=managing_the_sharing_model.htm&type=5) and user Profile (https://help.salesforce.com/articleView?id=admin_userprofiles.htm&type=5) configuration.
[Image: Screen Shot 2018-11-19 at 9.26.39 PM.png]
administrator monitoring

[Image: Screen Shot 2018-11-19 at 10.09.00 PM.png]Because Administrators can simply alter any configurations made to stop them from editing UAR records, this application will instead report on all changes made to Review Line Item fields of interest (i.e. *Is Access Needed?*, *Approval Date*, *Comments*). This field history (https://help.salesforce.com/articleView?id=tracking_field_history.htm&type=5) report will be generated at the end of every UAR as evidence that there was no Administrator tampering with the review's results. Internal Audit will verify the results of this report to validate UAR results.
