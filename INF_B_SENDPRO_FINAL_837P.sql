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

68	MPT_SENDPRO_ValidEncInternalProvider	1.	Join ENC_PRV_SEQ from Fact with sendpro. spro_b_enc_provider_hist on enc_prv_seq
2.	NPI: If ID_NPI  IS NOT  NULL Then 1 else 0
3.	Internal Provider Address Location: IF CDE_ENC_PROV_ID_LOC IS NOT NULL THEN 1 ELSE 0
4.	Internal Provider ID: IF ENC_PROV_ID IS NOT NULL THEN 1 ELSE 0

*/
-- DROP TABLE MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837_NCPDP;

-- CREATE TABLE MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837_NCPDP AS
--TRUNCATE TABLE MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837_NCPDP;

INSERT INTO MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837_NCPDP
SELECT DISTINCT
    RUN_DATE,
    NUM_ICN,
    NUM_DTL,
    CDE_ENTITY_MODEL,
    CDE_ENC_MCO,
    CDE_ENC_ACO,
--    ID_SUBMITTER,
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
/*
CASE WHEN CDE_BILL_FREQ IS NULL THEN 'NULL'
    WHEN CDE_BILL_FREQ NOT IN ('1','2','3','4','5','7','8') THEN 'INVALID' 
    ELSE 'VALID' 
END AS ClaimFrequencyTypeCode1X,
*/
/*
12.1.2	Claim Contract Type Code (MPT_SENDPRO_ClaimContractTypeCode_837)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_LTC, MPT_SENDPRO_ClaiimType_837I_INP, MPT_SENDPRO_ClaiimType_837I_OUTP, MPT_SENDPRO_ClaiimType_837P, MPT_SENDPRO_ClaiimType_837D
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_CLAIM_PROF_LEG_HIST.CDE_CONTRACT_TYPE, SPRO_B_ENC_PROF_INFO_DTL_HIST, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.CDE_CONTRACT_TYPE, SPRO_B_ENC_DNTL_INFO_DTL_HIST.CDE_CONTRACT_TYPE, SPRO_B_ENC_CLAIM_INST_LEG_HIST.CDE_CONTRACT_TYPE

23	MPT_SENDPRO_ContractTypeCode_Valid	Should contain one of these values "01, 02, 03, 04, 05, 06, 09"
*/
/*
CASE 
    WHEN CDE_CONTRACT_TYPE IS NULL THEN 'NULL'
    WHEN CDE_CONTRACT_TYPE NOT IN ('01','02','03','04','05','06','09') THEN 'INVALID'
    ELSE 'VALID'
END AS ClaimContractTypeCode1X,
*/
/*
12.1.3	Claim Allowable Amount (MPT_SENDPRO_ClaimAllowableAmt_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_ALLOWED
•	MPT_SENDPRO_AmountValue_ALLL: SPRO_B_ENC_PROF_INFO_DTL_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_CLAIM_INST_LEG_HIST.AMT_ALLOWED, SPRO_B_ENC_INST_INFO_DTL_HIST.AMT_ALLOWED AND 

4	MPT_SENDPRO_AmountValue_ALL 	Amount is greater than 0 then 1 else 0
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
    WHEN CDE_CLM_STATUS != 'P' THEN 'NOT APP'
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
    WHEN CDE_CLM_STATUS != 'P' THEN 'NOT APP'
    WHEN AMT_BILLED IS NULL THEN 'NULL'
    WHEN AMT_BILLED < 0 THEN 'INVALID'
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
         WHEN (billing_ProviderInternalId IS NULL OR billing_ProviderInternalId IN ('#','+','-')) THEN 'NULL'
		 WHEN 
         ( 
               (NOT EXISTS (SELECT ENC_PROV_ID from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = billing_ProviderInternalId) )
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
               ((billing_ProviderNPI IS NULL) OR (billing_ProviderNPI IN ('#','+','-')) OR billing_ProviderNPI IN ('0','000000000','0000000000') ) 
         )            
            THEN 'NULL'
		 WHEN 
         (
              (NOT EXISTS (SELECT ID_NPI from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ID_NPI NOT IN ('#','+','-') AND ID_NPI = billing_ProviderNPI))
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

         )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS BillingProviderTaxonomy1X,

/* 
10/31/25 NEW

12.1.9	Billing Internal Provider Address Location (MPT_SENDPRO_BillingInternalProviderAddressLocALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ ValidEncInternalProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ:

*/

    CASE 
		 WHEN 
         (
             (NOT EXISTS (SELECT prv.CDE_ENC_PROV_ID_LOC from mhdwqa.SENDPRO.spro_b_enc_provider_hist as prv
         where BILLING_ENC_PRV_SEQ = prv.ENC_PRV_SEQ AND prv.CDE_ENC_PROV_ID_LOC IS NOT NULL AND prv.CDE_ENC_PROV_ID_LOC NOT IN ('#','+','-')))

         )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS BillingInternalProviderAddressLocation1X,

