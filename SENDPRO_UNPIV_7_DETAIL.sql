
-- taken from SNOWFALKE QA
create or replace view MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_837I_UNPIV_DETAIL(
	RUN_DATE,
	FILENAME,
	CLAIM_TYPE,
	RECORD_TYPE,
	MEASURE,
	TYPE,
	PATIENTCONTROLNUM,
	NUMDTL,
	RNK,
	SUBMITTERNAME
) as

SELECT DISTINCT A.*,
S."SubmitterLastOrgName" AS SUBMITTERNAME
FROM
(

-- limit rank to 10 lines
SELECT *
FROM (
-- rank
  SELECT *,
                                            RANK ()
                                            OVER (PARTITION BY RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               RECORD_TYPE,
                                                               MEASURE
                                                  ORDER BY
                                                               RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               RECORD_TYPE,
                                                               MEASURE,
                                                               TYPE,
                                                               PATIENTCONTROLNUM,
                                                               NUMDTL)    AS rnk

  FROM (

-- only first claim line

SELECT *
  FROM (

-- core unpiv

SELECT RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE, PatientControlNum, NumDtl  
FROM (
    SELECT
    RUN_DATE,
    FILENAME, 
    CLAIM_TYPE, 
    RECORD_TYPE,
    CLAIMFREQUENCYCODE1X AS Claim_Frequency_Code,
	STATEMENTDTP1X AS Statement_Date,
	ADMISSIONDTP1X AS Admission_Date,
	ADMITTINGDIAGNOSISCODE1X AS Admitting_Diagnosis_Code,
	FACILITYTYPECODE1X AS Facility_Type_Code,
	ADMISSIONTYPECODE1X AS Admission_Type_Code,
	ADMISSIONSOURCECODE1X AS Admission_Source_Code,
	SVCLINECHARGEAMT1X AS Service_Line_Chrg_Amt,
	SVCLINEREVENUECODE1X AS Service_Line_Revenue_Code,
	OCCURRENCECODE1X AS Occurence_Code,
	OCCURRENCESPANCODE1X AS Occurrence_Span_Code,
	VALUECODE1X AS Value_Code,
	CONDITIONCODE1X AS Condition_Code,
	PATIENTSTATUSCODE1X AS Patient_Status_Code,
	PRINCIPALDIAGNOSISCODE1X AS Principal_Diag_Code,
	ICD10DIAGNOSIS_CODE1X AS ICD10_Diag_Code,
	MULTIPLEPROCEDURECODE1X AS Service_Line_Proc_Code,
	CDT_CODE1X AS CDT_Code,
	CPT_CODE1X AS CPT_Code,
	HIPPS_CODE1X AS HIPPS_Code,
	SVCLINEPROCMOD1X AS Service_Line_Proc_Mod,
	SVCLINEADJREVENUECODE1X AS Service_Line_Adjust_Revenue_Code,
	PROCEDURECODE1X AS Procedure_Code,
	SVCLINEADJUDICATIONPROCMOD1X AS Service_Line_Adj_Revenue_Code,

	BILLINGPROVNPI1X AS Bill_Provider_NPI,
    BILL_PROVIDERINTERNALID1X Bill_Provider_Internal_ID,
    BILL_PROVIDERPIDSL1X Bill_Provider_PIDSL,

    AT_ATTENDINGPROVNPI1X Attending_Provider_NPI,
    AT_PROVIDERINTERNALID1X Attending_Provider_Internal_ID,
    AT_PROVIDERPIDSL1X Attending_Provider_PIDSL,

    REF_REFERRINGPROVNPI1X Referring_Provider_NPI,
    REF_PROVIDERINTERNALID1X Referring_Provider_Internal_ID,
    REF_PROVIDERPIDSL1X Referring_Provider_PIDSL,

    REN_RENDERINGPROVNPI1X Rendering_Provider_NPI,
    REN_PROVIDERINTERNALID1X Rendering_Provider_Internal_ID,
    REN_PROVIDERPIDSL1X Rendering_Provider_PIDSL,

    OOP_OTHEROPERPROVNPI1X Other_Provider_NPI,
    OOP_PROVIDERINTERNALID1X Other_Provider_Internal_ID,
    OOP_PROVIDERPIDSL1X Other_Provider_PIDSL,

    OP_OPERATINGPROVNPI1X Operating_Provider_NPI,
    OP_PROVIDERINTERNALID1X Operating_Provider_Internal_ID,
    OP_PROVIDERPIDSL1X Operating_Provider_PIDSL,
    
    PatientControlNum, 
    NumDtl
    FROM MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA_7_QA
)
UNPIVOT (
TYPE
FOR MEASURE IN (
	Claim_Frequency_Code,
	Statement_Date,
	Admission_Date,
	Admitting_Diagnosis_Code,
	Facility_Type_Code,
	Admission_Type_Code,
	Admission_Source_Code,
	Service_Line_Chrg_Amt,
	Service_Line_Revenue_Code,
	Occurence_Code,
	Occurrence_Span_Code,
	Value_Code,
	Condition_Code,
	Patient_Status_Code,
	Principal_Diag_Code,
	ICD10_Diag_Code,
	Service_Line_Proc_Code,
	CDT_Code,
	CPT_Code,
	HIPPS_Code,
	Service_Line_Proc_Mod,
	Service_Line_Adjust_Revenue_Code,
	Procedure_Code,
	Service_Line_Adj_Revenue_Code,

	Bill_Provider_NPI,
    Bill_Provider_Internal_ID,
    Bill_Provider_PIDSL,

    Attending_Provider_NPI,
    Attending_Provider_Internal_ID,
    Attending_Provider_PIDSL,

    Referring_Provider_NPI,
    Referring_Provider_Internal_ID,
    Referring_Provider_PIDSL,

    Rendering_Provider_NPI,
    Rendering_Provider_Internal_ID,
    Rendering_Provider_PIDSL,

    Other_Provider_NPI,
    Other_Provider_Internal_ID,
    Other_Provider_PIDSL,

    Operating_Provider_NPI,
    Operating_Provider_Internal_ID,
    Operating_Provider_PIDSL

)
) AS UNPIV7
ORDER BY RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE

)
-- only first claim line
    WHERE NUMDTL = 1
    )
-- add rank
)
-- limit rank to 10 line
WHERE rnk <= 10
) A
LEFT JOIN MHDWQA.SENDPRO.RAW_SPRO_837I_FILE_STATISTICS S
    ON A.FILENAME = S."FileName" AND A.CLAIM_TYPE IN ('I','L','O')
