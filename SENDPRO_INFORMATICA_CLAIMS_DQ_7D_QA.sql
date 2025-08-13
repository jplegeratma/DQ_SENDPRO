INSERT INTO MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7D_QA

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

		
--  DENIED STATUS
--  SUBLINE_ADJ_REASON_CD (2,3,4…) 
--  This field is in the denied list.
--  And SERVICE_LINE_AMT = 0 this should be in the denied claim file. Please refer Link

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
    AND SvcLineAdjRevenueCode IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  '))
        THEN 1 ELSE 0 END SvcLineAdjRevenueCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M','D') THEN 'NOT APP'
	     WHEN SvcLineAdjRevenueCode IS NULL THEN 'NULL'
         WHEN SvcLineAdjRevenueCode NOT IN (SELECT CDE_CHAR FROM MHDWQA.NW.NW_SUP_CODE_REF WHERE CDE_GROUP = 'CDE_REVENUE' AND CDE_CHAR NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END SvcLineAdjRevenueCode1X,



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
	    AND ProviderInternalId IN (SELECT ENC_PROV_ID from MHDWQA.NW.NW_B_ENC_PROVIDER where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ProviderInternalId)
	    AND ProviderInternalId_bp IS NOT NULL 
	    AND ProviderInternalId_bp IN (SELECT ENC_PROV_ID from MHDWQA.NW.NW_B_ENC_PROVIDER where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ProviderInternalId_bp)
        THEN 1 ELSE 0 END bill_ProviderInternalId1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ProviderInternalId IS NULL OR ProviderInternalId_bp IS NULL) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWQA.NW.NW_B_ENC_PROVIDER where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ProviderInternalId) 
         OR
         NOT EXISTS (SELECT ENC_PROV_ID from MHDWQA.NW.NW_B_ENC_PROVIDER where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ProviderInternalId_bp)
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
	    AND ProviderPidsl IN (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_ENC_PROVIDER where ID_PROVIDER NOT IN ('#','+','-') AND ID_PROVIDER = ProviderPidsl)
	    AND ProviderPidsl_bp IS NOT NULL 
	    AND ProviderPidsl_bp IN (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_ENC_PROVIDER where ID_PROVIDER NOT IN ('#','+','-') AND ID_PROVIDER = ProviderPidsl_bp)
        THEN 1 ELSE 0 END bill_ProviderPidsl1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ProviderPidsl IS NULL OR ProviderPidsl_bp IS NULL) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_ENC_PROVIDER where ID_PROVIDER NOT IN ('#','+','-') AND ID_PROVIDER = ProviderPidsl) 
         OR
         NOT EXISTS (SELECT ID_PROVIDER from MHDWQA.NW.NW_B_ENC_PROVIDER where ID_PROVIDER NOT IN ('#','+','-') AND ID_PROVIDER = ProviderPidsl_bp)
         )
         THEN 'INVALID'
         ELSE 'VALID' END bill_ProviderPidsl1X,

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
	    WHEN ref_ReferringProvNPI IS NOT NULL 
	    AND ref_ReferringProvNPI IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ref_ReferringProvNPI
        
        )
        THEN 1 ELSE 0 END ref_ReferringProvNPI1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ref_ReferringProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ref_ReferringProvNPI) )
         THEN 'INVALID'
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
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ref_ProviderInternalId
        
        )
        THEN 1 ELSE 0 END ref_ProviderInternalId1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ref_ProviderInternalId IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ref_ProviderInternalId) )
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
        AND ref_ProviderPidsl IN (SELECT enc_prov_id from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 ap 
--          WHERE enc_prov_id NOT IN ('#','+','-') 
            WHERE enc_prov_id = ref_ProviderPidsl
            AND ref_ProviderLocationCode = (
            case when length(ap.cde_enc_prov_id_loc) <3 then lpad(ap.cde_enc_prov_id_loc,3,'0')
                 when length(ap.cde_enc_prov_id_loc) >3 then substr(ap.cde_enc_prov_id_loc,0,3)
                 else ap.cde_enc_prov_id_loc 
             end)     
        )        
        THEN 1 ELSE 0 END ref_ProviderPidsl1,

