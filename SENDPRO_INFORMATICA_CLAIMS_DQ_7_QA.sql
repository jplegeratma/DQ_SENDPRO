
GRANT SELECT ON MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA TO DI_TEAM_ROLE;

select * from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA; 

TRUNCATE TABLE MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA;

--CREATE TABLE MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA
--AS

-- using  VALIDATE_NPI_LUHN_PY(BillingProvNPI) and MHDWQA.NW.NW_B_PROVIDER

INSERT INTO MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA

SELECT DISTINCT
RUN_DATE,
TransSetControlNum,
SubmitterID,
PatientControlNum,
claim_type,
NumDtl,
FileName,
Record_Type,

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
    CASE WHEN Claim_Type IN ('I','L') 
	AND StatementDTP IS NOT NULL 
	AND ( SUBSTR(StatementDTP, 9, 1) = '-' AND TRY_TO_DATE(SUBSTR(StatementDTP, 1, 8),'YYYYMMDD') IS NOT NULL AND TRY_TO_DATE(SUBSTR(StatementDTP, 10, 8),'YYYYMMDD') IS NOT NULL )  
        THEN 1 ELSE 0 END StatementDTP1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('I','L') THEN 'NOT APP' 
         WHEN StatementDTP IS NULL THEN 'NULL'
         WHEN ( SUBSTR(StatementDTP, 9, 1) != '-' OR TRY_TO_DATE(SUBSTR(StatementDTP, 1, 8),'YYYYMMDD') IS NULL OR TRY_TO_DATE(SUBSTR(StatementDTP, 10, 8),'YYYYMMDD') IS NULL ) THEN 'INVALID' 
		 ELSE 'VALID' END StatementDTP1X,

/*@@@-1 */
--0 AS AdmissionDTP1,
--'FIX THIS' AS AdmissionDTP1X,

--  CLAIM_ADMISSION_DTM_PERIOD
--  This field should have a value if the Parameter MPT_SENDPRO_Facility_Type_Code_837I = 11
--  If String is of format “YYYYMMDD-YYYYMMDD” then 1 else 0
--  DI		 
    CASE WHEN Claim_Type IN ('I','L') 
	--AND SUBSTR(FacilityTypeCode,1,2) = '11' 
	AND AdmissionDTP IS NOT NULL 
--	AND ( SUBSTR(AdmissionDTP, 9, 1) = '-' AND TRY_TO_DATE(SUBSTR(AdmissionDTP, 1, 8),'YYYYMMDD') IS NOT NULL AND TRY_TO_DATE(SUBSTR(AdmissionDTP, 10, 8),'YYYYMMDD') IS NOT NULL )  
        THEN 1 ELSE 0 END AdmissionDTP1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('I','L') THEN 'NOT APP'
         --WHEN SUBSTR(FacilityTypeCode,1,2) != '11' THEN 'NOT HOSPITAL OR LTC'
	     WHEN AdmissionDTP IS NULL THEN 'NULL'
--         WHEN ( SUBSTR(AdmissionDTP, 9, 1) != '-' OR TRY_TO_DATE(SUBSTR(AdmissionDTP, 1, 8),'YYYYMMDD') IS NULL OR TRY_TO_DATE(SUBSTR(AdmissionDTP, 10, 8),'YYYYMMDD') IS NULL ) THEN 'INVALID' 
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
--  changing to validate against ID_NPI

--  DI
    CASE
	    WHEN BillingProvNPI IS NOT NULL
		AND VALIDATE_NPI_LUHN_PY(BillingProvNPI)        
        THEN 1 ELSE 0 END BillingProvNPI,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (BillingProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT VALIDATE_NPI_LUHN_PY(BillingProvNPI) ) THEN 'INVALID'
         ELSE 'VALID' END BillingProvNPIX,


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
	AND AdmittingDiagnosisCode IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','**','+','-')) 
	AND DiagnosisCodeQual='ABJ'
        THEN 1 ELSE 0 END AdmittingDiagnosisCode1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('I') THEN 'NOT APP'
