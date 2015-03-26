CREATE TABLE SP_APP (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
	    	APP_NAME VARCHAR (255) NOT NULL ,
	    	USER_STORE VARCHAR (255) NOT NULL,
            USERNAME VARCHAR (255) NOT NULL ,
            DESCRIPTION VARCHAR (1024),
	    	ROLE_CLAIM VARCHAR (512),
            AUTH_TYPE VARCHAR (255) NOT NULL,
	    	PROVISIONING_USERSTORE_DOMAIN VARCHAR (512),
	    	IS_LOCAL_CLAIM_DIALECT CHAR(1) DEFAULT '1',
	    	IS_SEND_LOCAL_SUBJECT_ID CHAR(1) DEFAULT '0',
	    	IS_SEND_AUTH_LIST_OF_IDPS CHAR(1) DEFAULT '0',
	    	SUBJECT_CLAIM_URI VARCHAR (512),
	    	IS_SAAS_APP CHAR(1) DEFAULT '0',
            PRIMARY KEY (ID))
/
CREATE SEQUENCE SP_APP_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER SP_APP_TRIG NO CASCADE
            BEFORE INSERT
            ON SP_APP
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR SP_APP_SEQ);
                END
/
ALTER TABLE SP_APP ADD CONSTRAINT APPLICATION_NAME_CONSTRAINT UNIQUE(APP_NAME, TENANT_ID)
/
CREATE TABLE SP_INBOUND_AUTH (
            ID INTEGER NOT NULL,
	     	TENANT_ID INTEGER NOT NULL,
	     	INBOUND_AUTH_KEY VARCHAR (255) NOT NULL,
            INBOUND_AUTH_TYPE VARCHAR (255) NOT NULL,
            PROP_NAME VARCHAR (255),
            PROP_VALUE VARCHAR (1024) ,
	     	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID))
/
CREATE SEQUENCE SP_INBOUND_AUTH_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER SP_INBOUND_AUTH_TRIG NO CASCADE
            BEFORE INSERT
            ON SP_INBOUND_AUTH
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR SP_INBOUND_AUTH_SEQ);
                END
/
ALTER TABLE SP_INBOUND_AUTH ADD CONSTRAINT APPLICATION_ID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE
/
CREATE TABLE SP_AUTH_STEP (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
	     	STEP_ORDER INTEGER DEFAULT 1,
            APP_ID INTEGER NOT NULL ,
            IS_SUBJECT_STEP CHAR(1) DEFAULT '0',
            IS_ATTRIBUTE_STEP CHAR(1) DEFAULT '0',
            PRIMARY KEY (ID))
/
CREATE SEQUENCE SP_AUTH_STEP_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER SP_AUTH_STEP_TRIG NO CASCADE
            BEFORE INSERT
            ON SP_AUTH_STEP
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR SP_AUTH_STEP_SEQ);
                END
/
ALTER TABLE SP_AUTH_STEP ADD CONSTRAINT APPLICATION_ID_CONSTRAINT_STEP FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE
/
CREATE TABLE SP_FEDERATED_IDP (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            AUTHENTICATOR_ID INTEGER NOT NULL,
            PRIMARY KEY (ID, AUTHENTICATOR_ID))
/
ALTER TABLE SP_FEDERATED_IDP ADD CONSTRAINT STEP_ID_CONSTRAINT FOREIGN KEY (ID) REFERENCES SP_AUTH_STEP (ID) ON DELETE CASCADE
/
CREATE TABLE SP_CLAIM_MAPPING (
	    	ID INTEGER NOT NULL,
	    	TENANT_ID INTEGER NOT NULL,
	    	IDP_CLAIM VARCHAR (512) NOT NULL ,
            SP_CLAIM VARCHAR (512) NOT NULL ,
	   		APP_ID INTEGER NOT NULL,
	    	IS_REQUESTED VARCHAR(128) DEFAULT '0',
			DEFAULT_VALUE VARCHAR(255),
            PRIMARY KEY (ID))