--  Ex
    CASE  
         WHEN (ref_ProviderPidsl IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (
         (SELECT enc_prov_id from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 ap 
--          WHERE enc_prov_id NOT IN ('#','+','-') 
          WHERE enc_prov_id = ref_ProviderPidsl
          AND ref_ProviderLocationCode = (
            case when length(ap.cde_enc_prov_id_loc) <3 then lpad(ap.cde_enc_prov_id_loc,3,'0')
                 when length(ap.cde_enc_prov_id_loc) >3 then substr(ap.cde_enc_prov_id_loc,0,3)
                 else ap.cde_enc_prov_id_loc 
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
	    AND ren_RenderingProvNPI IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ren_RenderingProvNPI
        
        )
        THEN 1 ELSE 0 END ren_RenderingProvNPI1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ren_RenderingProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ren_RenderingProvNPI) )
         THEN 'INVALID'
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
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ren_ProviderInternalId
        
        )
        THEN 1 ELSE 0 END ren_ProviderInternalId1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (ren_ProviderInternalId IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ren_ProviderInternalId) )
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
        AND ren_ProviderPidsl IN (SELECT enc_prov_id from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 ap 
--          WHERE enc_prov_id NOT IN ('#','+','-') 
            WHERE enc_prov_id = ren_ProviderPidsl
            AND ren_ProviderLocationCode = (
            case when length(ap.cde_enc_prov_id_loc) <3 then lpad(ap.cde_enc_prov_id_loc,3,'0')
                 when length(ap.cde_enc_prov_id_loc) >3 then substr(ap.cde_enc_prov_id_loc,0,3)
                 else ap.cde_enc_prov_id_loc 
             end)     
        )        
        THEN 1 ELSE 0 END ren_ProviderPidsl1,

--  Ex
    CASE  
         WHEN (ren_ProviderPidsl IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (
         (SELECT enc_prov_id from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 ap 
--          WHERE enc_prov_id NOT IN ('#','+','-') 
          WHERE enc_prov_id = ren_ProviderPidsl
          AND ren_ProviderLocationCode = (
            case when length(ap.cde_enc_prov_id_loc) <3 then lpad(ap.cde_enc_prov_id_loc,3,'0')
                 when length(ap.cde_enc_prov_id_loc) >3 then substr(ap.cde_enc_prov_id_loc,0,3)
                 else ap.cde_enc_prov_id_loc 
             end))))         
         THEN 'INVALID'
         ELSE 'VALID' END ren_ProviderPidsl1X,

-- RAW_SPRO_837D_ASSISTANT_SURGEON_DTL
-- Not in BRD

-- NPI

--  DI
    CASE
	    WHEN asst_AssistantSurgeonProvNPI IS NOT NULL 
	    AND asst_AssistantSurgeonProvNPI IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = asst_AssistantSurgeonProvNPI
        
        )
        THEN 1 ELSE 0 END asst_AssistantSurgeonProvNPI1,

--  Ex
    CASE  
         WHEN (asst_AssistantSurgeonProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = asst_AssistantSurgeonProvNPI) )
         THEN 'INVALID'
         ELSE 'VALID' END asst_AssistantSurgeonProvNPI1X,

-- InternalID

--  DI
    CASE
	    WHEN asst_ProviderInternalId IS NOT NULL 
	    AND asst_ProviderInternalId IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = asst_ProviderInternalId
        
        )
        THEN 1 ELSE 0 END asst_ProviderInternalId1,

--  Ex
    CASE  
         WHEN (asst_ProviderInternalId IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = asst_ProviderInternalId) )
         THEN 'INVALID'
         ELSE 'VALID' END asst_ProviderInternalId1X,

-- PIDSL

-- DI
    CASE
	    WHEN asst_ProviderPidsl IS NOT NULL
        AND asst_ProviderPidsl IN (SELECT enc_prov_id from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 ap 
--          WHERE enc_prov_id NOT IN ('#','+','-') 
            WHERE enc_prov_id = asst_ProviderPidsl
            AND asst_ProviderLocationCode = (
            case when length(ap.cde_enc_prov_id_loc) <3 then lpad(ap.cde_enc_prov_id_loc,3,'0')
                 when length(ap.cde_enc_prov_id_loc) >3 then substr(ap.cde_enc_prov_id_loc,0,3)
                 else ap.cde_enc_prov_id_loc 
             end)     
        )        
        THEN 1 ELSE 0 END asst_ProviderPidsl1,

