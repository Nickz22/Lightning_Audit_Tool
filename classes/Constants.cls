/*
Class Name      : Constants
Description     : This is TriggerHandler Framework
Created By      : AJ Deshmukh
Created Date    : Aug 14, 2017
Modification Log:
----------------------------------------------------------------------------------
Developer                   Date                   Description
----------------------------------------------------------------------------------
AJ Deshmukh                 Aug 14, 2017            Initial Version
AJ Deshmukh                 Aug 23, 2017            Added Strings constants for opportunity and other
AJ Deshmukh                 Sep 06, 2017            Added CaseTeamRole constant for CaseTriggerHandler
AJ Deshmukh                 Oct 11, 2017            Added Opportunity and Agreement__c related constants
Mark Klinski                Oct 26, 2017            Adding Non Pod singleton
AJ Deshmukh                 Nov 15, 2017            Added Placement__c related constants
AJ Deshmukh                 Jan 02, 2018            Added Json_Payload__c, IntegrationPayloadManager constants
Mark Klinski                Feb 22, 2018            Added singletons for Opp Product record type IDs
Badri B                     Jun 11, 2018            Added Placed related constants
Badri B                     July 25, 2018           Adding Managed package updates
Badri B                     Aug 6, 2018             Adding Unassigned owner
Nick Zozaya                 Sep 19, 2018            Adding Case, Account record type names
Badri B                     Oct 3, 2018             SFDC-2054 Adding the placed integration user
*/
public with sharing class Constants {
    /*
     * Custom Metadata Type: TriggerHandlerRegisters
    */
    public static final String TRIGGER_HANDLER_REGISTER_OBJ = 'TriggerHandlerRegister__mdt';
    public static final String TRIGGER_HANDLER_ACTIVE_FLD = 'Active__c';
    public static final String TRIGGER_HANDLER_APEX_CLASS_FLD = 'ApexClass__c';
    public static final String TRIGGER_HANDLER_ORDER_OF_EXECUTION_FLD = 'OrderOfExecution__c';
    
    /*
     * URL
    */
    public static final String SFDC_BASE_URL = URL.getSalesforceBaseUrl().toExternalForm();

    /*
     * Managed-Package
     */
    public static final String MEASUREMENT_TOKEN_NAME = 'Measurement_Api';

    /*
     * Object: Case
    */
    public static final String CASE_OBJ = 'Case';
    public static final String CASE_ADVERTISER_RT = 'Advertiser Request';
    public static final String CASE_AGENCY_RT = 'Agency Request';
    public static final String CASE_AGENCY_UPFRONT_RT = 'Upfront - Agency Requests';
    public static final String CASE_ADVERTISER_UPFRONT_RT = 'Upfront - Advertiser Request';    
    public static final String CASE_GENERAL_REQUEST_RT = 'Salesforce Help';
    public static final String CASE_MEASUREMENT_STUDY_RT = 'Measurement Study';
    public static final String CASE_STATUS_COMPLETED = 'Completed';
    public static final String CASE_STATUS_CANCELLED = 'Cancelled';
    public static final String CASE_STATUS_APPROVED = 'Approved';
    public static final String CASE_STATUS_DECLINED = 'Declined';
    public static final String CASE_RECALCULATE_EPOCH_TIME = 'Recalculate_Epoch_Time';

    /*
     * Object: CaseTeamRole
    */
    public static final String CASETEAMROLE_ROLE_CREATOR = 'Case Creator';

    /*
     * Object: Account
    */
    public static final String ACCOUNT_OBJ = 'Account';
    public static final String ACCOUNT_ACCOUNT_RT = 'Account';
    public static final String ACCOUNT_AGENCY_RT = 'Agency';
    public static final String ACCOUNT_AGENCY_GROUP_RT = 'Agency Group';
    public static final String ACCOUNT_HOLDING_CO_RT = 'Holding Company';

    /*
     * Object: Ad_Account__c
    */

    public static final String ADACCT_OBJ = 'Ad_Account__c';
    public static final String ADACCT_LABEL = 'Ad Account';

    /*
     * Object: Brand__c
    */

    public static final String BRAND_OBJ = 'Brand__c';
    public static final String BRAND_LABEL = 'Brand';

    /*
     * Object: Contact
    */
    public static final String CONTACT_ENTERPRISE_DEVNAME_RT = 'Enterprise_Contact';
    public static final String CONTACT_INDIVIDUAL_DEVNAME_RT = 'Individual_Contact';

    /*
     * Object: Contract
     */
    public static final String CONTRACT_POPULATE_ACTIVITIES = 'Activity Tracking Dummy Contract';
    public static final String CONTRACT_STATUS_DRAFT = 'Draft';

    /*
     * Object: Opportunity
    */
    public static final String OPPORTUNITY_OBJ = 'Opportunity';
    public static final String OPPORTUNITY_PLACED_RT = 'Placed-Sales';
    public static final String OPPORTUNITY_ADVERTISER_GROWTH_RT = 'Advertiser Growth';
    public static final String OPPORTUNITY_ADVERTISER_ONBOARDING_RT = 'Advertiser On-boarding';
    public static final String OPPORTUNITY_DIRECT_SALES_RT = 'Direct Sales - Insertion Orders';
    public static final String OPPORTUNITY_SELF_SERVE_AD_ACCT_RT = 'Self-Serve Ad Account';
    public static final String OPPORTUNITY_SELF_SERVE_CAMPAIGN_RT = 'Self-Serve Campaign';
    public static final String OPPORTUNITY_SELF_SERVE_EVERGREEN_RT = 'Self-Serve Evergreen Advertiser';
    public static final String OPPORTUNITY_DIRECT_SALES_SELF_SERVICE_RT = 'Direct Sales - Self Service';
    public static final String OPPORTUNITY_INSIDE_SALES_SELF_SERVICE_RT = 'GOS - Self Serve Ad Account';
    public static final String OPPORTUNITY_PARTNER_SALES_DEVNAME_RT = 'Partner_Sales_Insertion_Orders';
    public static final String OPPORTUNITY_PARTNER_SALES_IO_RT = 'Partner Sales - Insertion Orders';
    public static final String OPPORTUNITY_POPULATE_UPFRONT_CHECK_FS = 'Opportunity_Upfront_Check';
    public static final String OPPORTUNITY_STAGE_PROSPECTING = 'Prospecting';
    public static final String OPPORTUNITY_POPULATE_UPFRONT_FS = 'Populate_Upfront_On_Opportunity';
    public static final String OPPORTUNITY_POPULATE_ACTIVITIES = 'Activity Tracking Dummy Opportunity';
    public static final String OPPORTUNITY_STAGE_CONVERSATION = 'Conversation';

    public static Id OPPORTUNITY_RT_ID_AD_ACCT {
        public get {
            if (OPPORTUNITY_RT_ID_AD_ACCT == null) {
                OPPORTUNITY_RT_ID_AD_ACCT = SystemUtility.getRecordTypeIdByName('Opportunity', OPPORTUNITY_SELF_SERVE_AD_ACCT_RT);
            }

            return OPPORTUNITY_RT_ID_AD_ACCT;
        }
        private set;
    }

    public static Id OPPORTUNITY_RT_ID_ADVERTISER_GROWTH {
        public get {
            if (OPPORTUNITY_RT_ID_ADVERTISER_GROWTH == null) {
                OPPORTUNITY_RT_ID_ADVERTISER_GROWTH = SystemUtility.getRecordTypeIdByName('Opportunity', OPPORTUNITY_ADVERTISER_GROWTH_RT);
            }

            return OPPORTUNITY_RT_ID_ADVERTISER_GROWTH;
        }
        private set;
    }

    public static Id OPPORTUNITY_RT_ID_ADVERTISER_ONBOARDING {
        public get {
            if (OPPORTUNITY_RT_ID_ADVERTISER_ONBOARDING == null) {
                OPPORTUNITY_RT_ID_ADVERTISER_ONBOARDING = SystemUtility.getRecordTypeIdByName('Opportunity', OPPORTUNITY_ADVERTISER_ONBOARDING_RT);
            }

            return OPPORTUNITY_RT_ID_ADVERTISER_ONBOARDING;
        }
        private set;
    }

    public static Id OPPORTUNITY_RT_ID_CAMPAIGN {
        public get {
            if (OPPORTUNITY_RT_ID_CAMPAIGN == null) {
                OPPORTUNITY_RT_ID_CAMPAIGN = SystemUtility.getRecordTypeIdByName('Opportunity', OPPORTUNITY_SELF_SERVE_CAMPAIGN_RT);
            }

            return OPPORTUNITY_RT_ID_CAMPAIGN;
        }
        private set;
    }

    public static Id OPPORTUNITY_RT_ID_DIRECT_SALES_IO {
        public get {
            if (OPPORTUNITY_RT_ID_DIRECT_SALES_IO == null) {
                OPPORTUNITY_RT_ID_DIRECT_SALES_IO = SystemUtility.getRecordTypeIdByName('Opportunity', OPPORTUNITY_DIRECT_SALES_RT);
            }

            return OPPORTUNITY_RT_ID_DIRECT_SALES_IO;
        }
        private set;
    }
  
    public static Id OPPORTUNITY_RT_ID_DIRECT_SALES_SELF_SERVICE {
        public get {
            if (OPPORTUNITY_RT_ID_DIRECT_SALES_SELF_SERVICE == null) {
                OPPORTUNITY_RT_ID_DIRECT_SALES_SELF_SERVICE = SystemUtility.getRecordTypeIdByName('Opportunity', OPPORTUNITY_DIRECT_SALES_SELF_SERVICE_RT);
            }

            return OPPORTUNITY_RT_ID_DIRECT_SALES_SELF_SERVICE;
        }
        private set;
    }
  
    public static Id OPPORTUNITY_RT_ID_EVERGREEN {
        public get {
            if (OPPORTUNITY_RT_ID_EVERGREEN == null) {
                OPPORTUNITY_RT_ID_EVERGREEN = SystemUtility.getRecordTypeIdByName('Opportunity', OPPORTUNITY_SELF_SERVE_EVERGREEN_RT);
            }

            return OPPORTUNITY_RT_ID_EVERGREEN;
        }
        private set;
    }
  
    public static Id OPPORTUNITY_RT_ID_INSIDE_SALES_SELF_SERVICE {
        public get {
            if (OPPORTUNITY_RT_ID_INSIDE_SALES_SELF_SERVICE == null) {
                OPPORTUNITY_RT_ID_INSIDE_SALES_SELF_SERVICE = SystemUtility.getRecordTypeIdByName('Opportunity', OPPORTUNITY_INSIDE_SALES_SELF_SERVICE_RT);
            }

            return OPPORTUNITY_RT_ID_INSIDE_SALES_SELF_SERVICE;
        }
        private set;
    }
  
    public static Id OPPORTUNITY_RT_ID_PARTNER_SALES_IO {
        public get {
            if (OPPORTUNITY_RT_ID_PARTNER_SALES_IO == null) {
                OPPORTUNITY_RT_ID_PARTNER_SALES_IO = SystemUtility.getRecordTypeIdByName('Opportunity', OPPORTUNITY_PARTNER_SALES_IO_RT);
            }

            return OPPORTUNITY_RT_ID_PARTNER_SALES_IO;
        }
        private set;
    }
  
  /*
     * Object: Apttus__APTS_Agreement__c
    */
    public static final String APTTUS_AGREEMENT_OBJ = 'Apttus__APTS_Agreement__c';
    public static final String APTTUS_AGREEMENT_LABEL = 'Agreement';
    public static final String APTTUS_UPFRONT_RT = 'Upfront - Agency';


    /*
     * Object: Upfront__c
    */
    public static final String UPFRONT_OBJ = 'Upfront__c';
    public static final String UPFRONT_ACCOUNT_RT = 'Account';
    public static final String UPFRONT_AGENCY_RT = 'Agency';
    public static final String UPFRONT_AGENCY_GROUP_RT = 'Agency Group';
    public static final String UPFRONT_HOLDING_CO_RT = 'Holding Company';
    public static final String UPFRONT_LABEL = 'Upfront';

    /*
     * Object: Upfront_Entity__c
    */
    public static final String UPFRONT_ENTITY_OBJ = 'Upfront_Entity__c';
    public static final String UPFRONT_ENTITY_LABEL = 'Upfront Entity';

    /*
     * User
    */
    public static final String USER_UNASSIGNED = 'Unassigned Owner';
    public static final String USER_PLACED_INTEGRATION = 'placed-integration';
    public static final String USER_OBJ = 'User';

    /*
     * Profile
    */
    public static final String ADMIN_PROFILE = 'System Administrator';
    public static final String ACCOUNT_EXECUTIVE_PROFILE = 'Account Executive';
    public static final String ACCOUNT_MANAGER_PROFILE = 'Account Manager';
    public static final String AD_OPERATIONS_PROFILE = 'Ad Operations';
    public static final String API_USER_PROFILE = 'API User';
    public static final String PLACED_PROFILE = 'Placed-Sales';

    public static Id ADMIN_PROFILE_ID {
        public get {
            if (ADMIN_PROFILE_ID == null) {
                ADMIN_PROFILE_ID = [SELECT Profile.Id FROM PermissionSet WHERE Profile.Name = :ADMIN_PROFILE AND IsCustom = false LIMIT 1].Profile.Id;
            }

            return ADMIN_PROFILE_ID;
        }
        private set;
    }

    public static Id CUSTOM_ADMIN_PROFILE_ID {
        public get {
            if (CUSTOM_ADMIN_PROFILE_ID == null) {
                CUSTOM_ADMIN_PROFILE_ID = [SELECT Profile.Id FROM PermissionSet WHERE Profile.Name=: ADMIN_PROFILE AND IsCustom = true LIMIT 1].Profile.Id;
                System.debug(CUSTOM_ADMIN_PROFILE_ID);
            }

            return CUSTOM_ADMIN_PROFILE_ID;
        }
        private set;
    }

    private static String profileName;

    /**
     * @author          Badri
     * @description     Helper method to get profile name by Id
     * @return          String
     * @param           Id profileid
     */
    public static String getProfileNameById (Id profileId) {

        if (profileName == null) {
            profileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        }
        return profileName;
    }

    /*
     * Country
    */
    public static final String COUNTRY_GLOBAL = 'Global';
    public static final String COUNTRY_USA = 'United States';
    public static final String COUNTRY_GERMANY = 'Germany';
    /*
     * Object: Upfront_Discount_Tracking__mdt
    */
    public static final String UPFRONT_DISCOUNT_TRACKING_MDT = 'Upfront_Discount_Tracking__mdt';
    public static final String UPFRONT_DISCOUNT_ADVERTISER_FLD = 'Advertiser_Upfront_Api_Name__c';
    public static final String UPFRONT_DISCOUNT_PARENT_ADVERTISER_FLD = 'Parent_Advertiser_Upfront_Api_Name__c';
    public static final String UPFRONT_DISCOUNT_AGENCY_FLD = 'Agency_Upfront_Api_Name__c';
    public static final String UPFRONT_DISCOUNT_AGENCY_GROUP_FLD = 'Agency_Group_Upfront_Api_Name__c';
    public static final String UPFRONT_DISCOUNT_HOLDING_CO_FLD = 'Holding_Company_Upfront_Api_Name__c';
    public static final String UPFRONT_DISCOUNT_DISCOUNT_FLD = 'Discount_Percentage__c';
    public static final String UPFRONT_DISCOUNT_ERROR_FLAG_FLD = 'Error_Flag_Api_Name__c';
    public static final String UPFRONT_DISCOUNT_RETURN_WRAPPER_FLD = 'Return_Wrapper_Json__c';
    public static final String UPFRONT_DISCOUNT_TRACKER_FLAG_FLD = 'Reset_Tracker_Flag_Api_Name__c';

    /*
     * Object: Placement__c
    */
    public static final String PLACEMENT_OBJ = 'Placement__c';
    public static final String PLACEMENT_LABEL = 'Placement';
    public static final String PLACEMENT_LENS_RT = 'Lens';
    public static final String PLACEMENT_SUB_CHANNEL_PUB_STORIES = 'Publisher Stories';
    public static final String PLACEMENT_INV_SUB_CHANNEL_PUB_STORIES = 'Publisher Stories';
    public static final String PLACEMENT_INV_SUB_CHANNEL_MY_STORIES = 'My Stories';
    public static final String PLACEMENT_INV_SUB_CHANNEL_MAX_REACH = 'Max Reach';
    public static final String PLACEMENT_INV_SUB_CHANNEL_MY_OUR_STORIES = 'My Stories + Our Stories (O&O)';
    public static final String PLACEMENT_INV_SUB_CHANNEL_OUR_STORIES = 'Our Stories (O&O)';
    public static final String PLACEMENT_INV_SUB_CHANNEL_OUR_STORIES_PARTNER = 'Our Stories (Partnered)';
    public static final String PLACEMENT_INV_SUB_CHANNEL_SHOWS = 'Shows';
    public static final String PLACEMENT_INV_SUB_CHANNEL_PROMOTED_STORIES = 'Promoted Stories - Large Tile';
    public static final String PLACEMENT_INV_CHANNEL_AUDIENCE = 'Audience';
    public static final String PLACEMENT_INV_CHANNEL_TAKEOVER = 'Takeover';
    public static final String PLACEMENT_PRODUCT_AUDIENCE_LENS = 'Audience Lens';
    public static final String PLACEMENT_PRODUCT_PUB_STORIES = 'Publisher Stories';
    public static final String PLACEMENT_PRODUCT_MY_STORIES = 'My Stories';
    public static final String PLACEMENT_PRODUCT_MAX_REACH = 'Max Reach';
    public static final String PLACEMENT_SUB_PRODUCT_FACE_WORLD_LENS = 'Face + World Lens';
    public static final String PLACEMENT_SUB_PRODUCT_SNAPPABLE_PERSONAL = 'Snappable + Personal';
    public static final String PLACEMENT_SUB_PRODUCT_SNAPPABLE_PERSONAL_WORLD = 'Snappable + Personal + World';
    public static final String PLACEMENT_PYM_STATUS_AUTO_APPROVED = 'Auto Approved';
    public static final String PLACEMENT_PYM_STATUS_APPROVAL_REQUIRED = 'Approval Required';
    public static final String PLACEMENT_PYM_STATUS_CANCELLED = 'Placement Cancelled';
    public static final String PLACEMENT_INV_STATUS_CANCELLED = 'CANCELLED';
    public static final String PLACEMENT_INV_STATUS_HOLD_REQUESTED = 'HOLD_REQUESTED';
    public static final String PLACEMENT_PRICING_FLAG_CHECK_FS = 'Pricing_Flag_Check';
    public static final String PLACEMENT_APPROVAL_REASON_INV_CHANNEL = 'Inventory Channel/Sub Channel';
    public static final String PLACEMENT_APPROVAL_REASON_UPFRONT_VARIANCE = 'Upfront Variance';
    public static final String PLACEMENT_APPROVAL_REASON_RATE_CALC = 'Rate Calculation';
    public static final String PLACEMENT_APPROVAL_REASON_SUB_PRODUCT = 'Sub Product';
    public static final String PLACEMENT_APPROVAL_REASON_ADD_DISCOUNT = 'Additional Discount';

    /*
     * Object: Json_Payload__c
    */
    public static final String JSON_PAYLOAD_OBJ = 'Json_Payload__c';
    public static final String JSON_PAYLOAD_SOBJECT_NAME_FLD = 'Sobject_Name__c';
    public static final String JSON_PAYLOAD_STATUS_PENDING = 'Pending';
    public static final String JSON_PAYLOAD_SOBJECT_NAME_EXCEPTION = 'Exception';

    /*
     * Class: IntegrationPayloadManager
    */
    public static final String PAYLOAD_MANAGER_RECORDS_KEY = 'records';
    public static final String PAYLOAD_MANAGER_SOBJECT_TYPE_KEY = 'sObjectType';
    public static final String PAYLOAD_MANAGER_DETAILS_KEY = 'details';
    public static final String PAYLOAD_MANAGER_REFERENCE_ID_KEY = 'referenceId';
    public static final String PAYLOAD_MANAGER_CONTENT_TYPE_KEY = 'Content-Type';
    public static final String PAYLOAD_MANAGER_CONTENT_TYPE_JSON = 'application/json';
    
    /*
     * Object: Organization__c
    */
    public static final String HASH_TYPE = 'MD5';
    public static final String ORGANIZATION_OBJ = 'Organization__c';
    public static final String ORGANIZATION_LABEL = 'Organization';



    /*
     * Object: Lead
    */
    public static final String LEAD_SOURCE_BUSINESS_MANAGER = 'Business Manager';

    /*
    * SST Roles 
    */
    public static final String ACCOUNT_EXECUTIVE_ROLE = 'Account Executive';
    public static final String ACCOUNT_MANAGER_ROLE = 'Account Manager';
    /*
     * Object: Study_Group__c
    */
    public static final String STUDY_GROUP_OBJ = 'Study_Group__c';
    public static final String STUDY_GROUP_RECALCULATE_EPOCH_FS = 'Recalculate_Epoch_Time';
    public static final String STUDY_GROUP_RESET_SYNC_FLAG_FS = 'Reset_Sync_Flag';
    public static final String STUDY_GROUP_SYNC_STATUS_PENDING = 'Pending';
    public static final String STUDY_GROUP_SYNC_STATUS_ACTIVE = 'Active';
    public static final String STUDY_GROUP_SYNC_STATUS_FAILED = 'Failed';

    /*
     * Object: Study_Group_Cell__c
    */
    public static final String STUDY_GROUP_CELL_OBJ = 'Study_Group_Cell__c';
    public static final String STUDY_GROUP_CELL_SET_PENDING_STATUS_FS = 'Set_Pending_Status';

    /*
     * Object: Pod
    */

    public static final String NON_POD_NAME = 'Non Pod';

    public static Id NON_POD_ID {
        public get {
            if (NON_POD_ID == null) {
                NON_POD_ID = SystemUtility.getNonPodPodId();
            }

            return NON_POD_ID;
        }
        private set;
    }

    /*
     * Object: Opportunity_Product__c
    */
    public static Id OPPORTUNITY_PRODUCT_RT_ID_AD_ACCT {
        public get {
            if (OPPORTUNITY_PRODUCT_RT_ID_AD_ACCT == null) {
                OPPORTUNITY_PRODUCT_RT_ID_AD_ACCT = SystemUtility.getRecordTypeIdByName('Opportunity_Product__c', 'Ad Account');
            }

            return OPPORTUNITY_PRODUCT_RT_ID_AD_ACCT;
        }
        private set;
    }

    public static Id OPPORTUNITY_PRODUCT_RT_ID_CAMPAIGN {
        public get {
            if (OPPORTUNITY_PRODUCT_RT_ID_CAMPAIGN == null) {
                OPPORTUNITY_PRODUCT_RT_ID_CAMPAIGN = SystemUtility.getRecordTypeIdByName('Opportunity_Product__c', 'Campaign');
            }

            return OPPORTUNITY_PRODUCT_RT_ID_CAMPAIGN;
        }
        private set;
    }

    public static Id OPPORTUNITY_PRODUCT_RT_ID_EVERGREEN {
        public get {
            if (OPPORTUNITY_PRODUCT_RT_ID_EVERGREEN == null) {
                OPPORTUNITY_PRODUCT_RT_ID_EVERGREEN = SystemUtility.getRecordTypeIdByName('Opportunity_Product__c', 'Evergreen');
            }

            return OPPORTUNITY_PRODUCT_RT_ID_EVERGREEN;
        }
        private set;
    }

    /*
     * Object: Revenue_Schedule__c
    */
    public static final String REVENUE_SCHEDULE_INTEGRATION_USER='revenue-schedule-integration';
    public static Id REVENUE_SCHEDULE_RT_ID_DELIVERY {
        public get {
            if (REVENUE_SCHEDULE_RT_ID_DELIVERY == null) {
                REVENUE_SCHEDULE_RT_ID_DELIVERY = SystemUtility.getRecordTypeIdByName('Revenue_Schedule__c', 'Delivery');
            }

            return REVENUE_SCHEDULE_RT_ID_DELIVERY;
        }
        private set;
    }

    public static Id REVENUE_SCHEDULE_RT_ID_PIPELINE {
        public get {
            if (REVENUE_SCHEDULE_RT_ID_PIPELINE == null) {
                REVENUE_SCHEDULE_RT_ID_PIPELINE = SystemUtility.getRecordTypeIdByName('Revenue_Schedule__c', 'Pipeline');
            }

            return REVENUE_SCHEDULE_RT_ID_PIPELINE;
        }
        private set;
    }

    /*
     * Miscellaneous
    */
    public static final Integer SOQL_QUERY_RETURN_LIMIT = 2000;
    public static final String CURRENCY_VALUE = 'USD';

    /*
     * Object: Study_Type__c
    */
    public static final String STUDY_TYPE_OBJ = 'Study_Type__c';
    public static final String STUDY_GROUP_VENDOR_PLACED = 'Placed';
    public static final String STUDY_GROUP_VENDOR_ODC = 'ODC';

    public Static final Date DATE_VALUE_2050 = Date.parse('01/01/2050');

    /*
     * Object: Insertion_Order__c 
    */

    public static final String INSERTION_ORDER_OBJ = 'Insertion_Order__c';
    public static final String INSERTION_ORDER_LABEL = 'Insertion Order';

    /*
     * Object: Snapchat_Sales_Team__c
    */

    public static final String SNAPCHATSALESTEAM_OBJ = 'Snapchat_Sales_Team__c';
    public static final String SNAPCHATSALESTEAM_LABEL = 'Snapchat Sales Team';


    /*
     * Object: OpportunitySplit
    */

    public static final String OPPORTUNITY_SPLIT = 'OpportunitySplit';
    public static final String OPPORTUNITY_SPLIT_LABEL = 'Opportunity Split';
}