/*
12/19/25
12.1.10	Billing Provider Location (MPT_SENDPRO_BillingProviderLoc_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_DNTL_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_CLAIM_INST_LEG_HIST. BILLING_ENC_PRV_SEQ, SPRO_B_ENC_INST_INFO_DTL_HIST. BILLING_ENC_PRV_SEQ: 

*/

    CASE 
		 WHEN 
         (
             (NOT EXISTS (SELECT prv.ID_PROVIDER_LOCATION from mhdwqa.SENDPRO.spro_b_enc_provider_hist as prv
         where BILLING_ENC_PRV_SEQ = prv.ENC_PRV_SEQ AND prv.ID_PROVIDER_LOCATION IS NOT NULL AND prv.ID_PROVIDER_LOCATION NOT IN ('#','+','-')))

         )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS BillingProviderLocation1X,


/*
12.1.17	From Service Date (MPT_SENDPRO_From_Service_Date_ALL)
•	837P Claims population: MPT_SENDPRO_ClaiimType_ALL 
•	MPT_SENDPRO_DateIsNotBot_ALL: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_DNTL_INFO_DTL_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_INST_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_INST_INFO_DTL_HIST.DOS_FROM_DT
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_DNTL_INFO_DTL_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_CLAIM_INST_LEG_HIST.DOS_FROM_DT, SPRO_B_ENC_INST_INFO_DTL_HIST.DOS_FROM_DT

5	MPT_SENDPRO_DateIsNotBot_ALL	Date is not equal to 1/1/1900 then 1 else 0
1	MPT_SENDPRO_DateIsNotNull_ALL	Date is not null then 1 else 0
*/

    CASE 
        WHEN DOS_FROM_DT IS NULL THEN 'NULL'
        WHEN DOS_FROM_DT = '1900-01-01' THEN 'INVALID'
        ELSE 'VALID'
    END AS FromServiceDate1X,

/*
12.1.18	To Service Date (MPT_SENDPRO_To_Service_Date_ALL)
•	837P Claims population: MPT_SENDPRO_ClaiimType_ALL 
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.DOS_TO_DT, SPRO_B_ENC_DNTL_INFO_DTL_HIST.DOS_ TO _DT, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.DOS_ TO _DT, SPRO_B_ENC_CLAIM_INST_LEG_HIST.DOS_ TO _DT, SPRO_B_ENC_INST_INFO_DTL_HIST.DOS_ TO _DT
*/

    CASE 
        WHEN DOS_TO_DT IS NULL THEN 'NULL'
        WHEN DOS_TO_DT = '1900-01-01' THEN 'INVALID'
        ELSE 'VALID'
    END AS ToServiceDate1X,


/*
12.1.20	Member ID (MPT_SENDPRO_MemberID_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_ProviderInternalId_Valid: SPRO_B_ENC_CLAIM_DNTL_LEG_HIST.MEM_SEQ>0, SPRO_B_ENC_DNTL_INFO_DTL_HIST. MEM SEQ>0, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.MEM_SEQ>0, SPRO_B_ENC_INST_INFO_DTL_HIST.MEM_SEQ>0

58	MPT_SENDPRO_ValidMember	
    1.	Join MEM_SEQ from Fact with NW.NW_MEMBER on MEM_SEQ
    2.	If ID_MEDICAID IS NOT  NULL Then 1 else 0

*/

    CASE 
        WHEN FACT_MEM_SEQ IS NULL THEN 'NULL'
        WHEN FACT_MEM_SEQ <= 0 THEN 'INVALID'
		WHEN  
        (
              ( NOT EXISTS (SELECT ID_MEDICAID from MHDWQA.NW.NW_MEMBER mem WHERE FACT_MEM_SEQ = mem.MEM_SEQ AND ID_MEDICAID NOT IN ('#','+','-',' ')) )
        )  
        THEN 'INVALID'
        ELSE 'VALID'
    END AS MemberID1X,

