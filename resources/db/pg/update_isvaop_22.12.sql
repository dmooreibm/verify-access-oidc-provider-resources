/*
 * IBM Confidential 
 * PID 5725-V89 5725-V90 5737-F02
 *
 * Copyright IBM Corp. 2021, 2022
 */

CREATE TABLE IF NOT EXISTS OAUTH20_TOKEN_CACHE (
	TOKEN_ID          VARCHAR(512)    NOT NULL,
	TYPE              VARCHAR(64)     NOT NULL,
	SUB_TYPE          VARCHAR(64),
	DATE_CREATED      BIGINT,
	DATE_LAST_USED    BIGINT,
	LIFETIME          INT,
	TOKEN_STRING      VARCHAR(512)    NOT NULL,
	CLIENT_ID         VARCHAR(256)    NOT NULL,
	USERNAME          VARCHAR(256)    NOT NULL,
	SCOPE             VARCHAR(512),
	REDIRECT_URI      VARCHAR(256),
	STATE_ID          VARCHAR(64)     NOT NULL,
	TOKEN_ENABLED     CHAR            NOT NULL,
	PREV_TOKEN_STRING VARCHAR(512),
	CONSTRAINT  PK_LOOKUPKEY PRIMARY KEY (TOKEN_ID)
);

CREATE INDEX IF NOT EXISTS OAUTH20CACHE_ST        ON OAUTH20_TOKEN_CACHE      (STATE_ID ASC);
CREATE INDEX IF NOT EXISTS OAUTH20CACHE_PTKSTRING ON OAUTH20_TOKEN_CACHE      (PREV_TOKEN_STRING);
CREATE INDEX IF NOT EXISTS OAUTH20CACHE_LIFETIME  ON OAUTH20_TOKEN_CACHE      (LIFETIME ASC);
CREATE INDEX IF NOT EXISTS OAUTH20CACHE_UCID      ON OAUTH20_TOKEN_CACHE      (USERNAME, CLIENT_ID);


CREATE TABLE IF NOT EXISTS OAUTH20_TOKEN_EXTRA_ATTRIBUTE (
    STATE_ID    VARCHAR(256),
    ATTR_NAME   VARCHAR(256),
    ATTR_VALUE  VARCHAR(256),
    SENSITIVE   CHAR      DEFAULT 'N',
    READ_ONLY   CHAR      DEFAULT 'N',
    CONSTRAINT PK_UNIQUEIDEXTRA PRIMARY KEY (STATE_ID, ATTR_NAME)
);

CREATE INDEX IF NOT EXISTS EXTRAATTR_STATE_ID ON OAUTH20_TOKEN_EXTRA_ATTRIBUTE (STATE_ID ASC);


CREATE TABLE IF NOT EXISTS OAUTH20_JTI (
	JWT_TYPE   INT          NOT NULL,
	JWT_ID     VARCHAR(200) NOT NULL,
	EXPIRED_AT BIGINT       NOT NULL,
	CONSTRAINT PK_JTIS PRIMARY KEY(JWT_TYPE, JWT_ID)
);

CREATE INDEX IF NOT EXISTS IX_JTIS_EXPIRED ON OAUTH20_JTI (EXPIRED_AT);


CREATE TABLE IF NOT EXISTS OAUTH_TRUSTED_CLIENT (
    TRUSTED_CLIENT_ID        VARCHAR(256) NOT NULL,
    USERNAME                 VARCHAR(256) NOT NULL,
    CLIENT_ID                VARCHAR(256) NOT NULL,
    CONSTRAINT PK_UNIQUEID PRIMARY KEY (TRUSTED_CLIENT_ID)
);

CREATE INDEX IF NOT EXISTS TRUSTEDCLIENTS_USERNAME    ON OAUTH_TRUSTED_CLIENT    (USERNAME);
CREATE INDEX IF NOT EXISTS TRUSTEDCLIENTS_USERCLIENT  ON OAUTH_TRUSTED_CLIENT    (USERNAME, CLIENT_ID);


CREATE TABLE IF NOT EXISTS OAUTH_SCOPE (
    TRUSTED_CLIENT_ID    VARCHAR(256) NOT NULL,
    SCOPE                VARCHAR(256) NOT NULL,
    CONSTRAINT PK_UNIQUEIDSCOPE PRIMARY KEY (TRUSTED_CLIENT_ID, SCOPE),
    FOREIGN KEY (TRUSTED_CLIENT_ID) REFERENCES OAUTH_TRUSTED_CLIENT(TRUSTED_CLIENT_ID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS OAUTH20_DYNAMIC_CLIENT (
    CLIENT_ID       VARCHAR(256) NOT NULL,
    DEFINITION_ID   BIGINT       NOT NULL,
    DEFINITION_NAME VARCHAR(200),
    OWNER_USERNAME  VARCHAR(256),
    DYN_DATA        TEXT,
    CONSTRAINT DYN_PK_LOOKUPKEY PRIMARY KEY (CLIENT_ID)
);

CREATE INDEX IF NOT EXISTS OAUTH20DYNCLIENT_DEF    ON OAUTH20_DYNAMIC_CLIENT (DEFINITION_ID);
CREATE INDEX IF NOT EXISTS OAUTH20DYNCLIENTS_USER  ON OAUTH20_DYNAMIC_CLIENT (OWNER_USERNAME);


CREATE TABLE IF NOT EXISTS DMAP_ENTRIES (
    DMAP_KEY        VARCHAR(256) NOT NULL,
    DMAP_PARTITION  VARCHAR(256) NOT NULL,
    DMAP_VALUE      TEXT         NOT NULL,
    DMAP_EXPIRY     BIGINT,
    PRIMARY KEY (DMAP_KEY, DMAP_PARTITION)
);

CREATE INDEX IF NOT EXISTS DMAP_EXPIRY_INDEX ON DMAP_ENTRIES(DMAP_EXPIRY);