/*
 * IBM Confidential 
 * PID 5725-V89 5725-V90 5737-F02
 *
 * Copyright IBM Corp. 2022, 2024
 */

CREATE TABLE OAUTH20_TOKEN_CACHE 
(
    TOKEN_ID          VARCHAR2(512) NOT NULL,
    TYPE              VARCHAR2(64)  NOT NULL,
    SUB_TYPE          VARCHAR2(64),
    DATE_CREATED      NUMBER(19, 0),
    DATE_LAST_USED    NUMBER(19, 0),
    LIFETIME          NUMBER(11, 0),
    TOKEN_STRING      VARCHAR2(512) NOT NULL,
    CLIENT_ID         VARCHAR2(256) NOT NULL,
    USERNAME          VARCHAR2(256) NOT NULL,
    SCOPE             VARCHAR2(512),
    REDIRECT_URI      VARCHAR2(256),
    STATE_ID          VARCHAR2(64)  NOT NULL,
    TOKEN_ENABLED     CHAR          NOT NULL,
    PREV_TOKEN_STRING VARCHAR2(512),
    CONSTRAINT PK_LOOKUPKEY PRIMARY KEY (TOKEN_ID),
    CONSTRAINT CHECK_TOKEN_ENABLED CHECK (TOKEN_ENABLED IN ('Y', 'N'))
);

CREATE INDEX OAUTH20CACHE_ST ON OAUTH20_TOKEN_CACHE (STATE_ID ASC);
CREATE INDEX OAUTH20CACHE_TKSTRING ON OAUTH20_TOKEN_CACHE (TOKEN_STRING);
CREATE INDEX OAUTH20CACHE_PTKSTRING ON OAUTH20_TOKEN_CACHE (PREV_TOKEN_STRING);
CREATE INDEX OAUTH20CACHE_LIFETIME ON OAUTH20_TOKEN_CACHE (LIFETIME ASC);
CREATE INDEX OAUTH20CACHE_UCID ON OAUTH20_TOKEN_CACHE (USERNAME, CLIENT_ID);

CREATE TABLE OAUTH20_TOKEN_EXTRA_ATTRIBUTE
(
    STATE_ID   VARCHAR2(256),
    ATTR_NAME  VARCHAR2(256),
    ATTR_VALUE VARCHAR2(256),
    SENSITIVE  CHAR DEFAULT 'N',
    READ_ONLY  CHAR DEFAULT 'N',
    CONSTRAINT CHECK_SENSITIVE CHECK (SENSITIVE IN ('Y', 'N')),
    CONSTRAINT CHECK_READ_ONLY CHECK (READ_ONLY IN ('Y', 'N'))
);

ALTER TABLE OAUTH20_TOKEN_EXTRA_ATTRIBUTE add primary key (STATE_ID, ATTR_NAME);

CREATE TABLE OAUTH20_JTI
(
    JWT_TYPE   INT           NOT NULL,
    JWT_ID     VARCHAR(200)  NOT NULL,
    EXPIRED_AT NUMBER(19, 0) NOT NULL,
    CONSTRAINT PK_JTIS PRIMARY KEY (JWT_TYPE, JWT_ID)
);

CREATE INDEX JTIS_EXPIRED ON OAUTH20_JTI (EXPIRED_AT);

CREATE TABLE OAUTH_TRUSTED_CLIENT
(
    TRUSTED_CLIENT_ID VARCHAR2(256) NOT NULL,
    USERNAME          VARCHAR2(256) NOT NULL,
    CLIENT_ID         VARCHAR2(256) NOT NULL,
    CONSTRAINT PK_UNIQUEID PRIMARY KEY (TRUSTED_CLIENT_ID)
);

CREATE INDEX TRUSTEDCLIENTS_USERNAME ON OAUTH_TRUSTED_CLIENT (USERNAME);
CREATE INDEX TRUSTEDCLIENTS_USER_CLIENTID ON OAUTH_TRUSTED_CLIENT (USERNAME, CLIENT_ID);

CREATE TABLE OAUTH_SCOPE
(
    TRUSTED_CLIENT_ID VARCHAR2(256) NOT NULL,
    SCOPE             VARCHAR2(256),
    CONSTRAINT PK_UNIQUEIDSCOPE PRIMARY KEY (TRUSTED_CLIENT_ID, SCOPE),
    FOREIGN KEY (TRUSTED_CLIENT_ID) REFERENCES OAUTH_TRUSTED_CLIENT (TRUSTED_CLIENT_ID) ON DELETE CASCADE
);

CREATE TABLE OAUTH_AUTHORIZATION_DETAILS (
    TRUSTED_CLIENT_ID VARCHAR(256) NOT NULL,
    COMPARE_TYPE VARCHAR(256),
    ID VARCHAR(256) NOT NULL,
    AUTHORIZATION_DETAILS             CLOB,
    CONSTRAINT PK_UNIQUEIDAD PRIMARY KEY (TRUSTED_CLIENT_ID, ID),
    FOREIGN KEY (TRUSTED_CLIENT_ID) REFERENCES OAUTH_TRUSTED_CLIENT (TRUSTED_CLIENT_ID) ON DELETE CASCADE
);

CREATE TABLE OAUTH20_DYNAMIC_CLIENT
(
    CLIENT_ID       VARCHAR2(256) NOT NULL,
    DEFINITION_ID   NUMBER(19, 0) NOT NULL,
    DEFINITION_NAME VARCHAR2(200),
    OWNER_USERNAME  VARCHAR2(256),
    DYN_DATA        CLOB,
    CONSTRAINT DYN_PK_LOOKUPKEY PRIMARY KEY (CLIENT_ID)
);

CREATE INDEX OAUTH20DYNCLIENT_DEF ON OAUTH20_DYNAMIC_CLIENT (DEFINITION_ID);
CREATE INDEX OAUTH20DYNCLIENTS_USER ON OAUTH20_DYNAMIC_CLIENT (OWNER_USERNAME);

CREATE TABLE DMAP_ENTRIES
(
    DMAP_KEY       VARCHAR2(256) NOT NULL,
    DMAP_PARTITION VARCHAR2(256) NOT NULL,
    DMAP_VALUE     CLOB          NOT NULL,
    DMAP_EXPIRY    NUMBER(19, 0) NOT NULL,
    PRIMARY KEY (DMAP_KEY, DMAP_PARTITION)
);

CREATE INDEX DMAP_EXPIRY_INDEX ON DMAP_ENTRIES (DMAP_EXPIRY);

ALTER TABLE OAUTH20_TOKEN_EXTRA_ATTRIBUTE MODIFY ATTR_VALUE VARCHAR(1024);


ALTER TABLE OAUTH20_TOKEN_CACHE ADD AUTHORIZATION_DETAILS CLOB;

COMMIT;