--	     WHEN DiagnosisCodeQual != 'ABJ' THEN 'DiagnosisCodeQual NOT ABJ'
	     WHEN DiagnosisCodeQual != 'ABJ' THEN 'INVALID'
         WHEN AdmittingDiagnosisCode IS NULL THEN 'NULL'
		 WHEN AdmittingDiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
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
    AND FacilityTypeCode IN (SELECT LEFT(CDE_CHAR,2) FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_TYPE_OF_BILL' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END FacilityTypeCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('M','L','I','O') THEN 'NOT APP'
	     WHEN FacilityTypeCode IS NULL THEN 'NULL'
--         WHEN FacilityTypeCode NOT IN (SELECT LEFT(CDE_CHAR,2) FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_TYPE_OF_BILL' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'SUP CODE REF LOOKUP IS INVALID'
         WHEN FacilityTypeCode NOT IN (SELECT LEFT(CDE_CHAR,2) FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_TYPE_OF_BILL' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'

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
    AND AdmissionTypeCode IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_ADMIT_TYPE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END AdmissionTypeCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I') THEN 'NOT APP'
	     WHEN AdmissionTypeCode IS NULL THEN 'NULL'
         WHEN AdmissionTypeCode NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_ADMIT_TYPE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
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
    AND AdmissionSourceCode IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_ADMIT_SOURCE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END AdmissionSourceCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I') THEN 'NOT APP'
	     WHEN AdmissionSourceCode IS NULL THEN 'NULL'
         WHEN AdmissionSourceCode NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_ADMIT_SOURCE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
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
    CASE WHEN Claim_Type NOT IN ('L','I','O','M','D') THEN 'NOT APP'
	     WHEN SvcLineChargeAmt IS NULL THEN 'NULL'
         WHEN SvcLineChargeAmt < 0 THEN 'INVALID'
         ELSE 'VALID' END SvcLineChargeAmt1X,

--  SERVICE LINE REVENUE CODE
/*
-- for 6 and 5.3 just removed claim type M and D

•	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP
•	MPT_SENDPRO_ServiceLineRevenueCode_Valid: 
RAW_SPRO_837I_CLAIM_SERVICE_DETAIL.SvcLineRevenueCode
•	MPT_SENDPRO_StringIsNull_ALL: 
RAW_SPRO_837I_CLAIM_SERVICE_DETAIL.SvcLineRevenueCode

MPT_SENDPRO_ServiceLineRevenueCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP='CDE_REVENUE'  then 1 else 0
*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O') 
	AND SvcLineRevenueCode IS NOT NULL
    AND SvcLineRevenueCode IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END SvcLineRevenueCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O') THEN 'NOT APP'
	     WHEN SvcLineRevenueCode IS NULL THEN 'NULL'
         WHEN SvcLineRevenueCode NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
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
    AND ProcedureCode IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_OCCURRENCE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
    AND ProcedureCodeQual = 'BH'
        THEN 1 ELSE 0 END OccurrenceCode1,

--  Ex
    CASE 
         WHEN Claim_Type NOT IN ('L','I') THEN 'NOT APP'
		 WHEN ProcedureCode IS NULL THEN 'NULL'
         WHEN ProcedureCode NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_OCCURRENCE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
--		 WHEN ProcedureCodeQual <> 'BH' THEN 'ProcedureCodeQual <> BH' 
		 WHEN ProcedureCodeQual <> 'BH' THEN 'INVALID' 
         ELSE 'VALID' END OccurrenceCode1X,


--  Occurrence Span Code
/*
12.1.15	xOccurrence Span Code (MPT_SENDPRO_OccurrenceSpanCode_837I)
•	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP
•	MPT_SENDPRO_OccurrenceSpanCode_Valid: RAW_SPRO_837I_CLAIM_ENC_ATTRIBUTE_DTL.ProcedureCode
•	MPT_SENDPRO_StringIsNull_ALL: RAW_SPRO_837I_CLAIM_ENC_ATTRIBUTE_DTL.ProcedureCode	

        MPT_SENDPRO_OccurrenceSpanCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’CDE_OCCURRENCE_SPAN’ then 1 else 0 
*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O') 
	AND ProcedureCode IS NOT NULL
    AND ProcedureCode IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_OCCURRENCE_SPAN' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END OccurrenceSpanCode1,

--  Ex
    CASE 
         WHEN Claim_Type NOT IN ('L','I') THEN 'NOT APP'
		 WHEN ProcedureCode IS NULL THEN 'NULL'
         WHEN ProcedureCode NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_OCCURRENCE_SPAN' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END OccurrenceSpanCode1X,

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
    AND ProcedureCode IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_VALUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
    AND ProcedureCodeQual = 'BE'
        THEN 1 ELSE 0 END ValueCode1,

--  Ex
    CASE 
         WHEN Claim_Type NOT IN ('L','I') THEN 'NOT APP'
		 WHEN ProcedureCode IS NULL THEN 'NULL'
         WHEN ProcedureCode NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_VALUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID' 
--         WHEN ProcedureCodeQual <> 'BE' THEN 'ProcedureCodeQual <> BE'    
         WHEN ProcedureCodeQual <> 'BE' THEN 'INVALID'    
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
    AND ProcedureCode IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_COND' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
    AND ProcedureCodeQual = 'BG'
        THEN 1 ELSE 0 END ConditionCode1,

--  Ex
    CASE 
         WHEN Claim_Type NOT IN ('L','I') THEN 'NOT APP'
		 WHEN ProcedureCode IS NULL THEN 'NULL'
         WHEN ProcedureCode NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_COND' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
--		 WHEN ProcedureCodeQual <> 'BG' THEN 'ProcedureCodeQual <> BG'
		 WHEN ProcedureCodeQual <> 'BG' THEN 'INVALID'
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
    AND PatientStatusCode IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PATIENT_STATUS' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END PatientStatusCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O') THEN 'NOT APP'
	     WHEN PatientStatusCode IS NULL THEN 'NULL'
         WHEN PatientStatusCode NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PATIENT_STATUS' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END PatientStatusCode1X,


--  Principal Diagnosis Code
/*
12.1.19	Principal Diagnosis Code (MPT_SENDPRO_Principal_Diag_Code)
•	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D
•	MPT_SENDPRO_Diagnosis_Code_Valid_ALL: RAW_SPRO_837D_CLAIM_DIAGNOSIS_DTL.DiagnosisCode, DiagnosisType=’ ClmOtherDiagnosis’
RAW_SPRO_NCPDP_DIAGONSIS_CODE.DiagnosisCode,
RAW_SPRO_837P_CLAIM_DIAGNOSIS_DTL.DiagnosisCode, DiagnosisType=’ ClmPrincipalDiagnosis’
RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL.DiagnosisCode, DiagnosisType=’ ClmPrincipalDiagnosis’
•	MPT_SENDPRO_StringIsNull_ALL: RAW_SPRO_837D_CLAIM_DIAGNOSIS_DTL.DiagnosisCode,
RAW_SPRO_837P_CLAIM_DIAGNOSIS_DTL.DiagnosisCode, DiagnosisType=’ ClmPrincipalDiagnosis’
RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL.DiagnosisCode, DiagnosisType=’ ClmPrincipalDiagnosis’

*/

/* @@@-2 */
--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')
	AND DiagnosisCode IS NOT NULL 
	AND DiagnosisCode IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) 
    AND DiagnosisType = 'ClmPrincipalDiagnosis'	
        THEN 1 ELSE 0 END PrincipalDiagnosisCode1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT APP'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
--         WHEN DiagnosisType <> 'ClmPrincipalDiagnosis' THEN 'DiagnosisType <> ClmPrincipalDiagnosis'	
         WHEN DiagnosisType <> 'ClmPrincipalDiagnosis' THEN 'INVALID'	
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
	AND DiagnosisCode IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') )
    AND DiagnosisType = 'ClmOtherDiagnosis'	
        THEN 1 ELSE 0 END ICD10Diagnosis_Code1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M','P') THEN 'NOT APP'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
--         WHEN DiagnosisType <> 'ClmOtherDiagnosis' THEN 'DiagnosisType <> ClmOtherDiagnosis'	
         WHEN DiagnosisType <> 'ClmOtherDiagnosis' THEN 'INVALID'	
         ELSE 'VALID' END ICD10Diagnosis_Code1X,

--  Service Line Procedure Code

-- 6 is same as 5.3
/*
12.1.21	Service Line Procedure_Code_ICD10 
(MPT_SENDPRO_ServiceLineProcedure_Code)
•	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P,, MPT_SENDPRO_ClaiimType_837D
•	MPT_SENDPRO_Procedure_Code_Valid_ALL: 
RAW_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode,
RAW_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode
RAW_SPRO_837D_CLAIM_SERVICE_LINE_DETAIL. SvcProcCode
MPT_SENDPRO_StringIsNull_ALL: RAW_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode,
RAW_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode
RAW_SPRO_837D_CLAIM_SERVICE_LINE_DETAIL. SvcProcCode

--MultipleProcedureCode
SvcLineProcCode

*/
/* @@@-3 */

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')
	AND SvcLineProcCode IS NOT NULL 
	AND SvcLineProcCode IN (SELECT CDE_PROC FROM MHDWQA.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-'))
        THEN 1 ELSE 0 END MultipleProcedureCode1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT APP'
         WHEN SvcLineProcCode IS NULL THEN 'NULL'
		 WHEN SvcLineProcCode NOT IN (SELECT CDE_PROC FROM MHDWQA.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-')) THEN 'INVALID'
         ELSE 'VALID' END MultipleProcedureCode1X,

/*
--  CDT Code

12.1.22	CDT_Code_ICD10 (MPT_SENDPRO_CDT_Code)
837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P

MPT_SENDPRO_CDT_Code_Valid_ALL: RAW_SPRO_837I_CLAIM_ENC_ATTRIBUTE_DTL.ProcedureCode
MPT_SENDPRO_StringIsNull_ALL: RAW_SPRO_837I_CLAIM_ENC_ATTRIBUTE_DTL.ProcedureCode

MPT_SENDPRO_CDT_Code_Valid_ALL	
If valid based on lookup to the column CDE_PROC from "NW_B_PROCEDURE" where CDE_PROC like 'D%' and upper(proc_group) like 'ALPHA%' then 1 else 0
*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')
	AND ProcedureCode IS NOT NULL 
	AND ProcedureCode IN (SELECT CDE_PROC FROM MHDWQA.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND CDE_PROC LIKE 'D%' AND UPPER(proc_group) LIKE 'ALPHA%')
        THEN 1 ELSE 0 END CDT_Code1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT APP'
         WHEN ProcedureCode IS NULL THEN 'NULL'
		 WHEN ProcedureCode NOT IN (SELECT CDE_PROC FROM MHDWQA.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND CDE_PROC LIKE 'D%' AND UPPER(proc_group) LIKE 'ALPHA%') THEN 'INVALID'
         ELSE 'VALID' END CDT_Code1X,

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

--  DI
    CASE WHEN Claim_Type IN ('O','M','D')
	AND SvcLineProcCode IS NOT NULL 
	AND SvcLineProcCode IN (SELECT CDE_PROC FROM MHDWQA.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'CPT%')
    AND SvcLineProcCodeQual = 'HC'
        THEN 1 ELSE 0 END CPT_Code1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('O','M','D') THEN 'NOT APP'
         WHEN SvcLineProcCode IS NULL THEN 'NULL'
		 WHEN SvcLineProcCode NOT IN (SELECT CDE_PROC FROM MHDWQA.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'CPT%') THEN 'INVALID'
--         WHEN SvcLineProcCodeQual <> 'HC' THEN 'SvcLineProcCodeQual <> HC'
         WHEN SvcLineProcCodeQual <> 'HC' THEN 'INVALID'
         ELSE 'VALID' END CPT_Code1X,

--  HIPPS Code
/*
--6 same as 5.3

12.1.24	HIPPS_Code_ICD10 (MPT_SENDPRO_HIPPS_Code)
4.1.1.10.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P
4.1.1.11.	MPT_SENDPRO_HIPPS_Code_Valid_ALL: RAW_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, SvcLineProcCodeQual='HP'; RAW_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode, SvcLineProcCodeQual='HP'
4.1.1.12.	MPT_SENDPRO_StringIsNull_ALL: RAW_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode ; RAW_SPRO_837P_CLAIM_SERVICE_LINE_DETAIL. SvcLineProcCode

-- 5.3
MPT_SENDPRO_HIPPS_Code_Valid_ALL	If valid based on lookup to the column CDE_PROC from "NW_B_PROCEDURE" where upper(proc_group) like HIPPS%' then 1 else 0

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')
	AND SvcLineProcCode IS NOT NULL 
	AND SvcLineProcCode IN (SELECT CDE_PROC FROM MHDWQA.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'HIPPS%')
    AND SvcLineProcCodeQual = 'HP'
        THEN 1 ELSE 0 END HIPPS_Code1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT APP'
         WHEN SvcLineProcCode IS NULL THEN 'NULL'
		 WHEN SvcLineProcCode NOT IN (SELECT CDE_PROC FROM MHDWQA.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'HIPPS%') THEN 'INVALID'
--         WHEN SvcLineProcCodeQual <> 'HP' THEN 'SvcLineProcCodeQual <> HP'
         WHEN SvcLineProcCodeQual <> 'HP' THEN 'INVALID'
         ELSE 'VALID' END HIPPS_Code1X,


--  Service Line PROC MOD
/*
-- 6 same as 5.3
12.1.26.	Service Line PROC MOD (MPT_SENDPRO_ServiceLine_PROC_MOD)
4.1.1.16.	837I Claims population:  
MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P 
4.1.1.17.	MPT_SENDPRO_PROC_MOD_Valid_ALL: 
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.SvcLineProcMod01,
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.SvcLineProcMod02,
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.SvcLineProcMod03,
STG_SPRO_837I_CLAIM_SERVICE_LINE_DETAIL.SvcLineProcMod04,

-- 5.3
MPT_SENDPRO_PROC_MOD_Valid_All	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’CDE_PROC_MOD’ then 1 else 0

*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')     
	AND 
	( 
	( SvcLineProcMod01 IS NOT NULL
        AND SvcLineProcMod01 IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineProcMod02 IS NOT NULL
        AND SvcLineProcMod02 IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineProcMod03 IS NOT NULL
        AND SvcLineProcMod03 IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineProcMod04 IS NOT NULL
        AND SvcLineProcMod04 IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	)	
        THEN 1 ELSE 0 END SvcLineProcMod1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT APP'
	     WHEN SvcLineProcMod01 IS NULL AND SvcLineProcMod02 IS NULL AND SvcLineProcMod03 IS NULL AND SvcLineProcMod04 IS NULL THEN 'NULL'
         WHEN SvcLineProcMod01 NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
              AND SvcLineProcMod02 NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 
              AND SvcLineProcMod03 NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 
              AND SvcLineProcMod04 NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 			  
			  THEN 'INVALID'
         ELSE 'VALID' END SvcLineProcMod1X,


--  Service Line Adjustment Revenue Code
/*
-- 6 same as 5.3 but is filter needed on source filed?

-- 5.3
12.1.27.	Service Line Adjustment Revenue Code (MPT_SENDPRO_AdjRevenueCode_837I)
4.1.1.1.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D

4.1.1.2.	MPT_SENDPRO_ServiceLineRevenueCode_Valid: 
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,
4.1.1.3.	MPT_SENDPRO_StringIsNull_ALL: 
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjRevenueCode,

@@@ is this still required?
CASE WHEN LEFT(a."SvcLineAdjRevenueCode",1) != '0' then a."SvcLineAdjRevenueCode" ELSE SUBSTR(a."SvcLineAdjRevenueCode",2,3) END as SvcLineAdjRevenueCode,

-- 6
12.1.27	Service Line Adjustment Revenue Code (MPT_SENDPRO_AdjRevenueCode_837I)
•	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D

•	MPT_SENDPRO_ServiceLineRevenueCode_Valid: RAW_SPRO_837I_CLAIM_SVCLN_ADJUDICATION_DTL.SvcLineAdjRevenueCode,
•	MPT_SENDPRO_StringIsNull_ALL: 
RAW_SPRO_837I_CLAIM_SVCLN_ADJUDICATION_DTL.SvcLineAdjRevenueCode,

-- 5.3
MPT_SENDPRO_ServiceLineRevenueCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP='CDE_REVENUE'  then 1 else 0

-- 6
MPT_SENDPRO_ServiceLineRevenueCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP='CDE_REVENUE'  then 1 else 0
*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M','D') 
    
	AND SvcLineAdjRevenueCode IS NOT NULL
    AND SvcLineAdjRevenueCode IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END SvcLineAdjRevenueCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M','D') THEN 'NOT APP'
	     WHEN SvcLineAdjRevenueCode IS NULL THEN 'NULL'
         WHEN SvcLineAdjRevenueCode NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END SvcLineAdjRevenueCode1X,


--  Condition Treatment Procedure Code
/*
12.1.29.	Condition Treatment Procedure_Code_ICD10 (MPT_SENDPRO_CondTreatProcedure_Code)
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
	AND ProcedureCode IN (SELECT CDE_PROC from MHDWQA.NW.NW_B_PROCEDURE where CDE_PROC NOT IN ('#','+','-'))
        THEN 1 ELSE 0 END ProcedureCode1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT APP'
         WHEN ProcedureCode IS NULL THEN 'NULL'
		 WHEN ProcedureCode NOT IN (SELECT CDE_PROC from MHDWQA.NW.NW_B_PROCEDURE where CDE_PROC NOT IN ('#','+','-')) THEN 'INVALID'
         ELSE 'VALID' END ProcedureCode1X,


--  Service Line Adjustment PROC MOD
/*
-- 6 is same as 5.3

-- 5.3
12.1.30.	Service Line Adj PROC MOD (MPT_SENDPRO_ServiceLineAdj_PROC_MOD)
4.1.1.23.	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, 

MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P 
4.1.1.24.	MPT_SENDPRO_PROC_MOD_Valid_ALL: 
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjudicationProcMod01,
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjudicationProcMod03,
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjudicationProcMod02,
STG_SPRO_837I_CLAIM_SVCLN_LINEADJ_INFO.SvcLineAdjudicationProcMod04,

-- 6
12.1.30	Service Line Adj PROC MOD (MPT_SENDPRO_ServiceLineAdj_PROC_MOD)
•	837I Claims population:  MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P 

•	MPT_SENDPRO_PROC_MOD_Valid_ALL: RAW_SPRO_837I_CLAIM_SVCLN_ADJUDICATION_DTL.SvcLineAdjudicationProcMod04,
RAW_SPRO_837I_CLAIM_SVCLN_ADJUDICATION_DTL.SvcLineAdjudicationProcMod01,
RAW_SPRO_837I_CLAIM_SVCLN_ADJUDICATION_DTL.SvcLineAdjudicationProcMod03,
RAW_SPRO_837I_CLAIM_SVCLN_ADJUDICATION_DTL.SvcLineAdjudicationProcMod02,

-- 5.3

MPT_SENDPRO_PROC_MOD_Valid_All	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’CDE_PROC_MOD’ then 1 else 0

-- 6

MPT_SENDPRO_PROC_MOD_Valid_All	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’ CDE_PROC_MOD’ then 1 else 0
*/

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')     
	AND 
	( 
	( SvcLineAdjudicationProcMod01 IS NOT NULL
        AND SvcLineAdjudicationProcMod01 IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineAdjudicationProcMod02 IS NOT NULL
        AND SvcLineAdjudicationProcMod02 IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineAdjudicationProcMod03 IS NOT NULL
        AND SvcLineAdjudicationProcMod03 IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( SvcLineAdjudicationProcMod04 IS NOT NULL
        AND SvcLineAdjudicationProcMod04 IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PROC_MOD' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) )
	)	
        THEN 1 ELSE 0 END SvcLineAdjudicationProcMod1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT APP'
	     WHEN SvcLineAdjudicationProcMod01 IS NULL AND SvcLineAdjudicationProcMod02 IS NULL AND SvcLineAdjudicationProcMod03 IS NULL AND SvcLineAdjudicationProcMod04 IS NULL THEN 'NULL'
         WHEN SvcLineAdjudicationProcMod01 NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
              AND SvcLineAdjudicationProcMod02 NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 
              AND SvcLineAdjudicationProcMod03 NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 
              AND SvcLineAdjudicationProcMod04 NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 			  
			  THEN 'INVALID'
         ELSE 'VALID' END SvcLineAdjudicationProcMod1X,

-- Billing Provider Id

/*
12.1.32	Billing Provider Id (MPT_SENDPRO_BillingProviderID_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837

•	Missing String Value Parameter: : MP_SENDPRO_StringIsNull_ALL :  
RAW_SPRO_837I_CLAIM. ProviderInternalId, 
RAW_SPRO_837I_BILLING_PROVIDER_DTL.ProviderInternalId

•	MPT_SENDPRO_ProviderInternalId_Valid: 
RAW_SPRO_837I_CLAIM. ProviderInternalId,
RAW_SPRO_837I_BILLING_PROVIDER_DTL.ProviderInternalId

MPT_SENDPRO_StringIsNull_ALL	String is not null then 1 else 0

MPT_SENDPRO_ProviderInternalId_Valid	
Validity of Internal ID determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
If valid then 1 else 0

h."ProviderInternalId" as ProviderInternalId,
bp."ProviderInternalId" as ProviderInternalId_bp,

*/

--  DI
    CASE
    --all Claim_Types
	    WHEN ProviderInternalId IS NOT NULL 
	    AND ProviderInternalId IN (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ProviderInternalId)
	    AND ProviderInternalId_bp IS NOT NULL 
	    AND ProviderInternalId_bp IN (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ProviderInternalId_bp)
        THEN 1 ELSE 0 END bill_ProviderInternalId1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ProviderInternalId IS NULL OR ProviderInternalId_bp IS NULL) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ProviderInternalId) 
         OR
         NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ProviderInternalId_bp)
         )
         THEN 'INVALID'
         ELSE 'VALID' END bill_ProviderInternalId1X,

-- Billing Provider PIDSL

/*
12.1.33	Billing Provider PIDSL (MPT_SENDPRO_BillingProviderPIDSL_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837

•	Missing String Value Parameter: : MP_SENDPRO_StringIsNull_ALL 
RAW_SPRO_837I_CLAIM. ProviderPidsl,
RAW_SPRO_837I_BILLING_PROVIDER_DTL. ProviderPidsl, 

•	MPT_SENDPRO_ProviderInternalId_Valid: 
RAW_SPRO_837I_CLAIM. ProviderPidsl,
RAW_SPRO_837I_BILLING_PROVIDER_DTL. ProviderPidsl,

MPT_SENDPRO_StringIsNull_ALL	String is not null then 1 else 0

MPT_SENDPRO_ProviderPIDSL_Valid	Validity of  PIDSL 
is determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ID_PROVIDER
If valid then 1 else 0

h."ProviderPidsl" as ProviderPidsl,
bp."ProviderPidsl" as ProviderPidsl_bp

*/

--  DI
    CASE
    --all Claim_Types
	    WHEN ProviderPidsl IS NOT NULL
	    AND ProviderPidsl IN (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER where ID_PROVIDER NOT IN ('#','+','-') AND ID_PROVIDER = ProviderPidsl)
	    AND ProviderPidsl_bp IS NOT NULL 
	    AND ProviderPidsl_bp IN (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER where ID_PROVIDER NOT IN ('#','+','-') AND ID_PROVIDER = ProviderPidsl_bp)
        THEN 1 ELSE 0 END bill_ProviderPidsl1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ProviderPidsl IS NULL OR ProviderPidsl_bp IS NULL) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER where ID_PROVIDER NOT IN ('#','+','-') AND ID_PROVIDER = ProviderPidsl) 
         OR
         NOT EXISTS (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER where ID_PROVIDER NOT IN ('#','+','-') AND ID_PROVIDER = ProviderPidsl_bp)
         )
         THEN 'INVALID'
         ELSE 'VALID' END bill_ProviderPidsl1X,

