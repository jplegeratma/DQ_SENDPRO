--DROP VIEW INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV;

SELECT * FROM INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV;

SELECT * 
FROM INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV
ORDER BY FILENAME, CLAIM_TYPE, MEASURE
LIMIT 10;


SELECT MEASURE, SUM(VALID) SUM_VALID, SUM(TOT_REC) SUM_TOT_REC
FROM (
SELECT *,
CASE WHEN TYPE = 'VALID' OR TYPE = 'NOT APP' THEN 1 
     WHEN TYPE = 'INVALID' OR TYPE = 'NULL' THEN 0
     ELSE 0
     END VALID,
     1 TOT_REC

FROM INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV
WHERE CLAIM_TYPE = 'O'
AND RECORD_TYPE = 'O'
AND FILENAME = '110025617d_pacdri_05092025012200_test_pd_d654ab34-0de5-4bee-b22d-0bf88255f71b.xml'
ORDER BY FILENAME, CLAIM_TYPE, MEASURE
)
GROUP BY MEASURE
ORDER BY MEASURE
LIMIT 10;



SELECT DISTINCT FILENAME 
FROM INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV;

SELECT * 
FROM INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV
--where MEASURE = 'ADMISSIONDTP1X'
where FILENAME = '110025617h_pacdri_14032025082720_test_pd_5aecdb7e-5688-4d68-ae2d-aa596c911f26.xml'
order by FILENAME, CLAIM_TYPE, MEASURE, TYPE


SELECT * 
FROM MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA_7_QA

GRANT SELECT ON MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV TO DI_TEAM_ROLE;

DROP VIEW INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV;

-- tue 5/13 - first 7
-- mon 3/24 - lastest one
-- thu 4/3 = latest one

select * from INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV;

select count(1) from INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV;

select sum(REC_CNT)
from INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV
where --filename = '110025617d_pacdrp_05092025013247_test_fd_4cab7bd7-492b-4fc0-ab42-d3afe3c464fb.xml' and 
measure = 'CPT_CODE';

DROP VIEW INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV;

CREATE VIEW INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV
AS

SELECT DISTINCT RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE, REC_CNT,
S."SubmitterLastOrgName" AS SUBMITTERNAME,
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
    OP_PROVIDERPIDSL1X Operating_Provider_PIDSL
    
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
	Service_Line_Adj_Proc_Mod,
    
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
) AS INF_B_SENDPRO_CLAIMS_DQ_7_UNPIV
ORDER BY RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE
)
GROUP BY RUN_DATE, FILENAME, CLAIM_TYPE, RECORD_TYPE, MEASURE, TYPE
) A
LEFT JOIN MHDWQA.SENDPRO.RAW_SPRO_837I_FILE_STATISTICS S
    ON A.FILENAME = S."FileName" AND A.CLAIM_TYPE IN ('I','L','O')
JOIN INF_B_SENDPRO_LOOKUP L ON A.MEASURE = L.BENCHMARK

ORDER BY FILENAME, CLAIM_TYPE, MEASURE, TYPE;

-------------------

SELECT * FROM (
SELECT FILENAME, CLAIM_TYPE, MEASURE, TYPE, REC_CNT
FROM INF_B_SENDPRO_CLAIMS_DQ_7_QA_UNPIV
ORDER BY FILENAME, CLAIM_TYPE, MEASURE, TYPE
)
MINUS
SELECT * FROM (
SELECT FILENAME, CLAIM_TYPE, MEASURE, TYPE, REC_CNT
FROM INF_B_SENDPRO_CLAIMS_DQ_7_QA_PIV
ORDER BY FILENAME, CLAIM_TYPE, MEASURE, TYPE
)
;

-- Example for Rima 
----------------------

--SELECT * FROM MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_6_QA
--WHERE FILENAME = '110031447a_pacdri_02282025060912_test_de_92726a3e-738e-4711-8353-8802c4ac5f9b.xml';


