
-- Use the unpiv with rank filters instead

DROP VIEW MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_837I_DETAIL


CREATE VIEW MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_837I_DETAIL
AS
SELECT DISTINCT RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, patientcontrolnum, numdtl
FROM MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA_7_QA
ORDER BY RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE;


CREATE VIEW MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_837I_DETAIL
AS
select 
	RUN_DATE,
	FILENAME,
	CLAIM_TYPE,
	RECORD_TYPE,
	PATIENTCONTROLNUM,
	NUMDTL,
	CLAIMFREQUENCYCODE1X,
	STATEMENTDTP1X,
	ADMISSIONDTP1X,
	ADMITTINGDIAGNOSISCODE1X,
	FACILITYTYPECODE1X,
	ADMISSIONTYPECODE1X,
	ADMISSIONSOURCECODE1X,
	SVCLINECHARGEAMT1X,
	SVCLINEREVENUECODE1X,
	OCCURRENCECODE1X,
	OCCURRENCESPANCODE1X,
	VALUECODE1X,
	CONDITIONCODE1X,
	PATIENTSTATUSCODE1X,
	PRINCIPALDIAGNOSISCODE1X,
	ICD10DIAGNOSIS_CODE1X,
	MULTIPLEPROCEDURECODE1X,
	CDT_CODE1X,
	CPT_CODE1X,
	HIPPS_CODE1X,
	SVCLINEPROCMOD1X,
	SVCLINEADJREVENUECODE1X,
	PROCEDURECODE1X,
	SVCLINEADJUDICATIONPROCMOD1X,
	BILLINGPROVNPI1X,
	BILL_PROVIDERINTERNALID1X,
	BILL_PROVIDERPIDSL1X,
	AT_ATTENDINGPROVNPI1X,
	AT_PROVIDERINTERNALID1X,
	AT_PROVIDERPIDSL1X,
	REF_REFERRINGPROVNPI1X,
	REF_PROVIDERINTERNALID1X,
	REF_PROVIDERPIDSL1X,
	REN_RENDERINGPROVNPI1X,
	REN_PROVIDERINTERNALID1X,
	REN_PROVIDERPIDSL1X,
	OOP_OTHEROPERPROVNPI1X,
	OOP_PROVIDERINTERNALID1X,
	OOP_PROVIDERPIDSL1X,
	OP_OPERATINGPROVNPI1X,
	OP_PROVIDERINTERNALID1X,
	OP_PROVIDERPIDSL1X
FROM MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA_7_QA
ORDER BY RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE;

select count(1) from MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA_7_QA;

--------


select distinct filename
from MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_837I_UNPIV_DETAIL
order by filename;

select count(1)
from MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_837I_UNPIV_DETAIL
where type != 'VALID';

select count(1)
from MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_837I_UNPIV_DETAIL
where filename = 
--NCPDP'110088791b_pacdrd_12032025161702_sit_pd_30302539-9d7a-4a48-8f09-8ef9eaa7f71c.xml'
--D'110031447a_pacdrd_03032025155959_test_de_5256a86b-e060-42c7-93eb-85e98a8b3b70.xml'
--M'110031447b_pacdrp_04082025130110_test_pd_587e39fa-99ef-4bdf-bd24-8fc9ab2573a1.xml'
'110031447b_pacdri_02272025175541_test_pd_4e8fcb4d-61e4-4a7b-bdfe-77362f81a5e4.xml';


select *
from MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_QA_UNPIV
where filename = 
'110031447b_pacdri_02272025175541_test_pd_4e8fcb4d-61e4-4a7b-bdfe-77362f81a5e4.xml'
and measure = 'OTHER_PROVIDER_NPI';


GRANT SELECT ON MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_837I_UNPIV_DETAIL TO DI_TEAM_ROLE;
GRANT SELECT ON MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_837M_UNPIV_DETAIL TO DI_TEAM_ROLE;
GRANT SELECT ON MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_837D_UNPIV_DETAIL TO DI_TEAM_ROLE;

DROP VIEW INF_SENDPRO_CLAIMS_DQ_7_837I_UNPIV_DETAIL;

-- latest view

CREATE VIEW INF_SENDPRO_CLAIMS_DQ_7_837I_UNPIV_DETAIL
AS
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