ORDER BY 
                                                               RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               RECORD_TYPE,
                                                               MEASURE,
                                                               TYPE,
                                                               PATIENTCONTROLNUM,
                                                               RNK
;

-----------------

DROP VIEW INF_SENDPRO_CLAIMS_DQ_7_837M_UNPIV_DETAIL;


CREATE VIEW INF_SENDPRO_CLAIMS_DQ_7_837M_UNPIV_DETAIL
AS

SELECT DISTINCT A.*,
PS."SubmitterLastOrgName" AS SUBMITTERNAME
FROM
(

-- limit rank to 10 lines
SELECT *
FROM (
-- rank
  SELECT *,
                                            RANK ()
                                            OVER (PARTITION BY RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               RECORD_TYPE,
                                                               MEASURE
                                                  ORDER BY
                                                               RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               RECORD_TYPE,
                                                               MEASURE,
                                                               TYPE,
                                                               PATIENTCONTROLNUM,
                                                               NUMDTL)    AS rnk

  FROM (

-- only first claim line

SELECT *
  FROM (

-- core unpiv

SELECT RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE, PatientControlNum, NumDtl  
FROM (
    SELECT
    RUN_DATE,
    FILENAME, 
    CLAIM_TYPE,
    RECORD_TYPE,
    CLAIMFREQUENCYCODE1X AS Claim_Frequency_Code,
	STATEMENTDTP1X AS Statement_Date,
	ADMISSIONDTP1X AS Admission_Date,
	ADMITTINGDIAGNOSISCODE1X AS Admitting_Diagnosis_Code,
	FACILITYTYPECODE1X AS Facility_Type_Code,
	ADMISSIONTYPECODE1X AS Admission_Type_Code,
	ADMISSIONSOURCECODE1X AS Admission_Source_Code,
	SVCLINECHARGEAMT1X AS Service_Line_Chrg_Amt,
	SVCLINEREVENUECODE1X AS Service_Line_Revenue_Code,
	OCCURRENCECODE1X AS Occurence_Code,
	OCCURRENCESPANCODE1X AS Occurrence_Span_Code,
	VALUECODE1X AS Value_Code,
	CONDITIONCODE1X AS Condition_Code,
	PATIENTSTATUSCODE1X AS Patient_Status_Code,
	PRINCIPALDIAGNOSISCODE1X AS Principal_Diag_Code,
	ICD10DIAGNOSIS_CODE1X AS ICD10_Diag_Code,
	MULTIPLEPROCEDURECODE1X AS Service_Line_Proc_Code,
	CDT_CODE1X AS CDT_Code,
	CPT_CODE1X AS CPT_Code,
	HIPPS_CODE1X AS HIPPS_Code,
	SVCLINEPROCMOD1X AS Service_Line_Proc_Mod,
	SVCLINEADJREVENUECODE1X AS Service_Line_Adjust_Revenue_Code,
	PROCEDURECODE1X AS Procedure_Code,
	SVCLINEADJUDICATIONPROCMOD1X AS Service_Line_Adj_Proc_Mod,

	BILLINGPROVNPI1X AS Bill_Provider_NPI,
    BILL_PROVIDERINTERNALID1X Bill_Provider_Internal_ID,
    BILL_PROVIDERPIDSL1X Bill_Provider_PIDSL,

    REF_REFERRINGPROVNPI1X Referring_Provider_NPI,
    REF_PROVIDERINTERNALID1X Referring_Provider_Internal_ID,
    REF_PROVIDERPIDSL1X Referring_Provider_PIDSL,

    REN_RENDERINGPROVNPI1X Rendering_Provider_NPI,
    REN_PROVIDERINTERNALID1X Rendering_Provider_Internal_ID,
    REN_PROVIDERPIDSL1X Rendering_Provider_PIDSL,

    SUP_SUPERVISINGPROVNPI1X Supervising_Provider_NPI,
    SUP_PROVIDERINTERNALID1X Supervising_Provider_Internal_ID,
    SUP_PROVIDERPIDSL1X Supervising_Provider_PIDSL,

    ORD_ORDERINGPROVID1X Ordering_Provider_NPI,
    ORD_PROVIDERINTERNALID1X Ordering_Provider_Internal_ID,
    ORD_PROVIDERPIDSL1X Ordering_Provider_PIDSL,
    
    PatientControlNum, 
    NumDtl
    FROM MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA_7M_QA
)
UNPIVOT (
TYPE
FOR MEASURE IN (
	Claim_Frequency_Code,
	Statement_Date,
	Admission_Date,
	Admitting_Diagnosis_Code,
	Facility_Type_Code,
	Admission_Type_Code,
	Admission_Source_Code,
	Service_Line_Chrg_Amt,
	Service_Line_Revenue_Code,
	Occurence_Code,
	Occurrence_Span_Code,
	Value_Code,
	Condition_Code,
	Patient_Status_Code,
	Principal_Diag_Code,
	ICD10_Diag_Code,
	Service_Line_Proc_Code,
	CDT_Code,
	CPT_Code,
	HIPPS_Code,
	Service_Line_Proc_Mod,
	Service_Line_Adjust_Revenue_Code,
	Procedure_Code,
	Service_Line_Adj_Proc_Mod,

    Bill_Provider_NPI,
    Bill_Provider_Internal_ID,
    Bill_Provider_PIDSL,

    Referring_Provider_NPI,
    Referring_Provider_Internal_ID,
    Referring_Provider_PIDSL,

    Rendering_Provider_NPI,
    Rendering_Provider_Internal_ID,
    Rendering_Provider_PIDSL,

    Supervising_Provider_NPI,
    Supervising_Provider_Internal_ID,
    Supervising_Provider_PIDSL,

    Ordering_Provider_NPI,
    Ordering_Provider_Internal_ID,
    Ordering_Provider_PIDSL

)
) AS UNPIV7M
ORDER BY RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE

)
-- only first claim line
    WHERE NUMDTL = 1
    )
-- add rank
)
-- limit rank to 10 line
WHERE rnk <= 10

) A
LEFT JOIN MHDWQA.SENDPRO.RAW_SPRO_837P_FILE_STATISTICS PS
    ON A.FILENAME = PS."FileName" AND A.CLAIM_TYPE = 'M'
