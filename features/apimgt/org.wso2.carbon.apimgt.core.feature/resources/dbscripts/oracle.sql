CREATE TABLE AM_API_POLICY (
            UUID VARCHAR2(256),
            NAME VARCHAR2(512) NOT NULL,
            DISPLAY_NAME VARCHAR2(512) DEFAULT NULL NULL,
            DESCRIPTION VARCHAR2 (1024),
            DEFAULT_QUOTA_TYPE VARCHAR2(25) NOT NULL,
            DEFAULT_QUOTA NUMBER(10) NOT NULL,
            DEFAULT_QUOTA_UNIT VARCHAR2(10) NULL,
            DEFAULT_UNIT_TIME NUMBER(10) NOT NULL,
            DEFAULT_TIME_UNIT VARCHAR2(25) NOT NULL,
            APPLICABLE_LEVEL VARCHAR2(25) NOT NULL,
            IS_DEPLOYED NUMBER(3) DEFAULT 0 NOT NULL,
            CREATED_BY VARCHAR2(100),
            CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
            UPDATED_BY VARCHAR2(100),
            LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
            PRIMARY KEY (UUID),
            UNIQUE (NAME)
)
/
CREATE TABLE AM_ENDPOINT (
  UUID VARCHAR2(255),
  NAME VARCHAR2(100),
  ENDPOINT_CONFIGURATION BLOB,
  TPS NUMBER(10),
  TYPE VARCHAR2(100),
  APPLICABLE_LEVEL VARCHAR2(100),
  SECURITY_CONFIGURATION BLOB,
  GATEWAY_CONFIG BLOB,
  CREATED_BY VARCHAR2(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR2(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (UUID))
/
CREATE TABLE AM_CONDITION_GROUP (
            CONDITION_GROUP_ID NUMBER(10),
            UUID VARCHAR2(256),
            QUOTA_TYPE VARCHAR2(25),
            QUOTA NUMBER(10) NOT NULL,
            QUOTA_UNIT VARCHAR2(10) DEFAULT NULL NULL,
            UNIT_TIME NUMBER(10) NOT NULL,
            TIME_UNIT VARCHAR2(25) NOT NULL,
            DESCRIPTION VARCHAR2 (1024) DEFAULT NULL NULL,
            PRIMARY KEY (CONDITION_GROUP_ID),
            FOREIGN KEY (UUID) REFERENCES AM_API_POLICY(UUID) ON DELETE CASCADE
)
/
CREATE SEQUENCE AM_CONDITION_GROUP_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER AM_CONDITION_GROUP_seq_tr
 BEFORE INSERT ON AM_CONDITION_GROUP FOR EACH ROW
 WHEN (NEW.CONDITION_GROUP_ID IS NULL)
BEGIN
 SELECT AM_CONDITION_GROUP_seq.NEXTVAL INTO :NEW.CONDITION_GROUP_ID FROM DUAL;
END;
/

CREATE TABLE AM_QUERY_PARAMETER_CONDITION (
            QUERY_PARAMETER_ID NUMBER(10) NOT NULL,
            CONDITION_GROUP_ID NUMBER(10) NOT NULL,
            PARAMETER_NAME VARCHAR2(255) DEFAULT NULL,
            PARAMETER_VALUE VARCHAR2(255) DEFAULT NULL,
	    	IS_PARAM_MAPPING CHAR(1) DEFAULT 1,
            PRIMARY KEY (QUERY_PARAMETER_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE
)
/
CREATE SEQUENCE AM_QUERY_PARAM_CONDITION_seq START WITH 1 INCREMENT BY 1 NOCACHE
/

CREATE OR REPLACE TRIGGER AM_QUERY_PARM_CONDITION_seq_tr
 BEFORE INSERT ON AM_QUERY_PARAMETER_CONDITION FOR EACH ROW
 WHEN (NEW.QUERY_PARAMETER_ID IS NULL)
BEGIN
 SELECT AM_QUERY_PARAM_CONDITION_seq.NEXTVAL INTO :NEW.QUERY_PARAMETER_ID FROM DUAL;
END;
/

CREATE TABLE AM_HEADER_FIELD_CONDITION (
            HEADER_FIELD_ID NUMBER(10) NOT NULL,
            CONDITION_GROUP_ID NUMBER(10) NOT NULL,
            HEADER_FIELD_NAME VARCHAR2(255) DEFAULT NULL,
            HEADER_FIELD_VALUE VARCHAR2(255) DEFAULT NULL,
	    	IS_HEADER_FIELD_MAPPING CHAR(1) DEFAULT 1,
            PRIMARY KEY (HEADER_FIELD_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE
)
/

-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_HEADER_FIELD_CONDITION_seq START WITH 1 INCREMENT BY 1 NOCACHE
/

CREATE OR REPLACE TRIGGER AM_HEADER_FIELD_COND_seq_tr
 BEFORE INSERT ON AM_HEADER_FIELD_CONDITION FOR EACH ROW
 WHEN (NEW.HEADER_FIELD_ID IS NULL)
BEGIN
 SELECT AM_HEADER_FIELD_CONDITION_seq.NEXTVAL INTO :NEW.HEADER_FIELD_ID FROM DUAL;
END;
/

CREATE TABLE AM_JWT_CLAIM_CONDITION (
            JWT_CLAIM_ID NUMBER(10) NOT NULL,
            CONDITION_GROUP_ID NUMBER(10) NOT NULL,
            CLAIM_URI VARCHAR2(512) DEFAULT NULL,
            CLAIM_ATTRIB VARCHAR2(1024) DEFAULT NULL,
	        IS_CLAIM_MAPPING CHAR(1) DEFAULT 1,
            PRIMARY KEY (JWT_CLAIM_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE
)
/

-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_JWT_CLAIM_CONDITION_seq START WITH 1 INCREMENT BY 1 NOCACHE
/

CREATE OR REPLACE TRIGGER AM_JWT_CLAIM_CONDITION_seq_tr
 BEFORE INSERT ON AM_JWT_CLAIM_CONDITION FOR EACH ROW
 WHEN (NEW.JWT_CLAIM_ID IS NULL)
BEGIN
 SELECT AM_JWT_CLAIM_CONDITION_seq.NEXTVAL INTO :NEW.JWT_CLAIM_ID FROM DUAL;
END;
/

CREATE TABLE AM_IP_CONDITION (
  AM_IP_CONDITION_ID NUMBER(10) NOT NULL,
  STARTING_IP VARCHAR2(45) NULL,
  ENDING_IP VARCHAR2(45) NULL,
  SPECIFIC_IP VARCHAR2(45) NULL,
  WITHIN_IP_RANGE CHAR(1) DEFAULT 1,
  CONDITION_GROUP_ID NUMBER(10) NULL,
  PRIMARY KEY (AM_IP_CONDITION_ID),
   FOREIGN KEY (CONDITION_GROUP_ID)    REFERENCES AM_CONDITION_GROUP (CONDITION_GROUP_ID)  ON DELETE CASCADE
   )
/

-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_IP_CONDITION_seq START WITH 1 INCREMENT BY 1 NOCACHE
/

CREATE OR REPLACE TRIGGER AM_IP_CONDITION_seq_tr
 BEFORE INSERT ON AM_IP_CONDITION FOR EACH ROW
 WHEN (NEW.AM_IP_CONDITION_ID IS NULL)
BEGIN
 SELECT AM_IP_CONDITION_seq.NEXTVAL INTO :NEW.AM_IP_CONDITION_ID FROM DUAL;
END;
/

CREATE TABLE AM_APPLICATION_POLICY (
  UUID VARCHAR2(255),
  NAME VARCHAR2(512) NOT NULL,
  DISPLAY_NAME VARCHAR2(512) DEFAULT NULL NULL,
  DESCRIPTION VARCHAR2(1024) DEFAULT NULL NULL,
  QUOTA_TYPE VARCHAR2(25) NOT NULL,
  QUOTA NUMBER(10) NOT NULL,
  QUOTA_UNIT VARCHAR2(10) DEFAULT NULL NULL,
  UNIT_TIME NUMBER(10) NOT NULL,
  TIME_UNIT VARCHAR2(25) NOT NULL,
  IS_DEPLOYED NUMBER(3) DEFAULT 0 NOT NULL,
  CUSTOM_ATTRIBUTES BLOB DEFAULT NULL,
  CREATED_BY VARCHAR2(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR2(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (UUID),
  CONSTRAINT APP_POLICY_NAME UNIQUE (NAME)
  )
/

CREATE TABLE AM_SUBSCRIPTION_POLICY (
  UUID VARCHAR2(255),
  NAME VARCHAR2(255),
  DISPLAY_NAME VARCHAR2(512),
  DESCRIPTION VARCHAR2(1024),
  QUOTA_TYPE VARCHAR2(30),
  QUOTA NUMBER(10),
  QUOTA_UNIT VARCHAR2(30),
  UNIT_TIME NUMBER(10),
  TIME_UNIT VARCHAR2(30),
  RATE_LIMIT_COUNT NUMBER(10),
  RATE_LIMIT_TIME_UNIT VARCHAR2(30),
  IS_DEPLOYED CHAR(1),
  CUSTOM_ATTRIBUTES BLOB,
  STOP_ON_QUOTA_REACH CHAR(1),
  BILLING_PLAN VARCHAR2(30),
  CREATED_BY VARCHAR2(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR2(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (UUID),
  UNIQUE (NAME)
)
/

CREATE TABLE AM_API_TYPES (
  TYPE_ID  NUMBER(10) NOT NULL,
  TYPE_NAME VARCHAR(255),
  PRIMARY KEY (TYPE_ID),
  UNIQUE (TYPE_NAME)
)
/

-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_API_TYPES_seq START WITH 1 INCREMENT BY 1 NOCACHE
/

CREATE OR REPLACE TRIGGER AM_API_TYPES_seq_tr
 BEFORE INSERT ON AM_API_TYPES FOR EACH ROW
 WHEN (NEW.TYPE_ID IS NULL)
BEGIN
 SELECT AM_API_TYPES_seq.NEXTVAL INTO :NEW.TYPE_ID FROM DUAL;
END;
/

CREATE TABLE AM_API (
  UUID VARCHAR2(255),
  PROVIDER VARCHAR2(255),
  NAME VARCHAR2(255),
  CONTEXT VARCHAR2(255),
  VERSION VARCHAR2(30),
  IS_DEFAULT_VERSION CHAR(1),
  DESCRIPTION VARCHAR2(1024),
  VISIBILITY VARCHAR2(30),
  IS_RESPONSE_CACHED CHAR(1),
  CACHE_TIMEOUT NUMBER(10),
  TECHNICAL_OWNER VARCHAR2(255),
  TECHNICAL_EMAIL VARCHAR2(255),
  BUSINESS_OWNER VARCHAR2(255),
  BUSINESS_EMAIL VARCHAR2(255),
  LIFECYCLE_INSTANCE_ID VARCHAR2(255),
  CURRENT_LC_STATUS VARCHAR2(255),
  LC_WORKFLOW_STATUS VARCHAR2(255),
  CORS_ENABLED CHAR(1),
  CORS_ALLOW_ORIGINS VARCHAR2(512),
  CORS_ALLOW_CREDENTIALS CHAR(1),
  CORS_ALLOW_HEADERS VARCHAR2(512),
  CORS_ALLOW_METHODS VARCHAR2(255),
  API_TYPE_ID NUMBER(10),
  CREATED_BY VARCHAR2(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  COPIED_FROM_API VARCHAR2(255),
  AM_API_PERMISSION NUMBER (11) DEFAULT '7',
  UPDATED_BY VARCHAR2(100),
  SECURITY_SCHEME NUMBER(5),
  PRIMARY KEY (UUID),
  FOREIGN KEY (API_TYPE_ID) REFERENCES AM_API_TYPES(TYPE_ID),
  UNIQUE (PROVIDER,NAME,VERSION,API_TYPE_ID),
  UNIQUE (CONTEXT,VERSION)
)
/

BEGIN
ctx_ddl.create_preference('API_DATASTORE', 'MULTI_COLUMN_DATASTORE');
END;
/

BEGIN
ctx_ddl.set_attribute('API_DATASTORE', 'columns', 'AM_API.NAME, AM_API.VERSION, AM_API.PROVIDER, AM_API.DESCRIPTION, AM_API.CONTEXT, AM_API.TECHNICAL_OWNER, AM_API.BUSINESS_OWNER, AM_API.CURRENT_LC_STATUS');
END;
/

ALTER TABLE AM_API ADD INDEXER VARCHAR2(1)
/

CREATE INDEX API_INDEX ON AM_API(INDEXER) INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS('DATASTORE API_DATASTORE SYNC (ON COMMIT)')
/

CREATE TABLE AM_API_ENDPOINT_MAPPING (
  API_ID VARCHAR2(255),
  TYPE VARCHAR2(25),
  ENDPOINT_ID VARCHAR2(255),
  UNIQUE (API_ID,ENDPOINT_ID,TYPE),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON DELETE CASCADE,
  FOREIGN KEY (ENDPOINT_ID) REFERENCES AM_ENDPOINT(UUID)
)
/

CREATE TABLE AM_API_VISIBLE_ROLES (
  API_ID VARCHAR2(255),
  ROLE VARCHAR2(255),
  PRIMARY KEY (API_ID, ROLE),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON DELETE CASCADE
)
/

CREATE TABLE AM_API_TAG_MAPPING (
  API_ID VARCHAR2(255),
  TAG_ID VARCHAR2(255),
  PRIMARY KEY (API_ID, TAG_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON DELETE CASCADE
)
/

CREATE TABLE AM_TAGS (
  TAG_ID VARCHAR2(255),
  NAME VARCHAR2(255),
  COUNT NUMBER(10),
  PRIMARY KEY (TAG_ID)
)
/

CREATE TABLE AM_API_SUBS_POLICY_MAPPING (
  API_ID VARCHAR2(255),
  SUBSCRIPTION_POLICY_ID VARCHAR2(255),
  PRIMARY KEY (API_ID, SUBSCRIPTION_POLICY_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID)  ON DELETE CASCADE,
  FOREIGN KEY (SUBSCRIPTION_POLICY_ID) REFERENCES AM_SUBSCRIPTION_POLICY(UUID)  ON DELETE CASCADE
)
/

CREATE TABLE AM_API_POLICY_MAPPING (
  API_ID VARCHAR2(255),
  API_POLICY_ID VARCHAR2(255),
  PRIMARY KEY (API_ID, API_POLICY_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID)  ON DELETE CASCADE,
  FOREIGN KEY (API_POLICY_ID) REFERENCES AM_API_POLICY(UUID)  ON DELETE CASCADE
)
/

CREATE TABLE AM_API_OPERATION_MAPPING (
  API_ID VARCHAR2(255),
  OPERATION_ID VARCHAR2(255),
  HTTP_METHOD VARCHAR2(30),
  URL_PATTERN VARCHAR2(255),
  AUTH_SCHEME VARCHAR2(30),
  API_POLICY_ID VARCHAR2(255),
  PRIMARY KEY (API_ID,OPERATION_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON DELETE CASCADE,
  FOREIGN KEY (API_POLICY_ID) REFERENCES AM_API_POLICY(UUID)
)
/

CREATE TABLE AM_API_RESOURCE_ENDPOINT (
  API_ID VARCHAR2(255),
  OPERATION_ID VARCHAR2(255),
  TYPE VARCHAR2(25),
  ENDPOINT_ID VARCHAR2(255),
  UNIQUE (API_ID,ENDPOINT_ID,TYPE,OPERATION_ID),
  FOREIGN KEY (API_ID , OPERATION_ID) REFERENCES AM_API_OPERATION_MAPPING(API_ID , OPERATION_ID) ON DELETE CASCADE,
  FOREIGN KEY (ENDPOINT_ID) REFERENCES AM_ENDPOINT(UUID)
  )
/

CREATE TABLE AM_APPLICATION (
  UUID VARCHAR2(255),
  NAME VARCHAR2(255),
  APPLICATION_POLICY_ID VARCHAR2(255),
  DESCRIPTION VARCHAR2(1024),
  APPLICATION_STATUS VARCHAR2(255),
  CREATED_BY VARCHAR2(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR2(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  AM_APPLICATION_PERMISSION NUMBER(11) DEFAULT '7',
  PRIMARY KEY (UUID),
  UNIQUE (NAME),
  FOREIGN KEY (APPLICATION_POLICY_ID) REFERENCES AM_APPLICATION_POLICY(UUID)
)
/

CREATE TABLE AM_APP_KEY_MAPPING (
  APPLICATION_ID VARCHAR2(255),
  CLIENT_ID VARCHAR2(255),
  KEY_TYPE VARCHAR2(255),
  PRIMARY KEY (APPLICATION_ID, KEY_TYPE),
  FOREIGN KEY (APPLICATION_ID) REFERENCES AM_APPLICATION(UUID)  ON DELETE CASCADE
)
/

CREATE TABLE AM_API_TRANSPORTS (
  API_ID VARCHAR2(255),
  TRANSPORT VARCHAR2(30),
  PRIMARY KEY (API_ID, TRANSPORT),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID)  ON DELETE CASCADE
)
/

CREATE TABLE AM_RESOURCE_CATEGORIES (
  RESOURCE_CATEGORY_ID NUMBER(10),
  RESOURCE_CATEGORY VARCHAR2(255),
  PRIMARY KEY (RESOURCE_CATEGORY_ID),
  UNIQUE (RESOURCE_CATEGORY)
)
/

-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_RESOURCE_CATEGORIES_seq START WITH 1 INCREMENT BY 1 NOCACHE
/

CREATE OR REPLACE TRIGGER AM_RESOURCE_CATEGORIES_seq_tr
 BEFORE INSERT ON AM_RESOURCE_CATEGORIES FOR EACH ROW
 WHEN (NEW.RESOURCE_CATEGORY_ID IS NULL)
BEGIN
 SELECT AM_RESOURCE_CATEGORIES_seq.NEXTVAL INTO :NEW.RESOURCE_CATEGORY_ID FROM DUAL;
END;
/

CREATE TABLE AM_API_RESOURCES (
  UUID VARCHAR2(255),
  API_ID VARCHAR2(255),
  RESOURCE_CATEGORY_ID NUMBER(10),
  DATA_TYPE VARCHAR2(255),
  RESOURCE_TEXT_VALUE VARCHAR2(1024) ,
  RESOURCE_BINARY_VALUE BLOB,
  CREATED_BY VARCHAR2(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR2(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (UUID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID)  ON DELETE CASCADE,
  FOREIGN KEY (RESOURCE_CATEGORY_ID) REFERENCES AM_RESOURCE_CATEGORIES(RESOURCE_CATEGORY_ID)
)
/

CREATE TABLE AM_API_DOC_META_DATA (
  UUID VARCHAR2(255),
  NAME VARCHAR2(255),
  SUMMARY VARCHAR2(1024),
  TYPE VARCHAR2(255),
  OTHER_TYPE_NAME VARCHAR2(255),
  SOURCE_URL VARCHAR2(255),
  FILE_NAME VARCHAR2(255),
  SOURCE_TYPE VARCHAR2(255),
  VISIBILITY VARCHAR2(30),
  AM_DOC_PERMISSION NUMBER(11) DEFAULT '7',
  CREATED_BY VARCHAR2(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR2(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (UUID),
  FOREIGN KEY (UUID) REFERENCES AM_API_RESOURCES(UUID)  ON DELETE CASCADE
 )
/

CREATE TABLE AM_SUBSCRIPTION (
  UUID VARCHAR2(255),
  TIER_ID VARCHAR2(50),
  API_ID VARCHAR2(255),
  APPLICATION_ID VARCHAR2(255),
  SUB_STATUS VARCHAR2(50),
  SUB_TYPE VARCHAR2(50),
  CREATED_BY VARCHAR2(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR2(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  FOREIGN KEY(APPLICATION_ID) REFERENCES AM_APPLICATION(UUID),
  FOREIGN KEY(API_ID) REFERENCES AM_API(UUID),
  FOREIGN KEY(TIER_ID) REFERENCES AM_SUBSCRIPTION_POLICY(UUID),
  PRIMARY KEY (UUID)
)
/

CREATE TABLE AM_API_GROUP_PERMISSION (
  API_ID VARCHAR2(255) DEFAULT '' NOT NULL ,
  GROUP_ID VARCHAR2(255) NOT NULL,
  PERMISSION NUMBER(11) DEFAULT NULL,
  PRIMARY KEY(API_ID, GROUP_ID),
  FOREIGN KEY(API_ID) REFERENCES AM_API(UUID) ON DELETE CASCADE
)
/

CREATE TABLE AM_APPS_GROUP_PERMISSION (
  APPLICATION_ID VARCHAR2(255) DEFAULT '' NOT NULL,
  GROUP_ID VARCHAR2(11) NOT NULL,
  PERMISSION NUMBER(11) DEFAULT NULL,
  PRIMARY KEY (APPLICATION_ID,GROUP_ID),
  FOREIGN KEY (APPLICATION_ID) REFERENCES AM_APPLICATION (UUID) ON DELETE CASCADE
)
/

CREATE TABLE AM_DOC_GROUP_PERMISSION (
  DOC_ID VARCHAR2(255) DEFAULT '' NOT NULL ,
  GROUP_ID VARCHAR2(11) NOT NULL,
  PERMISSION NUMBER(11) DEFAULT NULL,
  PRIMARY KEY (DOC_ID,GROUP_ID),
  FOREIGN KEY (DOC_ID) REFERENCES AM_API_DOC_META_DATA (UUID) ON DELETE CASCADE
)
/

CREATE TABLE AM_API_LABEL_MAPPING (
  API_ID VARCHAR2(255),
  LABEL_ID VARCHAR2(255),
  PRIMARY KEY (API_ID, LABEL_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON DELETE CASCADE
)
/

CREATE TABLE AM_LABELS (
  LABEL_ID VARCHAR2(255),
  NAME VARCHAR2(255),
  PRIMARY KEY (LABEL_ID),
  UNIQUE (NAME)
)
/

CREATE TABLE AM_LABEL_ACCESS_URL_MAPPING (
  LABEL_ID VARCHAR2(255),
  ACCESS_URL VARCHAR2(255),
  PRIMARY KEY (LABEL_ID, ACCESS_URL),
  FOREIGN KEY (LABEL_ID) REFERENCES AM_LABELS(LABEL_ID) ON DELETE CASCADE
)
/

CREATE TABLE AM_LAMBDA_FUNCTION (
   FUNCTION_ID NUMBER(10,0),
   FUNCTION_NAME VARCHAR2(255) NOT NULL,
   FUNCTION_URI VARCHAR2(255) NOT NULL,
   USER_NAME VARCHAR2(255) NOT NULL,
   PRIMARY KEY (FUNCTION_ID),
   UNIQUE (FUNCTION_URI)
)
/

-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_LAMBDA_FUNCTION_seq START WITH 1 INCREMENT BY 1 NOCACHE
/

CREATE OR REPLACE TRIGGER AM_LAMBDA_FUNCTION_seq_tr
 BEFORE INSERT ON AM_LAMBDA_FUNCTION FOR EACH ROW
 WHEN (NEW.FUNCTION_ID IS NULL)
BEGIN
 SELECT AM_LAMBDA_FUNCTION_seq.NEXTVAL INTO :NEW.FUNCTION_ID FROM DUAL;
END;
/

CREATE TABLE AM_EVENT_FUNCTION_MAPPING (
   FUNCTION_ID NUMBER(10,0),
   EVENT VARCHAR2(255),
   PRIMARY KEY (FUNCTION_ID, EVENT),
   FOREIGN KEY (FUNCTION_ID) REFERENCES AM_LAMBDA_FUNCTION(FUNCTION_ID)  ON DELETE CASCADE
)
/

CREATE TABLE AM_WORKFLOWS (
    WF_ID NUMBER(10),
    WF_REFERENCE VARCHAR2(255) NOT NULL,
    WF_TYPE VARCHAR2(255) NOT NULL,
    WF_STATUS VARCHAR2(255) NOT NULL,
    WF_CREATED_TIME TIMESTAMP(0) DEFAULT SYSTIMESTAMP,
    WF_UPDATED_TIME TIMESTAMP(0) DEFAULT SYSTIMESTAMP,
    WF_STATUS_DESC CLOB,
    WF_ATTRIBUTES CLOB,
    WF_EXTERNAL_REFERENCE VARCHAR2(255) NOT NULL,
    PRIMARY KEY (WF_ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_WORKFLOWS_seq START WITH 1 INCREMENT BY 1
/

CREATE OR REPLACE TRIGGER AM_WORKFLOWS_seq_tr
 BEFORE INSERT ON AM_WORKFLOWS FOR EACH ROW
 WHEN (NEW.WF_ID IS NULL)
BEGIN
 SELECT AM_WORKFLOWS_seq.NEXTVAL INTO :NEW.WF_ID FROM DUAL;
END;
/

CREATE TABLE AM_API_RATINGS (
  UUID VARCHAR2(255) NOT NULL,
  API_ID VARCHAR2(255) NOT NULL,
  RATING FLOAT,
  USER_IDENTIFIER VARCHAR2(255) NOT NULL,
  CREATED_BY VARCHAR2(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR2(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  FOREIGN KEY(API_ID) REFERENCES AM_API(UUID) ON DELETE CASCADE,
  PRIMARY KEY (UUID),
  UNIQUE (API_ID,USER_IDENTIFIER)
)
/

CREATE TABLE AM_API_COMMENTS (
  UUID VARCHAR2(255) NOT NULL,
  COMMENT_TEXT CLOB,
  USER_IDENTIFIER VARCHAR2(255),
  API_ID VARCHAR2(255) NOT NULL,
  CREATED_BY VARCHAR2(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR2(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  FOREIGN KEY(API_ID) REFERENCES AM_API(UUID) ON DELETE CASCADE,
  PRIMARY KEY (UUID)
)
/

CREATE TABLE AM_BLOCK_CONDITIONS (
  CONDITION_ID NUMBER(10) NOT NULL,
  TYPE varchar2(45) DEFAULT NULL,
  VALUE varchar2(512) DEFAULT NULL,
  ENABLED CHAR(1) DEFAULT 1,
  UUID VARCHAR2(256),
  PRIMARY KEY (CONDITION_ID),
  UNIQUE (UUID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_BLOCK_CONDITIONS_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_BLOCK_CONDITIONS_seq_tr
 BEFORE INSERT ON AM_BLOCK_CONDITIONS FOR EACH ROW
 WHEN (NEW.CONDITION_ID IS NULL)
BEGIN
 SELECT AM_BLOCK_CONDITIONS_seq.NEXTVAL INTO :NEW.CONDITION_ID FROM DUAL;
END;
/

CREATE TABLE AM_IP_RANGE_CONDITION (
  AM_IP_RANGE_CONDITION_ID NUMBER(10),
  STARTING_IP VARCHAR(45) NULL,
  ENDING_IP VARCHAR(45) NULL,
  UUID VARCHAR(254),
  PRIMARY KEY (AM_IP_RANGE_CONDITION_ID),
  FOREIGN KEY (UUID) REFERENCES AM_BLOCK_CONDITIONS(UUID)  ON DELETE CASCADE
)
/

CREATE SEQUENCE AM_IP_RANGE_CONDITION_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_IP_RANGE_CONDITION_seq_tr
 BEFORE INSERT ON AM_IP_RANGE_CONDITION FOR EACH ROW
 WHEN (NEW.AM_IP_RANGE_CONDITION_ID IS NULL)
BEGIN
 SELECT AM_IP_RANGE_CONDITION_seq.NEXTVAL INTO :NEW.AM_IP_RANGE_CONDITION_ID FROM DUAL;
END;
/

CREATE TABLE AM_CUSTOM_POLICY (
            UUID VARCHAR2(256),
            NAME VARCHAR2(512) NOT NULL,
            KEY_TEMPLATE VARCHAR2(512) NOT NULL,
            DESCRIPTION VARCHAR2(1024) DEFAULT NULL NULL,
            SIDDHI_QUERY BLOB DEFAULT NULL,
            IS_DEPLOYED NUMBER(3) DEFAULT 0 NOT NULL,
            PRIMARY KEY (UUID)
)
/

CREATE TABLE AM_THREAT_PROTECTION_POLICIES (
  UUID VARCHAR2(255),
  NAME VARCHAR2(255) UNIQUE NOT NULL,
  TYPE VARCHAR2(64) NOT NULL,
  POLICY BLOB NOT NULL,
  PRIMARY KEY(UUID)
)
/

CREATE TABLE AM_THREAT_PROTECTION_MAPPING (
  API_ID VARCHAR2(255),
  POLICY_ID VARCHAR2(255),
  FOREIGN KEY (POLICY_ID) REFERENCES AM_THREAT_PROTECTION_POLICIES(UUID) ON DELETE CASCADE,
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON DELETE CASCADE
)
/

CREATE TABLE AM_SYSTEM_APPS (
            ID NUMBER(10),
            NAME VARCHAR2(50) NOT NULL,
            CONSUMER_KEY VARCHAR2(512) NOT NULL,
            CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
            PRIMARY KEY (ID)
)
/

CREATE SEQUENCE AM_SYSTEM_APPS_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_SYSTEM_APPS_seq_tr
 BEFORE INSERT ON AM_SYSTEM_APPS FOR EACH ROW
 WHEN (NEW.ID IS NULL)
BEGIN
 SELECT AM_SYSTEM_APPS_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
END;
/