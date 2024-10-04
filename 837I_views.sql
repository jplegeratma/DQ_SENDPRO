GRANT SELECT ON MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_BI_STATS TO DI_TEAM_ROLE;
GRANT SELECT ON MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_BI TO DI_TEAM_ROLE;
GRANT SELECT ON MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA TO DI_TEAM_ROLE;
GRANT SELECT ON MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ TO DI_TEAM_ROLE;

SELECT * FROM MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_BI_STATS;

SELECT * FROM MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_BI;

SELECT * FROM MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA;

SELECT * FROM MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ;


-- DROP VIEW MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_BI_STATS


CREATE VIEW MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_BI_STATS
AS
SELECT DISTINCT
IMPLEMENTATIONCONVENTIONREF,
TRANSSETCONTROLNUM,
FILENAME,
SUBMITTERID,
SUBMITTERNAME,
CLAIM_TYPE,
SUM_CLAIMFREQUENCYCODE1/SUM_TOT_REX PCT_CLAIMFREQUENCYCODE1,
SUM_STATEMENTDTP1/SUM_TOT_REX PCT_STATEMENTDTP1,
SUM_ADMISSIONDTP1/SUM_TOT_REX PCT_ADMISSIONDTP1,
SUM_BILLINGPROVNPI1/SUM_TOT_REX PCT_BILLINGPROVNPI1,
SUM_ADMITTINGDIAGNOSISCODE1/SUM_TOT_REX PCT_ADMITTINGDIAGNOSISCODE1,
SUM_FACILITYTYPECODE1/SUM_TOT_REX PCT_FACILITYTYPECODE1,
SUM_ADMISSIONTYPECODE1/SUM_TOT_REX PCT_ADMISSIONTYPECODE1,
SUM_ADMISSIONSOURCECODE1/SUM_TOT_REX PCT_ADMISSIONSOURCECODE1,
SUM_SVCLINECHARGEAMT1/SUM_TOT_REX PCT_SVCLINECHARGEAMT1,
SUM_SVCLINEREVENUECODE1/SUM_TOT_REX PCT_SVCLINEREVENUECODE1,


SUM_OCCURRENCECODE1/SUM_TOT_REX PCT_OCCURRENCECODE1,
SUM_VALUECODE1/SUM_TOT_REX PCT_VALUECODE1,
SUM_CONDITIONCODE1/SUM_TOT_REX PCT_CONDITIONCODE1,

SUM_PATIENTSTATUSCODE1/SUM_TOT_REX PCT_PATIENTSTATUSCODE1,
SUM_PRINCIPALDIAGNOSISCODE1/SUM_TOT_REX PCT_PRINCIPALDIAGNOSISCODE1,

SUM_ICD10DIAGNOSIS_CODE1/SUM_TOT_REX PCT_ICD10DIAGNOSIS_CODE1,

SUM_MULTIPLEPROCEDURECODE1/SUM_TOT_REX PCT_MULTIPLEPROCEDURECODE1,

SUM_CPT_CODE1/SUM_TOT_REX PCT_CPT_CODE1,
SUM_HIPPS_CODE1/SUM_TOT_REX PCT_HIPPS_CODE1,

SUM_SVCLINEPROCMOD1/SUM_TOT_REX PCT_SVCLINEPROCMOD1,
SUM_SVCLINEADJREVENUECODE1/SUM_TOT_REX PCT_SVCLINEADJREVENUECODE1,
SUM_PROCEDURECODE1/SUM_TOT_REX PCT_PROCEDURECODE1,
SUM_SVCLINEADJUDICATIONPROCMOD1/SUM_TOT_REX PCT_SVCLINEADJUDICATIONPROCMOD1,
SUM_CLAIMFREQUENCYCODE1,
SUM_STATEMENTDTP1,
SUM_ADMISSIONDTP1,
SUM_BILLINGPROVNPI1,
SUM_ADMITTINGDIAGNOSISCODE1,
SUM_FACILITYTYPECODE1,
SUM_ADMISSIONTYPECODE1,
SUM_ADMISSIONSOURCECODE1,
SUM_SVCLINECHARGEAMT1,
SUM_SVCLINEREVENUECODE1,
SUM_OCCURRENCECODE1,
SUM_VALUECODE1,
SUM_CONDITIONCODE1,
SUM_PATIENTSTATUSCODE1,
SUM_PRINCIPALDIAGNOSISCODE1,
SUM_ICD10DIAGNOSIS_CODE1,
SUM_MULTIPLEPROCEDURECODE1,
SUM_CPT_CODE1,
SUM_HIPPS_CODE1,
SUM_SVCLINEPROCMOD1,
SUM_SVCLINEADJREVENUECODE1,
SUM_PROCEDURECODE1,
SUM_SVCLINEADJUDICATIONPROCMOD1,
SUM_TOT_REX
FROM (
SELECT
IMPLEMENTATIONCONVENTIONREF,
TRANSSETCONTROLNUM,
FILENAME,
SUBMITTERID,
S."SubmitterLastOrgName" SUBMITTERNAME,
CLAIM_TYPE,
SUM(CLAIMFREQUENCYCODE1) SUM_CLAIMFREQUENCYCODE1,
SUM(STATEMENTDTP1) SUM_STATEMENTDTP1,
SUM(ADMISSIONDTP1) SUM_ADMISSIONDTP1,
SUM(BILLINGPROVNPI1) SUM_BILLINGPROVNPI1,
SUM(ADMITTINGDIAGNOSISCODE1) SUM_ADMITTINGDIAGNOSISCODE1,
SUM(FACILITYTYPECODE1) SUM_FACILITYTYPECODE1,
SUM(ADMISSIONTYPECODE1) SUM_ADMISSIONTYPECODE1,
SUM(ADMISSIONSOURCECODE1) SUM_ADMISSIONSOURCECODE1,
SUM(SVCLINECHARGEAMT1) SUM_SVCLINECHARGEAMT1,
SUM(SVCLINEREVENUECODE1) SUM_SVCLINEREVENUECODE1,

SUM(OCCURRENCECODE1) SUM_OCCURRENCECODE1,
SUM(VALUECODE1) SUM_VALUECODE1,
SUM(CONDITIONCODE1) SUM_CONDITIONCODE1,

SUM(PATIENTSTATUSCODE1) SUM_PATIENTSTATUSCODE1,
SUM(PRINCIPALDIAGNOSISCODE1) SUM_PRINCIPALDIAGNOSISCODE1,

SUM(ICD10DIAGNOSIS_CODE1) SUM_ICD10DIAGNOSIS_CODE1,

SUM(MULTIPLEPROCEDURECODE1) SUM_MULTIPLEPROCEDURECODE1,

SUM(CPT_CODE1) SUM_CPT_CODE1,
SUM(HIPPS_CODE1) SUM_HIPPS_CODE1,

SUM(SVCLINEPROCMOD1) SUM_SVCLINEPROCMOD1,
SUM(SVCLINEADJREVENUECODE1) SUM_SVCLINEADJREVENUECODE1,
SUM(PROCEDURECODE1) SUM_PROCEDURECODE1,
SUM(SVCLINEADJUDICATIONPROCMOD1) SUM_SVCLINEADJUDICATIONPROCMOD1,
SUM(TOT_REX) SUM_TOT_REX
FROM MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_BI A
LEFT JOIN MHDWDEV.SENDPRO.RAW_SPRO_837I_FILE_STATISTICS S
    ON A.IMPLEMENTATIONCONVENTIONREF = S."ImplementationConventionRef" AND A.SUBMITTERID = S."SubmitterID"
GROUP BY
IMPLEMENTATIONCONVENTIONREF,
TRANSSETCONTROLNUM,
FILENAME,
SUBMITTERID,
S."SubmitterLastOrgName",
CLAIM_TYPE
)
ORDER BY
IMPLEMENTATIONCONVENTIONREF,
TRANSSETCONTROLNUM,
FILENAME,
SUBMITTERID,
SUBMITTERNAME,
CLAIM_TYPE
;