/*

12.1.34	Attending Provider NPI (MPT_SENDPRO_AttendingProviderNPI_837I)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, 
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_837I_ATTENDING_PROVIDER_DTL.AttendingProvNPI


MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
If valid then 1 else 0

*/

--  DI
    CASE
    --all Claim_Types
	    WHEN at_AttendingProvNPI IS NOT NULL 
		AND VALIDATE_NPI_LUHN_PY(at_AttendingProvNPI)        
        THEN 1 ELSE 0 END at_AttendingProvNPI1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (at_AttendingProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT VALIDATE_NPI_LUHN_PY(at_AttendingProvNPI) ) THEN 'INVALID'
         ELSE 'VALID' END at_AttendingProvNPI1X,

/*
12.1.35	Attending Provider ID (MPT_SENDPRO_AttendingProviderID_837I)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, 
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_837I_ATTENDING_PROVIDER_DTL.AttendingProvID

MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
If valid then 1 else 0

left join MHDWDEV.SENDPRO.spro_b_enc837_provider_hist ap
on ad."ProviderPidsl"= ap.enc_prov_id
and ad."ProviderLocationCode"= (
    case when length(ap.cde_enc_prov_id_loc) <3 then lpad(ap.cde_enc_prov_id_loc,3,'0')
         when length(ap.cde_enc_prov_id_loc) >3 then substr(ap.cde_enc_prov_id_loc,0,3)
        else ap.cde_enc_prov_id_loc 

*/

