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
59	MPT_SENDPRO_ValidMember	
    1.	Join MEM_SEQ from Fact with NW.NW_MEMBER on MEM_SEQ
    2.	If ID_MEDICAID IS NOT  NULL Then 1 else 0
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
61	MPT_SENDPRO_ValidEncDiagnosisCode	
    1.	Join DIAG_GRP_SEQ from Fact with NW. NW_B_DIAGNOSIS_GROUP ON  NW_B_DIAGNOSIS_GROUP .DIAG_GRP_SEQ 
    2.	Admission Diagnosis Code: If CDE_DIAG_ADMIT  IS NOT  NULL Then 1 else 0
    3.	Primary Diagnosis Code: IF CDE_DIAG_P1 IS NOT NULL THEN 1 ELSE 0
62	MPT_SENDPRO_ValidEncDProcedureCode	
    1.	Join PROC_SEQ from Fact with NW. NW_B_PROCEDURE ON  NW_B_PROCEDURE .PROC_SEQ
    2.	Procedure Code: If COALESCE(CDE_PROC,’ ‘)  <> ‘ ‘ Then 1 else 0
63	MPT_SENDPRO_ValidEncDProcedureModifierCode	
    1.	Join PROCMFR_SEQ from Fact with NW. NW_B_PROCEDURE_MFR ON  NW_B_PROCEDURE_MFR .PROCMFR_SEQ
    2.	Procedure Modifier Code: If COALESCE(CDE_PROC_MOD,’ ‘)  <> ‘ ‘ Then 1 else 0
64	MPT_SENDPRO_ValidPlaceOfService	If valid based on the lookup against the CDE_CHAR from NW.NW_SUP_CODE_REF where CDE_GROUP=’ CDE_PLACE_OF_SERVICE’ then 1 else 0
*/


SELECT

    NUM_ICN,
    NUM_DTL,
    CDE_ENTITY_MODEL,
    CDE_ENC_MCO,
    CDE_ENC_ACO,
    ID_SUBMITTER,
    DOS_FROM_DT,
    CDE_CLM_TYPE,
--    CDE_BILL_TYPE,
    CDE_CLM_STATUS,
--    CDE_FACILITY_TYPE,
    CDE_CLM_DISPOSITION,
    IND_OFFSET,
    WH_FROM_DT,


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
    ELSE 'VALID' END ClaimFrequencyTypeCode1X,

/*
12.1.2	Claim Contract Type Code (MPT_SENDPRO_ClaimContractTypeCode_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_CLAIM_PROF_LEG_HIST.CDE_CONTRACT_TYPE, SPRO_B_ENC_PROF_INFO_DTL_HIST, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.CDE_CONTRACT_TYPE, SPRO_B_ENC_DNTL_INFO_DTL_HIST.CDE_CONTRACT_TYPE, SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_CONTRACT_TYPE
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
*/

CASE
    WHEN AMT_ALLOWED IS NULL THEN 'NULL'
    WHEN AMT_ALLOWED <= 0 THEN 'INVALID'
    ELSE 'VALID'
END AS ClaimAllowableAmount1X,

/*
12.1.4	Claim Paid Amount (MPT_SENDPRO_ClaimAllPaidAmt_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_PAID, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_PAID, SPRO_B_ENC_DNTL_INFO_DTL_HIST.AMT_PAID, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_PAID, SPRO_B_ENC_PHRM_OTHER_PAYMENTS.AMT_PAID, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_PAID, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_PAID
•	MPT_SENDPRO_AmountValueNotNegative: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_ALLOWED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_ALLOWED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_ALLOWED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_ALLOWED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_ALLOWED AND CDE_CLM_STATUS=’P’
*/

CASE
    WHEN AMT_PAID IS NULL THEN 'NULL'
    WHEN AMT_PAID < 0 THEN 'INVALID'
    ELSE 'VALID'
END AS ClaimPaidAmount1X,

