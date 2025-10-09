/* 
RULES

1	MPT_SENDPRO_DateIsNotNull_ALL	Date is not null then 1 else 0
2	MPT_SENDPRO_Diagnosis_Code_Valid_ALL	If valid based on lookup to the column CDE_DIAG from "NW_B_DIAGNOSIS" where CDE_ICD_VERSION=10 then 1 else 0
3	MPT_SENDPRO_StringIsNull_ALL	String is not null then 1 else 0
4	MPT_SENDPRO_AmountValue_ALL 	Amount is greater than 0 then 1 else 0
5	MPT_SENDPRO_DateIsNotBot_ALL	Date is not equal to 1/1/1900 then 1 else 0
6	MPT_SENDPRO_DateIsNotNull_ALL	Date is not null then 1 else 0
7	MPT_SENDPRO_DateLeDate_ALL	Date 1 is less than or equal to Date 2 then 1 else 0
8	MPT_SENDPRO_DateIsNull_ALL	Date is null then 1 else 0
9	MPT_SENDPRO_AmountValueNotNegative_ALL	Amount is greater than or equals 0 then 1 else 0
10	MPT_SENDPRO_BillingProviderType_Valid_ALL	First character String in (‘2) then 1 else 0 (Non-Person Entity)
11	MPT_SENDPRO_ProviderNPINull_ALL	(null)','0','000000000','0000000000')
12	MPT_SENDPRO_ProviderNPIValid_ ALL	Validity of  NPI determined by performing a look up to the following tables 
        1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ID_NPI
        If valid then 1 else 0
13	MPT_SENDPRO_ClaimCategory_837I	’005010X299A1’
14	MPT_SENDPRO_DischargeStatusCode_837I	Discharge Date Qualifier (DISCHARGE_DATE_QUALIFIER) =098
15	MPT_SENDPRO_ICD_Version_Qualifier_Valid	If Principal Diagnosis Version Qualifier = “ABK” then 1 else 0
16	MPT_SENDPRO_PatientPaymentAmt_Null_837I	Patient Responsibility Amount Qualifier Code = “F3”
17	MPT_SENDPRO_FirstChar_ALL	First Char has specific value like = ‘7’
18	MPT_SENDPRO_PatientPaymentAmt_Null_837I	Patient Responsibility Amount Qualifier Code = “F3”
19	MPT_SENDPRO_PatientDischargeStatusCodeValid_837I	If valid based on lookup to the column CDE_CHAR from "NW_SUP_CODE_REF" where CDE_GROUP=’CDE_PATIENT_STATUS’, then 1 else 0
21	MPT_SENDPRO_Facility_Type_Code_837I	If valid based on the lookup against the first 2 characters of CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP='CDE_TYPE_OF_BILL' for Type of Bill Code, then 1 else 0
22	MPT_SENDPRO_TypeofBill_INP2	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP='CDE_BILL_FREQ' for Billing Frequency
23	MPT_SENDPRO_ContractTypeCode_Valid	Should contain one of these values "01, 02, 03, 04, 05, 06, 09"
24	MPT_SENDPRO_ServiceLineRevenueCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP='CDE_REVENUE'  then 1 else 0
25	MPT_ClaimType_837I_INP	Claims have claim type=’I’ then 1 else 0
26	MPT_ClaimType_837I_LTC	Claims have claim type in ‘L’ then 1 else 0
27	MPT_ClaimType_837I_OUTP	Claims have claim type=’O’ then 1 else 0
28	MPT_ClaimType_837P	Claims have claim type=’M’ then 1 else 0
29	MPT_ClaimType_NCPDP	Claims have claim type=’P’ then 1 else 0
30	MPT_ClaimType_837D	Claims have claim type=’D’ then 1 else 0
31	MPT_SENDPRO_PrescribingProviderIDValid	If valid based on the lookup against the table NW_ENC_PROVIDER ON field ENC_PROV_ID
32	MPT_SENDPRO_PrescribingProviderIDTypeValid	Should contain ‘01’
33	MPT_SENDPRO_PrescriptionRefillIndicatorValid	Should contain 0-99
34	MPT_SENDPRO_NumberIsNull_ALL	Number is not null then 1 else 0
35	MPT_SENDPRO_Adj_Reason_Code_Valid_ALL	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP= ‘CDE_ADJ_RSN ' for Adjustment Reason Code, then 1 else 0
36	MPT_SENDPRO_Statement_Period_Valid	If String is of format “CCYYMMDD-CCYYMMDD” then 1 else 0
37	MPT_SENDPRO_AmountValue_Zero 	Number should be 0
38	MPT_SENDPRO_TypeOfAdmission_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP= ‘CDE_ADMIT_TYPE' for Type Of Admission
39	MPT_SENDPRO_Claim_Freq_Type_Code_Valid	Should contain one of these values "1”,”2”,”3”,”4”,”5”,”7”,”8”. If valid then 1 else 0
40	MPT_SENDPRO_ServiceLineRevenueCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP='CDE_REVENUE'  then 1 else 0
41	MPT_SENDPRO_OccurrenceCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’ CDE_OCCURRENCE’ then 1 else 0
42	MPT_SENDPRO_OccurrenceSpanCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’ CDE_OCCURRENCE_SPAN’ then 1 else 0
43	MPT_SENDPRO_ValueCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’ CDE_VALUE then 1 else 0
44	MPT_SENDPRO_ConditionCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’ CDE_COND then 1 else 0
45	MPT_SENDPRO_PatientStatusCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’ CDE_PATIENT_STATUS’ then 1 else 0
46	MPT_SENDPRO_Procedure_Code_Valid_ALL	If valid based on lookup to the column CDE_PROC from "NW_B_PROCEDURE" then 1 else 0
47	MPT_SENDPRO_CDT_Code_Valid_ALL	If valid based on lookup to the column CDE_PROC from "NW_B_PROCEDURE" where CDE_PROC like 'D%' and upper(proc_group) like 'ALPHA%' then 1 else 0
48	MPT_SENDPRO_CPT_Code_Valid_ALL	If valid based on lookup to the column CDE_PROC from "NW_B_PROCEDURE" where upper(proc_group) like CPT%' then 1 else 0
49	MPT_SENDPRO_HIPPS_Code_Valid_ALL	If valid based on lookup to the column CDE_PROC from "NW_B_PROCEDURE" where upper(proc_group) like HIPPS%' then 1 else 0
50	MPT_SENDPRO_NDC_Valid_ALL	If valid based on lookup to the column CDE_NDC from "NW_B_DRUG" then 1 else 0
51	MPT_SENDPRO_PROC_MOD_Valid_All	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’ CDE_PROC_MOD’ then 1 else 0
52	MPT_SENDPRO_CARDHOLDERID_Valid	If valid based on the lookup against the ID_MEDICAID from NW.NW_MEMBER then 1 else 0
53	MPT_SENDPRO_ClaimCategory_ALL	SUBSTR(DSC_ENC_CLAIM_CAT,1,1) IN ('1','2','3','4','5','6','7')
54	MPT_SENDPRO_Validate_Adjudication_Date	NCPDP:
    Step 1: Lookup SENDPRO.RAW_SPRO_NCPDP_CLAIM OrigClm based on SENDPRO.RAW_SPRO_NCPDP_CLAIM newClaim. TransIDCrossRef = OrigClm. TransID and Obtain AdjudicationDate
    Step 2: If newClaim.AdjudicationDate > OrigClm. AdjudicationDate Then 1 else 0 end
55	MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
    1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
    If valid then 1 else 0
56	MPT_SENDPRO_ProviderPIDSL_Valid	Validity of  PIDSL is determined by performing a look up to the following tables 
    1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ID_PROVIDER
    If valid then 1 else 0
57	MPT_SENDPRO_AmountValueNotNegative 	Amount i>=l 0 then 1 else 0
58	MPT_SENDPRO_ValidMember	
    1.	Join MEM_SEQ from Fact with NW.NW_MEMBER on MEM_SEQ
    2.	If ID_MEDICAID IS NOT  NULL Then 1 else 0
DUPLICATE 59	MPT_SENDPRO_ValidMember	
    1.	Join MEM_SEQ from Fact with NW.NW_MEMBER on MEM_SEQ
    2.	If ID_MEDICAID IS NOT  NULL Then 1 else 0
59	MPT_SENDPRO_ValidEncClmProvider	
    1.	Join ENC_CLM_PRV_SEQ from Fact with sendpro.spro_b_enc_claim_provider on enc_clm_prv_seq
    2.	NPI: If PROV_NPI  IS NOT  NULL Then 1 else 0
    3.	Internal Provider ID: IF ENC_PROV_ID IS NOT NULL THEN 1 ELSE 0
    4.	Provider Type: IF CDE_ENC_CLM_PROV_TYPE IS NOT NULL THEN 1 ELSE 0 
    5.	Provider Location: If ID_PROVIDER_LOCATION IS NOT NULL THEN 1 ELSE 0
    6.	Provider Taxonomy: If CDE_PROV_TAXONOMY IS NOT NULL THEN 1 ELSE 0

60	MPT_SENDPRO_ValidEncClmProvider	1.	Join ENC_CLM_PRV_SEQ from Fact with sendpro.spro_b_enc_claim_provider on enc_clm_prv_seq
2.	NPI: If PROV_NPI  IS NOT  NULL Then 1 else 0
3.	Internal Provider ID: IF ENC_PROV_ID IS NOT NULL THEN 1 ELSE 0
4.	Provider Type: IF CDE_ENC_CLM_PROV_TYPE IS NOT NULL THEN 1 ELSE 0 
5.	Provider Location: If ID_PROVIDER_LOCATION IS NOT NULL THEN 1 ELSE 0
6.	Provider Taxonomy: If CDE_PROV_TAXONOMY IS NOT NULL THEN 1 ELSE 0


61	MPT_SENDPRO_ValidEncProvider	
    1.	Join ENC_PRV_SEQ from Fact with sendpro. SPRO_B_ENC_PROVIDER_HIST on.enc_prv_seq left join spro_b_enc_taxonomy_hist on SPRO_B_ENC_PROVIDER_HIST.enc_prv_seq= spro_b_enc_taxonomy_hist.enc_prv_seq
    2.	NPI: If ID_NPI  IS NOT  NULL Then 1 else 0
    3.	Internal Provider ID: IF ENC_PROV_ID IS NOT NULL THEN 1 ELSE 0
    4.	Provider Type: IF CDE_ENC_PROV_TYPE IS NOT NULL THEN 1 ELSE 0 
    5.	Provider Location: If COALESCE(ID_PROVIDER_LOCATION,’+’)<>’+’ THEN 1 ELSE 0
    6.	Provider Taxonomy: If CDE_ENC_TAXONOMY IS NOT NULL THEN 1 ELSE 0

62	MPT_SENDPRO_ValidEncDiagnosisCode	
    1.	Join DIAG_GRP_SEQ from Fact with NW. NW_B_DIAGNOSIS_GROUP ON  NW_B_DIAGNOSIS_GROUP .DIAG_GRP_SEQ 
    2.	Admission Diagnosis Code: If CDE_DIAG_ADMIT  IS NOT  NULL Then 1 else 0
    3.	Primary Diagnosis Code: IF CDE_DIAG_1 IS NOT NULL THEN 1 ELSE 0
63	MPT_SENDPRO_ValidEncDProcedureCode	
    1.	Join PROC_SEQ from Fact with NW. NW_B_PROCEDURE ON  NW_B_PROCEDURE .PROC_SEQ
    2.	Procedure Code: If COALESCE(CDE_PROC,’ ‘)  <> ‘ ‘ Then 1 else 0
64	MPT_SENDPRO_ValidEncDProcedureModifierCode	
    1.	Join PROCMFR_SEQ from Fact with NW. NW_B_PROCEDURE_MFR ON  NW_B_PROCEDURE_MFR .PROCMFR_SEQ
    2.	Procedure Modifier Code: If COALESCE(CDE_PROC_MOD,’ ‘)  <> ‘ ‘ Then 1 else 0
65	MPT_SENDPRO_ValidPlaceOfService	If valid based on the lookup against the CDE_CHAR from NW.NW_SUP_CODE_REF where CDE_GROUP=’ CDE_PLACE_OF_SERVICE’ then 1 else 0

66	MPT_SENDPRO_ValidRecordStatus	If valid based on the lookup against the CDE_CHAR from NW.NW_SUP_CODE_REF where CDE_GROUP=’ CDE_REC_STATUS’ then 1 else 0
67	MPT_SENDPRO_ValidPrescriptionOriginCode	If valid based on the lookup against the CDE_CHAR from NW.NW_SUP_CODE_REF where CDE_GROUP=’ CDE_PRESC_ORIG then 1 else 0

*/