/
CREATE SEQUENCE SP_CLAIM_MAPPING_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER SP_CLAIM_MAPPING_TRIG NO CASCADE
            BEFORE INSERT
            ON SP_CLAIM_MAPPING
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR SP_CLAIM_MAPPING_SEQ);
                END
/
ALTER TABLE SP_CLAIM_MAPPING ADD CONSTRAINT CLAIMID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE
/
CREATE TABLE SP_ROLE_MAPPING (
	    	ID INTEGER NOT NULL,
	    	TENANT_ID INTEGER NOT NULL,
	    	IDP_ROLE VARCHAR (255) NOT NULL ,
            SP_ROLE VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID))
/
CREATE SEQUENCE SP_ROLE_MAPPING_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER SP_ROLE_MAPPING_TRIG NO CASCADE
            BEFORE INSERT
            ON SP_ROLE_MAPPING
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR SP_ROLE_MAPPING_SEQ);
                END
/
ALTER TABLE SP_ROLE_MAPPING ADD CONSTRAINT ROLEID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE
/
CREATE TABLE SP_REQ_PATH_AUTHENTICATOR (
	    	ID INTEGER NOT NULL,
	    	TENANT_ID INTEGER NOT NULL,
	    	AUTHENTICATOR_NAME VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID))
/
CREATE SEQUENCE SP_REQ_PATH_AUTH_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER SP_REQ_PATH_AUTH_TRIG NO CASCADE
            BEFORE INSERT
            ON SP_REQ_PATH_AUTHENTICATOR
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR SP_REQ_PATH_AUTH_SEQ);
                END
/
ALTER TABLE SP_REQ_PATH_AUTHENTICATOR ADD CONSTRAINT REQ_AUTH_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE
/
CREATE TABLE SP_PROVISIONING_CONNECTOR (
	    	ID INTEGER NOT NULL,
	    	TENANT_ID INTEGER NOT NULL,
            IDP_NAME VARCHAR (255) NOT NULL ,
	    	CONNECTOR_NAME VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
	    	IS_JIT_ENABLED CHAR(1) NOT NULL DEFAULT '0',
		BLOCKING CHAR(1) NOT NULL DEFAULT '0',
            PRIMARY KEY (ID))
/
CREATE SEQUENCE SP_PROV_CONNECTOR_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER SP_PROV_CONNECTOR_TRIG NO CASCADE
            BEFORE INSERT
            ON SP_PROVISIONING_CONNECTOR
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR SP_PROV_CONNECTOR_SEQ);
                END
/
ALTER TABLE SP_PROVISIONING_CONNECTOR ADD CONSTRAINT PRO_CONNECTOR_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE
/
CREATE TABLE IDP (
			ID INTEGER NOT NULL,
			TENANT_ID INTEGER NOT NULL,
			NAME VARCHAR(254) NOT NULL,
			IS_ENABLED CHAR(1) NOT NULL DEFAULT '1',
			IS_PRIMARY CHAR(1) NOT NULL DEFAULT '0',
			HOME_REALM_ID VARCHAR(254),
			IMAGE BLOB,
			CERTIFICATE BLOB,
			ALIAS VARCHAR(254),
			INBOUND_PROV_ENABLED CHAR (1) NOT NULL DEFAULT '0',
			INBOUND_PROV_USER_STORE_ID VARCHAR(254),
 			USER_CLAIM_URI VARCHAR(254),
 			ROLE_CLAIM_URI VARCHAR(254),
  			DESCRIPTION VARCHAR (1024),
 			DEFAULT_AUTHENTICATOR_NAME VARCHAR(254),
 			DEFAULT_PRO_CONNECTOR_NAME VARCHAR(254),
 			PROVISIONING_ROLE VARCHAR(128),
 			IS_FEDERATION_HUB CHAR(1) NOT NULL DEFAULT '0',
 			IS_LOCAL_CLAIM_DIALECT CHAR(1) NOT NULL DEFAULT '0',
	                DISPLAY_NAME VARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (TENANT_ID, NAME))
