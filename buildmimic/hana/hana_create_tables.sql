-- -------------------------------------------------------------------------------
--
-- This is a script to generate the MIMIC-III schema and import data for SAP HANA.
--
-- -------------------------------------------------------------------------------

--------------------------------------------------------
--  File created - Wednesday-November-20-2015   
--------------------------------------------------------

-- Create the schema
CREATE SCHEMA MIMICIII;

DROP TABLE MIMICIII.ADMISSIONS;
--DROP TABLE MIMICIII.CENSUSEVENTS;
DROP TABLE MIMICIII.CALLOUT;
DROP TABLE MIMICIII.CAREGIVERS;
DROP TABLE MIMICIII.CHARTEVENTS;
--DROP TABLE MIMICIII.COMORBIDITY_SCORES;
DROP TABLE MIMICIII.CPTEVENTS;
DROP TABLE MIMICIII.DATETIMEEVENTS;
DROP TABLE MIMICIII.DIAGNOSES_ICD;
DROP TABLE MIMICIII.DRGCODES;
--DROP TABLE MIMICIII.D_CAREGIVERS;
--DROP TABLE MIMICIII.D_CAREUNITS;
DROP TABLE MIMICIII.D_CPT;
DROP TABLE MIMICIII.D_ICD_DIAGNOSES;
DROP TABLE MIMICIII.D_ICD_PROCEDURES;
DROP TABLE MIMICIII.D_ITEMS;
DROP TABLE MIMICIII.D_LABITEMS;
--DROP TABLE MIMICIII.D_PATIENTS;
--DROP TABLE MIMICIII.D_UNITS;
--DROP TABLE MIMICIII.DEMOGRAPHIC_DETAIL;
--DROP TABLE MIMICIII.DRGEVENTS;
--DROP TABLE MIMICIII.ICD9;
DROP TABLE MIMICIII.ICUSTAYS;
--DROP TABLE MIMICIII.ICUSTAY_DAYS;
--DROP TABLE MIMICIII.ICUSTAYEVENTS;
--DROP TABLE MIMICIII.IOEVENTS;
DROP TABLE MIMICIII.INPUTEVENTS_CV;
DROP TABLE MIMICIII.INPUTEVENTS_MV;
DROP TABLE MIMICIII.LABEVENTS;
--DROP TABLE MIMICIII.MEDEVENTS;
DROP TABLE MIMICIII.MICROBIOLOGYEVENTS;
DROP TABLE MIMICIII.NOTEEVENTS;
--DROP TABLE MIMICIII.ORDERENTRY;
DROP TABLE MIMICIII.OUTPUTEVENTS;
DROP TABLE MIMICIII.PATIENTS;
--DROP TABLE MIMICIII.POE_MED_ORDER;
DROP TABLE MIMICIII.PRESCRIPTIONS;
--DROP TABLE MIMICIII.PROCEDUREEVENTS;
DROP TABLE MIMICIII.PROCEDUREEVENTS_MV;
DROP TABLE MIMICIII.PROCEDURES_ICD;
DROP TABLE MIMICIII.SERVICES;
--DROP TABLE MIMICIII.TOTALBALEVENTS;
DROP TABLE MIMICIII.TRANSFERS;


-- The below command defines the schema where all tables are created
SET SCHEMA MIMICIII;

--------------------------------------------------------
--  DDL for Table ADMISSIONS
--------------------------------------------------------

  CREATE COLUMN TABLE ADMISSIONS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT NOT NULL,
	ADMITTIME LONGDATE CS_LONGDATE NOT NULL,
	DISCHTIME LONGDATE CS_LONGDATE NOT NULL,
	DEATHTIME LONGDATE CS_LONGDATE,
	ADMISSION_TYPE VARCHAR(50) NOT NULL,
	ADMISSION_LOCATION VARCHAR(50) NOT NULL,
	DISCHARGE_LOCATION VARCHAR(50) NOT NULL,
	INSURANCE VARCHAR(255) NOT NULL,
	LANGUAGE VARCHAR(10),
	RELIGION VARCHAR(50),
	MARITAL_STATUS VARCHAR(50),
	ETHNICITY VARCHAR(200) NOT NULL,
	EDREGTIME LONGDATE CS_LONGDATE,
	EDOUTTIME LONGDATE CS_LONGDATE,
	DIAGNOSIS VARCHAR(255),
	HOSPITAL_EXPIRE_FLAG SMALLINT,
    HAS_IOEVENTS_DATA SMALLINT NOT NULL,
    HAS_CHARTEVENTS_DATA SMALLINT NOT NULL,
	CONSTRAINT adm_rowid_pk PRIMARY KEY (ROW_ID),
    CONSTRAINT adm_hadm_unique UNIQUE (HADM_ID)
   ) ;