--  DI
    CASE
    --all Claim_Types
	    WHEN at_ProviderInternalId IS NOT NULL 
	    AND at_ProviderInternalId IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = at_ProviderInternalId
--        SELECT ENC_PROV_ID from MHDWQA.NW.NW_B_ENC_PROVIDER where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = at_ProviderInternalId
       
        )
        THEN 1 ELSE 0 END at_ProviderInternalId1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (at_ProviderInternalId IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = at_ProviderInternalId) )
         THEN 'INVALID'
         ELSE 'VALID' END at_ProviderInternalId1X,

/*
12.1.36	Attending Provider PIDSL (MPT_SENDPRO_AttendingProviderPIDSL_837I)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, 
•	MPT_SENDPRO_ProviderPIDSL_Valid: RAW_SPRO_837I_ATTENDING_PROVIDER_DTL.AttendingProvPIDSL

MPT_SENDPRO_ProviderPIDSL_Valid	Validity of  PIDSL is determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ID_PROVIDER
If valid then 1 else 0

*/

-- DI
    CASE
	    WHEN at_ProviderPidsl IS NOT NULL
        AND at_ProviderPidsl IN (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER ap 
--          WHERE ID_PROVIDER NOT IN ('#','+','-') 
            WHERE ID_PROVIDER = at_ProviderPidsl
            AND at_ProviderLocationCode = (
            case when length(ap.ID_PROVIDER_LOCATION) <3 then lpad(ap.ID_PROVIDER_LOCATION,3,'0')
                 when length(ap.ID_PROVIDER_LOCATION) >3 then substr(ap.ID_PROVIDER_LOCATION,0,3)
                 else ap.ID_PROVIDER_LOCATION 
             end)     
        )        
        THEN 1 ELSE 0 END at_ProviderPidsl1,