-- DROP TABLE MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837I;

-- CREATE TABLE MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837I AS

-- TRUNCATE TABLE MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837I;

INSERT INTO MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837I
SELECT DISTINCT
    RUN_DATE,
    NUM_ICN,
    NUM_DTL,
    CDE_ENTITY_MODEL,
    CDE_ENC_MCO,
    CDE_ENC_ACO,
    ID_SUBMITTER,
    DOS_FROM_DT,
    CDE_CLM_TYPE AS CLAIM_TYPE,
--    CDE_BILL_TYPE,
    CDE_CLM_STATUS,
--    CDE_FACILITY_TYPE,
    CDE_CLM_DISPOSITION,
    IND_OFFSET,
    WH_FROM_DT,
    MD_BATCH_SEQ,

/*
12.1.1	Claim Frequency Type Code (MPT_SENDPRO_ClaimFrequencyTypeCode_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D
•	Valid Frequency Code: MPT_SENDPRO_Claim_Freq_Type_Code_Valid, SPRO_B_ENC_CLAIM_PROF_LEG_HIST. CDE_BILL_FREQ, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.CDE_BILL_FREQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_BILL_FREQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_BILL_FREQ
•	MPT_SENDPRO_NumberIsNull_ALL

MPT_SENDPRO_Claim_Freq_Type_Code_Valid	Should contain one of these values "1”,”2”,”3”,”4”,”5”,”7”,”8”. If valid then 1 else 0

MPT_SENDPRO_NumberIsNull_ALL	Number is not null then 1 else 0
*/