-- Example command for importing from a CSV to a table

IMPORT FROM CSV FILE '/path/to/csv/file/ADMISSIONS_DATA_TABLE.csv'
INTO ADMISSIONS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/ADMISSIONS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table CALLOUT
--------------------------------------------------------

CREATE COLUMN TABLE CALLOUT
    (   ROW_ID INTEGER CS_INT NOT NULL,
        SUBJECT_ID INTEGER CS_INT NOT NULL,
        HADM_ID INTEGER CS_INT NOT NULL,
        SUBMIT_WARDID INTEGER CS_INT,
        SUBMIT_CAREUNIT VARCHAR(15),
        CURR_WARDID INTEGER CS_INT,
        CURR_CAREUNIT VARCHAR(15),
        CALLOUT_WARDID INTEGER CS_INT,
        CALLOUT_SERVICE VARCHAR(10) NOT NULL,
        REQUEST_TELE SMALLINT NOT NULL,
        REQUEST_RESP SMALLINT NOT NULL,
        REQUEST_CDIFF SMALLINT NOT NULL,
        REQUEST_MRSA SMALLINT NOT NULL,
        REQUEST_VRE SMALLINT NOT NULL,
        CALLOUT_STATUS VARCHAR(20) NOT NULL,
        CALLOUT_OUTCOME VARCHAR(20) NOT NULL,
        DISCHARGE_WARDID INTEGER CS_INT,
        ACKNOWLEDGE_STATUS VARCHAR(20) NOT NULL,
        CREATETIME LONGDATE CS_LONGDATE NOT NULL,
        UPDATETIME LONGDATE CS_LONGDATE NOT NULL,
        ACKNOWLEDGETIME LONGDATE CS_LONGDATE,
        OUTCOMETIME LONGDATE CS_LONGDATE NOT NULL,
        FIRSTRESERVATIONTIME LONGDATE CS_LONGDATE,
        CURRENTRESERVATIONTIME LONGDATE CS_LONGDATE,
        CONSTRAINT callout_rowid_pk PRIMARY KEY (ROW_ID)
        );

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/CALLOUT_DATA_TABLE.csv'
INTO CALLOUT
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/CALLOUT_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table CAREGIVERS
--------------------------------------------------------

  CREATE COLUMN TABLE CAREGIVERS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	CGID INTEGER CS_INT NOT NULL,
	LABEL VARCHAR(15),
	DESCRIPTION VARCHAR(30),
	CONSTRAINT cg_rowid_pk  PRIMARY KEY (ROW_ID),
	CONSTRAINT cg_cgid_unique UNIQUE (CGID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/CAREGIVERS_DATA_TABLE.csv'
INTO CAREGIVERS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/CAREGIVERS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table CHARTEVENTS
--------------------------------------------------------

  CREATE COLUMN TABLE CHARTEVENTS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT,
	ICUSTAY_ID INTEGER CS_INT,
	ITEMID INTEGER CS_INT,
	CHARTTIME LONGDATE CS_LONGDATE,
	STORETIME LONGDATE CS_LONGDATE,
	CGID INTEGER CS_INT,
	VALUE VARCHAR(255),
	VALUENUM DOUBLE PRECISION,
	UOM VARCHAR(50),
	WARNING INTEGER CS_INT,
	ERROR INTEGER CS_INT,
	RESULTSTATUS VARCHAR(50),
	STOPPED VARCHAR(50),
	CONSTRAINT chartevents_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/CHARTEVENTS_DATA_TABLE.csv'
INTO CHARTEVENTS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/CHARTEVENTS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table CPTEVENTS
--------------------------------------------------------

  CREATE COLUMN TABLE CPTEVENTS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT NOT NULL,
	COSTCENTER VARCHAR(10) NOT NULL,
	CHARTDATE LONGDATE CS_LONGDATE,
	CPT_CD VARCHAR(10) NOT NULL,
	CPT_NUMBER INTEGER CS_INT,
	CPT_SUFFIX VARCHAR(5),
	TICKET_ID_SEQ INTEGER CS_INT,
	SECTIONHEADER VARCHAR(50),
	SUBSECTIONHEADER VARCHAR(255),
	DESCRIPTION VARCHAR(200),
	CONSTRAINT cpt_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/CPTEVENTS_DATA_TABLE.csv'
INTO CPTEVENTS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/CPTEVENTS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table DATETIMEEVENTS
--------------------------------------------------------

  CREATE COLUMN TABLE DATETIMEEVENTS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT,
	ICUSTAY_ID INTEGER CS_INT,
	ITEMID INTEGER CS_INT NOT NULL,
	CHARTTIME LONGDATE CS_LONGDATE NOT NULL,
	STORETIME LONGDATE CS_LONGDATE NOT NULL,
	CGID INTEGER CS_INT NOT NULL,
	VALUE LONGDATE CS_LONGDATE,
	UOM VARCHAR(50) NOT NULL,
	WARNING SMALLINT,
	ERROR SMALLINT,
	RESULTSTATUS VARCHAR(50),
	STOPPED VARCHAR(50),
	CONSTRAINT datetime_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/DATETIMEEVENTS_DATA_TABLE.csv'
INTO DATETIMEEVENTS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/DATETIMEEVENTS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table DIAGNOSES_ICD
--------------------------------------------------------

  CREATE COLUMN TABLE DIAGNOSES_ICD
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT NOT NULL,
	SEQ_NUM INTEGER CS_INT,
	ICD9_CODE VARCHAR(20),
	CONSTRAINT diagnosesicd_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/DIAGNOSES_ICD_DATA_TABLE.csv'
INTO DIAGNOSES_ICD
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/DIAGNOSES_ICD_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table DRGCODES
--------------------------------------------------------

  CREATE COLUMN TABLE DRGCODES
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT NOT NULL,
	DRG_TYPE VARCHAR(20) NOT NULL,
	DRG_CODE VARCHAR(20) NOT NULL,
	DESCRIPTION VARCHAR(255),
	DRG_SEVERITY SMALLINT,
	DRG_MORTALITY SMALLINT,
	CONSTRAINT drg_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/DRGCODES_DATA_TABLE.csv'
INTO DRGCODES
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/DRGCODES_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table D_CPT
--------------------------------------------------------

  CREATE COLUMN TABLE D_CPT
   (	ROW_ID INTEGER CS_INT NOT NULL,
	CATEGORY SMALLINT NOT NULL,
	SECTIONRANGE VARCHAR(100) NOT NULL,
	SECTIONHEADER VARCHAR(50) NOT NULL,
	SUBSECTIONRANGE VARCHAR(100) NOT NULL,
	SUBSECTIONHEADER VARCHAR(255) NOT NULL,
	CODESUFFIX VARCHAR(5),
	MINCODEINSUBSECTION INTEGER CS_INT NOT NULL,
	MAXCODEINSUBSECTION INTEGER CS_INT NOT NULL,
    	CONSTRAINT dcpt_ssrange_unique UNIQUE (SUBSECTIONRANGE),
    	CONSTRAINT dcpt_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/D_CPT_DATA_TABLE.csv'
INTO D_CPT
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/D_CPT_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table D_ICD_DIAGNOSES
--------------------------------------------------------

  CREATE COLUMN TABLE D_ICD_DIAGNOSES
   (	ROW_ID INTEGER CS_INT NOT NULL,
	ICD9_CODE VARCHAR(10) NOT NULL,
	SHORT_TITLE VARCHAR(50) NOT NULL,
	LONG_TITLE VARCHAR(255) NOT NULL,
    	CONSTRAINT d_icd_diag_code_unique UNIQUE (ICD9_CODE),
    	CONSTRAINT d_icd_diag_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/D_ICD_DIAGNOSES_DATA_TABLE.csv'
INTO D_ICD_DIAGNOSES
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/D_ICD_DIAGNOSES_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table D_ICD_PROCEDURES
--------------------------------------------------------

  CREATE COLUMN TABLE D_ICD_PROCEDURES
   (	ROW_ID INTEGER CS_INT NOT NULL,
	ICD9_CODE VARCHAR(10) NOT NULL,
	SHORT_TITLE VARCHAR(50) NOT NULL,
	LONG_TITLE VARCHAR(255) NOT NULL,
    	CONSTRAINT d_icd_proc_code_unique UNIQUE (ICD9_CODE),
    	CONSTRAINT d_icd_proc_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/D_ICD_PROCEDURES_DATA_TABLE.csv'
INTO D_ICD_PROCEDURES
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/D_ICD_PROCEDURES_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table D_ITEMS
--------------------------------------------------------

  CREATE COLUMN TABLE D_ITEMS
   (	ROW_ID INTEGER CS_INT NOT NULL,
    	ITEMID INTEGER CS_INT NOT NULL,
    	LABEL VARCHAR(200),
    	ABBREVIATION VARCHAR(100),
    	DBSOURCE VARCHAR(20),
    	LINKSTO VARCHAR(50),
    	CATEGORY VARCHAR(100),
    	UNITNAME VARCHAR(100),
    	PARAM_TYPE VARCHAR(30),
    	CONCEPTID INTEGER CS_INT,
    	CONSTRAINT ditems_itemid_unique UNIQUE (ITEMID),
    	CONSTRAINT ditems_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/D_ITEMS_DATA_TABLE.csv'
INTO D_ITEMS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/D_ITEMS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table D_LABITEMS
--------------------------------------------------------

  CREATE COLUMN TABLE D_LABITEMS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	ITEMID INTEGER CS_INT NOT NULL,
	LABEL VARCHAR(100) NOT NULL,
	FLUID VARCHAR(100) NOT NULL,
	CATEGORY VARCHAR(100) NOT NULL,
	LOINC_CODE VARCHAR(100),
    	CONSTRAINT dlabitems_itemid_unique UNIQUE (ITEMID),
    	CONSTRAINT dlabitems_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/D_LABITEMS_DATA_TABLE.csv'
INTO D_LABITEMS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/D_LABITEMS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table ICUSTAYS
--------------------------------------------------------

  CREATE COLUMN TABLE ICUSTAYS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT NOT NULL,
	ICUSTAY_ID INTEGER CS_INT NOT NULL,
	DBSOURCE VARCHAR(20) NOT NULL,
	FIRST_CAREUNIT VARCHAR(20) NOT NULL,
	LAST_CAREUNIT VARCHAR(20) NOT NULL,
	FIRST_WARDID SMALLINT NOT NULL,
	LAST_WARDID SMALLINT NOT NULL,
	INTIME LONGDATE CS_LONGDATE NOT NULL,
	OUTTIME LONGDATE CS_LONGDATE,
	LOS DOUBLE PRECISION,
    	CONSTRAINT icustay_icustayid_unique UNIQUE (ICUSTAY_ID),
    	CONSTRAINT icustay_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/ICUSTAYS_DATA_TABLE.csv'
INTO ICUSTAYS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/ICUSTAYS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;


--------------------------------------------------------
--  DDL for Table INPUTEVENTS_CV
--------------------------------------------------------

  CREATE COLUMN TABLE INPUTEVENTS_CV
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT,
	ICUSTAY_ID INTEGER CS_INT,
	CHARTTIME LONGDATE CS_LONGDATE,
	ITEMID INTEGER CS_INT,
	AMOUNT DOUBLE PRECISION,
	AMOUNTUOM VARCHAR(30),
	RATE DOUBLE PRECISION,
	RATEUOM VARCHAR(30),
	STORETIME LONGDATE CS_LONGDATE,
	CGID INTEGER CS_INT,
	ORDERID INTEGER CS_INT,
	LINKORDERID INTEGER CS_INT,
	STOPPED VARCHAR(30),
	NEWBOTTLE INTEGER CS_INT,
	ORIGINALAMOUNT DOUBLE PRECISION,
	ORIGINALAMOUNTUOM VARCHAR(30),
	ORIGINALROUTE VARCHAR(30),
	ORIGINALRATE DOUBLE PRECISION,
	ORIGINALRATEUOM VARCHAR(30),
	ORIGINALSITE VARCHAR(30),
	CONSTRAINT inputevents_cv_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/INPUTEVENTS_CV_DATA_TABLE.csv'
INTO INPUTEVENTS_CV
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/INPUTEVENTS_CV_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table INPUTEVENTS_MV
--------------------------------------------------------

  CREATE COLUMN TABLE INPUTEVENTS_MV
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT,
	ICUSTAY_ID INTEGER CS_INT,
	STARTTIME LONGDATE CS_LONGDATE,
	ENDTIME LONGDATE CS_LONGDATE,
	ITEMID INTEGER CS_INT,
	AMOUNT DOUBLE PRECISION,
	AMOUNTUOM VARCHAR(30),
	RATE DOUBLE PRECISION,
	RATEUOM VARCHAR(30),
	STORETIME LONGDATE CS_LONGDATE,
	CGID INTEGER CS_INT,
	ORDERID INTEGER CS_INT,
	LINKORDERID INTEGER CS_INT,
	ORDERCATEGORYNAME VARCHAR(100),
	SECONDARYORDERCATEGORYNAME VARCHAR(100),
	ORDERCOMPONENTTYPEDESCRIPTION VARCHAR(200),
	ORDERCATEGORYDESCRIPTION VARCHAR(50),
	PATIENTWEIGHT DOUBLE PRECISION,
	TOTALAMOUNT DOUBLE PRECISION,
	TOTALAMOUNTUOM VARCHAR(50),
	ISOPENBAG SMALLINT,
	CONTINUEINNEXTDEPT SMALLINT,
	CANCELREASON SMALLINT,
	STATUSDESCRIPTION VARCHAR(30),
	COMMENTS_EDITEDBY VARCHAR(30),
	COMMENTS_CANCELEDBY VARCHAR(40),
	COMMENTS_DATE LONGDATE CS_LONGDATE,
	ORIGINALAMOUNT DOUBLE PRECISION,
	ORIGINALRATE DOUBLE PRECISION,
	CONSTRAINT inputevents_mv_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/INPUTEVENTS_MV_DATA_TABLE.csv'
INTO INPUTEVENTS_MV
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/INPUTEVENTS_MV_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table LABEVENTS
--------------------------------------------------------

  CREATE COLUMN TABLE LABEVENTS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT,
	ITEMID INTEGER CS_INT NOT NULL,
	CHARTTIME LONGDATE CS_LONGDATE,
	VALUE VARCHAR(200),
	VALUENUM DOUBLE PRECISION,
	UOM VARCHAR(20),
	FLAG VARCHAR(20),
	CONSTRAINT labevents_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/LABEVENTS_DATA_TABLE.csv'
INTO LABEVENTS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/LABEVENTS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table MICROBIOLOGYEVENTS
--------------------------------------------------------

  CREATE COLUMN TABLE MICROBIOLOGYEVENTS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT,
	CHARTDATE LONGDATE CS_LONGDATE,
	CHARTTIME LONGDATE CS_LONGDATE,
	SPEC_ITEMID INTEGER CS_INT,
	SPEC_TYPE_DESC VARCHAR(100),
	ORG_ITEMID INTEGER CS_INT,
	ORG_NAME VARCHAR(100),
	ISOLATE_NUM SMALLINT,
	AB_ITEMID INTEGER CS_INT,
	AB_NAME VARCHAR(30),
	DILUTION_TEXT VARCHAR(10),
	DILUTION_COMPARISON VARCHAR(20),
	DILUTION_VALUE DOUBLE PRECISION,
	INTERPRETATION VARCHAR(5),
	CONSTRAINT micro_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/MICROBIOLOGYEVENTS_DATA_TABLE.csv'
INTO MICROBIOLOGYEVENTS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/MICROBIOLOGYEVENTS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table NOTEEVENTS
--------------------------------------------------------

  CREATE COLUMN TABLE NOTEEVENTS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT,
	CHARTDATE LONGDATE CS_LONGDATE,
	CHARTTIME LONGDATE CS_LONGDATE,
	STORETIME LONGDATE CS_LONGDATE,
	CATEGORY VARCHAR(50),
	DESCRIPTION VARCHAR(255),
	CGID INTEGER CS_INT,
	ISERROR CHAR(1),
	TEXT NCLOB ST_MEMORY_LOB,
	CONSTRAINT noteevents_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/NOTEEVENTS_DATA_TABLE.csv'
INTO NOTEEVENTS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/NOTEEVENTS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table OUTPUTEVENTS
--------------------------------------------------------

  CREATE COLUMN TABLE OUTPUTEVENTS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT,
	ICUSTAY_ID INTEGER CS_INT,
	CHARTTIME LONGDATE CS_LONGDATE,
	ITEMID INTEGER CS_INT,
	VALUE DOUBLE PRECISION,
	VALUEUOM VARCHAR(30),
	STORETIME LONGDATE CS_LONGDATE,
	CGID INTEGER CS_INT,
	STOPPED VARCHAR(30),
	NEWBOTTLE CHAR(1),
	ISERROR INTEGER CS_INT,
	CONSTRAINT outputevents_cv_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/OUTPUTEVENTS_DATA_TABLE.csv'
INTO OUTPUTEVENTS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/OUTPUTEVENTS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table PATIENTS
--------------------------------------------------------

  CREATE COLUMN TABLE PATIENTS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	GENDER VARCHAR(5) NOT NULL,
	DOB LONGDATE CS_LONGDATE NOT NULL,
	DOD LONGDATE CS_LONGDATE,
	DOD_HOSP LONGDATE CS_LONGDATE,
	DOD_SSN LONGDATE CS_LONGDATE,
	EXPIRE_FLAG VARCHAR(5) NOT NULL,
    	CONSTRAINT pat_subid_unique UNIQUE (SUBJECT_ID),
    	CONSTRAINT pat_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/PATIENTS_DATA_TABLE.csv'
INTO PATIENTS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/PATIENTS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table PRESCRIPTIONS
--------------------------------------------------------

  CREATE COLUMN TABLE PRESCRIPTIONS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT NOT NULL,
	ICUSTAY_ID INTEGER CS_INT,
	STARTDATE LONGDATE CS_LONGDATE,
	ENDDATE LONGDATE CS_LONGDATE,
	DRUG_TYPE VARCHAR(100) NOT NULL,
	DRUG VARCHAR(100) NOT NULL,
	DRUG_NAME_POE VARCHAR(100),
	DRUG_NAME_GENERIC VARCHAR(100),
	FORMULARY_DRUG_CD VARCHAR(120),
	GSN VARCHAR(200),
	NDC VARCHAR(120),
	PROD_STRENGTH VARCHAR(120),
	DOSE_VAL_RX VARCHAR(120),
	DOSE_UNIT_RX VARCHAR(120),
	FORM_VAL_DISP VARCHAR(120),
	FORM_UNIT_DISP VARCHAR(120),
	ROUTE VARCHAR(120),
	CONSTRAINT prescription_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/PRESCRIPTIONS_DATA_TABLE.csv'
INTO PRESCRIPTIONS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/PRESCRIPTIONS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;


--------------------------------------------------------
--  DDL for Table PROCEDUREEVENTS_MV
--------------------------------------------------------


  CREATE COLUMN TABLE PROCEDUREEVENTS_MV
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT NOT NULL,
	ICUSTAY_ID INTEGER CS_INT,
	STARTTIME LONGDATE CS_LONGDATE,
	ENDTIME LONGDATE CS_LONGDATE,
	ITEMID INTEGER CS_INT,
	VALUE DOUBLE PRECISION,
	VALUEUOM VARCHAR(30),
	LOCATION VARCHAR(30),
	LOCATIONCATEGORY VARCHAR(30),
	STORETIME LONGDATE CS_LONGDATE,
	CGID INTEGER CS_INT,
	ORDERID INTEGER CS_INT,
	LINKORDERID INTEGER CS_INT,
	ORDERCATEGORYNAME VARCHAR(100),
	SECONDARYORDERCATEGORYNAME VARCHAR(100),
	ORDERCATEGORYDESCRIPTION VARCHAR(50),
	ISOPENBAG SMALLINT,
	CONTINUEINNEXTDEPT SMALLINT,
	CANCELREASON SMALLINT,
	STATUSDESCRIPTION VARCHAR(30),
	COMMENTS_EDITEDBY VARCHAR(30),
	COMMENTS_CANCELEDBY VARCHAR(30),
	COMMENTS_DATE LONGDATE CS_LONGDATE,
	CONSTRAINT procedureevents_mv_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/PROCEDUREEVENTS_MV_DATA_TABLE.csv'
INTO PROCEDUREEVENTS_MV
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/PROCEDUREEVENTS_MV_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table PROCEDURES_ICD
--------------------------------------------------------

  CREATE COLUMN TABLE PROCEDURES_ICD
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT NOT NULL,
	SEQ_NUM INTEGER CS_INT NOT NULL,
	ICD9_CODE VARCHAR(20) NOT NULL,
	CONSTRAINT proceduresicd_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/PROCEDURES_ICD_DATA_TABLE.csv'
INTO PROCEDURES_ICD
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/PROCEDURES_ICD_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table SERVICES
--------------------------------------------------------

  CREATE COLUMN TABLE SERVICES
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT NOT NULL,
	TRANSFERTIME LONGDATE CS_LONGDATE NOT NULL,
	PREV_SERVICE VARCHAR(20),
	CURR_SERVICE VARCHAR(20),
	CONSTRAINT services_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/SERVICES_DATA_TABLE.csv'
INTO SERVICES
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/SERVICES_DATA_TABLE.log'
--FAIL ON INVALID DATA
;

--------------------------------------------------------
--  DDL for Table TRANSFERS
--------------------------------------------------------

  CREATE COLUMN TABLE TRANSFERS
   (	ROW_ID INTEGER CS_INT NOT NULL,
	SUBJECT_ID INTEGER CS_INT NOT NULL,
	HADM_ID INTEGER CS_INT NOT NULL,
	ICUSTAY_ID INTEGER CS_INT,
	DBSOURCE VARCHAR(20) NOT NULL,
	EVENTTYPE VARCHAR(20),
	PREV_CAREUNIT VARCHAR(20),
	CURR_CAREUNIT VARCHAR(20),
	PREV_WARDID SMALLINT,
	CURR_WARDID SMALLINT,
	INTIME LONGDATE CS_LONGDATE,
	OUTTIME LONGDATE CS_LONGDATE,
	LOS DOUBLE PRECISION,
	CONSTRAINT transfers_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

-- Example command for importing from a CSV to a table
IMPORT FROM CSV FILE '/path/to/csv/file/TRANSFERS_DATA_TABLE.csv'
INTO TRANSFERS
WITH THREADS 8
BATCH 2000
TABLE LOCK
NO TYPE CHECK
SKIP FIRST 1 ROW
--COLUMN LIST IN FIRST ROW WITH SCHEMA FLEXIBILITY
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"'
ERROR LOG '/path/to/log/file/TRANSFERS_DATA_TABLE.log'
--FAIL ON INVALID DATA
;
