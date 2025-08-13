INSERT INTO MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA
SELECT DISTINCT
RUN_DATE,
claim_type,
SendProTransId,
PAHdrSendingEntityID,
PAHdrBatchNum,
Filename,
SubscriberMemberID,
Numdtl,
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

--  NCPDP- Cardholder Id
/*
Cardholder Id (MPT_SENDPRO_CardholderID_NCPDP)
4.1.1.5.	All Claims population: MPT_SENDPRO_ClaimType_NCPDP
4.1.1.6.	MPT_SENDPRO_CARDHOLDERID_Valid: raw_spro_ncpdp_header.SubscriberMemberID
4.1.1.7.	Missing String Value Parameter: MP_SENDPRO_StringIsNull_ALL,

MPT_SENDPRO_CARDHOLDERID_Valid	If valid based on the lookup against the ID_MEDICAID from NW.NW_MEMBER then 1 else 0

*/

--  DI
    CASE WHEN Claim_Type IN ('P')     
	AND SubscriberMemberID IS NOT NULL 
	AND SubscriberMemberID IN (SELECT ID_MEDICAID FROM MHDWQA.NW.NW_MEMBER WHERE ID_MEDICAID = SubscriberMemberID AND ID_MEDICAID NOT IN ('#','**','+','-','$','  '))
    THEN 1 ELSE 0 END SubscriberMemberID1,


--  Ex
    CASE WHEN Claim_Type NOT IN ('P') THEN 'NOT PHARMACY'
	     WHEN SubscriberMemberID IS NULL THEN 'NULL'
         WHEN NOT EXISTS (SELECT ID_MEDICAID FROM MHDWQA.NW.NW_MEMBER WHERE ID_MEDICAID = SubscriberMemberID AND ID_MEDICAID NOT IN ('#','**','+','-','$','  ')) 
			  THEN 'INVALID'
         ELSE 'VALID' END SubscriberMemberID1X,
         
/*
--  Ex
    CASE WHEN Claim_Type NOT IN ('P') THEN 'NOT PHARMACY'
	     WHEN SubscriberMemberID IS NULL THEN 'NULL'
         WHEN SubscriberMemberID NOT IN (SELECT ID_MEDICAID FROM MHDWQA.NW.NW_MEMBER WHERE ID_MEDICAID = SubscriberMemberID AND ID_MEDICAID NOT IN ('#','**','+','-','$','  ')) 
			  THEN 'INVALID'
         ELSE 'VALID' END SubscriberMemberID1X,

'VALID' AS SubscriberMemberID1X,
*/

--  NCPDP- NDC
/*
12.7.18.	NDC (MPT_SENDPRO_NDC)
4.1.1.13.	837I Claims population:  MPT_SENDPRO_ClaimType_NCPDP
4.1.1.14.	MPT_SENDPRO_NDC_Valid_ALL: STG_SPRO_NCPDP_HEADER.NDCServ,
STG_SPRO_NCPDP_HEADER.ProdCode01,
STG_SPRO_NCPDP_HEADER.ProdCode02,
STG_SPRO_NCPDP_HEADER.ProdCode03
4.1.1.15.	MPT_SENDPRO_StringIsNull_ALL: STG_SPRO_NCPDP_HEADER.NDCServ,
STG_SPRO_NCPDP_HEADER.ProdCode01,
STG_SPRO_NCPDP_HEADER.ProdCode02,
STG_SPRO_NCPDP_HEADER.ProdCode03

MPT_SENDPRO_StringIsNull_ALL

MPT_SENDPRO_ClaimType_NCPDP

MPT_SENDPRO_NDC_Valid_ALL

MPT_SENDPRO_NDC_Valid_ALL	If valid based on lookup to the column CDE_NDC from "NW_B_DRUG" then 1 else 0

*/