--  Ex
    CASE  
         WHEN (at_ProviderPidsl IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (
         (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER ap 
--          WHERE ID_PROVIDER NOT IN ('#','+','-') 
          WHERE ID_PROVIDER = at_ProviderPidsl
          AND at_ProviderLocationCode = (
            case when length(ap.ID_PROVIDER_LOCATION) <3 then lpad(ap.ID_PROVIDER_LOCATION,3,'0')
                 when length(ap.ID_PROVIDER_LOCATION) >3 then substr(ap.ID_PROVIDER_LOCATION,0,3)
                 else ap.ID_PROVIDER_LOCATION
             end))))         
         THEN 'INVALID'
         ELSE 'VALID' END at_ProviderPidsl1X,

/*
12.1.37	Referring Provider NPI (MPT_SENDPRO_ ReferringProviderNPI_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, MPT_SENDPRO_ClaimType_837D
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_837I_ REFERRING_PROVIDER_DTL.ReferringProvNPI, RAW_SPRO_837D_REFERRING_PROVIDER_DTL.ReferringProvNPI,

MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
If valid then 1 else 0

*/

--  DI
    CASE
    --all Claim_Types
	    WHEN ref_ReferringProvNPI IS NOT NULL 
		AND VALIDATE_NPI_LUHN_PY(ref_ReferringProvNPI)        
        THEN 1 ELSE 0 END ref_ReferringProvNPI1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ref_ReferringProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT VALIDATE_NPI_LUHN_PY(ref_ReferringProvNPI) ) THEN 'INVALID'
         ELSE 'VALID' END ref_ReferringProvNPI1X,