CASE WHEN CDE_BILL_FREQ IS NULL THEN 'NULL'
    WHEN CDE_BILL_FREQ NOT IN ('1','2','3','4','5','7','8') THEN 'INVALID' 
    ELSE 'VALID' 
END AS ClaimFrequencyTypeCode1X,

/*
12.1.2	Claim Contract Type Code (MPT_SENDPRO_ClaimContractTypeCode_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_CLAIM_PROF_LEG_HIST.CDE_CONTRACT_TYPE, SPRO_B_ENC_PROF_INFO_DTL_HIST, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.CDE_CONTRACT_TYPE, SPRO_B_ENC_DNTL_INFO_DTL_HIST.CDE_CONTRACT_TYPE, SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_CONTRACT_TYPE

23	MPT_SENDPRO_ContractTypeCode_Valid	Should contain one of these values "01, 02, 03, 04, 05, 06, 09"
*/

CASE 
    WHEN CDE_CONTRACT_TYPE IS NULL THEN 'NULL'
    WHEN CDE_CONTRACT_TYPE NOT IN ('01','02','03','04','05','06','09') THEN 'INVALID'
    ELSE 'VALID'
END AS ClaimContractTypeCode1X,

/*
12.1.3	Claim Allowable Amount (MPT_SENDPRO_ClaimAllowableAmt_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_ALLOWED
•	MPT_SENDPRO_AmountValue_ALLL: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_ALLOWED AND 

4	MPT_SENDPRO_AmountValue_ALL 	Amount is greater than 0 then 1 else 0
*/

CASE WHEN CDE_CLM_TYPE NOT IN ('L','I','O','M') THEN 'NOT APP'
    WHEN AMT_ALLOWED IS NULL AND DTL_AMT_ALLOWED IS NULL THEN 'NULL'
    WHEN AMT_ALLOWED <= 0 OR DTL_AMT_ALLOWED <= 0 THEN 'INVALID'
    ELSE 'VALID'
END AS ClaimAllowableAmount1X,

/*
12.1.4	Claim Paid Amount (MPT_SENDPRO_ClaimAllPaidAmt_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_PAID, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_PAID, SPRO_B_ENC_DNTL_INFO_DTL_HIST.AMT_PAID, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_PAID, SPRO_B_ENC_PHRM_OTHER_PAYMENTS.AMT_PAID, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_PAID, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_PAID
•	MPT_SENDPRO_AmountValueNotNegative: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_ALLOWED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_ALLOWED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_ALLOWED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_ALLOWED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_ALLOWED AND CDE_CLM_STATUS=’P’
*/

CASE
    WHEN AMT_PAID IS NULL AND DTL_AMT_PAID IS NULL THEN 'NULL'
    WHEN AMT_PAID < 0 OR DTL_AMT_PAID < 0 THEN 'INVALID'
    ELSE 'VALID'
END AS ClaimPaidAmount1X,

/*
12.1.5	Claim Billed Amount (MPT_SENDPRO_ClaimAllBilledAmt_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_BILLED, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_PAID, SPRO_B_ENC_DNTL_INFO_DTL_HIST.AMT_ BILLED, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_PAID, SPRO_B_ENC_PHRM_OTHER_PAYMENTS.AMT_ BILLED, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_PAID, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_ BILLED
•	MPT_SENDPRO_AmountValueNotNegative: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_ BILLED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_ BILLED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_ BILLED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_ BILLED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_ BILLED AND CDE_CLM_STATUS=’P’
*/

CASE
    WHEN AMT_BILLED IS NULL AND DTL_AMT_BILLED IS NULL THEN 'NULL'
    WHEN AMT_BILLED < 0 OR DTL_AMT_BILLED < 0 THEN 'INVALID'
    ELSE 'VALID'
END AS ClaimBilledAmount1X,

/*
12.1.6	Billing Provider Id (MPT_SENDPRO_BillingProviderID_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidClmEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENCClm_CLM_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ: 

55 MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
    1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
    If valid then 1 else 0

59	MPT_SENDPRO_ValidEncClmProvider	
    1.	Join ENC_CLM_PRV_SEQ from Fact with sendpro.spro_b_enc_claim_provider on enc_clm_prv_seq
    2.	NPI: If PROV_NPI  IS NOT  NULL Then 1 else 0
    3.	Internal Provider ID: IF ENC_PROV_ID IS NOT NULL THEN 1 ELSE 0
    4.	Provider Type: IF CDE_ENC_CLM_PROV_TYPE IS NOT NULL THEN 1 ELSE 0 
    5.	Provider Location: If ID_PROVIDER_LOCATION IS NOT NULL THEN 1 ELSE 0
    6.	Provider Taxonomy: If CDE_PROV_TAXONOMY IS NOT NULL THEN 1 ELSE 0

60	MPT_SENDPRO_ValidEncProvider	
    1.	Join ENC_PRV_SEQ from Fact with sendpro. SPRO_B_ENC_PROVIDER_HIST on.enc_prv_seq left join spro_b_enc_taxonomy_hist on SPRO_B_ENC_PROVIDER_HIST.enc_prv_seq= spro_b_enc_taxonomy_hist.enc_prv_seq
    2.	NPI: If ID_NPI  IS NOT  NULL Then 1 else 0
    3.	Internal Provider ID: IF ENC_PROV_ID IS NOT NULL THEN 1 ELSE 0
    4.	Provider Type: IF CDE_ENC_PROV_TYPE IS NOT NULL THEN 1 ELSE 0 
    5.	Provider Location: If COALESCE(ID_PROVIDER_LOCATION,’+’)<>’+’ THEN 1 ELSE 0
    6.	Provider Taxonomy: If CDE_ENC_TAXONOMY IS NOT NULL THEN 1 ELSE 0

*/

    CASE  
         WHEN (billing_ProviderInternalId IS NULL) AND (dtl_billing_ProviderInternalId IS NULL) THEN 'NULL'
		 WHEN ( 
               (NOT EXISTS (SELECT ENC_PROV_ID from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = billing_ProviderInternalId) )
           AND (NOT EXISTS (SELECT ENC_PROV_ID from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = dtl_billing_ProviderInternalId) )
         )
         THEN 'INVALID'
         ELSE 'VALID' 
    END AS BillingProviderInternalId1X,