/*
12.1.5	Claim Billed Amount (MPT_SENDPRO_ClaimAllBilledAmt_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_BILLED, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_PAID, SPRO_B_ENC_DNTL_INFO_DTL_HIST.AMT_ BILLED, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_PAID, SPRO_B_ENC_PHRM_OTHER_PAYMENTS.AMT_ BILLED, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_PAID, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_ BILLED
•	MPT_SENDPRO_AmountValueNotNegative: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_ BILLED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_ BILLED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_ BILLED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_ BILLED AND CDE_CLM_STATUS=’P’, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_ BILLED AND CDE_CLM_STATUS=’P’
*/

CASE
    WHEN AMT_BILLED IS NULL THEN 'NULL'
    WHEN AMT_BILLED < 0 THEN 'INVALID'
    ELSE 'VALID'
END AS ClaimBilledAmount1X,

/*
12.1.6	Billing Provider Id (MPT_SENDPRO_BillingProviderID_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidClmEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_CLM_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENCClm_CLM_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_CLM_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_CLM_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_CLM_PRV_SEQ: 
*/

/*
12.1.7	Billing Provider NPI (MPT_SENDPRO_BillingProviderNPI_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ ValidClmEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_CLM_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_CLM_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_CLM_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_CLM_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_CLM_PRV_SEQ: 
*/

/*
12.1.8	Billing Provider Taxonomy Code (MPT_SENDPRO_BillingProviderTaxonomyALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ ValidClmEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_CLM_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_CLM_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_CLM_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_CLM_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_CLM_PRV_SEQ: 
*/

/*
12.1.9	Servicing Provider Id (MPT_SENDPRO_ServicingProviderID_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ: 
*/

/*
12.1.10	Servicing Provider NPI (MPT_SENDPRO_ServicingProviderNPI_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ: 
*/

/*
12.1.11	Servicing Provider Type (MPT_SENDPRO_ServicingProviderType_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ: 
*/

/*
12.1.12	Servicing Provider Location (MPT_SENDPRO_ServicingProviderLoc_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ: 
*/

/*
12.1.13	Servicing Provider Taxonomy Code (MPT_SENDPRO_ServicingProviderTaxonomyCode_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ: 
*/

/*
12.1.14	From Service Date (MPT_SENDPRO_From_Service_Date_ALL)
•	837P Claims population: MPT_SENDPRO_ClaiimType_ALL 
•	MPT_SENDPRO_DateIsNotBot_ALL: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_DNTL_INFO_DTL_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_INST_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_INST_INFO_DTL_HIST.DOS_FROM_DT
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_DNTL_INFO_DTL_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_INST_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_INST_INFO_DTL_HIST.DOS_FROM_DT
*/

    CASE 
        WHEN DOS_FROM_DT IS NULL THEN 'NULL'
        WHEN DOS_FROM_DT = '1900-01-01' THEN 'INVALID'
        ELSE 'VALID'
    END AS FromServiceDate1X,

/*
12.1.15	To Service Date (MPT_SENDPRO_To_Service_Date_ALL)
•	837P Claims population: MPT_SENDPRO_ClaiimType_ALL 
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.DOS_TO_DT, SPRO_B_ENC_DNTL_INFO_DTL_HIST.DOS_ TO _DT, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.DOS_ TO _DT, SPRO_B_ENC_CLAIM_INST_LEG_HIST.DOS_ TO _DT, SPRO_B_ENC_INST_INFO_DTL_HIST.DOS_ TO _DT
*/

    CASE 
        WHEN DOS_TO_DT IS NULL THEN 'NULL'
        WHEN DOS_TO_DT = '1900-01-01' THEN 'INVALID'
        ELSE 'VALID'
    END AS ToServiceDate1X,

/*
12.1.16	Admission Date (MPT_SENDPRO_Admission_Date_837I)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP
•	MPT_SENDPRO_DateIsNotBot_ALL: SPRO_B_ENC_CLAIM_INST_LEG_HIST.ADMIT_DT_TM
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL SPRO_B_ENC_CLAIM_INST_LEG_HIST.ADMIT_DT_TM
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. ADMIT_DT_TM
*/

    CASE 
        WHEN ADMIT_DT_TM IS NULL THEN 'NULL'
        WHEN ADMIT_DT_TM = '1900-01-01' THEN 'INVALID'
        ELSE 'VALID'
    END AS AdmissionDate1X, 