/*
12.1.21	Quantity (MPT_SENDPRO_ClaimAllowableAmt_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_ALL
•	MPT_SENDPRO_NumberIsNull_ALL: SPRO_B_ENC_CLAIM_PROF_LEG_HIST,QTY_UNITS_BILLED,  SPRO_B_ENC_PROF_INFO_DTL_HIST.QTY_UNITS_BILLED, SPRO_B_ENC_CLAIM_INST_LEG_HIST,QTY_UNITS_BILLED,  SPRO_B_ENC_ INST_INFO_DTL_HIST.QTY_UNITS_BILLED, SPRO_B_ENC_CLAIM_DNTL_LEG_HIST,QTY_UNITS_BILLED,  
*   SPRO_B_ENC_DNTL_INFO_DTL_HIST.QTY_UNITS_BILLED, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST, QTY_DISPD,  SPRO_B_ENC_PROF_INFO_DTL_HIST. QTY_PRESCRIBED

QTY_DISPD in 12.1.41	Dispense Quantity (MPT_SENDPRO_DispenseQty_NCPDP)

10/31/25 Removed validation for QTY_PRESCRIBED from SPRO_B_ENC_PHRM_INFO_DTL_HIST and the Qty_units_billed from LEG_HIST tables for PROF and INST

*/

    CASE 
        WHEN QTY_PRESCRIBED IS NULL THEN 'NULL'
        ELSE 'VALID'
    END AS QuantityBilled1X,

/*
12.1.29	Procedure Code (MPT_SENDPRO_ProcedureCode_837)
62	MPT_SENDPRO_ValidEncDProcedureCode	
    1.	Join PROC_SEQ from Fact with NW. NW_B_PROCEDURE ON  NW_B_PROCEDURE .PROC_SEQ
    2.	Procedure Code: If COALESCE(CDE_PROC,’ ‘)  <> ‘ ‘ Then 1 else 0

*/

    CASE 
        WHEN PROC_SEQ IS NULL OR PROC_SEQ IN (-1,-4,-5) THEN 'NULL'
        WHEN NOT EXISTS (SELECT CDE_PROC from MHDWQA.NW.NW_B_PROCEDURE proc WHERE PROC_SEQ = proc.PROC_SEQ 
            AND CDE_PROC IS NOT NULL AND CDE_PROC NOT IN ('#','+','-',' ')) 
        THEN 'INVALID'
        ELSE 'VALID'
    END AS ProcedureCode1X,


-- NCPDP Specific Fields

/*
12.1.32	Record Status (MPT_SENDPRO_RecordStatus_NCPDP)
•	837I Claims population: MPT_SENDPRO_ClaimType_NCPDP
•	MPT_SENDPRO_ValidRecordStatus_NCPDP: SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.CDE_REC_STATUS 
•	Missing Number Value Parameter: MPT_SENDPRO_NumberIsNull_ALL, SPRO_B_ENC_CLAIM_PHRM_LEG_HIST.CDE_REC_STATUS

34	MPT_SENDPRO_NumberIsNull_ALL	Number is not null then 1 else 0

66	MPT_SENDPRO_ValidRecordStatus	If valid based on the lookup against the CDE_CHAR from NW.NW_SUP_CODE_REF where CDE_GROUP=’ CDE_REC_STATUS’ then 1 else 0

10/31/25 NW.NW_SUP_CODE_REF entry for CDE_REC_STATUS missing
Using just NULL check for now

*/

CASE 
    WHEN CDE_REC_STATUS IS NULL OR CDE_REC_STATUS IN ('#','+','-') THEN 'NULL'
    --WHEN CDE_REC_STATUS NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REC_STATUS' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
    ELSE 'VALID'