/
CREATE SEQUENCE IDP_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDP_TRIG NO CASCADE
            BEFORE INSERT
            ON IDP
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR IDP_SEQ);
                END
/
INSERT INTO IDP (TENANT_ID, NAME, HOME_REALM_ID) VALUES (-1234, 'LOCAL', 'localhost')
/
CREATE TABLE IDP_ROLE (
			ID INTEGER NOT NULL,
			IDP_ID INTEGER NOT NULL,
			TENANT_ID INTEGER NOT NULL,
			ROLE VARCHAR(254) NOT NULL,
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, ROLE),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_ROLE_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDP_ROLE_TRIG NO CASCADE
            BEFORE INSERT
            ON IDP_ROLE
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR IDP_ROLE_SEQ);
                END
/
CREATE TABLE IDP_ROLE_MAPPING (
			ID INTEGER NOT NULL,
			IDP_ROLE_ID INTEGER NOT NULL,
			TENANT_ID INTEGER NOT NULL,
			USER_STORE_ID VARCHAR (253) NOT NULL,
			LOCAL_ROLE VARCHAR(253) NOT NULL,
			PRIMARY KEY (ID),
			UNIQUE (IDP_ROLE_ID, TENANT_ID, USER_STORE_ID, LOCAL_ROLE),
			FOREIGN KEY (IDP_ROLE_ID) REFERENCES IDP_ROLE(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_ROLE_MAPPING_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDP_ROLE_MAPPING_TRIG NO CASCADE
            BEFORE INSERT
            ON IDP_ROLE_MAPPING
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR IDP_ROLE_MAPPING_SEQ);
                END
/
CREATE TABLE IDP_CLAIM (
			ID INTEGER NOT NULL,
			IDP_ID INTEGER NOT NULL,
			TENANT_ID INTEGER NOT NULL,
			CLAIM VARCHAR(254) NOT NULL,
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, CLAIM),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_CLAIM_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDP_CLAIM_TRIG NO CASCADE
            BEFORE INSERT
            ON IDP_CLAIM
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR IDP_CLAIM_SEQ);
                END
/
CREATE TABLE IDP_CLAIM_MAPPING (
			ID INTEGER NOT NULL,
			IDP_CLAIM_ID INTEGER NOT NULL,
			TENANT_ID INTEGER NOT NULL,
			LOCAL_CLAIM VARCHAR(253) NOT NULL,
			DEFAULT_VALUE VARCHAR(255),
	    	IS_REQUESTED VARCHAR(128) DEFAULT '0',
			PRIMARY KEY (ID),
			UNIQUE (IDP_CLAIM_ID, TENANT_ID, LOCAL_CLAIM),
			FOREIGN KEY (IDP_CLAIM_ID) REFERENCES IDP_CLAIM(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_CLAIM_MAPPING_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDP_CLAIM_MAPPING_TRIG NO CASCADE
            BEFORE INSERT
            ON IDP_CLAIM_MAPPING
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR IDP_CLAIM_MAPPING_SEQ);
                END
/
CREATE TABLE IDP_AUTHENTICATOR (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            IDP_ID INTEGER NOT NULL,
            NAME VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '1',
            DISPLAY_NAME VARCHAR(255),
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, NAME),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_AUTHENTICATOR_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDP_AUTHENTICATOR_TRIG NO CASCADE
            BEFORE INSERT
            ON IDP_AUTHENTICATOR
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR IDP_AUTHENTICATOR_SEQ);
                END
/

INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) VALUES (-1234, 1, 'samlsso')
/
CREATE TABLE IDP_AUTHENTICATOR_PROPERTY (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            AUTHENTICATOR_ID INTEGER NOT NULL,
            PROPERTY_KEY VARCHAR(255) NOT NULL,
            PROPERTY_VALUE VARCHAR(2047),
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY),
            FOREIGN KEY (AUTHENTICATOR_ID) REFERENCES IDP_AUTHENTICATOR(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_AUTHENTICATOR_PROP_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDP_AUTHENTICATOR_PROP_TRIG NO CASCADE
            BEFORE INSERT
            ON IDP_AUTHENTICATOR_PROPERTY
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR IDP_AUTHENTICATOR_PROP_SEQ);
                END
/
INSERT INTO  IDP_AUTHENTICATOR_PROPERTY (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY,PROPERTY_VALUE, IS_SECRET ) VALUES (-1234, 1 , 'IdPEntityId', 'localhost', '0');
/
CREATE TABLE IDP_PROVISIONING_CONFIG (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            IDP_ID INTEGER NOT NULL,
            PROVISIONING_CONNECTOR_TYPE VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '0',
            IS_BLOCKING CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, PROVISIONING_CONNECTOR_TYPE),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_PROV_CONFIG_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDP_PROV_CONFIG_TRIG NO CASCADE
            BEFORE INSERT
            ON IDP_PROVISIONING_CONFIG
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR IDP_PROV_CONFIG_SEQ);
                END
/
CREATE TABLE IDP_PROV_CONFIG_PROPERTY (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            PROVISIONING_CONFIG_ID INTEGER NOT NULL,
            PROPERTY_KEY VARCHAR(255) NOT NULL,
            PROPERTY_VALUE VARCHAR(2048),
            PROPERTY_BLOB_VALUE BLOB,
            PROPERTY_TYPE CHAR(32) NOT NULL,
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, PROVISIONING_CONFIG_ID, PROPERTY_KEY),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_PROV_CONFIG_PROP_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDP_PROV_CONFIG_PROP_TRIG NO CASCADE
            BEFORE INSERT
            ON IDP_PROV_CONFIG_PROPERTY
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR IDP_PROV_CONFIG_PROP_SEQ);
                END
/
CREATE TABLE IDP_PROVISIONING_ENTITY (
            ID INTEGER NOT NULL,
            PROVISIONING_CONFIG_ID INTEGER NOT NULL,
            ENTITY_TYPE VARCHAR(255) NOT NULL,
            ENTITY_LOCAL_USERSTORE VARCHAR(255) NOT NULL,
            ENTITY_NAME VARCHAR(255) NOT NULL,
            ENTITY_VALUE VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            PRIMARY KEY (ID),
            UNIQUE (ENTITY_TYPE, TENANT_ID, ENTITY_LOCAL_USERSTORE, ENTITY_NAME, PROVISIONING_CONFIG_ID),
            UNIQUE (PROVISIONING_CONFIG_ID, ENTITY_TYPE, ENTITY_VALUE),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_PROV_ENTITY_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDP_PROV_ENTITY_TRIG NO CASCADE
            BEFORE INSERT
            ON IDP_PROVISIONING_ENTITY
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR IDP_PROV_ENTITY_SEQ);
                END
/
CREATE TABLE IDP_LOCAL_CLAIM (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            IDP_ID INTEGER NOT NULL,
            CLAIM_URI VARCHAR(255) NOT NULL,
            DEFAULT_VALUE VARCHAR(255),
       	    IS_REQUESTED VARCHAR(128) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, CLAIM_URI),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_LOCAL_CLAIM_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDP_LOCAL_CLAIM_TRIG NO CASCADE
            BEFORE INSERT
            ON IDP_LOCAL_CLAIM
            REFERENCING NEW AS NEW
            FOR EACH ROW MODE DB2SQL
                BEGIN ATOMIC
                    SET (NEW.ID) = (NEXTVAL FOR IDP_LOCAL_CLAIM_SEQ);
                END
/