--DROP VIEW MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_BI;

CREATE VIEW MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_BI
AS
SELECT
TRANSSETCONTROLNUM,
IMPLEMENTATIONCONVENTIONREF,
SUBMITTERID,
FILENAME,
PATIENTCONTROLNUM,
NUMDTL,
CLAIM_TYPE,
CLAIMFREQUENCYCODE1,
STATEMENTDTP1,
ADMISSIONDTP1,
BILLINGPROVNPI1,
ADMITTINGDIAGNOSISCODE1,
FACILITYTYPECODE1,
ADMISSIONTYPECODE1,
ADMISSIONSOURCECODE1,
SVCLINECHARGEAMT1,
SVCLINEREVENUECODE1,
OCCURRENCECODE1,
VALUECODE1,
CONDITIONCODE1,
PATIENTSTATUSCODE1,
PRINCIPALDIAGNOSISCODE1,
ICD10DIAGNOSIS_CODE1,
MULTIPLEPROCEDURECODE1,
CPT_CODE1,
HIPPS_CODE1,
SVCLINEPROCMOD1,
SVCLINEADJREVENUECODE1,
PROCEDURECODE1,
SVCLINEADJUDICATIONPROCMOD1,
TOT_REX
FROM MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ;

--DROP VIEW MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA;

CREATE VIEW MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_QA
AS
SELECT
TRANSSETCONTROLNUM,
IMPLEMENTATIONCONVENTIONREF,
SUBMITTERID,
FILENAME,
PATIENTCONTROLNUM,
NUMDTL,
CLAIM_TYPE,
CLAIMFREQUENCYCODE1X,
STATEMENTDTP1X,
ADMISSIONDTP1X,
BILLINGPROVNPI1X,
ADMITTINGDIAGNOSISCODE1X,
FACILITYTYPECODE1X,
ADMISSIONTYPECODE1X,
ADMISSIONSOURCECODE1X,
SVCLINECHARGEAMT1X,
SVCLINEREVENUECODE1X,
OCCURRENCECODE1X,
VALUECODE1X,
CONDITIONCODE1X,
PATIENTSTATUSCODE1X,
PRINCIPALDIAGNOSISCODE1X,
ICD10DIAGNOSIS_CODE1X,
MULTIPLEPROCEDURECODE1X,
CPT_CODE1X,
HIPPS_CODE1X,
SVCLINEPROCMOD1X,
SVCLINEADJREVENUECODE1X,
PROCEDURECODE1X,
SVCLINEADJUDICATIONPROCMOD1X,
FROM MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ;

select * from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ;
--drop table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ;

CREATE TABLE MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ
AS

SELECT
TransSetControlNum,
ImplementationConventionRef,
SubmitterID,
PatientControlNum,
claim_type,
NumDtl,
FileName,

--  CLAIM_FREQ_TYPE_CD
--  TypeCode All
--  Values is not null.
--  Value is 1-5,7,8
--  DI
    CASE WHEN ClaimFrequencyCode IS NOT NULL 
	AND ClaimFrequencyCode IN ('1','2','3','4','5','7','8') 
	    THEN 1 ELSE 0 END ClaimFrequencyCode1,
--  Ex
    CASE WHEN ClaimFrequencyCode IS NULL THEN 'NULL'
    WHEN ClaimFrequencyCode NOT IN ('1','2','3','4','5','7','8') THEN 'INVALID' 
    ELSE 'VALID' END ClaimFrequencyCode1X,
	   