--  CPT Code
/*
-- 6 is same as 5.3

12.1.23	CDT_Code_ICD10 (MPT_SENDPRO_CPT_Code)
4.1.1.7.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P
4.1.1.8.	MPT_SENDPRO_CPT_Code_Valid_ALL: RAW_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, SvcLineProcCodeQual='HC'; RAW_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, SvcLineProcCodeQual='HC'
4.1.1.9.	MPT_SENDPRO_StringIsNull_ALL: RAW_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, RAW_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, 

-- 5.3

MPT_SENDPRO_CPT_Code_Valid_ALL	If valid based on lookup to the column CDE_PROC from "NW_B_PROCEDURE" where upper(proc_group) like CPT%' then 1 else 0

*/

SELECT 
FILENAME,
claim_type,
PatientControlNum,
NumDtl,

SvcLineProcCode,
/*
--  DI
    CASE WHEN Claim_Type IN ('O','M','D')
	AND SvcLineProcCode IS NOT NULL 
	AND SvcLineProcCode IN (SELECT CDE_PROC FROM MHDWQA.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'CPT%')
    AND SvcLineProcCodeQual = 'HC'
        THEN 1 ELSE 0 END CPT_Code1,
*/
        --  Ex
    CASE WHEN Claim_Type NOT IN ('O','M','D') THEN 'NOT APP'
         WHEN SvcLineProcCode IS NULL THEN 'NULL'
		 WHEN SvcLineProcCode NOT IN (SELECT CDE_PROC FROM MHDWQA.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'CPT%') THEN 'INVALID'
         WHEN SvcLineProcCodeQual <> 'HC' THEN 'SvcLineProcCodeQual <> HC'
         ELSE 'VALID' END CPT_Code1X,

         FROM (
select * from (

select DISTINCT
h."TransSetControlNum" as TransSetControlNum,
-- h."ImplementationConventionRef" as ImplementationConventionRef,
h."SubmitterID" as SubmitterID,
h."PatientControlNum" as PatientControlNum,
to_number(d."NumDtl",4,0) as NumDtl,
h."FileName" as FileName,
-- 'I' as Claim_Type,

    CASE 
        WHEN "FacilityTypeCode" IN ('11','12') THEN 'I'
        WHEN "FacilityTypeCode" IN ('13','14','22','23','32','33','34','43','81','82','83','85','87','89') 
            OR LEFT("FacilityTypeCode",1) = '7' THEN 'O'
        WHEN "FacilityTypeCode" IN ('18','21','28','86') 
            OR LEFT("FacilityTypeCode",1) = '6' THEN 'L'
        ELSE 'X' 
    END Claim_Type,

--to_date(d."ServiceDTP",'YYYYMMDD') as DOS_FROM_DATE,
to_date(substr(h."StatementDTP",1,8),'YYYYMMDD') as DOS_FROM_DATE,

h."ClaimFrequencyCode" as ClaimFrequencyCode,

h."AdmissionDateHourDTP" as AdmissionDateHourDTP,
substr(h."AdmissionDateHourDTP",1,8),'YYYYMMDD' as AdmissionDTP,
--to_date(substr(h."AdmissionDateHourDTP",1,8),'YYYYMMDD') as AdmissionDTP,
--@@@-1 h."AdmissionDTP" as AdmissionDTP,

h."StatementDTP" as StatementDTP,

to_number(d."SvcLineChargeAmt", 12,2) as SvcLineChargeAmt,
-- a."AdjReasonCode01" as AdjReasonCode01,

h."BillingProvNPI" as BillingProvNPI,

dia."DiagnosisCode" as AdmittingDiagnosisCode,

h."FacilityTypeCode" as FacilityTypeCode,
h."AdmissionTypeCode" as AdmissionTypeCode,
h."AdmissionSourceCode" as AdmissionSourceCode,

dia."DiagnosisCodeQual" as DiagnosisCodeQual,
-- strip off leading 0
CASE WHEN LEFT(d."SvcLineRevenueCode",1) != '0' then d."SvcLineRevenueCode" ELSE SUBSTR(d."SvcLineRevenueCode",2,3) END as SvcLineRevenueCode,

CASE WHEN LEFT(a."SvcLineAdjRevenueCode",1) != '0' then a."SvcLineAdjRevenueCode" ELSE SUBSTR(a."SvcLineAdjRevenueCode",2,3) END as SvcLineAdjRevenueCode,
h."PatientStatusCode" as PatientStatusCode,

d."SvcLineProcMod01" as SvcLineProcMod01,
d."SvcLineProcMod02" as SvcLineProcMod02,
d."SvcLineProcMod03" as SvcLineProcMod03,
d."SvcLineProcMod04" as SvcLineProcMod04,

a."SvcLineAdjudicationProcMod01" as SvcLineAdjudicationProcMod01,
a."SvcLineAdjudicationProcMod02" as SvcLineAdjudicationProcMod02,
a."SvcLineAdjudicationProcMod03" as SvcLineAdjudicationProcMod03,
a."SvcLineAdjudicationProcMod04" as SvcLineAdjudicationProcMod04,

ctvd."ProcedureCode" as ProcedureCode, 
ctvd."ProcedureCodeQual" as ProcedureCodeQual,

d."SvcLineProcCode" as SvcLineProcCode, 
d."SvcLineProcCodeQual" as SvcLineProcCodeQual,

dia."DiagnosisCode" as DiagnosisCode,
dia."DiagnosisType" as DiagnosisType,

h."PatientResEstAmtQual" as PatientResEstAmtQual,
h."PatientResEstAmt" as PatientResEstAmt,
h."ContractTypeCode" as ContractTypeCode

from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM as h

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_SERVICE_DTL as d
on  h."TransSetControlNum" = d."TransSetControlNum"
and h."SubmitterID"        = d."SubmitterID"
and h."PatientControlNum"  = d."PatientControlNum"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_SVCLN_ADJUDICATION_DTL as a
on  h."TransSetControlNum" = a."TransSetControlNum"
-- and h."SubmitterID"        = a."SubmitterID"
and h."PatientControlNum"  = a."PatientControlNum"
and d."NumDtl"             = a."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL dia
on  h."TransSetControlNum" = dia."TransSetControlNum"
-- and h."SubmitterID"        = dia."SubmitterID"
and h."PatientControlNum"  = dia."PatientControlNum"
and dia."DiagnosisCodeQual" = 'ABJ'
/*
left join MHDWQA.SENDPRO.RAW_SPRO_837I_BILLING_PROVIDER_DTL bpd
on  h."TransSetControlNum" = bpd."TransSetControlNum"
and h."SubmitterID"        = bpd."SubmitterID"
-- and h."BillingProviderHierarchialLoopset_PK" = bpd."BillingProviderHierarchialLoopset_PK"
and h."BillingProvEntityIDCode" = bpd."BillingProvEntityIDCode"
and h."PatientControlNum"  = dia."PatientControlNum"
*/
-- left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_PROC_COND_TREAT_VAL_DTLS ctvd
 left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_ENC_ATTRIBUTE_DTL ctvd
 on  h."TransSetControlNum" = ctvd."TransSetControlNum"
-- and h."SubmitterID"        = ctvd."SubmitterID"
 and h."PatientControlNum"  = ctvd."PatientControlNum"
 and d."NumDtl"             = ctvd."NumDtl"

order by
--    TransSetControlNum,
--    ImplementationConventionRef,
--    h."SubmitterID",
    FileName,
    Claim_Type,
    h."PatientControlNum",
    to_number(d."NumDtl",4,0)
)
WHERE FILENAME = '110031447a_pacdri_02282025060912_test_de_92726a3e-738e-4711-8353-8802c4ac5f9b.xml'

);