/*
12.1.7	Billing Provider NPI (MPT_SENDPRO_BillingProviderNPI_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidClmEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ: 

11	MPT_SENDPRO_ProviderNPINull_ALL	(null)','0','000000000','0000000000')
12	MPT_SENDPRO_ProviderNPIValid_ ALL	Validity of  NPI determined by performing a look up to the following tables 
        1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ID_NPI
        If valid then 1 else 0
*/

    CASE  
         WHEN 
         (
               ((billing_ProviderNPI IS NULL) OR billing_ProviderNPI IN ('0','000000000','0000000000') ) 
           AND ((dtl_billing_ProviderNPI IS NULL) OR dtl_billing_ProviderNPI IN ('0','000000000','0000000000') )
         )            
            THEN 'NULL'
		 WHEN 
         (
              (NOT EXISTS (SELECT ID_NPI from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ID_NPI NOT IN ('#','+','-') AND ID_NPI = billing_ProviderNPI))
          AND (NOT EXISTS (SELECT ID_NPI from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ID_NPI NOT IN ('#','+','-') AND ID_NPI = dtl_billing_ProviderNPI)) 
         )
         THEN 'INVALID'
         ELSE 'VALID' 
    END AS BillingProviderNPI1X,

/*
12.1.8	Billing Provider Taxonomy Code (MPT_SENDPRO_BillingProviderTaxonomyALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidClmEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST.BILLING_ENC_PRV_SEQ, 
SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, 
SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ: 

BILLING_ENC_PRV_SEQ

60	MPT_SENDPRO_ValidEncProvider	
    1.	Join ENC_PRV_SEQ from Fact with sendpro. SPRO_B_ENC_PROVIDER_HIST on.enc_prv_seq left join spro_b_enc_taxonomy_hist 
    on SPRO_B_ENC_PROVIDER_HIST.enc_prv_seq= spro_b_enc_taxonomy_hist.enc_prv_seq
    2.	NPI: If ID_NPI  IS NOT  NULL Then 1 else 0
    3.	Internal Provider ID: IF ENC_PROV_ID IS NOT NULL THEN 1 ELSE 0
    4.	Provider Type: IF CDE_ENC_PROV_TYPE IS NOT NULL THEN 1 ELSE 0 
    5.	Provider Location: If COALESCE(ID_PROVIDER_LOCATION,’+’)<>’+’ THEN 1 ELSE 0
    6.	Provider Taxonomy: If CDE_ENC_TAXONOMY IS NOT NULL THEN 1 ELSE 0

SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, 

*/

    CASE 
		 WHEN 
         (
             (NOT EXISTS (SELECT tax.CDE_ENC_TAXONOMY from mhdwqa.SENDPRO.spro_b_enc_provider_hist as prv
         LEFT JOIN mhdwqa.SENDPRO.spro_b_enc_provider_taxonomy_hist tax ON prv.ENC_PRV_SEQ = tax.ENC_PRV_SEQ
         where BILLING_ENC_PRV_SEQ = prv.ENC_PRV_SEQ AND tax.CDE_ENC_TAXONOMY IS NOT NULL AND tax.CDE_ENC_TAXONOMY NOT IN ('#','+','-')))

         AND (NOT EXISTS (SELECT tax.CDE_ENC_TAXONOMY from mhdwqa.SENDPRO.spro_b_enc_provider_hist as prv
         LEFT JOIN mhdwqa.SENDPRO.spro_b_enc_provider_taxonomy_hist tax ON prv.ENC_PRV_SEQ = tax.ENC_PRV_SEQ
         where DTL_BILLING_ENC_PRV_SEQ = prv.ENC_PRV_SEQ AND tax.CDE_ENC_TAXONOMY IS NOT NULL AND tax.CDE_ENC_TAXONOMY NOT IN ('#','+','-')))
         )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS BillingProviderTaxonomy1X,

/*
12.1.9	Servicing Provider Id (MPT_SENDPRO_ServicingProviderID_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ: 
*/

    CASE  
         WHEN (servicing_ProviderInternalId IS NULL) AND (dtl_servicing_ProviderInternalId IS NULL)THEN 'NULL'
		 WHEN 
         (
              (NOT EXISTS (SELECT ENC_PROV_ID from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = servicing_ProviderInternalId)) 
          AND (NOT EXISTS (SELECT ENC_PROV_ID from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = dtl_servicing_ProviderInternalId))
         )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS ServicingProviderInternalId1X,

/*
12.1.10	Servicing Provider NPI (MPT_SENDPRO_ServicingProviderNPI_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. SERVICING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. SERVICING_ENC_PRV_SEQ, 
SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. SERVICING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. SERVICING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. SERVICING_ENC_PRV_SEQ: 
*/

    CASE  
         WHEN 
         (
                ((servicing_ProviderNPI IS NULL) OR servicing_ProviderNPI IN ('0','000000000','0000000000')) 
            AND ((dtl_servicing_ProviderNPI IS NULL) OR dtl_servicing_ProviderNPI IN ('0','000000000','0000000000'))
         )            
         THEN 'NULL'
            
         WHEN 
         (
              (NOT EXISTS (SELECT ID_NPI from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ID_NPI NOT IN ('#','+','-') AND ID_NPI = servicing_ProviderNPI)) 
          AND (NOT EXISTS (SELECT ID_NPI from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ID_NPI NOT IN ('#','+','-') AND ID_NPI = dtl_servicing_ProviderNPI))
         )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS ServicingProviderNPI1X,