--  Ex
    CASE  
         WHEN (asst_ProviderPidsl IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (
         (SELECT enc_prov_id from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 ap 
--          WHERE enc_prov_id NOT IN ('#','+','-') 
          WHERE enc_prov_id = asst_ProviderPidsl
          AND asst_ProviderLocationCode = (
            case when length(ap.cde_enc_prov_id_loc) <3 then lpad(ap.cde_enc_prov_id_loc,3,'0')
                 when length(ap.cde_enc_prov_id_loc) >3 then substr(ap.cde_enc_prov_id_loc,0,3)
                 else ap.cde_enc_prov_id_loc 
             end))))         
         THEN 'INVALID'
         ELSE 'VALID' END asst_ProviderPidsl1X,

-- RAW_SPRO_837D_SUPERVISING_PROVIDER_DTL
-- not in BRD

-- NPI

--  DI
    CASE
	    WHEN sup_SupervisingProvNPI IS NOT NULL 
	    AND sup_SupervisingProvNPI IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = sup_SupervisingProvNPI
        
        )
        THEN 1 ELSE 0 END sup_SupervisingProvNPI1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (sup_SupervisingProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = sup_SupervisingProvNPI) )
         THEN 'INVALID'
         ELSE 'VALID' END sup_SupervisingProvNPI1X,

-- InternalID

--  DI
    CASE
    --all Claim_Types
	    WHEN sup_ProviderInternalId IS NOT NULL 
	    AND sup_ProviderInternalId IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = sup_ProviderInternalId
        
        )
        THEN 1 ELSE 0 END sup_ProviderInternalId1,

--  Ex
    CASE  
    --all Claim_Types
         WHEN (sup_ProviderInternalId IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = sup_ProviderInternalId) )
         THEN 'INVALID'
         ELSE 'VALID' END sup_ProviderInternalId1X,

-- PIDSL

-- DI
    CASE
	    WHEN sup_ProviderPidsl IS NOT NULL
        AND sup_ProviderPidsl IN (SELECT enc_prov_id from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 ap 
--          WHERE enc_prov_id NOT IN ('#','+','-') 
            WHERE enc_prov_id = sup_ProviderPidsl
            AND sup_ProviderLocationCode = (
            case when length(ap.cde_enc_prov_id_loc) <3 then lpad(ap.cde_enc_prov_id_loc,3,'0')
                 when length(ap.cde_enc_prov_id_loc) >3 then substr(ap.cde_enc_prov_id_loc,0,3)
                 else ap.cde_enc_prov_id_loc 
             end)     
        )        
        THEN 1 ELSE 0 END sup_ProviderPidsl1,

--  Ex
    CASE  
         WHEN (sup_ProviderPidsl IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (
         (SELECT enc_prov_id from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 ap 
--          WHERE enc_prov_id NOT IN ('#','+','-') 
          WHERE enc_prov_id = sup_ProviderPidsl
          AND sup_ProviderLocationCode = (
            case when length(ap.cde_enc_prov_id_loc) <3 then lpad(ap.cde_enc_prov_id_loc,3,'0')
                 when length(ap.cde_enc_prov_id_loc) >3 then substr(ap.cde_enc_prov_id_loc,0,3)
                 else ap.cde_enc_prov_id_loc 
             end))))         
         THEN 'INVALID'
         ELSE 'VALID' END sup_ProviderPidsl1X,

         
--  ALL RECORDS
    1 AS TOT_REX