END AS RecordStatus1X,

/*
12.1.33	NDC (MPT_SENDPRO_NDC_NCPDP)
•	837I Claims population:  MPT_SENDPRO_ClaimType_NCPDP
•	MPT_SENDPRO_NDC_Valid_ALL: sendpro.spro_b_enc_claim_phrm_leg_hist.cde_ndc
•	Missing String Value Parameter: MPT_StringIsNull_ALL,, IND_SCRIPT_OT <>’O’ (NDC should not be null for non-OTC Prescriptions)

50	MPT_SENDPRO_NDC_Valid_ALL	If valid based on lookup to the column CDE_NDC from "NW_B_DRUG" then 1 else 0

3	MPT_SENDPRO_StringIsNull_ALL	String is not null then 1 else 0
*/

CASE
    WHEN (IND_SCRIPT_OT = 'O') THEN 'NOT APP'
    WHEN (PHRM_CDE_NDC IS NULL OR PHRM_CDE_NDC IN ('#','+','-')) AND (IND_SCRIPT_OT <> 'O') THEN 'NULL'
    WHEN NOT EXISTS (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = PHRM_CDE_NDC AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) 
	THEN 'INVALID'
    ELSE 'VALID'
END AS NDC1X,

/*
12.1.34	Compound NDC (MPT_SENDPRO_Compound_NDC_NCPDP)
•	837I Claims population:  MPT_SENDPRO_ClaimType_NCPDP
•	MPT_SENDPRO_NDC_Valid_ALL: spro_b_enc_phrm_info_dtl_hist.cde_ndc

50	MPT_SENDPRO_NDC_Valid_ALL	If valid based on lookup to the column CDE_NDC from "NW_B_DRUG" then 1 else 0
*/

CASE
    WHEN CDE_CLM_TYPE != 'Q' THEN 'NOT APP'
    --WHEN (IND_SCRIPT_OT = 'O') OR (DTL_CDE_NDC IS NULL OR DTL_CDE_NDC IN ('#','+','-')) THEN 'NOT APP'
    WHEN (IND_SCRIPT_OT = 'O') OR (DTL_CDE_NDC IS NULL OR DTL_CDE_NDC IN ('#','+','-')) THEN 'NULL'
    WHEN NOT EXISTS (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = DTL_CDE_NDC AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) 
	THEN 'INVALID'
    ELSE 'VALID'
END AS CompoundNDC1X,

/*
12.1.35	Script Written Date (MPT_SENDPRO_Script_Written_Date_NCPDP)
•	837P Claims population: MPT_SENDPRO_ClaiimType_NCPDP 
•	MPT_SENDPRO_DateIsNotBot_ALL: spro_b_enc_claim_phrm_leg_hist. SCRIPT_WRITTEN_DTSPRO_B_ENC_DNTL_INFO_DTL_HIST.DOS_FROM_DT,, IND_SCRIPT_OT <>’O’ (NDC should not be null for non-OTC Prescriptions)
•	Valid Date value parameter: MPT_SENDPRO_DateIsNotNull_ALL: spro_b_enc_claim_phrm_leg_hist. SCRIPT_WRITTEN_DTSPRO_B_ENC_DNTL_INFO_DTL_HIST.DOS_FROM_DT,, IND_SCRIPT_OT <>’O’ (NDC should not be null for non-OTC Prescriptions)

1	MPT_SENDPRO_DateIsNotNull_ALL	Date is not null then 1 else 0

5	MPT_SENDPRO_DateIsNotBot_ALL	Date is not equal to 1/1/1900 then 1 else 0
*/

CASE 
    WHEN (IND_SCRIPT_OT = 'O') THEN 'NOT APP'
    WHEN DOS_FROM_DT IS NULL AND SCRIPT_WRITTEN_DT IS NULL THEN 'NULL'
    WHEN DOS_FROM_DT = '1900-01-01' AND SCRIPT_WRITTEN_DT = '1900-01-01' THEN 'INVALID'
    ELSE 'VALID'
    END AS ScriptWrittenDate1X,