/*
12.1.11	Servicing Provider Type (MPT_SENDPRO_ServicingProviderType_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.SERVICING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST.SERVICING_ENC_PRV_SEQ, 
SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.SERVICING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST.SERVICING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST.SERVICING_ENC_PRV_SEQ: 

60	MPT_SENDPRO_ValidEncProvider	
    1.	Join ENC_PRV_SEQ from Fact with sendpro. SPRO_B_ENC_PROVIDER_HIST on.enc_prv_seq left join spro_b_enc_taxonomy_hist 
    on SPRO_B_ENC_PROVIDER_HIST.enc_prv_seq= spro_b_enc_taxonomy_hist.enc_prv_seq
    2.	NPI: If ID_NPI  IS NOT  NULL Then 1 else 0
    3.	Internal Provider ID: IF ENC_PROV_ID IS NOT NULL THEN 1 ELSE 0
    4.	Provider Type: IF CDE_ENC_PROV_TYPE IS NOT NULL THEN 1 ELSE 0 
    5.	Provider Location: If COALESCE(ID_PROVIDER_LOCATION,’+’)<>’+’ THEN 1 ELSE 0
    6.	Provider Taxonomy: If CDE_ENC_TAXONOMY IS NOT NULL THEN 1 ELSE 0

*/

    CASE 
		 WHEN 
         (
              (NOT EXISTS (SELECT prv.CDE_ENC_PROV_TYPE from mhdwqa.SENDPRO.spro_b_enc_provider_hist as prv
         where SERVICING_ENC_PRV_SEQ = prv.ENC_PRV_SEQ AND prv.CDE_ENC_PROV_TYPE IS NOT NULL AND prv.CDE_ENC_PROV_TYPE NOT IN ('#','+','-')))
          AND (NOT EXISTS (SELECT prv.CDE_ENC_PROV_TYPE from mhdwqa.SENDPRO.spro_b_enc_provider_hist as prv
            where DTL_SERVICING_ENC_PRV_SEQ = prv.ENC_PRV_SEQ AND prv.CDE_ENC_PROV_TYPE IS NOT NULL AND prv.CDE_ENC_PROV_TYPE NOT IN ('#','+','-')))
         )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS ServicingProviderType1X,

/*
12.1.12	Servicing Provider Location (MPT_SENDPRO_ServicingProviderLoc_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ: 
*/
    CASE 
         WHEN 
         (
            (NOT EXISTS (SELECT prv.ID_PROVIDER_LOCATION from mhdwqa.SENDPRO.spro_b_enc_provider_hist as prv
        where SERVICING_ENC_PRV_SEQ = prv.ENC_PRV_SEQ AND prv.ID_PROVIDER_LOCATION IS NOT NULL AND prv.ID_PROVIDER_LOCATION NOT IN ('#','+','-')))
        AND (NOT EXISTS (SELECT prv.ID_PROVIDER_LOCATION from mhdwqa.SENDPRO.spro_b_enc_provider_hist as prv
        where DTL_SERVICING_ENC_PRV_SEQ = prv.ENC_PRV_SEQ AND prv.ID_PROVIDER_LOCATION IS NOT NULL AND prv.ID_PROVIDER_LOCATION NOT IN ('#','+','-')))
            )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS ServicingProviderLocation1X,

/*
12.1.13	Servicing Provider Taxonomy Code (MPT_SENDPRO_ServicingProviderTaxonomyCode_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.SERVICING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST.SERVICING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.SERVICING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST.SERVICING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST.SERVICING_ENC_PRV_SEQ: 
*/

    CASE 
		 WHEN 
         (
             (NOT EXISTS (SELECT tax.CDE_ENC_TAXONOMY from mhdwqa.SENDPRO.spro_b_enc_provider_hist as prv
         LEFT JOIN mhdwqa.SENDPRO.spro_b_enc_provider_taxonomy_hist tax ON prv.ENC_PRV_SEQ = tax.ENC_PRV_SEQ
         where SERVICING_ENC_PRV_SEQ = prv.ENC_PRV_SEQ AND tax.CDE_ENC_TAXONOMY IS NOT NULL AND tax.CDE_ENC_TAXONOMY NOT IN ('#','+','-')))
  
         AND (NOT EXISTS (SELECT tax.CDE_ENC_TAXONOMY from mhdwqa.SENDPRO.spro_b_enc_provider_hist as prv
         LEFT JOIN mhdwqa.SENDPRO.spro_b_enc_provider_taxonomy_hist tax ON prv.ENC_PRV_SEQ = tax.ENC_PRV_SEQ
         where DTL_SERVICING_ENC_PRV_SEQ = prv.ENC_PRV_SEQ AND tax.CDE_ENC_TAXONOMY IS NOT NULL AND tax.CDE_ENC_TAXONOMY NOT IN ('#','+','-')))
         )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS ServicingProviderTaxonomy1X,

/*
12.1.14	From Service Date (MPT_SENDPRO_From_Service_Date_ALL)
•	837P Claims population: MPT_SENDPRO_ClaiimType_ALL 
•	MPT_SENDPRO_DateIsNotBot_ALL: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_DNTL_INFO_DTL_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_INST_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_INST_INFO_DTL_HIST.DOS_FROM_DT
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_DNTL_INFO_DTL_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_INST_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_INST_INFO_DTL_HIST.DOS_FROM_DT

5	MPT_SENDPRO_DateIsNotBot_ALL	Date is not equal to 1/1/1900 then 1 else 0
1	MPT_SENDPRO_DateIsNotNull_ALL	Date is not null then 1 else 0
*/

    CASE 
        WHEN DOS_FROM_DT IS NULL AND DTL_DOS_FROM_DT IS NULL THEN 'NULL'
        WHEN DOS_FROM_DT = '1900-01-01' AND DTL_DOS_FROM_DT = '1900-01-01' THEN 'INVALID'
        ELSE 'VALID'
    END AS FromServiceDate1X,

/*
12.1.15	To Service Date (MPT_SENDPRO_To_Service_Date_ALL)
•	837P Claims population: MPT_SENDPRO_ClaiimType_ALL 
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.DOS_TO_DT, SPRO_B_ENC_DNTL_INFO_DTL_HIST.DOS_ TO _DT, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.DOS_ TO _DT, SPRO_B_ENC_CLAIM_INST_LEG_HIST.DOS_ TO _DT, SPRO_B_ENC_INST_INFO_DTL_HIST.DOS_ TO _DT
*/

    CASE 
        WHEN DOS_TO_DT IS NULL AND DTL_DOS_TO_DT IS NULL THEN 'NULL'
        WHEN DOS_TO_DT = '1900-01-01' AND DTL_DOS_TO_DT = '1900-01-01' THEN 'INVALID'
        ELSE 'VALID'
    END AS ToServiceDate1X,

/*
12.1.16	Admission Date (MPT_SENDPRO_Admission_Date_837I)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP
•	MPT_SENDPRO_DateIsNotBot_ALL: SPRO_B_ENC_CLAIM_INST_LEG_HIST.ADMIT_DT_TM
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL SPRO_B_ENC_CLAIM_INST_LEG_HIST.ADMIT_DT_TM
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. ADMIT_DT_TM
*/

    CASE WHEN CDE_CLM_TYPE NOT IN ('L','I','O','M') THEN 'NOT APP'
        WHEN ADMIT_DT_TM IS NULL THEN 'NULL'
        WHEN ADMIT_DT_TM = '1900-01-01' THEN 'INVALID'
        ELSE 'VALID'
    END AS AdmissionDate1X, 