--  CLAIM_STATEMENT_DTM_PERIOD
--  If String is of format “YYYYMMDD-YYYYMMDD” then 1 else 0
--  DI
    CASE WHEN Claim_Type in ('I','L') 
	AND StatementDTP IS NOT NULL 
	AND ( SUBSTR(StatementDTP, 9, 1) = '-' AND TRY_TO_DATE(SUBSTR(StatementDTP, 1, 8),'YYYYMMDD') IS NOT NULL AND TRY_TO_DATE(SUBSTR(StatementDTP, 10, 8),'YYYYMMDD') IS NOT NULL )  
        THEN 1 ELSE 0 END StatementDTP1,
--  Ex
    CASE WHEN StatementDTP IS NULL THEN 'NULL'
         WHEN ( SUBSTR(StatementDTP, 9, 1) != '-' OR TRY_TO_DATE(SUBSTR(StatementDTP, 1, 8),'YYYYMMDD') IS NULL OR TRY_TO_DATE(SUBSTR(StatementDTP, 10, 8),'YYYYMMDD') IS NULL ) THEN 'INVALID' 
		 ELSE 'VALID' END StatementDTP1X,

--  CLAIM_ADMISSION_DTM_PERIOD
--  This field should have a value if the Parameter MPT_SENDPRO_Facility_Type_Code_837I = 11
--  If String is of format “YYYYMMDD-YYYYMMDD” then 1 else 0
--  DI		 
    CASE WHEN Claim_Type IN ('I','L')
	AND SUBSTR(FacilityTypeCode,1,2) = '11' 
	AND AdmissionDTP IS NOT NULL 
	AND ( SUBSTR(AdmissionDTP, 9, 1) = '-' AND TRY_TO_DATE(SUBSTR(AdmissionDTP, 1, 8),'YYYYMMDD') IS NOT NULL AND TRY_TO_DATE(SUBSTR(AdmissionDTP, 10, 8),'YYYYMMDD') IS NOT NULL )  
        THEN 1 ELSE 0 END AdmissionDTP1,
--  Ex
    CASE 
         WHEN Claim_Type NOT IN ('L','I') THEN 'NOT INPATIENT OR LTC'
	     WHEN SUBSTR(FacilityTypeCode,1,2) != '11' THEN 'Facility Type Code NOT HOSPITAL OR LTC'
	     WHEN AdmissionDTP IS NULL THEN 'NULL'
         WHEN ( SUBSTR(AdmissionDTP, 9, 1) != '-' OR TRY_TO_DATE(SUBSTR(AdmissionDTP, 1, 8),'YYYYMMDD') IS NULL OR TRY_TO_DATE(SUBSTR(AdmissionDTP, 10, 8),'YYYYMMDD') IS NULL ) THEN 'INVALID' 
		 ELSE 'VALID' END AdmissionDTP1X,
		
--  DENIED STATUS
--  SUBLINE_ADJ_REASON_CD (2,3,4…) 
--  This field is in the denied list.
--  And SERVICE_LINE_AMT = 0 this should be in the denied claim file. Please refer Link
--@@@

		
--  BILLING PROVIDER CODE
--  Claim Type All
--  BillingProvNPI
--  StringIsNull_ALL - String is not null then 1 else 0
--  DI
    CASE WHEN BillingProvNPI IS NOT NULL
        THEN 1 ELSE 0 END BillingProvNPI1,

--  Ex
    CASE WHEN BillingProvNPI IS NULL THEN 'NULL'
		 ELSE 'VALID' END BillingProvNPI1X,
		 

--  ADMITTING DIAGNOSIS
--  Claim Type I
--  Missing String Value Parameter: MPT_SENDPRO_StringIsNull_ALL - String is not null then 1 else 0
--  MPT_SENDPRO_Diagnosis_Code_Valid_ALL STG_SENDPRO_837I_CLAIM_DIAGNOSIS_DTL.DiagnosisCode,
--  If valid based on lookup to the column CDE_DIAG from "NW_B_DIAGNOSIS" where CDE_ICD_VERSION=10 then 1 else 0 
--  STG_SENDPRO_837I_CLAIM_DIAGNOSIS_DTL.DiagnosisCode, 
--  STG_SENDPRO_837I_CLAIM_DIAGNOSIS_DTL.DiagnosisCodeQual=’ABJ’

--  Scorecard
--         case when CLAIM_TYPE IN('I') AND substr(cde_type_of_bill_enc,1,2) not in('12','22','42','62','81','82') AND CDE_DIAG_ADMIT not IN ('+','-', ' ')
--         THEN 1 else 0 END CDE_DIAG_ADMIT1,