/*
12.1.38	Referring Provider ID (MPT_SENDPRO_ ReferringProviderID_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, MPT_SENDPRO_ClaimType_837D
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_837I_REFERRING_PROVIDER_DTL.ReferringProvID, RAW_SPRO_837D_ REFERRING_PROVIDER_DTL. ReferringProvID,

MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
If valid then 1 else 0

*/

--  DI
    CASE
    --all Claim_Types
	    WHEN ref_ProviderInternalId IS NOT NULL 
	    AND ref_ProviderInternalId IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ref_ProviderInternalId
        
        )
        THEN 1 ELSE 0 END ref_ProviderInternalId1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ref_ProviderInternalId IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ref_ProviderInternalId) )
         THEN 'INVALID'
         ELSE 'VALID' END ref_ProviderInternalId1X,

/*
12.1.39	Referring Provider PIDSL (MPT_SENDPRO_ ReferringProviderPIDSL_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, MPT_SENDPRO_ClaimType_837D
•	MPT_SENDPRO_ProviderPIDSL_Valid: RAW_SPRO_837I_REFERRING_PROVIDER_DTL.ReferringProvPIDSL, RAW_SPRO_837D_REFERRING_PROVIDER_DTL.ReferringProvPIDSL

MPT_SENDPRO_ProviderPIDSL_Valid	Validity of  PIDSL is determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ID_PROVIDER
If valid then 1 else 0
*/

-- DI
    CASE
	    WHEN ref_ProviderPidsl IS NOT NULL
        AND ref_ProviderPidsl IN (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER ap 
--          WHERE ID_PROVIDER NOT IN ('#','+','-') 
            WHERE ID_PROVIDER = ref_ProviderPidsl
            AND ref_ProviderLocationCode = (
            case when length(ap.ID_PROVIDER_LOCATION) <3 then lpad(ap.ID_PROVIDER_LOCATION,3,'0')
                 when length(ap.ID_PROVIDER_LOCATION) >3 then substr(ap.ID_PROVIDER_LOCATION,0,3)
                 else ap.ID_PROVIDER_LOCATION 
             end)     
        )        
        THEN 1 ELSE 0 END ref_ProviderPidsl1,

--  Ex
    CASE  
         WHEN (ref_ProviderPidsl IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (
         (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER ap 
--          WHERE ID_PROVIDER NOT IN ('#','+','-') 
          WHERE ID_PROVIDER = ref_ProviderPidsl
          AND ref_ProviderLocationCode = (
            case when length(ap.ID_PROVIDER_LOCATION) <3 then lpad(ap.ID_PROVIDER_LOCATION,3,'0')
                 when length(ap.ID_PROVIDER_LOCATION) >3 then substr(ap.ID_PROVIDER_LOCATION,0,3)
                 else ap.ID_PROVIDER_LOCATION
             end))))         
         THEN 'INVALID'
         ELSE 'VALID' END ref_ProviderPidsl1X,

/*
12.1.40	Rendering Provider NPI (MPT_SENDPRO_ RenderingProviderNPI_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, MPT_SENDPRO_ClaimType_837D, 
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_837I_ RENDERING_PROVIDER_DTL.RenderingProvNPI, RAW_SPRO_837D_RENDERING_PROVIDER_DTL.RenderingProvNPI

MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
If valid then 1 else 0

*/

--  DI
    CASE
    --all Claim_Types
	    WHEN ren_RenderingProvNPI IS NOT NULL 
		AND VALIDATE_NPI_LUHN_PY(ren_RenderingProvNPI)        
        THEN 1 ELSE 0 END ren_RenderingProvNPI1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ren_RenderingProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT VALIDATE_NPI_LUHN_PY(ren_RenderingProvNPI) ) THEN 'INVALID'
         ELSE 'VALID' END ren_RenderingProvNPI1X,

/*

12.1.41	Rendering Provider ID (MPT_SENDPRO_ RenderingProviderID_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, MPT_SENDPRO_ClaimType_837D
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_837I_RENDERING_PROVIDER_DTL.RenderingProvID, RAW_SPRO_837D_RENDERING_PROVIDER_DTL. RenderingProvID

MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
If valid then 1 else 0

*/

--  DI
    CASE
    --all Claim_Types
	    WHEN ren_ProviderInternalId IS NOT NULL 
	    AND ren_ProviderInternalId IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ren_ProviderInternalId
        
        )
        THEN 1 ELSE 0 END ren_ProviderInternalId1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ren_ProviderInternalId IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ren_ProviderInternalId) )
         THEN 'INVALID'
         ELSE 'VALID' END ren_ProviderInternalId1X,

/*

12.1.42	Rendering Provider PIDSL (MPT_SENDPRO_RenderingProviderPIDSL_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, MPT_SENDPRO_ClaimType_837D
•	MPT_SENDPRO_ProviderPIDSL_Valid: RAW_SPRO_837I_ RENDERING_PROVIDER_DTL.RenderingProvPIDSL, RAW_SPRO_837D_RENDERING_PROVIDER_DTL.RenderingProvPIDSL


MPT_SENDPRO_ProviderPIDSL_Valid	Validity of  PIDSL is determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ID_PROVIDER
If valid then 1 else 0

*/

-- DI
    CASE
	    WHEN ren_ProviderPidsl IS NOT NULL
        AND ren_ProviderPidsl IN (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER ap 
--          WHERE ID_PROVIDER NOT IN ('#','+','-') 
            WHERE ID_PROVIDER = ren_ProviderPidsl
            AND ren_ProviderLocationCode = (
            case when length(ap.ID_PROVIDER_LOCATION) <3 then lpad(ap.ID_PROVIDER_LOCATION,3,'0')
                 when length(ap.ID_PROVIDER_LOCATION) >3 then substr(ap.ID_PROVIDER_LOCATION,0,3)
                 else ap.ID_PROVIDER_LOCATION 
             end)     
        )        
        THEN 1 ELSE 0 END ren_ProviderPidsl1,