/*
12.1.17	Member ID (MPT_SENDPRO_MemberID_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ProviderInternalId_Valid: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.MEM_SEQ>0, SPRO_B_ENC_DNTL_INFO_DTL_HIST. MEM SEQ>0, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.MEM_SEQ>0, SPRO_B_ENC_INST_INFO_DTL_HIST.MEM_SEQ>0

58	MPT_SENDPRO_ValidMember	
    1.	Join MEM_SEQ from Fact with NW.NW_MEMBER on MEM_SEQ
    2.	If ID_MEDICAID IS NOT  NULL Then 1 else 0

*/

    CASE 
        WHEN FACT_MEM_SEQ IS NULL AND DTL_FACT_MEM_SEQ IS NULL THEN 'NULL'
        WHEN FACT_MEM_SEQ <= 0 AND DTL_FACT_MEM_SEQ <= 0 THEN 'INVALID'
		WHEN  (
              ( NOT EXISTS (SELECT ID_MEDICAID from MHDWQA.NW.NW_MEMBER mem WHERE FACT_MEM_SEQ = mem.MEM_SEQ AND ID_MEDICAID NOT IN ('#','+','-',' ')) )
          AND ( NOT EXISTS (SELECT ID_MEDICAID from MHDWQA.NW.NW_MEMBER mem WHERE DTL_FACT_MEM_SEQ = mem.MEM_SEQ AND ID_MEDICAID NOT IN ('#','+','-',' '))) 
             )
        THEN 'INVALID'
        ELSE 'VALID'
    END AS MemberID1X,

/*
12.1.18	Quantity (MPT_SENDPRO_ClaimAllowableAmt_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_CLAIM_PROF_LEG_HIST,QTY_UNITS_BILLED,  SPRO_B_ENC_PROF_INFO_DTL_HIST.QTY_UNITS_BILLED, SPRO_B_ENC_CLAIM_INST_LEG_HIST,QTY_UNITS_BILLED,  SPRO_B_ENC_ INST_INFO_DTL_HIST.QTY_UNITS_BILLED, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST,QTY_UNITS_BILLED,  SPRO_B_ENC_DNTL_INFO_DTL_HIST.QTY_UNITS_BILLED, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST, QTY_DISPD,  SPRO_B_ENC_PROF_INFO_DTL_HIST. QTY_PRESCRIBED
*/

    CASE 
        WHEN QTY_UNITS_BILLED IS NULL AND DTL_QTY_UNITS_BILLED IS NULL THEN 'NULL'
        WHEN QTY_UNITS_BILLED <= 0 OR DTL_QTY_UNITS_BILLED <= 0 THEN 'INVALID'
        ELSE 'VALID'
    END AS QuantityBilled1X,

/*
12.1.19	Admitting Diagnosis (MPT_SENDPRO_Admitting_Diagnosis_837I)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_INP
•	SENDPRO_ValidEncDiagnosisCode SPRO_B_ENC_CLAIM_INST_LEG_HIST.DIAG_GRP_SEQ, Admission Diagnosis Code

61	MPT_SENDPRO_ValidEncDiagnosisCode	
    1.	Join DIAG_GRP_SEQ from Fact with NW.NW_B_DIAGNOSIS_GROUP ON  NW_B_DIAGNOSIS_GROUP.DIAG_GRP_SEQ 
    2.	Admission Diagnosis Code: If CDE_DIAG_ADMIT  IS NOT  NULL Then 1 else 0
    3.	Primary Diagnosis Code: IF CDE_DIAG_1 IS NOT NULL THEN 1 ELSE 0

*/

    CASE WHEN CDE_CLM_TYPE NOT IN ('L','I','O') THEN 'NOT APP'
         WHEN DIAGRP_SEQ IS NULL THEN 'NULL'
         WHEN NOT EXISTS (SELECT CDE_DIAG_ADMIT from MHDWQA.NW.NW_B_DIAGNOSIS_GROUP grp WHERE CDE_DIAG_ADMIT IS NOT NULL AND DIAGRP_SEQ = grp.DIAGRP_SEQ)
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS AdmittingDiagnosisCode1X,

/*
12.1.20	Primary Diagnosis (MPT_SENDPRO_Primary_Diagnosis_837)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837I_LTC. MPT_SENDPRO_ClaiimType_837P
•	SENDPRO_ValidEncDiagnosisCode SPRO_B_ENC_CLAIM_INST_LEG_HIST.DIAG_GRP_SEQ, SPRO_B_ENC_CLAIM_PROF_LEG_HIST.DIAG_GRP_SEQ, Primary Diagnosis Code

61	MPT_SENDPRO_ValidEncDiagnosisCode	
    1.	Join DIAG_GRP_SEQ from Fact with NW. NW_B_DIAGNOSIS_GROUP ON  NW_B_DIAGNOSIS_GROUP .DIAG_GRP_SEQ 
    2.	Admission Diagnosis Code: If CDE_DIAG_ADMIT  IS NOT  NULL Then 1 else 0
    3.	Primary Diagnosis Code: IF CDE_DIAG_1 IS NOT NULL THEN 1 ELSE 0

*/

    CASE --WHEN CDE_CLM_TYPE NOT IN ('I') THEN 'NOT APP'
         WHEN DIAGRP_SEQ IS NULL THEN 'NULL'
         WHEN NOT EXISTS (SELECT CDE_DIAG_1 from MHDWQA.NW.NW_B_DIAGNOSIS_GROUP grp WHERE CDE_DIAG_1 IS NOT NULL AND DIAGRP_SEQ = grp.DIAGRP_SEQ)
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS PrimaryDiagnosisCode1X,

/*
12.1.21	Discharge Date (MPT_SENDPRO_Discharge_Date_837I)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_INP
•	MPT_SENDPRO_DateIsNotBot_ALL: SPRO_B_ENC_CLAIM_INST_LEG_HIST. DISCHARGE_DT_TM, SPRO_B_ENC_INST_INFO_DTL_HIST. DISCHARGE_DT
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL SPRO_B_ENC_CLAIM_INST_LEG_HIST. DISCHARGE_DT_TM, SPRO_B_ENC_INST_INFO_DTL_HIST. DISCHARGE_DT
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL: SPRO_B_ENC_CLAIM_INST_LEG_HIST. DISCHARGE_DT_TM, SPRO_B_ENC_INST_INFO_DTL_HIST. DISCHARGE_DT
*/
    CASE WHEN CDE_CLM_TYPE NOT IN ('L','I','O','M') THEN 'NOT APP'
        WHEN DISCHARGE_DT_TM IS NULL AND DTL_DISCHARGE_DT IS NULL THEN 'NULL'
        WHEN DISCHARGE_DT_TM = '1900-01-01' AND DTL_DISCHARGE_DT = '1900-01-01' THEN 'INVALID'
        ELSE 'VALID'
    END AS DischargeDate1X,