/*
12.1.17	Member ID (MPT_SENDPRO_MemberID_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ProviderInternalId_Valid: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.MEM_SEQ>0, SPRO_B_ENC_DNTL_INFO_DTL_HIST. MEM SEQ>0, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.MEM_SEQ>0, SPRO_B_ENC_INST_INFO_DTL_HIST.MEM_SEQ>0
@@@
*/

    CASE 
        WHEN MEM_SEQ IS NULL THEN 'NULL'
        WHEN MEM_SEQ <= 0 THEN 'INVALID'
        ELSE 'VALID'
    END AS MemberID1X,

/*
12.1.18	Quantity (MPT_SENDPRO_ClaimAllowableAmt_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_CLAIM_PROF_LEG_HIST,QTY_UNITS_BILLED,  SPRO_B_ENC_PROF_INFO_DTL_HIST.QTY_UNITS_BILLED, SPRO_B_ENC_CLAIM_INST_LEG_HIST,QTY_UNITS_BILLED,  SPRO_B_ENC_ INST_INFO_DTL_HIST.QTY_UNITS_BILLED, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST,QTY_UNITS_BILLED,  SPRO_B_ENC_DNTL_INFO_DTL_HIST.QTY_UNITS_BILLED, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST, QTY_DISPD,  SPRO_B_ENC_PROF_INFO_DTL_HIST. QTY_PRESCRIBED
*/

    CASE 
        WHEN QTY_UNITS_BILLED IS NULL THEN 'NULL'
        WHEN QTY_UNITS_BILLED <= 0 THEN 'INVALID'
        ELSE 'VALID'
    END AS Quantity1X,
/*
12.1.19	Admitting Diagnosis (MPT_SENDPRO_Admitting_Diagnosis_837I)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_INP
•	SENDPRO_ValidEncDiagnosisCode SPRO_B_ENC_CLAIM_INST_LEG_HIST.DIAG_GRP_SEQ, Admission Diagnosis Code
*/

/*
12.1.20	Admitting Diagnosis (MPT_SENDPRO_Admitting_Diagnosis_837)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837I_LTC. MPT_SENDPRO_ClaiimType_837P
•	SENDPRO_ValidEncDiagnosisCode SPRO_B_ENC_CLAIM_INST_LEG_HIST.DIAG_GRP_SEQ, SPRO_B_ENC_CLAIM_PROF_LEG_HIST.DIAG_GRP_SEQ, Primary Diagnosis Code
*/

/*
12.1.21	Discharge Date (MPT_SENDPRO_Discharge_Date_837I)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_INP
•	MPT_SENDPRO_DateIsNotBot_ALL: SPRO_B_ENC_CLAIM_INST_LEG_HIST. DISCHARGE_DT_TM, SPRO_B_ENC_INST_INFO_DTL_HIST. DISCHARGE_DT
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL SPRO_B_ENC_CLAIM_INST_LEG_HIST. DISCHARGE_DT_TM, SPRO_B_ENC_INST_INFO_DTL_HIST. DISCHARGE_DT
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL: SPRO_B_ENC_CLAIM_INST_LEG_HIST. DISCHARGE_DT_TM, SPRO_B_ENC_INST_INFO_DTL_HIST. DISCHARGE_DT
*/
    CASE 
        WHEN DISCHARGE_DT_TM IS NULL THEN 'NULL'
        WHEN DISCHARGE_DT_TM = '1900-01-01' THEN 'INVALID'
        ELSE 'VALID'
    END AS DischargeDate1X,
/*
12.1.22	Type of Admission (MPT_TypeofAdmission_837I)
•	837I Claims population: MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP
•	MPT_SENDPRO_TypeOfAdmission_Valid: SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_ADMIT_TYPE
•	Missing String Value Parameter: MP_SENDPRO_StringIsNull_ALL, SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_ADMIT_TYPE
*/

    CASE 
        WHEN CDE_ADMIT_TYPE IS NULL THEN 'NULL'
        WHEN CDE_ADMIT_TYPE NOT IN ('1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S') THEN 'INVALID'
        ELSE 'VALID'
    END AS TypeOfAdmission1X,