--  Ex
    CASE  
         WHEN (ren_ProviderPidsl IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (
         (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER ap 
--          WHERE ID_PROVIDER NOT IN ('#','+','-') 
          WHERE ID_PROVIDER = ren_ProviderPidsl
          AND ren_ProviderLocationCode = (
            case when length(ap.ID_PROVIDER_LOCATION) <3 then lpad(ap.ID_PROVIDER_LOCATION,3,'0')
                 when length(ap.ID_PROVIDER_LOCATION) >3 then substr(ap.ID_PROVIDER_LOCATION,0,3)
                 else ap.ID_PROVIDER_LOCATION
             end))))         
         THEN 'INVALID'
         ELSE 'VALID' END ren_ProviderPidsl1X,

/*

12.1.43	Other Provider NPI (MPT_SENDPRO_OtherProviderNPI_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, MPT_SENDPRO_ClaimType_837P 
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_837I_OPERATING_PHYS_PROVIDER_DTL. OperatingProvNPI, RAW_SPRO_837I_OTHER_OPERATING_PHYS_PROVIDER_DTL. OtherOperProvNPI, RAW_SPRO_837P_SUPERVISING_PROVIDER_DTL. SupervisingProvNPI, RAW_SPRO_837P_SVCLN_ORDERING_PROVIDER_DTL. OrderingProvID

RAW_SPRO_837I_OTHER_OPERATING_PHYS_PROVIDER_DTL

*/

--  DI
    CASE
    --all Claim_Types
	    WHEN oop_OtherOperProvNPI IS NOT NULL 
		AND VALIDATE_NPI_LUHN_PY(oop_OtherOperProvNPI)        
        THEN 1 ELSE 0 END oop_OtherOperProvNPI1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (oop_OtherOperProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT VALIDATE_NPI_LUHN_PY(oop_OtherOperProvNPI) ) THEN 'INVALID'
         ELSE 'VALID' END oop_OtherOperProvNPI1X,

/*
12.1.44	Other Provider ID (MPT_SENDPRO_ RenderingProviderID_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, MPT_SENDPRO_ClaimType_837P
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_837I_OPERATING_PHYS_PROVIDER_DTL. ProviderInternalId, RAW_SPRO_837I_OTHER_OPERATING_PHYS_PROVIDER_DTL. ProviderInternalId, RAW_SPRO_837P_SUPERVISING_PROVIDER_DTL. ProviderInternalId, RAW_SPRO_837P_SVCLN_ORDERING_PROVIDER_DTL. ProviderInternalId

*/

--  DI
    CASE
    --all Claim_Types
	    WHEN oop_ProviderInternalId IS NOT NULL 
	    AND oop_ProviderInternalId IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = oop_ProviderInternalId
        
        )
        THEN 1 ELSE 0 END oop_ProviderInternalId1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (oop_ProviderInternalId IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = oop_ProviderInternalId) )
         THEN 'INVALID'
         ELSE 'VALID' END oop_ProviderInternalId1X,

/*
12.1.45	Other Provider PIDSL (MPT_SENDPRO_RenderingProviderPIDSL_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_837_OUTP, MPT_SENDPRO_ClaimType_837P
•	MPT_SENDPRO_ProviderPIDSL_Valid: RAW_SPRO_837I_OPERATING_PHYS_PROVIDER_DTL. ProviderPidsl, RAW_SPRO_837I_OTHER_OPERATING_PHYS_PROVIDER_DTL. ProviderPidsl, RAW_SPRO_837P_SUPERVISING_PROVIDER_DTL. ProviderPidsl, RAW_SPRO_837P_SVCLN_ORDERING_PROVIDER_DTL. ProviderPidsl

*/

-- DI
    CASE
	    WHEN oop_ProviderPidsl IS NOT NULL
        AND oop_ProviderPidsl IN (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER ap 
--          WHERE ID_PROVIDER NOT IN ('#','+','-') 
            WHERE ID_PROVIDER = oop_ProviderPidsl
            AND oop_ProviderLocationCode = (
            case when length(ap.ID_PROVIDER_LOCATION) <3 then lpad(ap.ID_PROVIDER_LOCATION,3,'0')
                 when length(ap.ID_PROVIDER_LOCATION) >3 then substr(ap.ID_PROVIDER_LOCATION,0,3)
                 else ap.ID_PROVIDER_LOCATION
             end)     
        )        
        THEN 1 ELSE 0 END oop_ProviderPidsl1,

--  Ex
    CASE  
         WHEN (oop_ProviderPidsl IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (
         (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER ap 
--          WHERE ID_PROVIDER NOT IN ('#','+','-') 
          WHERE ID_PROVIDER = oop_ProviderPidsl
          AND oop_ProviderLocationCode = (
            case when length(ap.ID_PROVIDER_LOCATION) <3 then lpad(ap.ID_PROVIDER_LOCATION,3,'0')
                 when length(ap.ID_PROVIDER_LOCATION) >3 then substr(ap.ID_PROVIDER_LOCATION,0,3)
                 else ap.ID_PROVIDER_LOCATION 
             end))))         
         THEN 'INVALID'
         ELSE 'VALID' END oop_ProviderPidsl1X,

-- Operating found with Other Operating
-- NPI

--  DI
    CASE
    --all Claim_Types
	    WHEN op_OperatingProvNPI IS NOT NULL 
		AND VALIDATE_NPI_LUHN_PY(op_OperatingProvNPI)        
        THEN 1 ELSE 0 END op_OperatingProvNPI1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (op_OperatingProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT VALIDATE_NPI_LUHN_PY(op_OperatingProvNPI) ) THEN 'INVALID'
         ELSE 'VALID' END op_OperatingProvNPI1X,

-- Internal ID 

--  DI
    CASE
    --all Claim_Types
	    WHEN op_ProviderInternalId IS NOT NULL 
	    AND op_ProviderInternalId IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = op_ProviderInternalId
        
        )
        THEN 1 ELSE 0 END op_ProviderInternalId1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (op_ProviderInternalId IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = op_ProviderInternalId) )
         THEN 'INVALID'
         ELSE 'VALID' END op_ProviderInternalId1X,

-- PIDSL