/*
12.1.22	Type of Admission (MPT_TypeofAdmission_837I)
•	837I Claims population: MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP
•	MPT_SENDPRO_TypeOfAdmission_Valid: SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_ADMIT_TYPE
•	Missing String Value Parameter: MP_SENDPRO_StringIsNull_ALL, SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_ADMIT_TYPE

38	MPT_SENDPRO_TypeOfAdmission_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP= ‘CDE_ADMIT_TYPE' for Type Of Admission

*/

    CASE WHEN CDE_CLM_TYPE NOT IN ('L','I','O') THEN 'NOT APP'
        WHEN CDE_ADMIT_TYPE IS NULL THEN 'NULL'
        WHEN CDE_ADMIT_TYPE NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_ADMIT_TYPE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
        ELSE 'VALID'
    END AS TypeOfAdmission1X,
/*
12.1.23	Source of Admission (MPT_SourceofAdmission_837I)
•	837I Claims population: MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP
•	MPT_SENDPRO_SourceOfAdmission_Valid: SPRO_B_ENC_CLAIM_INST_LEG_HIST. CDE_ADMIT_SOURCE
•	Missing String Value Parameter: MP_SENDPRO_StringIsNull_ALL, SPRO_B_ENC_CLAIM_INST_LEG_HIST. CDE_ADMIT_SOURCE

*/

    CASE WHEN CDE_CLM_TYPE NOT IN ('L','I','O') THEN 'NOT APP'
        WHEN CDE_ADMIT_SOURCE IS NULL THEN 'NULL'
        WHEN CDE_ADMIT_SOURCE NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_ADMIT_SOURCE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
        ELSE 'VALID'
    END AS SourceOfAdmission1X,
/*
12.1.24	Patient Status Code (MPT_SENDPRO_PatientStatusCode_837I)
•	837I Claims population:  MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP
•	MPT_SENDPRO_PatientStatusCode_Valid: SPRO_B_ENC_CLAIM_INST_LEG_HIST. CDE_PATIENT_STATUS
•	MPT_SENDPRO_StringIsNull_ALL: SPRO_B_ENC_CLAIM_INST_LEG_HIST. CDE_PATIENT_STATUS

45	MPT_SENDPRO_PatientStatusCode_Valid	If valid based on the lookup against the CDE_CHAR from NW_SUP_CODE_REF where CDE_GROUP=’ CDE_PATIENT_STATUS’ then 1 else 0

*/

    CASE WHEN CDE_CLM_TYPE NOT IN ('L','I','O') THEN 'NOT APP'
        WHEN CDE_PATIENT_STATUS IS NULL THEN 'NULL'
        WHEN CDE_PATIENT_STATUS NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PATIENT_STATUS' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
        ELSE 'VALID'
    END AS PatientStatusCode1X,
/*
12.1.25	Facility Type Code (MPT_SENDPRO_FacilityTypeCode_837I_837P)
•	837I Claims population: MPT_SENDPRO_ClaimType_837P, MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP
•	MPT_SENDPRO_FacilityTypeCode_837I: SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_TYPE_OF_BILL, 
•	Missing String Value Parameter: MPT_StringIsNull_ALL, SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_TYPE_OF_BILL

46	MPT_SENDPRO_FacilityTypeCode_Valid	If valid based on the lookup against the CDE_CHAR from NW.NW_SUP_CODE_REF where CDE_GROUP=’ CDE_TYPE_OF_BILL’ then 1 else 0

*/

    CASE WHEN CDE_CLM_TYPE NOT IN ('L','I','O') THEN 'NOT APP'
        WHEN CDE_TYPE_OF_BILL IS NULL THEN 'NULL'
        WHEN CDE_TYPE_OF_BILL NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_TYPE_OF_BILL' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
        ELSE 'VALID'
    END AS FacilityTypeCode1X,
/*
12.1.26	Procedure Code (MPT_SENDPRO_ProcedureCode_837)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837I_LTC, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D
•	SENDPRO_ValidEncDiagnosisCode SPRO_B_ENC_CLAIM_INST_LEG_HIST.PROC_SEQ, SPRO_B_ENC_CLAIM_PROF_LEG_HIST.PROC_SEQ, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.PROC_SEQ, Procedure Code

62	MPT_SENDPRO_ValidEncDProcedureCode	
    1.	Join PROC_SEQ from Fact with NW. NW_B_PROCEDURE ON  NW_B_PROCEDURE .PROC_SEQ
    2.	Procedure Code: If COALESCE(CDE_PROC,’ ‘)  <> ‘ ‘ Then 1 else 0

*/

    CASE 
        WHEN PROC_SEQ IS NULL THEN 'NULL'
        WHEN NOT EXISTS (SELECT CDE_PROC from MHDWQA.NW.NW_B_PROCEDURE proc WHERE PROC_SEQ = proc.PROC_SEQ 
            AND CDE_PROC IS NOT NULL AND CDE_PROC NOT IN ('#','+','-',' ')) 
        THEN 'INVALID'
        ELSE 'VALID'
    END AS ProcedureCode1X,

/*
12.1.27	Procedure Modifier Code (MPT_SENDPRO_ProcedureModCode_837)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837I_LTC, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D
•	SENDPRO_ValidEncProcedureModifierCode SPRO_B_ENC_CLAIM_INST_LEG_HIST. PROCMFR _SEQ, SPRO_B_ENC_CLAIM_PROF_LEG_HIST. PROCMFR _SEQ, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. PROCMFR _SEQ, Procedure Modfier` Code

63	MPT_SENDPRO_ValidEncDProcedureModifierCode	
    1.	Join PROCMFR_SEQ from Fact with NW. NW_B_PROCEDURE_MFR ON  NW_B_PROCEDURE_MFR .PROCMFR_SEQ
    2.	Procedure Modifier Code: If COALESCE(CDE_PROC_MOD,’ ‘)  <> ‘ ‘ Then 1 else 0

*/

    CASE 
        WHEN PROCMFRGRP_SEQ IS NULL THEN 'NULL'
        WHEN NOT EXISTS (SELECT GROUP_ITEM_CD_STRING FROM MHDWQA.NW.NW_B_PROCEDURE_MFR_GROUP procmfr WHERE PROCMFRGRP_SEQ = procmfr.PROCMFRGRP_SEQ 
            AND GROUP_ITEM_CD_STRING IS NOT NULL AND GROUP_ITEM_CD_STRING NOT IN ('#','+','-',' ')) 
        THEN 'INVALID'
        ELSE 'VALID'
    END AS ProcedureModCode1X,