--  DI
    CASE WHEN Claim_Type IN ('P')     
	AND 
	( 
	( NDCServ IS NOT NULL
        AND NDCServ IN (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = NDCServ AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( ProdCode01 IS NOT NULL
        AND ProdCode01 IN (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = ProdCode01 AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( ProdCode02 IS NOT NULL
        AND ProdCode02 IN (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = ProdCode02 AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( ProdCode03 IS NOT NULL
        AND ProdCode03 IN (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = ProdCode03 AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) )
	)	
        THEN 1 ELSE 0 END NDCServ1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('P') THEN 'NOT PHARMACY'
    WHEN NDCServ IS NULL AND ProdCode01 IS NULL AND ProdCode02 IS NULL AND ProdCode02 IS NULL THEN 'NULL'
         WHEN NOT EXISTS (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = NDCServ AND CDE_NDC NOT IN ('#','**','+','-','$','  '))
             AND NOT EXISTS (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = ProdCode01 AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) 
             AND NOT EXISTS (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = ProdCode02 AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) 
             AND NOT EXISTS (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = ProdCode03 AND CDE_NDC NOT IN ('#','**','+','-','$','  '))
         THEN 'INVALID'
         ELSE 'VALID' END NDCServ1X,
         
--  NCPDP- NDC
/*
12.7.21.	Compound NDC (MPT_SENDPRO_Compound_NDC)
4.1.1.18.	837I Claims population:  MPT_SENDPRO_ClaimType_NCPDP
4.1.1.19.	MPT_SENDPRO_NDC_Valid_ALL: 
STG_SPRO_NCPDP_COMPOUND_DETAIL.CompndProdCode03,
STG_SPRO_NCPDP_COMPOUND_DETAIL.CompndProdCode02,
STG_SPRO_NCPDP_COMPOUND_DETAIL.CompndProdCode01

MPT_SENDPRO_NDC_Valid_ALL	If valid based on lookup to the column CDE_NDC from "NW_B_DRUG" then 1 else 0

*/

--  DI
    CASE WHEN Claim_Type IN ('P')     
	AND 
	( 
	( CompndProdCode01 IS NOT NULL
        AND CompndProdCode01 IN (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = CompndProdCode01 AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( CompndProdCode02 IS NOT NULL
        AND CompndProdCode02 IN (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = CompndProdCode02 AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) )
	OR 
	( CompndProdCode03 IS NOT NULL
        AND CompndProdCode03 IN (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = CompndProdCode03 AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) )
	)	
        THEN 1 ELSE 0 END CompndProdCode1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('P') THEN 'NOT PHARMACY'
	     WHEN CompndProdCode01 IS NULL AND CompndProdCode02 IS NULL AND CompndProdCode03 IS NULL THEN 'NULL'
         WHEN     NOT EXISTS (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = CompndProdCode01 AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) 
              AND NOT EXISTS (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = CompndProdCode02 AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) 
              AND NOT EXISTS (SELECT CDE_NDC FROM MHDWQA.NW.NW_B_DRUG WHERE CDE_NDC = CompndProdCode03 AND CDE_NDC NOT IN ('#','**','+','-','$','  ')) 			  
			  THEN 'INVALID'
         ELSE 'VALID' END CompndProdCode1X,

/*
         
12.1.31	xAdjudication Date (MPT_SENDPRO_Adjudication_Date)
MPT_SENDPRO_ClaiimType_NCPDP
MPT_SENDPRO_Valid_Adjudication_Date: RAW_SPRO_NCPDP_CLAIM.AdjudicationDate

MPT_SENDPRO_Validate_Adjudication_Date	NCPDP:
Step 1: Lookup SENDPRO.RAW_SPRO_NCPDP_CLAIM OrigClm based on SENDPRO.RAW_SPRO_NCPDP_CLAIM newClaim. TransIDCrossRef = OrigClm. TransID and Obtain AdjudicationDate

Step 2: If newClaim.AdjudicationDate > OrigClm. AdjudicationDate Then 1 else 0 end

*/

--SELECT

--  DI
    CASE WHEN Claim_Type IN ('P')     
	AND AdjudicationDate IS NOT NULL
-- doesn't work
--    AND AdjudicationDate >= (SELECT NVL((SELECT "AdjudicationDate" FROM MHDWQA.SENDPRO.RAW_SPRO_NCPDP_CLAIM i WHERE TransIDCrossRef = i."TransID"),'19700101'))
--    THEN 1 ELSE 0 END AdjudicationDate1,

-- sugseted by Snowflake copilot
    AND AdjudicationDate >= COALESCE((SELECT MAX(i."AdjudicationDate") FROM MHDWQA.SENDPRO.RAW_SPRO_NCPDP_CLAIM AS i WHERE i."TransID" = TransIDCrossRef), '19700101') 
    THEN 1 ELSE 0 END AdjudicationDate1,

--  Ex
    CASE WHEN Claim_Type NOT IN ('P') THEN 'NOT PHARMACY'
	     WHEN AdjudicationDate IS NULL THEN 'NULL'
--         WHEN AdjudicationDate < (SELECT NVL((SELECT "AdjudicationDate" FROM MHDWQA.SENDPRO.RAW_SPRO_NCPDP_CLAIM i WHERE TransIDCrossRef = i."TransID"),'19700101'))
--			  THEN 'INVALID'

-- suggested by Snowflake copilot
         WHEN AdjudicationDate < COALESCE((SELECT MAX(i."AdjudicationDate") FROM MHDWQA.SENDPRO.RAW_SPRO_NCPDP_CLAIM AS i WHERE i."TransID" = TransIDCrossRef), '19700101') 
         THEN 'INVALID'
    ELSE 'VALID' END AdjudicationDate1X,


--  NCPDP- Service Provider Id
-- replaced with 12.1.46
/*
  Service Provider Id (MPT_SENDPRO_ServiceProviderID_NCPDP)
4.1.1.1.	NCPDP Claims population: MPT_SENDPRO_ClaimType_NCPDP
4.1.1.2.	Missing String Value Parameter: MPT_SENDPRO_StringIsNull_ALL, ServProvNPI
4.1.1.3.	MPT_SENDPRO_ProviderNPINull_ALL
4.1.1.4.	MPT_SENDPRO_ProviderNPIValid, SERVICE_PROV_ID

Claims have claim type=’P’ then 1 else 0

MPT_SENDPRO_ProviderNPINull_ALL	(null)','0','000000000','0000000000')

MPT_SENDPRO_ProviderNPIValid_ ALL	If valid NPI determined by performing a look up to the following tables 
1.	NW_B_PROVIDER_NPPES on the field "NPI" 
2.	NW_PROVIDER_ID_NPI on the field ID_PROVIDER_OTHER where DSC_PROV_ID_TYPE = 'NPI - National Provider ID'
3.	NW_ENC_PROVIDER on the field NPI 
If valid then 1 else 0

12.1.46	Servicing Provider NPI (MPT_SENDPRO_ServicingProviderNPI_NCPDP)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_NCPDP 
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_NCPDP_CLAIM. ServProvNPI

MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
If valid then 1 else 0

*/

--  DI
    CASE
	    WHEN ServProvNPI IS NOT NULL 
	    AND ServProvNPI IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ServProvNPI
        
        )
        THEN 1 ELSE 0 END ServProvNPI1,

--  Ex
    CASE  
         WHEN (ServProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ServProvNPI) )
         THEN 'INVALID'
         ELSE 'VALID' END ServProvNPI1X,

/*

12.1.47	Servicing Provider ID (MPT_SENDPRO_ServicingProviderID_NCPDP)
•	ALL Claims population: MPT_SENDPRO_ClaimType_NCPDP
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_NCPDP_CLAIM. ServProvSecID, 

MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
If valid then 1 else 0

*/

--  DI
    CASE
	    WHEN ServProvSecID IS NOT NULL 
	    AND ServProvSecID IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ServProvSecID
        
        )
        THEN 1 ELSE 0 END ServProvSecID1,

--  Ex
    CASE  
         WHEN (ServProvSecID IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ServProvSecID) )
         THEN 'INVALID'
         ELSE 'VALID' END ServProvSecID1X,

/*

12.1.48	Prescriber Provider NPI (MPT_SENDPRO_ PrescriberProviderNPI_NCPDP)
•	ALL Claims population: MPT_SENDPRO_ClaimType_837I_INP, MPT_SENDPRO_ClaimType_NCPDP 
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_NCPDP_CLAIM. PrescriberNPI

MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
If valid then 1 else 0

*/

--  DI
    CASE
	    WHEN PrescriberNPI IS NOT NULL 
	    AND PrescriberNPI IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = PrescriberNPI
        
        )
        THEN 1 ELSE 0 END PrescriberNPI1,

--  Ex
    CASE  
         WHEN (PrescriberNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = PrescriberNPI) )
         THEN 'INVALID'
         ELSE 'VALID' END PrescriberNPI1X,

/*

12.1.49	Prescriber Provider ID (MPT_SENDPRO_ PrescriberProviderID_ NCPDP)
•	ALL Claims population: MPT_SENDPRO_ClaimType_NCPDP
•	MPT_SENDPRO_ProviderInternalId_Valid: RAW_SPRO_NCPDP_CLAIM. PrescriberSecID, 

MPT_SENDPRO_ProviderInternalId_Valid	Validity of Internal ID determined by performing a look up to the following tables 
1.	SENDPRO.SPRO_B_ENC837_PROVIDER_HIST on the field ENC_PROV_ID 
If valid then 1 else 0


*/

--  DI
    CASE
	    WHEN PrescriberSecID IS NOT NULL 
	    AND PrescriberSecID IN (
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = PrescriberSecID
        
        )
        THEN 1 ELSE 0 END PrescriberSecID1,

--  Ex
    CASE  
         WHEN (PrescriberSecID IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc837_provider_hist_05082025 where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = PrescriberSecID) )
         THEN 'INVALID'
         ELSE 'VALID' END PrescriberSecID1X,

    --  ALL RECORDS

    1 AS TOT_REX

FROM (
SELECT
    'P' AS claim_type,
    CURRENT_DATE() AS run_date,
	h."SendProTransId" as SendProTransId,
	h."PAHdrSendingEntityID" as PAHdrSendingEntityID,
    h."PAHdrBatchNum" as PAHdrBatchNum,
    h."FileName" as Filename,
    "DOS" AS DOS,
    h."SubscriberMemberID" as SubscriberMemberID,
    '1' as Numdtl,
    --cd."NumDtl" as Numdtl,
	REPLACE("NDCServ",'-','') as NDCServ,
	REPLACE("ProdCode01",'-','') as ProdCode01,
	REPLACE("ProdCode01",'-','') as ProdCode02,
	REPLACE("ProdCode01",'-','') as ProdCode03,
	REPLACE(cd."CompndProdCode01",'-','') as CompndProdCode01,
	REPLACE(cd."CompndProdCode02",'-','') as CompndProdCode02,
	REPLACE(cd."CompndProdCode03",'-','') as CompndProdCode03,	
    h."AdjudicationDate" as AdjudicationDate,
    h."TransID" as TransID,
    h."TransIDCrossRef" as TransIDCrossRef,
    trim(h."ServProvNPI")     as ServProvNPI,
    trim(h."ServProvSecID")   as ServProvSecID,
    trim(h."PrescriberNPI")   as PrescriberNPI,
    trim(h."PrescriberSecID") as PrescriberSecID

    FROM MHDWQA.SENDPRO.RAW_SPRO_NCPDP_CLAIM h

    LEFT JOIN MHDWQA.SENDPRO.RAW_SPRO_NCPDP_COMPOUND_DTL cd
    ON  h."SendProTransId"       = cd."SendProTransId" 
    AND h."FileName"             = cd."FileName" 
    AND h."PAHdrSendingEntityID" = cd."PAHdrSendingEntityID"   
);