/*
12.1.23	Source of Admission (MPT_SourceofAdmission_837I)
•	837I Claims population: MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP
•	MPT_SENDPRO_SourceOfAdmission_Valid: SPRO_B_ENC_CLAIM_INST_LEG_HIST. CDE_ADMIT_SOURCE
•	Missing String Value Parameter: MP_SENDPRO_StringIsNull_ALL, SPRO_B_ENC_CLAIM_INST_LEG_HIST. CDE_ADMIT_SOURCE
*/

    CASE 
        WHEN CDE_ADMIT_SOURCE IS NULL THEN 'NULL'
        WHEN CDE_ADMIT_SOURCE NOT IN ('1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S') THEN 'INVALID'
        ELSE 'VALID'
    END AS SourceOfAdmission1X,
/*
12.1.24	Patient Status Code (MPT_SENDPRO_PatientStatusCode_837I)
•	837I Claims population:  MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP
•	MPT_SENDPRO_PatientStatusCode_Valid: SPRO_B_ENC_CLAIM_INST_LEG_HIST. CDE_PATIENT_STATUS
•	MPT_SENDPRO_StringIsNull_ALL: SPRO_B_ENC_CLAIM_INST_LEG_HIST. CDE_PATIENT_STATUS
*/

    CASE 
        WHEN CDE_PATIENT_STATUS IS NULL THEN 'NULL'
        WHEN CDE_PATIENT_STATUS NOT IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50') THEN 'INVALID'
        ELSE 'VALID'
    END AS PatientStatusCode1X,
/*
12.1.25	Facility Type Code (MPT_SENDPRO_FacilityTypeCode_837I_837P)
•	837I Claims population: MPT_SENDPRO_ClaimType_837P, MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP
•	MPT_SENDPRO_FacilityTypeCode_837I: SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_TYPE_OF_BILL, 
•	Missing String Value Parameter: MPT_StringIsNull_ALL, SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_TYPE_OF_BILL
*/

    CASE 
        WHEN CDE_TYPE_OF_BILL IS NULL THEN 'NULL'
        WHEN CDE_TYPE_OF_BILL NOT IN ('0111','0112','0113','0114','0115','0116','0117','0118','0121','0122','0123','0124','0125','0126','0127','0128','0131','0132','0133','0134','0135','0136','0137','0138','0141','0142','0143','0144','0145','0146','0147','0148','0211','0212','0213','0214','0215','0216','0217','0218','0221','0222','0223','0224','0225','0226','0227','0228','0231','0232','0233','0234','0235','0236','0237','0238') THEN 'INVALID'
        ELSE 'VALID'
    END AS FacilityTypeCode1X,
/*
12.1.26	Procedure Code (MPT_SENDPRO_ProcedureCode_837)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837I_LTC, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D
•	SENDPRO_ValidEncDiagnosisCode SPRO_B_ENC_CLAIM_INST_LEG_HIST.PROC_SEQ, SPRO_B_ENC_CLAIM_PROF_LEG_HIST.PROC_SEQ, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.PROC_SEQ, Procedure Code
*/

/*
    CASE 
        WHEN PROC_SEQ IS NULL THEN 'NULL'
        WHEN PROC_SEQ <= 0 THEN 'INVALID'
        ELSE 'VALID'
    END AS ProcedureCode1X,
*/

/*
12.1.27	Procedure Modifier Code (MPT_SENDPRO_ProcedureModCode_837)
•	837I Claims population: MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837I_LTC, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D
•	SENDPRO_ValidEncProcedureModifierCode SPRO_B_ENC_CLAIM_INST_LEG_HIST. PROCMFR _SEQ, SPRO_B_ENC_CLAIM_PROF_LEG_HIST. PROCMFR _SEQ, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. PROCMFR _SEQ, Procedure Modfier` Code
*/

/*
    CASE 
        WHEN PROCMFR_SEQ IS NULL THEN 'NULL'
        WHEN PROCMFR_SEQ <= 0 THEN 'INVALID'
        ELSE 'VALID'
    END AS ProcedureModCode1X,
*/