--  DI
    CASE WHEN Claim_Type IN ('I') AND AdmittingDiagnosisCode IS NOT NULL 
	AND AdmittingDiagnosisCode IN (SELECT CDE_DIAG from MHDWDEV.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','**','+','-')) 
	AND DiagnosisCodeQual='ABJ'
        THEN 1 ELSE 0 END AdmittingDiagnosisCode1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('I') THEN 'NOT INPATIENT'
	     WHEN DiagnosisCodeQual != 'ABJ' THEN 'DiagnosisCodeQual NOT ABJ'
         WHEN AdmittingDiagnosisCode IS NULL THEN 'NULL'
		 WHEN AdmittingDiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWDEV.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END AdmittingDiagnosisCode1X,
		
--  FACILITY TYPE CODE
/*
837I Claims population: MPT_SENDPRO_ClaimType_837P, MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, 
MPT_SENDPRO_ClaiimType_837I_OUTP

MPT_SENDPRO_FacilityTypeCode_837I: STG_ SPRO_837P_CLAIM.FacilityTypeCode, 
STG_SENDPRO_837I_CLAIM.FacilityTypeCode, STG_SPRO_837D_CLAIM.FacilityTypeCode

Missing String Value Parameter: MPT_StringIsNull_ALL, STG_ SPRO_837P_CLAIM.FacilityTypeCode, 
STG_SPRO_837I_CLAIM.FacilityTypeCode,  STG_ SPRO_837D_CLAIM.FacilityTypeCode

MPT_SENDPRO_StringIsNull_ALL String is not null then 1 else 0

MPT_SENDPRO_Facility_Type_Code_837I 
If valid based on the lookup against the first 2 characters of CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP='CDE_TYPE_OF_BILL' for Type of Bill Code, then 1 else 0
*/

--  DI
    CASE WHEN Claim_Type IN ('M','L','I','O') 
	AND FacilityTypeCode IS NOT NULL
    AND FacilityTypeCode IN (SELECT LEFT(CDE_CHAR,2) FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_TYPE_OF_BILL' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END FacilityTypeCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('M','L','I','O') THEN 'NOT IN M,L,I,O'
	     WHEN FacilityTypeCode IS NULL THEN 'NULL'
         WHEN FacilityTypeCode NOT IN (SELECT LEFT(CDE_CHAR,2) FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_TYPE_OF_BILL' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END FacilityTypeCode1X,
		 
--  TYPE OF ADMISSION		 
/*         	
Type of Admission (MPT_TypeofAdmission_837I)
837I Claims population: MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP
MPT_SENDPRO_TypeOfAdmission_Valid: STG_SENDPRO_837I_CLAIM.AdmissionTypeCode

MPT_SENDPRO_TypeOfAdmission_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP= ‘CDE_ADMIT_TYPE' for Type Of Admission

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I') 
	AND AdmissionTypeCode IS NOT NULL
    AND AdmissionTypeCode IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_ADMIT_TYPE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END AdmissionTypeCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I') THEN 'NOT INPATIENT OR LTC'
	     WHEN AdmissionTypeCode IS NULL THEN 'NULL'
         WHEN AdmissionTypeCode NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_ADMIT_TYPE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END AdmissionTypeCode1X,
		 
--  SOURCE OF ADMISSION
/*
Source of Admission (MPT_SourceofAdmission_837I)
837I Claims population: MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP
MPT_SENDPRO_SourceOfAdmission_Valid: STG_SENDPRO_837I_CLAIM. AdmissionSourceCode

MPT_SENDPRO_SourceOfAdmission_Valid	  If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP= ‘CDE_ADMIT_SOURCE' for Source Of Admission

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I') 
	AND AdmissionSourceCode IS NOT NULL
    AND AdmissionSourceCode IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_ADMIT_SOURCE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END AdmissionSourceCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I') THEN 'NOT INPATIENT OR LTC'
	     WHEN AdmissionSourceCode IS NULL THEN 'NULL'
         WHEN AdmissionSourceCode NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_ADMIT_SOURCE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END AdmissionSourceCode1X,
		 
--  SERVICE LINE CHARGE AMOUNT
/*
Service Line Charge Amount (MPT_ServiceLineChargeAmt_837)
	837I Claims population: MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D
	MPT_SENDPRO_AmountValueNotNegative_ALL: STG_SENDPRO_837P_CLAIM_SERVICE_LINE_DETAIL.SvcLineChargeAmt, STG_SENDPRO_837I_CLAIM_SERVICE_LINE_DETAIL.SvcLineChargeAmt, 
	STG_SENDPRO_837D_CLAIM_SERVICE_LINE_DETAIL.SvcLineChargeAmt

MPT_SENDPRO_AmountValueNotNegative_ALL	Amount is greater than or equals 0 then 1 else 0
*/	 
		 
--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M','D') 
	AND SvcLineChargeAmt IS NOT NULL
    AND SvcLineChargeAmt >= 0 
        THEN 1 ELSE 0 END SvcLineChargeAmt1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M','D') THEN 'NOT IN L,I,O,M,D'
	     WHEN SvcLineChargeAmt IS NULL THEN 'NULL'
         WHEN SvcLineChargeAmt < 0 THEN 'INVALID'
         ELSE 'VALID' END SvcLineChargeAmt1X,

--  SERVICE LINE REVENUE CODE
/*
12.7.6.	Service Line Revenue Code (MPT_SENDPRO_RevenueCode_837I)
12.7.6.1.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D

12.7.6.2.	MPT_SENDPRO_ServiceLineRevenueCode_Valid: STG_SPRO_837D_CLAIM_SERVICE_LINE_DETAIL.SvcLineRevenueCode,
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.SvcLineRevenueCode

STG_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL.SvcLineRevenueCode,
STG_SPRO_837P_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,
STG_SPRO_837D_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,

12.7.6.3.	MPT_SENDPRO_StringIsNull_ALL: 
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.SvcLineRevenueCode

STG_SPRO_837D_CLAIM_SERVICE_LINE_DETAIL.SvcLineRevenueCode,
STG_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL.SvcLineRevenueCode,
STG_SPRO_837P_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,
STG_SPRO_837D_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,

MPT_SENDPRO_ServiceLineRevenueCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP='CDE_REVENUE'  then 1 else 0
*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M','D') 
	AND SvcLineRevenueCode IS NOT NULL
    AND SvcLineRevenueCode IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END SvcLineRevenueCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M','D') THEN 'NOT IN L,I,O,M,D'
	     WHEN SvcLineRevenueCode IS NULL THEN 'NULL'
         WHEN SvcLineRevenueCode NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END SvcLineRevenueCode1X,

--  Occurrence Code
/*
12.7.7.	Occurrence Code (MPT_SENDPRO_OccurrenceCode_837I)
12.7.7.1.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP
12.7.7.2.	MPT_SENDPRO_OccurrenceCode_Valid: RAW_SPRO_837I_CLAIM_PROC_COND_TREAT_VAL_DTLS.ProcedureCode, ProcedureCodeQual=’BH’
12.7.7.3.	MPT_SENDPRO_StringIsNull_ALL: RAW_SPRO_837I_CLAIM_PROC_COND_TREAT_VAL_DTLS. ProcedureCode, ProcedureCodeQual=’BH’

MPT_SENDPRO_OccurrenceCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’CDE_OCCURRENCE’ then 1 else 0

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O') 
	AND ProcedureCode IS NOT NULL
    AND ProcedureCode IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_OCCURRENCE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
    AND ProcedureCodeQual = 'BH'
        THEN 1 ELSE 0 END OccurrenceCode1,

--  Ex
    CASE 
         WHEN Claim_Type NOT IN ('L','I') THEN 'NOT INPATIENT, LTC or OUTPATIENT'
		 WHEN ProcedureCode IS NULL THEN 'NULL'
         WHEN ProcedureCode NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_OCCURRENCE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
		 WHEN ProcedureCodeQual <> 'BH' THEN 'ProcedureCodeQual <> BH' 
         ELSE 'VALID' END OccurrenceCode1X,

--  Value Code
/*
12.7.9.	Value Code (MPT_SENDPRO_ValueCode_837I)
4.1.1.1.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP
12.7.9.1.	MPT_SENDPRO_ValueCode_Valid: RAW_SPRO_837I_CLAIM_PROC_COND_TREAT_VAL_DTLS.ProcedureCode, ProcedureCodeQual=’BE’
4.1.1.2.	
12.7.9.2.	MPT_SENDPRO_StringIsNull_ALL: RAW_SPRO_837I_CLAIM_PROC_COND_TREAT_VAL_DTLS.ProcedureCode, ProcedureCodeQual=’BE’

MPT_SENDPRO_ValueCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’CDE_VALUE then 1 else 0

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O') 
	AND ProcedureCode IS NOT NULL
    AND ProcedureCode IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_VALUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
    AND ProcedureCodeQual = 'BE'
        THEN 1 ELSE 0 END ValueCode1,

--  Ex
    CASE 
         WHEN Claim_Type NOT IN ('L','I') THEN 'NOT INPATIENT, LTC or OUTPATIENT'
		 WHEN ProcedureCode IS NULL THEN 'NULL'
         WHEN ProcedureCode NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_VALUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID' 
         WHEN ProcedureCodeQual <> 'BE' THEN 'ProcedureCodeQual <> BE'    
         ELSE 'VALID' END ValueCode1X,

--  Condition Code
/*
12.7.10.	Condition Code (MPT_SENDPRO_ConditionCode_837I)
4.1.1.4.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP
4.1.1.5.	MPT_SENDPRO_ConditionCode_Valid: RAW_SPRO_837I_CLAIM_PROC_COND_TREAT_VAL_DTLS.ProcedureCode, ProcedureCodeQual=’BG’
4.1.1.6.	MPT_SENDPRO_StringIsNull_ALL: RAW_SPRO_837I_CLAIM_PROC_COND_TREAT_VAL_DTLS.ProcedureCode, ProcedureCodeQual=’BG’

MPT_SENDPRO_ConditionCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’CDE_COND then 1 else 0

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O')
	AND ProcedureCode IS NOT NULL
    AND ProcedureCode IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_COND' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
    AND ProcedureCodeQual = 'BG'
        THEN 1 ELSE 0 END ConditionCode1,

--  Ex
    CASE 
         WHEN Claim_Type NOT IN ('L','I') THEN 'NOT INPATIENT, LTC or OUTPATIENT'
		 WHEN ProcedureCode IS NULL THEN 'NULL'
         WHEN ProcedureCode NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_COND' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
		 WHEN ProcedureCodeQual <> 'BG' THEN 'ProcedureCodeQual <> BG'
         ELSE 'VALID' END ConditionCode1X,

--  PATIENT STATUS CODE
/*
4.1.5.	Patient Status Code (MPT_SENDPRO_PatientStatusCode_837I)
4.1.5.1.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP

4.1.5.2.	MPT_SENDPRO_PatientStatusCode_Valid: 
	STG_SPRO_837D_CLAIM.PatientStatusCode,
	STG_SPRO_837P_CLAIM.PatientStatusCode,
	STG_SPRO_837I_CLAIM.PatientStatusCode

4.1.5.3.	MPT_SENDPRO_StringIsNull_ALL: 
	STG_SPRO_837D_CLAIM.PatientStatusCode,
	STG_SPRO_837P_CLAIM.PatientStatusCode,
	STG_SPRO_837I_CLAIM.PatientStatusCode

MPT_SENDPRO_PatientStatusCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’CDE_PATIENT_STATUS’ then 1 else 0
*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O') 
	AND PatientStatusCode IS NOT NULL
    AND PatientStatusCode IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PATIENT_STATUS' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END PatientStatusCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O') THEN 'NOT INPATIENT, LTC or OUTPATIENT'
	     WHEN PatientStatusCode IS NULL THEN 'NULL'
         WHEN PatientStatusCode NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PATIENT_STATUS' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END PatientStatusCode1X,


--  Principal Diagnosis Code
/*
12.7.12.	Principal Diagnosis Code (MPT_SENDPRO_Principal_Diagnosis_Code)
4.1.1.10.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P
4.1.1.11.	MPT_SENDPRO_Diagnosis_Code_Valid_ALL: STG_SPRO_837I_CLAIM_DIAGNOSIS_PVT.PrincipalDiagnosisCode,
4.1.1.12.	MPT_SENDPRO_StringIsNull_ALL: STG_SPRO_837I_CLAIM_DIAGNOSIS_PVT.PrincipalDiagnosisCode,

RAW_SPRO_837I_CLAIM_DIAGNOSIS_PVT

PrincipalDiagnosisCode

MPT_SENDPRO_Diagnosis_Code_Valid_ALL	If valid based on lookup to the column CDE_DIAG from "NW_B_DIAGNOSIS" where CDE_ICD_VERSION=10 then 1 else 0

MPT_SENDPRO_StringIsNull_ALL 

dpvt.PrincipalDiagnosisCode

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')
	AND PrincipalDiagnosisCode IS NOT NULL 
	AND PrincipalDiagnosisCode IN (SELECT CDE_DIAG from MHDWDEV.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) 
        THEN 1 ELSE 0 END PrincipalDiagnosisCode1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT INPATIENT, LTC, OUTPATIENT or PROF'
         WHEN PrincipalDiagnosisCode IS NULL THEN 'NULL'
		 WHEN PrincipalDiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWDEV.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
         ELSE 'VALID' END PrincipalDiagnosisCode1X,


--  ICD10 Diagnosis

/*
12.7.13.	Diagnosis_ICD10 (MPT_SENDPRO_ICD10Diagnosis_Code)
4.1.1.13.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_NCPDP
4.1.1.14.	MPT_SENDPRO_Diagnosis_Code_Valid_ALL: RAW_SPRO_837D_CLAIM_DIAGNOSIS_DTL.DiagnosisCode, DiagnosisType=’ClmOtherDiagnosis’
4.1.1.15.	MPT_SENDPRO_StringIsNull_ALL: STG_SPRO_837I_CLAIM_DIAGNOSIS_DTL.DiagnosisCode

MPT_SENDPRO_Diagnosis_Code_Valid_ALL	If valid based on lookup to the column CDE_DIAG from "NW_B_DIAGNOSIS" where CDE_ICD_VERSION=10 then 1 else 0

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M','P')
	AND DiagnosisCode IS NOT NULL 
	AND DiagnosisCode IN (SELECT CDE_DIAG from MHDWDEV.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') )
    AND DiagnosisType = 'ClmOtherDiagnosis'	
        THEN 1 ELSE 0 END ICD10Diagnosis_Code1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M','P') THEN 'NOT IN L,I,O,M,P'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWDEV.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
         WHEN DiagnosisType <> 'ClmOtherDiagnosis' THEN 'DiagnosisType <> ClmOtherDiagnosis'	
         ELSE 'VALID' END ICD10Diagnosis_Code1X,

--  Service Line Procedure Code
/*
12.7.14.	Service Line Procedure_Code_ICD10 (MPT_SENDPRO_ServiceLineProcedure_Code)
4.1.1.1.	837I Claims population:  
MPT_SENDPRO_ClaimType_837I_LTC, 
MPT_SENDPRO_ClaiimType_837I_INP, 
MPT_SENDPRO_ClaiimType_837I_OUTP, 
MPT_SENDPRO_ClaiimType_837P

4.1.1.2.	MPT_SENDPRO_Procedure_Code_Valid_ALL: 
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.MultipleProcedureCode,

4.1.1.3.	MPT_SENDPRO_StringIsNull_ALL: 
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.MultipleProcedureCode,

MPT_SENDPRO_Procedure_Code_Valid_ALL	If valid based on lookup to the column CDE_PROC from "NW_B_PROCEDURE" then 1 else 0

MultipleProcedureCode

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')
	AND MultipleProcedureCode IS NOT NULL 
	AND MultipleProcedureCode IN (SELECT CDE_PROC FROM MHDWDEV.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-'))
        THEN 1 ELSE 0 END MultipleProcedureCode1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT INPATIENT, LTC, OUTPATIENT or PROF'
         WHEN MultipleProcedureCode IS NULL THEN 'NULL'
		 WHEN MultipleProcedureCode NOT IN (SELECT CDE_PROC FROM MHDWDEV.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-')) THEN 'INVALID'
         ELSE 'VALID' END MultipleProcedureCode1X,

--  CPT Code
/*
12.7.16.	CDT_Code_ICD10 (MPT_SENDPRO_CPT_Code)
4.1.1.7.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P
4.1.1.8.	MPT_SENDPRO_CPT_Code_Valid_ALL: RAW_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, SvcLineProcCodeQual='HC'; RAW_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, SvcLineProcCodeQual='HC'
4.1.1.9.	MPT_SENDPRO_StringIsNull_ALL: RAW_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, RAW_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, 

MPT_SENDPRO_CPT_Code_Valid_ALL	If valid based on lookup to the column CDE_PROC from "NW_B_PROCEDURE" where upper(proc_group) like CPT%' then 1 else 0
*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')
	AND SvcLineProcCode IS NOT NULL 
	AND SvcLineProcCode IN (SELECT CDE_PROC FROM MHDWDEV.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'CPT%')
    AND SvcLineProcCodeQual = 'HC'
        THEN 1 ELSE 0 END CPT_Code1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT INPATIENT, LTC, OUTPATIENT or PROF'
         WHEN SvcLineProcCode IS NULL THEN 'NULL'
		 WHEN SvcLineProcCode NOT IN (SELECT CDE_PROC FROM MHDWDEV.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'CPT%') THEN 'INVALID'
         WHEN SvcLineProcCodeQual <> 'HC' THEN 'SvcLineProcCodeQual <> HC'
         ELSE 'VALID' END CPT_Code1X,

--  HIPPS Code
/*
12.7.17.	HIPPS_Code_ICD10 (MPT_SENDPRO_HIPPS_Code)
4.1.1.10.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P
4.1.1.11.	MPT_SENDPRO_HIPPS_Code_Valid_ALL: RAW_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, SvcLineProcCodeQual='HP'; RAW_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, SvcLineProcCodeQual='HP'
4.1.1.12.	MPT_SENDPRO_StringIsNull_ALL: RAW_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode ; RAW_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode

MPT_SENDPRO_HIPPS_Code_Valid_ALL	If valid based on lookup to the column CDE_PROC from "NW_B_PROCEDURE" where upper(proc_group) like HIPPS%' then 1 else 0

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')
	AND SvcLineProcCode IS NOT NULL 
	AND SvcLineProcCode IN (SELECT CDE_PROC FROM MHDWDEV.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'HIPPS%')
    AND SvcLineProcCodeQual = 'HP'
        THEN 1 ELSE 0 END HIPPS_Code1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT INPATIENT, LTC, OUTPATIENT or PROF'
         WHEN SvcLineProcCode IS NULL THEN 'NULL'
		 WHEN SvcLineProcCode NOT IN (SELECT CDE_PROC FROM MHDWDEV.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'HIPPS%') THEN 'INVALID'
         WHEN SvcLineProcCodeQual <> 'HP' THEN 'SvcLineProcCodeQual <> HP'
         ELSE 'VALID' END HIPPS_Code1X,


--  Service Line PROC MOD
/*
12.7.19.	Service Line PROC MOD (MPT_SENDPRO_ServiceLine_PROC_MOD)
4.1.1.16.	837I Claims population:  
MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P 
4.1.1.17.	MPT_SENDPRO_PROC_MOD_Valid_ALL: 
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.SvcLineProcMod01,
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.SvcLineProcMod02,
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.SvcLineProcMod03,
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.SvcLineProcMod04,

MPT_SENDPRO_PROC_MOD_Valid_All	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’CDE_PROC_MOD’ then 1 else 0

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')     
	AND 
	( 
	( SvcLineProcMod01 IS NOT NULL
        AND SvcLineProcMod01 IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineProcMod02 IS NOT NULL
        AND SvcLineProcMod02 IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineProcMod03 IS NOT NULL
        AND SvcLineProcMod03 IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineProcMod04 IS NOT NULL
        AND SvcLineProcMod04 IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	)	
        THEN 1 ELSE 0 END SvcLineProcMod1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT INPATIENT, LTC, OUTPATIENT or PROF'
	     WHEN SvcLineProcMod01 IS NULL AND SvcLineProcMod02 IS NULL AND SvcLineProcMod03 IS NULL AND SvcLineProcMod04 IS NULL THEN 'NULL'
         WHEN SvcLineProcMod01 NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
              AND SvcLineProcMod02 NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 
              AND SvcLineProcMod03 NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 
              AND SvcLineProcMod04 NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 			  
			  THEN 'INVALID'
         ELSE 'VALID' END SvcLineProcMod1X,


--  Service Line Adjustment Revenue Code
/*
12.7.20.	Service Line Adjustment Revenue Code (MPT_SENDPRO_AdjRevenueCode_837I)
4.1.1.1.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D

4.1.1.2.	MPT_SENDPRO_ServiceLineRevenueCode_Valid: 
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,
STG_SPRO_837P_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,
STG_SPRO_837D_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,
4.1.1.3.	MPT_SENDPRO_StringIsNull_ALL: 
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,
STG_SPRO_837P_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,
STG_SPRO_837D_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,
*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M','D') 
    
	AND SvcLineAdjRevenueCode IS NOT NULL
    AND SvcLineAdjRevenueCode IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END SvcLineAdjRevenueCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M','D') THEN 'NOT IN L,I,O,M,D'
	     WHEN SvcLineAdjRevenueCode IS NULL THEN 'NULL'
         WHEN SvcLineAdjRevenueCode NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END SvcLineAdjRevenueCode1X,


--  Condition Treatment Procedure Code
/*
12.7.22.	Condition Treatment Procedure_Code_ICD10 (MPT_SENDPRO_CondTreatProcedure_Code)
4.1.1.20.	837I Claims population:  
MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P

4.1.1.21.	MPT_SENDPRO_Procedure_Code_Valid_ALL: 
STG_SPRO_837I_CLAIM_PROC_COND_TREAT_VAL_DTLS.ProcedureCode,

4.1.1.22.	MPT_SENDPRO_StringIsNull_ALL: 
STG_SPRO_837I_CLAIM_PROC_COND_TREAT_VAL_DTLS.ProcedureCode,

MPT_SENDPRO_Procedure_Code_Valid_ALL	If valid based on lookup to the column CDE_PROC from "NW_B_PROCEDURE" then 1 else 0

ProcedureCode
*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')
	AND ProcedureCode IS NOT NULL 
	AND ProcedureCode IN (SELECT CDE_PROC from MHDWDEV.NW.NW_B_PROCEDURE where CDE_PROC NOT IN ('#','+','-'))
        THEN 1 ELSE 0 END ProcedureCode1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT INPATIENT, LTC, OUTPATIENT or PROF'
         WHEN ProcedureCode IS NULL THEN 'NULL'
		 WHEN ProcedureCode NOT IN (SELECT CDE_PROC from MHDWDEV.NW.NW_B_PROCEDURE where CDE_PROC NOT IN ('#','+','-')) THEN 'INVALID'
         ELSE 'VALID' END ProcedureCode1X,


--  Service Line Adjustment PROC MOD
/*
12.7.23.	Service Line Adj PROC MOD (MPT_SENDPRO_ServiceLineAdj_PROC_MOD)
4.1.1.23.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P 
4.1.1.24.	MPT_SENDPRO_PROC_MOD_Valid_ALL: 
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjudicationProcMod01,
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjudicationProcMod03,
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjudicationProcMod02,
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjudicationProcMod04,

MPT_SENDPRO_PROC_MOD_Valid_All	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’CDE_PROC_MOD’ then 1 else 0


*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')     
	AND 
	( 
	( SvcLineAdjudicationProcMod01 IS NOT NULL
        AND SvcLineAdjudicationProcMod01 IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineAdjudicationProcMod02 IS NOT NULL
        AND SvcLineAdjudicationProcMod02 IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineAdjudicationProcMod03 IS NOT NULL
        AND SvcLineAdjudicationProcMod03 IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineAdjudicationProcMod04 IS NOT NULL
        AND SvcLineAdjudicationProcMod04 IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	)	
        THEN 1 ELSE 0 END SvcLineAdjudicationProcMod1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT INPATIENT, LTC, OUTPATIENT or PROF'
	     WHEN SvcLineAdjudicationProcMod01 IS NULL AND SvcLineAdjudicationProcMod02 IS NULL AND SvcLineAdjudicationProcMod03 IS NULL AND SvcLineAdjudicationProcMod04 IS NULL THEN 'NULL'
         WHEN SvcLineAdjudicationProcMod01 NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
              AND SvcLineAdjudicationProcMod02 NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 
              AND SvcLineAdjudicationProcMod03 NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 
              AND SvcLineAdjudicationProcMod04 NOT IN (SELECT CDE_CHAR FROM MHDWDEV.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 			  
			  THEN 'INVALID'
         ELSE 'VALID' END SvcLineAdjudicationProcMod1X,


--  ALL RECORDS
    1 AS TOT_REX

FROM (
select * from (
select DISTINCT
h."TransSetControlNum" as TransSetControlNum,
h."ImplementationConventionRef" as ImplementationConventionRef,
h."FileName" as FileName,
h."SubmitterID" as SubmitterID,
h."PatientControlNum" as PatientControlNum,
to_number(d."NumDtl",4,0) as NumDtl,
'I' as Claim_Type,
--to_date(d."ServiceDTP",'YYYYMMDD') as DOS_FROM_DATE,
to_date(substr(h."StatementDTP",1,8),'YYYYMMDD') as DOS_FROM_DATE,

h."ClaimFrequencyCode" as ClaimFrequencyCode,
h."AdmissionDTP" as AdmissionDTP,
h."StatementDTP" as StatementDTP,

to_number(d."SvcLineChargeAmt", 12,2) as SvcLineChargeAmt,
a."AdjReasonCode01" as AdjReasonCode01,

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

dpvt."PrincipalDiagnosisCode" as PrincipalDiagnosisCode,
d."MultipleProcedureCode" as MultipleProcedureCode,
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

-- original list
bpd."BillingProvNPIQual" as BillingProvNPIQual,

h."PatientResEstAmtQual" as PatientResEstAmtQual,
h."PatientResEstAmt" as PatientResEstAmt,
h."ContractTypeCode" as ContractTypeCode,

renpd."RenderingProvEntityIDCode" as RenderingProvEntityIDCode


from MHDWDEV.SENDPRO.RAW_SPRO_837I_CLAIM as h

left join MHDWDEV.SENDPRO.RAW_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL as d
on  h."TransSetControlNum" = d."TransSetControlNum"
and h."SubmitterID"        = d."SubmitterID"
and h."PatientControlNum"  = d."PatientControlNum"

left join MHDWDEV.SENDPRO.RAW_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO as a
on  h."TransSetControlNum" = a."TransSetControlNum"
and h."SubmitterID"        = a."SubmitterID"
and h."PatientControlNum"  = a."PatientControlNum"
and d."NumDtl"             = a."NumDtl"

left join MHDWDEV.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL dia
on  h."TransSetControlNum" = dia."TransSetControlNum"
and h."SubmitterID"        = dia."SubmitterID"
and h."PatientControlNum"  = dia."PatientControlNum"
and dia."DiagnosisCodeQual" = 'ABJ'

left join MHDWDEV.SENDPRO.RAW_SPRO_837I_BILLING_PROVIDER_DETAILS bpd
on  h."TransSetControlNum" = bpd."TransSetControlNum"
and h."SubmitterID"        = bpd."SubmitterID"
and h."BillingProviderHierarchialLoopset_PK" = bpd."BillingProviderHierarchialLoopset_PK"
and h."BillingProvEntityIDCode" = bpd."BillingProvEntityIDCode"
and h."PatientControlNum"  = dia."PatientControlNum"

left join MHDWDEV.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_PVT dpvt
on  h."TransSetControlNum" = dpvt."TransSetControlNum"
and h."SubmitterID"        = dpvt."SubmitterID"
and h."PatientControlNum"  = dpvt."PatientControlNum"
--and dpvt."DiagnosisCodeQual" = 'ABJ'

left join MHDWDEV.SENDPRO.RAW_SPRO_837I_RENDERING_PROVIDER_DTL renpd
on  h."TransSetControlNum" = bpd."TransSetControlNum"
and h."SubmitterID"        = bpd."SubmitterID"
and h."PatientControlNum"  = dia."PatientControlNum"

left join MHDWDEV.SENDPRO.RAW_SPRO_837I_CLAIM_PROC_COND_TREAT_VAL_DTLS ctvd
on  h."TransSetControlNum" = ctvd."TransSetControlNum"
and h."SubmitterID"        = ctvd."SubmitterID"
and h."PatientControlNum"  = ctvd."PatientControlNum"
and d."NumDtl"             = ctvd."NumDtl"

order by
    TransSetControlNum,
    ImplementationConventionRef,
    h."SubmitterID",
    h."PatientControlNum",
    to_number(d."NumDtl",4,0)
));