ORDER BY 
                                                               RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               RECORD_TYPE,
                                                               MEASURE,
                                                               TYPE,
                                                               PATIENTCONTROLNUM,
                                                               RNK
;

-----------------

DROP VIEW INF_SENDPRO_CLAIMS_DQ_7_837D_UNPIV_DETAIL;


CREATE VIEW INF_SENDPRO_CLAIMS_DQ_7_837D_UNPIV_DETAIL
AS

SELECT DISTINCT A.*,
DS."SubmitterLastOrgName" AS SUBMITTERNAME
FROM
(

-- limit rank to 10 lines
SELECT *
FROM (
-- rank
  SELECT *,
                                            RANK ()
                                            OVER (PARTITION BY RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               RECORD_TYPE,
                                                               MEASURE
                                                  ORDER BY
                                                               RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               RECORD_TYPE,
                                                               MEASURE,
                                                               TYPE,
                                                               PATIENTCONTROLNUM,
                                                               NUMDTL)    AS rnk

  FROM (

-- only first claim line

SELECT *
  FROM (

-- core unpiv

SELECT RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE, PatientControlNum, NumDtl  
FROM (
    SELECT
    RUN_DATE,
    FILENAME, 
    CLAIM_TYPE,
    RECORD_TYPE,
    CLAIMFREQUENCYCODE1X AS Claim_Frequency_Code,
	SVCLINECHARGEAMT1X AS Service_Line_Chrg_Amt,
	SVCLINEADJREVENUECODE1X AS Service_Line_Revenue_Code,

	BILLINGPROVNPI1X AS Bill_Provider_NPI,
    BILL_PROVIDERINTERNALID1X Bill_Provider_Internal_ID,
    BILL_PROVIDERPIDSL1X Bill_Provider_PIDSL,

    REF_REFERRINGPROVNPI1X Referring_Provider_NPI,
    REF_PROVIDERINTERNALID1X Referring_Provider_Internal_ID,
    REF_PROVIDERPIDSL1X Referring_Provider_PIDSL,

    REN_RENDERINGPROVNPI1X Rendering_Provider_NPI,
    REN_PROVIDERINTERNALID1X Rendering_Provider_Internal_ID,
    REN_PROVIDERPIDSL1X Rendering_Provider_PIDSL,

    SUP_SUPERVISINGPROVNPI1X Supervising_Provider_NPI,
    SUP_PROVIDERINTERNALID1X Supervising_Provider_Internal_ID,
    SUP_PROVIDERPIDSL1X Supervising_Provider_PIDSL,

    ASST_ASSISTANTSURGEONPROVNPI1X Assistant_Surg_Provider_NPI,    
    ASST_PROVIDERINTERNALID1X Assistant_Surg_Provider_Internal_ID,
    ASST_PROVIDERPIDSL1X Assistant_Surg_Provider_PIDSL,
    
    PatientControlNum, 
    NumDtl
    FROM MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA_7D_QA
)
UNPIVOT (
TYPE
FOR MEASURE IN (
	Claim_Frequency_Code,
	Service_Line_Chrg_Amt,
	Service_Line_Revenue_Code,
    
    Bill_Provider_NPI,
    Bill_Provider_Internal_ID,
    Bill_Provider_PIDSL,

    Referring_Provider_NPI,
    Referring_Provider_Internal_ID,
    Referring_Provider_PIDSL,

    Rendering_Provider_NPI,
    Rendering_Provider_Internal_ID,
    Rendering_Provider_PIDSL,

    Supervising_Provider_NPI,
    Supervising_Provider_Internal_ID,
    Supervising_Provider_PIDSL,

    Assistant_Surg_Provider_NPI,
    Assistant_Surg_Provider_Internal_ID,
    Assistant_Surg_Provider_PIDSL

)
) AS UNPIV7D
ORDER BY RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE

)
-- only first claim line
    WHERE NUMDTL = 1
    )
-- add rank
)
-- limit rank to 10 line
WHERE rnk <= 10
) A
LEFT JOIN MHDWQA.SENDPRO.RAW_SPRO_837D_FILE_STATISTICS DS
    ON A.FILENAME = DS."FileName" AND A.CLAIM_TYPE = 'D'