/*
12.1.36	DAW (MPT_SENDPRO_DAW_NCPDP)
•	837I Claims population:  MPT_SENDPRO_ClaimType_NCPDP
•	Missing String Value Parameter: spro_b_enc_phrm_info_dtl_hist.CDE_DAWPROD_SEL
*/

CASE
    WHEN CDE_DAWPROD_SEL IS NULL OR CDE_DAWPROD_SEL IN ('#','+','-') THEN 'NULL'
    ELSE 'VALID'
END AS DAW1X,

/*
12.1.37	Dispense Fee (MPT_SENDPRO_DispenseFee_NCPDP)
•	ALL Claims population: MPT_SENDPRO_ClaimType_NCPDP
•	MPT_SENDPRO_NumberIsNull_ALL: spro_b_enc_claim_phrm_leg_hist. AMT_DISP_FEE

34	MPT_SENDPRO_NumberIsNull_ALL	Number is not null then 1 else 0
*/

CASE
    WHEN AMT_DISP_FEE IS NULL OR AMT_DISP_FEE < 0 THEN 'NULL'
    ELSE 'VALID'
END AS DispenseFee1X,

/*
12.1.38	Prescribing Provider Id (MPT_SENDPRO_PrescribingProviderID_NCPDP)
•	ALL Claims population: MPT_SENDPRO_ClaimType_NCPDP
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. PRESCRIBING_ENC_PRV_SEQ
*/


    CASE  
         WHEN (prescribing_ProviderInternalId IS NULL OR prescribing_ProviderInternalId IN ('#','+','-')) THEN 'NULL'
		 WHEN 
         (
              (NOT EXISTS (SELECT ENC_PROV_ID from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = prescribing_ProviderInternalId)) 
         )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS PrescribingProviderInternalId1X,


/*
12.1.39	Prescribing Provider NPI (MPT_SENDPRO_PrescribingProviderNPI__NCPDP)
•	ALL Claims population: MPT_SENDPRO_ClaimType_NCPDP
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. PRESCRIBING_ENC_PRV_SEQ
*/

    CASE  
         WHEN 
         (
                ((prescribing_ProviderNPI IS NULL) OR (prescribing_ProviderNPI IN ('#','+','-')) OR prescribing_ProviderNPI IN ('0','000000000','0000000000')) 
         )            
         THEN 'NULL'
            
         WHEN 
         (
              (NOT EXISTS (SELECT ID_NPI from mhdwqa.SENDPRO.spro_b_enc_provider_hist where ID_NPI NOT IN ('#','+','-') AND ID_NPI = prescribing_ProviderNPI))
         )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS PrescribingProviderNPI1X,

/*
12.1.40	Prescribing Provider Location (MPT_SENDPRO_PrescribingProviderLoc_ALL)
•	ALL Claims population: MPT_SENDPRO_ClaimType_NCPDP
•	MPT_SENDPRO_ValidEncProvider: SPRO_B_ENC_CLAIM_PHRM_LEG_HIST. PRESCRIBING_ENC_PRV_SEQ
*/

    CASE 
         WHEN 
         (
            (NOT EXISTS (SELECT prv.ID_PROVIDER_LOCATION from mhdwqa.SENDPRO.spro_b_enc_provider_hist as prv
        where PRESCRIBING_ENC_PRV_SEQ = prv.ENC_PRV_SEQ AND prv.ID_PROVIDER_LOCATION IS NOT NULL AND prv.ID_PROVIDER_LOCATION NOT IN ('#','+','-')))
            )
         THEN 'INVALID'
         ELSE 'VALID' 
         END AS PrescribingProviderLocation1X,

/*
12.1.41	Prescription Number (MPT_SENDPRO_PrescriptionNumber_NCPDP)
•	837I Claims population:  MPT_SENDPRO_ClaimType_NCPDP
•	Missing String Value Parameter: MPT_StringIsNull_ALL,, NUM_SCRIPT_SERV_REF

3	MPT_SENDPRO_StringIsNull_ALL	String is not null then 1 else 0
*/

CASE
    WHEN NUM_SCRIPT_SERV_REF IS NULL OR NUM_SCRIPT_SERV_REF IN (-1,-4,-5) THEN 'NULL'
    ELSE 'VALID'
END AS PrescriptionNumber1X,