-- DI
    CASE
	    WHEN op_ProviderPidsl IS NOT NULL
        AND op_ProviderPidsl IN (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER ap 
--          WHERE ID_PROVIDER NOT IN ('#','+','-') 
            WHERE ID_PROVIDER = op_ProviderPidsl
            AND op_ProviderLocationCode = (
            case when length(ap.ID_PROVIDER_LOCATION) <3 then lpad(ap.ID_PROVIDER_LOCATION,3,'0')
                 when length(ap.ID_PROVIDER_LOCATION) >3 then substr(ap.ID_PROVIDER_LOCATION,0,3)
                 else ap.ID_PROVIDER_LOCATION 
             end)     
        )        
        THEN 1 ELSE 0 END op_ProviderPidsl1,

--  Ex
    CASE  
         WHEN (op_ProviderPidsl IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (
         (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_PROVIDER ap 
--          WHERE ID_PROVIDER NOT IN ('#','+','-') 
          WHERE ID_PROVIDER = op_ProviderPidsl
          AND op_ProviderLocationCode = (
            case when length(ap.ID_PROVIDER_LOCATION) <3 then lpad(ap.ID_PROVIDER_LOCATION,3,'0')
                 when length(ap.ID_PROVIDER_LOCATION) >3 then substr(ap.ID_PROVIDER_LOCATION,0,3)
                 else ap.ID_PROVIDER_LOCATION 
             end))))         
         THEN 'INVALID'
         ELSE 'VALID' END op_ProviderPidsl1X,
         
--  ALL RECORDS
    1 AS TOT_REX

FROM (

select * from (

select DISTINCT
CURRENT_DATE() AS RUN_DATE,
h."TransSetControlNum" as TransSetControlNum,
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

    CASE
        WHEN h."ClaimFrequencyCode" IN ('1','2','3','4','5') THEN 'O'
        WHEN h."ClaimFrequencyCode" IN ('7') THEN 'A'
        WHEN h."ClaimFrequencyCode" IN ('8') THEN 'V'
        ELSE 'X'
    END AS Record_Type,
    
h."AdmissionDateHourDTP" as AdmissionDateHourDTP,
substr(h."AdmissionDateHourDTP",1,8),'YYYYMMDD' as AdmissionDTP,
--to_date(substr(h."AdmissionDateHourDTP",1,8),'YYYYMMDD') as AdmissionDTP,

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
h."ContractTypeCode" as ContractTypeCode,

-- Providers
trim(h."ProviderInternalId") as ProviderInternalId,
upper(trim(h."ProviderPidsl")) as ProviderPidsl,

trim(bp."ProviderInternalId") as ProviderInternalId_bp,
upper(trim(bp."ProviderPidsl")) as ProviderPidsl_bp,

trim(atnd."AttendingProvNPI")     as at_AttendingProvNPI,
trim(atnd."ProviderInternalId")   as at_ProviderInternalId,
upper(trim(atnd."ProviderPidsl"))        as at_ProviderPidsl,
trim(atnd."ProviderLocationCode") as at_ProviderLocationCode,

trim(ref."ReferringProvNPI")      as ref_ReferringProvNPI,
trim(ref."ProviderInternalId")    as ref_ProviderInternalId,
upper(trim(ref."ProviderPidsl"))         as ref_ProviderPidsl,
trim(ref."ProviderLocationCode")  as ref_ProviderLocationCode,

trim(ren."RenderingProvNPI")      as ren_RenderingProvNPI,
trim(ren."ProviderInternalId")    as ren_ProviderInternalId,
upper(trim(ren."ProviderPidsl"))         as ren_ProviderPidsl,
trim(ren."ProviderLocationCode")  as ren_ProviderLocationCode,

trim(oop."OtherOperProvNPI")      as oop_OtherOperProvNPI,
trim(oop."ProviderInternalId")    as oop_ProviderInternalId,
upper(trim(oop."ProviderPidsl"))         as oop_ProviderPidsl,
trim(oop."ProviderLocationCode")  as oop_ProviderLocationCode,

trim(op."OperatingProvNPI")       as op_OperatingProvNPI,
trim(op."ProviderInternalId")     as op_ProviderInternalId,
upper(trim(op."ProviderPidsl"))          as op_ProviderPidsl,
trim(op."ProviderLocationCode")   as op_ProviderLocationCode

from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM as h

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_SERVICE_DTL as d
--on  h."TransSetControlNum" = d."TransSetControlNum"
on  h."FileName" = d."FileName"
and h."SubmitterID"        = d."SubmitterID"
and h."PatientControlNum"  = d."PatientControlNum"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_SVCLN_ADJUDICATION_DTL as a
on  h."FileName" = a."FileName"
-- and h."SubmitterID"        = a."SubmitterID"
and h."PatientControlNum"  = a."PatientControlNum"
and d."NumDtl"             = a."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL dia
on  h."FileName" = dia."FileName"
and h."PatientControlNum"  = dia."PatientControlNum"
and dia."DiagnosisCodeQual" = 'ABJ'

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_ENC_ATTRIBUTE_DTL ctvd
 on  h."FileName" = ctvd."FileName"
 and h."PatientControlNum"  = ctvd."PatientControlNum"
 and d."NumDtl"             = ctvd."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_BILLING_PROVIDER_DTL bp
on bp."TransSetControlNum"  = h."TransSetControlNum" and
   bp."SendProTransId"      = h."SendProTransId" and
   bp.RAW_SPRO_BPROV_SEQ    = h.RAW_SPRO_BPROV_SEQ

left join MHDWQA.SENDPRO.RAW_SPRO_837I_ATTENDING_PROVIDER_DTL atnd
on h."FileName"         = atnd."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = atnd.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= atnd."PatientControlNum" and
   h."NumDtl"           = atnd."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_REFERRING_PROVIDER_DTL ref
on h."FileName"         = ref."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = ref.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ref."PatientControlNum" and
   h."NumDtl"           = ref."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_RENDERING_PROVIDER_DTL ren
on h."FileName"         = ren."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = ren.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ren."PatientControlNum" and
   h."NumDtl"           = ren."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OTHER_OPERATING_PHYS_PROVIDER_DTL oop
on h."FileName"         = oop."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = oop.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= oop."PatientControlNum" and
   h."NumDtl"           = oop."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OPERATING_PHYS_PROVIDER_DTL op
on h."FileName"         = op."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = op.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= op."PatientControlNum" and
   h."NumDtl"           = op."NumDtl"

order by
    TransSetControlNum,
    h."SubmitterID",
    FileName,
    h."PatientControlNum",
    to_number(d."NumDtl",4,0)
)
)
;