ORDER BY 
                                                               RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               RECORD_TYPE,
                                                               MEASURE,
                                                               TYPE,
                                                               PATIENTCONTROLNUM,
                                                               RNK
;

---------

create or replace view MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV_DETAIL(
	RUN_DATE,
	FILENAME,
	CLAIM_TYPE,
	MEASURE,
	TYPE,
	SUBSCRIBERMEMBERID,
	NUMDTL,
	PAHDRSENDINGENTITYID,
	DOS,
	NDCSERV,
	PRODCODE01,
	PRODCODE02,
	PRODCODE03,
	COMPNDPRODCODE01,
	COMPNDPRODCODE02,
	COMPNDPRODCODE03,
	ADJUDICATIONDATE,
	TRANSID,
	TRANSIDCROSSREF,
	SERVPROVNPI,
	SERVPROVSECID,
	PRESCRIBERNPI,
	PRESCRIBERSECID,
	RNK
) as

-- limit rank to 10 lines
SELECT *
FROM (
-- rank
  SELECT *,
                                            RANK ()
                                            OVER (PARTITION BY RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               MEASURE
                                                  ORDER BY
                                                               RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               MEASURE,
                                                               TYPE,
                                                               SubscriberMemberID,
                                                               NUMDTL)    AS rnk

  FROM (

-- only first claim line

SELECT *
  FROM (

-- core unpiv

SELECT RUN_DATE, FILENAME, CLAIM_TYPE, MEASURE, TYPE, SubscriberMemberID, Numdtl,
PAHdrSendingEntityID,
DOS,
NDCServ,
ProdCode01,
ProdCode02,
ProdCode03,
CompndProdCode01,
CompndProdCode02,
CompndProdCode03,
AdjudicationDate,
TransID,
TransIDCrossRef,
ServProvNPI,
ServProvSecID,
PrescriberNPI,
PrescriberSecID

FROM (
    SELECT 
RUN_DATE,
claim_type,
PAHdrSendingEntityID,
Filename,
DOS,
NDCServ,
ProdCode01,
ProdCode02,
ProdCode03,
CompndProdCode01,
CompndProdCode02,
CompndProdCode03,
AdjudicationDate,
TransID,
TransIDCrossRef,
ServProvNPI,
ServProvSecID,
PrescriberNPI,
PrescriberSecID,
	SUBSCRIBERMEMBERID1X AS Cardholder_Id,
	NDCSERV1X            AS NDC,
	COMPNDPRODCODE1X     AS Compound_NDC,
	ADJUDICATIONDATE1X   AS Adjudication_Date, 
	SERVPROVNPI1X        AS Service_Provider_NPI,
	SERVPROVSECID1X      AS Service_Provider_ID,
    PRESCRIBERNPI1X      AS Prescriber_Provider_NPI,
    PRESCRIBERSECID1X    AS Prescriber_Provider_ID,
    SubscriberMemberID,
    Numdtl
    FROM MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA
)
UNPIVOT (
TYPE
FOR MEASURE IN (
 	Cardholder_Id,
	NDC,
	Compound_NDC,
	Adjudication_Date,
	Service_Provider_NPI,
	Service_Provider_ID,
    Prescriber_Provider_NPI,
    Prescriber_Provider_ID
 )
) AS UNPIV
ORDER BY RUN_DATE, FILENAME, CLAIM_TYPE, MEASURE, TYPE

)
-- only first claim line
    WHERE NUMDTL = 1
    )
-- add rank
)
-- limit rank to 10 line
WHERE rnk <= 10
ORDER BY 
                                                               RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               MEASURE,
                                                               TYPE,
                                                               SubscriberMemberID,
                                                               RNK
;