/*
12.1.42	Refill Indicator (MPT_SENDPRO_RefillIndicator_NCPDP)
•	ALL Claims population: MPT_SENDPRO_ClaimType_NCPFDP
•	MPT_SENDPRO_NumberIsNull_ALL: raw_spro_ncpdp_claim.NUM_FILL 

34	MPT_SENDPRO_NumberIsNull_ALL	Number is not null then 1 else 0
*/

CASE
    WHEN NUM_REFILLS_AUTH IS NULL THEN 'NULL'
    WHEN NUM_REFILLS_AUTH < 0 THEN 'INVALID'
    ELSE 'VALID'
END AS RefillIndicator1X,

/*
12.1.43	Prescription Origin (MPT_SENDPRO_PrescriptionOriginCode_NCPDP)
•	ALL Claims population: MPT_SENDPRO_ClaimType_NCPFDP
•	Missing String Value Parameter: MPT_StringIsNull_ALL: raw_spro_ncpdp_claim. CDE_PRESC_ORIG
•	MPT_SENDPRO_ValidPrescriptionOriginCode: raw_spro_ncpdp_claim. CDE_PRESC_ORIG

3	MPT_SENDPRO_StringIsNull_ALL	String is not null then 1 else 0

67	MPT_SENDPRO_ValidPrescriptionOriginCode	If valid based on the lookup against the CDE_CHAR from NW.NW_SUP_CODE_REF where CDE_GROUP=’ CDE_PRESC_ORIG then 1 else 0

10/31/25 NW.NW_SUP_CODE_REF entry for CDE_PRESC_ORIG missing
Using just NULL check for now

*/

CASE
    WHEN CDE_PRESC_ORIG IS NULL OR CDE_PRESC_ORIG IN ('#','+','-') THEN 'NULL'
    --WHEN CDE_PRESC_ORIG NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_PRESC_ORIG' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
    ELSE 'VALID'
END AS PrescriptionOrigin1X,

/*
12.1.44	Dispense Quantity (MPT_SENDPRO_DispenseQty_NCPDP)
•	ALL Claims population: MPT_SENDPRO_ClaimType_NCPDP
•	MPT_SENDPRO_NumberIsNull_ALL: spro_b_enc_claim_phrm_leg_hist. QTY_DISPD

34	MPT_SENDPRO_NumberIsNull_ALL	Number is not null then 1 else 0

-- This field was removed.
*/
'NOT APP' AS DispenseQuantity1X,
/*
CASE
    WHEN QTY_DISPD IS NULL THEN 'NULL'
    ELSE 'VALID'
END AS DispenseQuantity1X,
*/



1 as TOT_REX