/*
12.1.28	Place of Service (MPT_SENDPRO_PlaceOfServiceCode_837)
•	837I Claims population: MPT_SENDPRO_ClaimType_837P, MPT_SENDPRO_ClaiimType_837D
•	MPT_SENDPRO_ValidPlaceOfService_837I: SPRO_B_ENC_CLAIM_PROF_LEG_HIST.CDE_PLACE_OF_SERVICE, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.CDE_PLACE_OF_SERVICE, 
•	Missing String Value Parameter: MPT_StringIsNull_ALL, SPRO_B_ENC_CLAIM_PROF_LEG_HIST.CDE_PLACE_OF_SERVICE, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.CDE_PLACE_OF_SERVICE,

-- Prof and Dntl only as Inst does not have this field
*/

/* 
    CASE 
        WHEN CDE_PLACE_OF_SERVICE IS NULL THEN 'NULL'
        WHEN CDE_PLACE_OF_SERVICE NOT IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44') THEN 'INVALID'
        ELSE 'VALID'
    END AS PlaceOfServiceCode1X,
*/

1 as TOT_REX

FROM (
SELECT
    inst.NUM_ICN,
    inst.NUM_DTL,
    inst.CDE_ENTITY_MODEL,
    inst.CDE_ENC_MCO,
    inst.CDE_ENC_ACO,
    inst.ID_SUBMITTER,
    inst.DOS_FROM_DT,
    inst.CDE_CLM_TYPE,
 --   inst.CDE_BILL_TYPE,
    inst.CDE_CLM_STATUS,
 --   inst.CDE_FACILITY_TYPE,
    inst.CDE_CLM_DISPOSITION,
    inst.IND_OFFSET,
    inst.WH_FROM_DT,

    inst.CDE_BILL_FREQ,
    inst.CDE_CONTRACT_TYPE,
    inst.AMT_ALLOWED,
    inst.AMT_PAID,
    inst.AMT_BILLED,
    inst.DOS_TO_DT,
    inst.ADMIT_DT_TM,
    inst.MEM_SEQ,
    inst.QTY_UNITS_BILLED,
    inst.DISCHARGE_DT_TM,
    inst.CDE_ADMIT_TYPE,
    inst.CDE_ADMIT_SOURCE,
    inst.CDE_PATIENT_STATUS,
    inst.CDE_TYPE_OF_BILL,
    --inst.PROC_SEQ,
    --inst.PROCMFR_SEQ,
    --inst.CDE_PLACE_OF_SERVICE

--    inst_info.*,
--    pharm.*,
--    prov_billing.*,
--    prov_servicing.*,
--    prov_operating.*,
--    prov_other.*,
--    prov_referring.*
--    tax.*

FROM MHDWQA.SENDPRO.SPRO_B_ENC_CLAIM_INST_LEG_HIST inst
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_INST_INFO_DTL_HIST inst_info
    ON inst.NUM_ICN = inst_info.NUM_ICN
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PHRM_OTHER_PAYMENTS pharm
    ON inst.CLM_SEQ = pharm.CLM_SEQ
-- Join PROVIDER_HIST for each *_PRV_SEQ field in inst_info
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_billing
    ON inst_info.BILLING_ENC_CLM_PRV_SEQ = prov_billing.ENC_PRV_SEQ
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_servicing
    ON inst_info.SERVICING_ENC_PRV_SEQ = prov_servicing.ENC_PRV_SEQ
--LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_operating
--    ON inst_info.OPERATING_ENC_CLM_PRV_SEQ = prov_operating.ENC_PRV_SEQ
--LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_other
--    ON inst_info.OTHER_ENC_CLM_PRV_SEQ = prov_other.ENC_PRV_SEQ
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_referring
    ON inst_info.REFERRING_ENC_PRV_SEQ = prov_referring.ENC_PRV_SEQ
--LEFT JOIN MHDWDEV.SENDPRO.SPRO_B_ENC_TAXONOMY_HIST_07212025 tax
--    ON inst.ENC_PRV_SEQ = tax.ENC_PRV_SEQ

)
LIMIT 100;