/*
12.1.28	Place of Service (MPT_SENDPRO_PlaceOfServiceCode_837)
•	837I Claims population: MPT_SENDPRO_ClaimType_837P, MPT_SENDPRO_ClaiimType_837D
•	MPT_SENDPRO_ValidPlaceOfService_837I: SPRO_B_ENC_CLAIM_PROF_LEG_HIST.CDE_PLACE_OF_SERVICE, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.CDE_PLACE_OF_SERVICE, 
•	Missing String Value Parameter: MPT_StringIsNull_ALL, SPRO_B_ENC_CLAIM_PROF_LEG_HIST.CDE_PLACE_OF_SERVICE, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.CDE_PLACE_OF_SERVICE,

-- Prof and Dntl only as Inst does not have this field

64	MPT_SENDPRO_ValidPlaceOfService	If valid based on the lookup against the CDE_CHAR from NW.NW_SUP_CODE_REF where CDE_GROUP=’ CDE_PLACE_OF_SERVICE’ then 1 else 0

*/

    CASE WHEN CDE_CLM_TYPE NOT IN ('P','D') THEN 'NOT APP'
         WHEN CDE_PLACE_OF_SERVICE IS NULL THEN 'NULL'
         WHEN CDE_PLACE_OF_SERVICE NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PLACE_OF_SERVICE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) 
         THEN 'INVALID'
         ELSE 'VALID'
    END AS PlaceOfServiceCode1X,


1 as TOT_REX

FROM (
select DISTINCT
    CURRENT_DATE() AS RUN_DATE,
    inst.NUM_ICN,
    inst.CDE_ENTITY_MODEL,
    inst.CDE_ENC_MCO,
    inst.CDE_ENC_ACO,
    inst.ID_SUBMITTER,
    inst.DOS_FROM_DT,
    inst.CDE_CLM_TYPE,
    inst.CDE_CLM_STATUS,
    inst.CDE_CLM_DISPOSITION,
    inst.IND_OFFSET,
    inst.WH_FROM_DT,
    inst.MD_BATCH_SEQ,

    inst.CDE_BILL_FREQ,
    inst.CDE_CONTRACT_TYPE,
    inst.AMT_ALLOWED,
    inst.AMT_PAID,
    inst.AMT_BILLED,
    inst.DOS_TO_DT,
    inst.ADMIT_DT_TM,
    inst.MEM_SEQ AS FACT_MEM_SEQ,
    inst.QTY_UNITS_BILLED,
    inst.DISCHARGE_DT_TM,
    inst.CDE_ADMIT_TYPE,
    inst.CDE_ADMIT_SOURCE,
    inst.CDE_PATIENT_STATUS,
    inst.CDE_TYPE_OF_BILL,
    inst.DIAGRP_SEQ,

    inst.BILLING_ENC_PRV_SEQ,
    inst.SERVICING_ENC_PRV_SEQ,
    NULL AS CDE_PLACE_OF_SERVICE,
  
    prov_billing.ENC_PROV_ID AS billing_ProviderInternalId,
    prov_billing.ID_NPI AS billing_ProviderNPI,
    --prov_billing.CDE_PROVIDER_TYPE AS billing_ProviderType,

    prov_servicing.ENC_PROV_ID AS servicing_ProviderInternalId,
    prov_servicing.ID_NPI AS servicing_ProviderNPI,
    --prov_servicing.CDE_PROVIDER_TYPE AS servicing_ProviderType

    dtl.NUM_DTL,

    dtl.PROC_SEQ,
    dtl.PROCMFRGRP_SEQ,

--    dtl.CDE_CONTRACT_TYPE       AS DTL_CDE_CONTRACT_TYPE,
    dtl.AMT_ALLOWED             AS DTL_AMT_ALLOWED,
    dtl.AMT_PAID                AS DTL_AMT_PAID,
    dtl.AMT_BILLED              AS DTL_AMT_BILLED,
    dtl.BILLING_ENC_PRV_SEQ AS DTL_BILLING_ENC_PRV_SEQ,
    dtl.SERVICING_ENC_PRV_SEQ   AS DTL_SERVICING_ENC_PRV_SEQ,
    dtl.DOS_FROM_DT             AS DTL_DOS_FROM_DT,
    dtl.DOS_TO_DT               AS DTL_DOS_TO_DT,
    dtl.MEM_SEQ                 AS DTL_FACT_MEM_SEQ,
    dtl.QTY_UNITS_BILLED        AS DTL_QTY_UNITS_BILLED,
    dtl.DISCHARGE_DT            AS DTL_DISCHARGE_DT,

    dtl_prov_billing.ENC_PROV_ID   AS dtl_billing_ProviderInternalId,
    dtl_prov_billing.ID_NPI        AS dtl_billing_ProviderNPI,

    dtl_prov_servicing.ENC_PROV_ID AS dtl_servicing_ProviderInternalId,
    dtl_prov_servicing.ID_NPI      AS dtl_servicing_ProviderNPI

FROM MHDWQA.SENDPRO.SPRO_B_ENC_CLAIM_INST_LEG_HIST inst
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_INST_INFO_DTL_HIST dtl
    ON inst.NUM_ICN = dtl.NUM_ICN
--LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PHRM_OTHER_PAYMENTS pharm
--    ON inst.CLM_SEQ = pharm.CLM_SEQ
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_billing
    ON inst.BILLING_ENC_PRV_SEQ = prov_billing.ENC_PRV_SEQ
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_servicing
    ON inst.SERVICING_ENC_PRV_SEQ = prov_servicing.ENC_PRV_SEQ
--LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_operating
--    ON inst.OPERATING_ENC_CLM_PRV_SEQ = prov_operating.ENC_PRV_SEQ
--LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_other
--    ON inst.OTHER_ENC_CLM_PRV_SEQ = prov_other.ENC_PRV_SEQ
--LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_referring
--    ON inst.REFERRING_ENC_PRV_SEQ = prov_referring.ENC_PRV_SEQ

LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST dtl_prov_billing
    ON DTL_BILLING_ENC_PRV_SEQ = dtl_prov_billing.ENC_PRV_SEQ
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST dtl_prov_servicing
    ON DTL_SERVICING_ENC_PRV_SEQ = dtl_prov_servicing.ENC_PRV_SEQ

WHERE inst.IND_OFFSET = 'N'
 ) A;

--LIMIT 100;