FROM (
select DISTINCT
    CURRENT_DATE() AS RUN_DATE,
    phrm.NUM_ICN,
    phrm.CDE_ENTITY_MODEL,
    phrm.CDE_ENC_MCO,
    phrm.CDE_ENC_ACO,
--    phrm.ID_SUBMITTER,
    DATE(phrm.DOS_FROM_DT) AS DOS_FROM_DT,
    phrm.CDE_CLM_TYPE,
    phrm.CDE_CLM_STATUS,
    phrm.CDE_CLM_DISPOSITION,
    phrm.IND_OFFSET,
    DATE(phrm.WH_FROM_DT) AS WH_FROM_DT,
    phrm.MD_BATCH_SEQ,

--    phrm.CDE_BILL_FREQ,
--    phrm.CDE_CONTRACT_TYPE,
    phrm.AMT_ALLOWED,
    phrm.AMT_PAID,
    phrm.AMT_BILLED,
    DATE(phrm.DOS_TO_DT) AS DOS_TO_DT,
--    phrm.ADMIT_DT_TM,
    phrm.MEM_SEQ AS FACT_MEM_SEQ,
    phrm.QTY_UNITS_BILLED,
--    phrm.DISCHARGE_DT_TM,
--    phrm.CDE_ADMIT_TYPE,
--    phrm.CDE_ADMIT_SOURCE,
--    phrm.CDE_PATIENT_STATUS,
--    phrm.CDE_TYPE_OF_BILL,
    phrm.DIAGRP_SEQ,

    phrm.BILLING_ENC_PRV_SEQ,
--    phrm.SERVICING_ENC_PRV_SEQ,
    phrm.PRESCRIBING_ENC_PRV_SEQ,
    NULL AS CDE_PLACE_OF_SERVICE,

    phrm.PROC_SEQ,

    phrm.CDE_REC_STATUS,
    phrm.CDE_NDC AS PHRM_CDE_NDC,
    phrm.IND_SCRIPT_OT,
    phrm.SCRIPT_WRITTEN_DT,
    phrm.CDE_DAWPROD_SEL,
    phrm.AMT_DISP_FEE,
    phrm.NUM_SCRIPT_SERV_REF,
    phrm.NUM_REFILLS_AUTH,
    phrm.CDE_PRESC_ORIG,
    phrm.QTY_PRESCRIBED,
-- QTY_DISPD removed 11/24/25
    NULL AS QTY_DISPD,

    prov_billing.ENC_PROV_ID AS billing_ProviderInternalId,
    prov_billing.ID_NPI AS billing_ProviderNPI,
--    prov_billing.CDE_PROVIDER_TYPE AS billing_ProviderType,

--    prov_servicing.ENC_PROV_ID AS servicing_ProviderInternalId,
--    prov_servicing.ID_NPI AS servicing_ProviderNPI,
--    prov_servicing.CDE_PROVIDER_TYPE AS servicing_ProviderType

    prov_prescribing.ENC_PROV_ID AS prescribing_ProviderInternalId,
    prov_prescribing.ID_NPI AS prescribing_ProviderNPI,
--    prov_prescribing.CDE_PROVIDER_TYPE AS prescribing_ProviderType

    CASE WHEN dtl.NUM_DTL IS NULL THEN 0 ELSE dtl.NUM_DTL END AS NUM_DTL,

--    dtl.PROC_SEQ,
--    dtl.PROCMFRGRP_SEQ,

--    dtl.CDE_CONTRACT_TYPE       AS DTL_CDE_CONTRACT_TYPE,
--    dtl.AMT_ALLOWED             AS DTL_AMT_ALLOWED,
--    dtl.AMT_PAID                AS DTL_AMT_PAID,
--    dtl.AMT_BILLED              AS DTL_AMT_BILLED,
--    dtl.BILLING_ENC_PRV_SEQ AS DTL_BILLING_ENC_PRV_SEQ,
--    dtl.SERVICING_ENC_PRV_SEQ   AS DTL_SERVICING_ENC_PRV_SEQ,
--    dtl.DOS_FROM_DT             AS DTL_DOS_FROM_DT,
--    dtl.DOS_TO_DT               AS DTL_DOS_TO_DT,
--    dtl.MEM_SEQ                 AS DTL_FACT_MEM_SEQ,
--    Removed 11/24/25
--    dtl.QTY_UNITS_BILLED        AS DTL_QTY_UNITS_BILLED,
--    dtl.DISCHARGE_DT            AS DTL_DISCHARGE_DT,

--    dtl_prov_billing.ENC_PROV_ID   AS dtl_billing_ProviderInternalId,
--    dtl_prov_billing.ID_NPI        AS dtl_billing_ProviderNPI,

--    dtl_prov_servicing.ENC_PROV_ID AS dtl_servicing_ProviderInternalId,
--    dtl_prov_servicing.ID_NPI      AS dtl_servicing_ProviderNPI

    dtl.CDE_NDC                 AS DTL_CDE_NDC


FROM MHDWQA.SENDPRO.SPRO_B_ENC_CLAIM_PHRM_LEG_HIST phrm
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PHRM_INFO_DTL_HIST dtl
    ON phrm.NUM_ICN = dtl.NUM_ICN
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_billing
    ON phrm.BILLING_ENC_PRV_SEQ = prov_billing.ENC_PRV_SEQ
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_PROVIDER_HIST prov_prescribing
    ON phrm.PRESCRIBING_ENC_PRV_SEQ = prov_prescribing.ENC_PRV_SEQ

WHERE phrm.IND_OFFSET = 'N'
AND phrm.MD_BATCH_SEQ NOT IN ( SELECT DISTINCT tar.MD_BATCH_SEQ from MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837_NCPDP tar)
 ) A;

--LIMIT 100;