FROM (
select * from (

select DISTINCT
CURRENT_DATE() AS RUN_DATE,
h."TransSetControlNum" as TransSetControlNum,
-- h."ImplementationConventionRef" as ImplementationConventionRef,
h."SubmitterID" as SubmitterID,
h."PatientControlNum" as PatientControlNum,
to_number(d."NumDtl",4,0) as NumDtl,
h."FileName" as FileName,

 'D' as Claim_Type,

h."ClaimFrequencyCode" as ClaimFrequencyCode,

    CASE
        WHEN h."ClaimFrequencyCode" IN ('1','2','3','4','5') THEN 'O'
        WHEN h."ClaimFrequencyCode" IN ('7') THEN 'A'
        WHEN h."ClaimFrequencyCode" IN ('8') THEN 'V'
        ELSE 'X'
    END AS Record_Type,

to_number(d."SvcLineChargeAmt", 12,2) as SvcLineChargeAmt,
-- a."AdjReasonCode01" as AdjReasonCode01,

h."BillingProvNPI" as BillingProvNPI,
h."ContractTypeCode" as ContractTypeCode,

CASE WHEN LEFT(a."SvcLineAdjRevenueCode",1) != '0' then a."SvcLineAdjRevenueCode" ELSE SUBSTR(a."SvcLineAdjRevenueCode",2,3) END as SvcLineAdjRevenueCode,

-- Billing Provider
trim(h."ProviderInternalId") as ProviderInternalId,
trim(h."ProviderPidsl") as ProviderPidsl,

trim(bp."ProviderInternalId") as ProviderInternalId_bp,
trim(bp."ProviderPidsl") as ProviderPidsl_bp,

trim(ref."ReferringProvNPI")      as ref_ReferringProvNPI,
trim(ref."ProviderInternalId")    as ref_ProviderInternalId,
trim(ref."ProviderPidsl")         as ref_ProviderPidsl,
trim(ref."ProviderLocationCode")  as ref_ProviderLocationCode,

trim(ren."RenderingProvNPI")      as ren_RenderingProvNPI,
trim(ren."ProviderInternalId")    as ren_ProviderInternalId,
trim(ren."ProviderPidsl")         as ren_ProviderPidsl,
trim(ren."ProviderLocationCode")  as ren_ProviderLocationCode,

trim(sup."SupervisingProvNPI")    as sup_SupervisingProvNPI,
trim(sup."ProviderInternalId")    as sup_ProviderInternalId,
trim(sup."ProviderPidsl")         as sup_ProviderPidsl,
trim(sup."ProviderLocationCode")  as sup_ProviderLocationCode,

trim(asst."AssistantSurgeonProvNPI") as asst_AssistantSurgeonProvNPI,
trim(asst."ProviderInternalId")      as asst_ProviderInternalId,
trim(asst."ProviderPidsl")           as asst_ProviderPidsl,
trim(asst."ProviderLocationCode")    as asst_ProviderLocationCode

from MHDWQA.SENDPRO.RAW_SPRO_837D_CLAIM as h

left join MHDWQA.SENDPRO.RAW_SPRO_837D_CLAIM_SERVICE_DTL as d
on  h."TransSetControlNum" = d."TransSetControlNum"
and h."SubmitterID"        = d."SubmitterID"
and h."PatientControlNum"  = d."PatientControlNum"

left join MHDWQA.SENDPRO.RAW_SPRO_837D_CLAIM_SVCLN_ADJUDICATION_DTL as a
on  h."TransSetControlNum" = a."TransSetControlNum"
-- and h."SubmitterID"        = a."SubmitterID"
and h."PatientControlNum"  = a."PatientControlNum"
and d."NumDtl"             = a."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837D_BILLING_PROVIDER_DTL bp
on bp."TransSetControlNum"  = h."TransSetControlNum" and
   bp."SendProTransId"      = h."SendProTransId" and
   bp.RAW_SPRO_BPROV_SEQ    = h.RAW_SPRO_BPROV_SEQ

left join MHDWQA.SENDPRO.RAW_SPRO_837D_REFERRING_PROVIDER_DTL ref
on h."FileName"         = ref."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = ref.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ref."PatientControlNum" and
   h."NumDtl"           = ref."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837D_RENDERING_PROVIDER_DTL ren
on h."FileName"         = ren."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = ren.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ren."PatientControlNum" and
   h."NumDtl"           = ren."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837D_ASSISTANT_SURGEON_DTL asst
on h."FileName"         = asst."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = asst.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= asst."PatientControlNum" and
   h."NumDtl"           = asst."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837D_SUPERVISING_PROVIDER_DTL sup
on h."FileName"         = sup."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = sup.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= sup."PatientControlNum" and
   h."NumDtl"           = sup."NumDtl"
   
order by
    TransSetControlNum,
--    ImplementationConventionRef,
    h."SubmitterID",
    FileName,
    h."PatientControlNum",
    to_number(d."NumDtl",4,0)
));
