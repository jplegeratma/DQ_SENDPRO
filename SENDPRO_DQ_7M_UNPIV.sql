
SELECT * FROM INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UNPIV;

SELECT * 
FROM INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UNPIV
ORDER BY FILENAME, CLAIM_TYPE, MEASURE;

select sum(REC_CNT)
FROM INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UNPIV
where FILENAME = '110025617d_pacdrp_06112025090859_test_pd_8bdc0b0c-077a-49bf-9515-1f683bccfe98.xml'
and MEASURE = 'ADMISSION_DATE';

SELECT * 
FROM INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UNPIV
--where MEASURE = 'ADMISSIONDTP1X'
--where FILENAME = '110025617h_pacdri_03032025113026_test_de_e2948853-4667-434e-aefd-d51abc7a2ae0.xml'
order by FILENAME, CLAIM_TYPE, MEASURE, TYPE


select count(1) from (
SELECT distinct *
FROM MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA_7M_QA
)

select * from INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UNPIV;

select count(1) from INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UNPIV;

select sum(REC_CNT)
from INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UNPIV
where --filename = '110025617d_pacdrp_05092025013247_test_fd_4cab7bd7-492b-4fc0-ab42-d3afe3c464fb.xml' and 
measure = 'CPT_CODE';

select count(1) 
FROM MHDWQA.SENDPRO.RAW_SPRO_837P_FILE_STATISTICS PS

select count(distinct "FileName") 
FROM MHDWQA.SENDPRO.RAW_SPRO_837P_FILE_STATISTICS PS

select count(1) 
FROM MHDWQA.SENDPRO.RAW_SPRO_837P_FILE_STATISTICS PS
where "FileName" = '110025617d_pacdrp_06112025090859_test_pd_8bdc0b0c-077a-49bf-9515-1f683bccfe98.xml'


DROP VIEW INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UNPIV;

-- thu 5/15 - first 7
-- wed 7/9 - added benchmark

CREATE VIEW INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UNPIV
AS

SELECT DISTINCT RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE, REC_CNT,
--SELECT RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE, REC_CNT,
PS."SubmitterLastOrgName" AS SUBMITTERNAME,
L.BENCHMARK_THRESHOLD
FROM
(
SELECT RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE, COUNT(TYPE) AS REC_CNT
FROM (
SELECT RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE
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
    ORD_PROVIDERPIDSL1X Ordering_Provider_PIDSL

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
) AS INF_B_SENDPRO_CLAIMS_DQ_7M_UNPIV
ORDER BY RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE
)
GROUP BY RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE
) A
LEFT JOIN MHDWQA.SENDPRO.RAW_SPRO_837P_FILE_STATISTICS PS
    ON A.FILENAME = PS."FileName" AND A.CLAIM_TYPE = 'M'
JOIN INF_B_SENDPRO_LOOKUP L ON A.MEASURE = L.BENCHMARK
ORDER BY FILENAME, CLAIM_TYPE, MEASURE, TYPE;

