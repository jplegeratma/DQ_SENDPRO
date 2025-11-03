
DROP VIEW MHTEAM.DWDQ.INF_SENDPRO_TARGET_837I_UNPIV_DETAIL;

CREATE VIEW INF_SENDPRO_TARGET_837I_UNPIV_DETAIL
AS

SELECT DISTINCT 
               a.RUN_DATE, 
               a.CDE_ENTITY_MODEL, 
               a.CDE_ENC_MCO, 
               a.CDE_ENC_ACO, 
               a.CLAIM_TYPE, 
               a.CDE_CLM_DISPOSITION, 
               a.CDE_CLM_STATUS, 
               a.MD_BATCH_SEQ, 
               a.MEASURE, 
               a.TYPE, 
               a.NUM_ICN, 
               a.NUM_DTL,
               a.RNK,
               s.FILE_NAME, 
               s.PROCESS_START_TM
FROM (


-- limit rank to 10 lines
-- 10/14/2024 - limit to 3 lines
SELECT DISTINCT 
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL,
               RNK

FROM (
-- rank
  SELECT 
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL,
                                          RANK ()
                                            OVER (PARTITION BY RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MD_BATCH_SEQ,
                                                               MEASURE
                                                  ORDER BY
                                                               RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MD_BATCH_SEQ,
                                                               MEASURE,
                                                               TYPE,
                                                               NUM_ICN,
                                                               NUM_DTL)    AS rnk

  FROM (

-- only first claim line

SELECT 

               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL
  FROM (

-- core unpiv

        SELECT 
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL

        FROM (
            SELECT
                RUN_DATE,
                CDE_ENTITY_MODEL, 
                CDE_ENC_MCO, 
                CDE_ENC_ACO, 
                CLAIM_TYPE,
                CDE_CLM_DISPOSITION,
                CDE_CLM_STATUS,
                MD_BATCH_SEQ,
                ClaimFrequencyTypeCode1X AS Claim_Frequency_Code,
                ClaimContractTypeCode1X AS Claim_Contract_Type_Code,
                ClaimAllowableAmount1X AS Allowed_Amount,
                ClaimPaidAmount1X AS Paid_Amount,
                ClaimBilledAmount1X AS Billed_Amount,
                BillingProviderInternalId1X AS Bill_Provider_Internal_ID,
                BillingProviderNPI1X AS Bill_Provider_NPI,
                BillingProviderTaxonomy1X AS Bill_Provider_Taxonomy,
                BillingInternalProviderAddressLocation1X AS Billing_Provider_PIDSL,
                ServicingProviderInternalId1X AS Servicing_Provider_Internal_ID,
                ServicingProviderNPI1X AS Servicing_Provider_NPI,
                ServicingProviderType1X AS Servicing_Provider_Type,
                ServicingProviderLocation1X AS Servicing_Provider_Location,
                ServicingProviderTaxonomy1X AS Servicing_Provider_Taxonomy,
                ServicingInternalProviderAddressLocation1X AS Servicing_Provider_PIDSL,
                FromServiceDate1X AS Statement_Date,
                ToServiceDate1X AS To_Service_Date,
                AdmissionDate1X AS Admission_Date,
                MemberID1X AS Member_ID,
                QuantityBilled1X AS Quantity_Billed,
                AdmittingDiagnosisCode1X AS Admitting_Diagnosis_Code,
                PrimaryDiagnosisCode1X AS Principal_Diag_Code,
                DischargeDate1X AS Discharge_Date,
                TypeOfAdmission1X AS Admission_Type_Code,
                SourceOfAdmission1X AS Admission_Source_Code,
                PatientStatusCode1X AS Patient_Status_Code,
                FacilityTypeCode1X AS Facility_Type_Code,
                ProcedureCode1X AS Procedure_Code,
                ProcedureModCode1X AS Procedure_Mod_Code,
                PlaceOfServiceCode1X AS Place_Of_Service_Code,
                PricingMethod1X AS Pricing_Method_Code,
                NUM_ICN,
                NUM_DTL
            FROM MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837I
        )
        UNPIVOT (
            TYPE
            FOR MEASURE IN (
                Claim_Frequency_Code,
                Claim_Contract_Type_Code,
                Allowed_Amount,
                Paid_Amount,
                Billed_Amount,
                Bill_Provider_Internal_ID,
                Bill_Provider_NPI,
                Bill_Provider_Taxonomy,
                Billing_Provider_PIDSL,
                Servicing_Provider_Internal_ID,
                Servicing_Provider_NPI,
                Servicing_Provider_Type,
                Servicing_Provider_Location,
                Servicing_Provider_Taxonomy,
                Servicing_Provider_PIDSL,
                Statement_Date,
                To_Service_Date,
                Admission_Date,
                Member_ID,
                Quantity_Billed,
                Admitting_Diagnosis_Code,
                Principal_Diag_Code,
                Discharge_Date,
                Admission_Type_Code,
                Admission_Source_Code,
                Patient_Status_Code,
                Facility_Type_Code,
                Procedure_Code,
                Procedure_Mod_Code,
                Place_Of_Service_Code,
                Pricing_Method_Code
            )
) AS UNPIV7I
ORDER BY RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MEASURE, TYPE

-- only first claim line
)
WHERE NUM_DTL = 1    
)
-- add rank
)
-- limit rank to 3 lines
WHERE rnk <= 3

ORDER BY 
                                                               RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MEASURE,
                                                               TYPE,
                                                               NUM_ICN,
                                                               RNK
) AS A
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_STATISTIC S ON A.MD_BATCH_SEQ = s.MD_BATCH_SEQ_SPRO;
-----------------

DROP VIEW INF_SENDPRO_TARGET_837M_UNPIV_DETAIL;

CREATE VIEW INF_SENDPRO_TARGET_837M_UNPIV_DETAIL
AS

SELECT DISTINCT 
               a.RUN_DATE, 
               a.CDE_ENTITY_MODEL, 
               a.CDE_ENC_MCO, 
               a.CDE_ENC_ACO, 
               a.CLAIM_TYPE, 
               a.CDE_CLM_DISPOSITION, 
               a.CDE_CLM_STATUS, 
               a.MD_BATCH_SEQ, 
               a.MEASURE, 
               a.TYPE, 
               a.NUM_ICN, 
               a.NUM_DTL,
               a.RNK,
               s.FILE_NAME, 
               s.PROCESS_START_TM
FROM (


-- limit rank to 10 lines
SELECT DISTINCT 
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL,
               RNK

FROM (
-- rank
  SELECT 
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL,
                                          RANK ()
                                            OVER (PARTITION BY RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MD_BATCH_SEQ,
                                                               MEASURE
                                                  ORDER BY
                                                               RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MD_BATCH_SEQ,
                                                               MEASURE,
                                                               TYPE,
                                                               NUM_ICN,
                                                               NUM_DTL)    AS rnk

  FROM (

-- only first claim line

SELECT 

               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL
  FROM (

-- core unpiv

        SELECT 
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL

        FROM (
            SELECT
                RUN_DATE,
                CDE_ENTITY_MODEL, 
                CDE_ENC_MCO, 
                CDE_ENC_ACO, 
                CLAIM_TYPE,
                CDE_CLM_DISPOSITION,
                CDE_CLM_STATUS,
                MD_BATCH_SEQ,
                ClaimFrequencyTypeCode1X AS Claim_Frequency_Code,
                ClaimContractTypeCode1X AS Claim_Contract_Type_Code,
                ClaimAllowableAmount1X AS Allowed_Amount,
                ClaimPaidAmount1X AS Paid_Amount,
                ClaimBilledAmount1X AS Billed_Amount,
                BillingProviderInternalId1X AS Bill_Provider_Internal_ID,
                BillingProviderNPI1X AS Bill_Provider_NPI,
                BillingProviderTaxonomy1X AS Bill_Provider_Taxonomy,
                BillingInternalProviderAddressLocation1X AS Billing_Provider_PIDSL,
                ServicingProviderInternalId1X AS Servicing_Provider_Internal_ID,
                ServicingProviderNPI1X AS Servicing_Provider_NPI,
                ServicingProviderType1X AS Servicing_Provider_Type,
                ServicingProviderLocation1X AS Servicing_Provider_Location,
                ServicingProviderTaxonomy1X AS Servicing_Provider_Taxonomy,
                ServicingInternalProviderAddressLocation1X AS Servicing_Provider_PIDSL,
                FromServiceDate1X AS Statement_Date,
                ToServiceDate1X AS To_Service_Date,
                AdmissionDate1X AS Admission_Date,
                MemberID1X AS Member_ID,
                QuantityBilled1X AS Quantity_Billed,
                AdmittingDiagnosisCode1X AS Admitting_Diagnosis_Code,
                PrimaryDiagnosisCode1X AS Principal_Diag_Code,
                DischargeDate1X AS Discharge_Date,
                TypeOfAdmission1X AS Admission_Type_Code,
                SourceOfAdmission1X AS Admission_Source_Code,
                PatientStatusCode1X AS Patient_Status_Code,
                FacilityTypeCode1X AS Facility_Type_Code,
                ProcedureCode1X AS Procedure_Code,
                ProcedureModCode1X AS Procedure_Mod_Code,
                PlaceOfServiceCode1X AS Place_Of_Service_Code,
                PricingMethod1X AS Pricing_Method_Code,
                NUM_ICN,
                NUM_DTL
            FROM MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837M
        )
        UNPIVOT (
            TYPE
            FOR MEASURE IN (
                Claim_Frequency_Code,
                Claim_Contract_Type_Code,
                Allowed_Amount,
                Paid_Amount,
                Billed_Amount,
                Bill_Provider_Internal_ID,
                Bill_Provider_NPI,
                Bill_Provider_Taxonomy,
                Billing_Provider_PIDSL,
                Servicing_Provider_Internal_ID,
                Servicing_Provider_NPI,
                Servicing_Provider_Type,
                Servicing_Provider_Location,
                Servicing_Provider_Taxonomy,
                Servicing_Provider_PIDSL,
                Statement_Date,
                To_Service_Date,
                Admission_Date,
                Member_ID,
                Quantity_Billed,
                Admitting_Diagnosis_Code,
                Principal_Diag_Code,
                Discharge_Date,
                Admission_Type_Code,
                Admission_Source_Code,
                Patient_Status_Code,
                Facility_Type_Code,
                Procedure_Code,
                Procedure_Mod_Code,
                Place_Of_Service_Code,
                Pricing_Method_Code
            )
) AS UNPIV7M
ORDER BY RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MEASURE, TYPE

-- only first claim line
)
WHERE NUM_DTL = 1    
)
-- add rank
)
-- limit rank to 10 line
WHERE rnk <= 10

ORDER BY 
                                                               RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MEASURE,
                                                               TYPE,
                                                               NUM_ICN,
                                                               RNK
) AS A
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_STATISTIC S ON A.MD_BATCH_SEQ = s.MD_BATCH_SEQ_SPRO;

-----------------

DROP VIEW INF_SENDPRO_TARGET_837D_UNPIV_DETAIL;

CREATE VIEW INF_SENDPRO_TARGET_837D_UNPIV_DETAIL
AS

SELECT DISTINCT 
               a.RUN_DATE, 
               a.CDE_ENTITY_MODEL, 
               a.CDE_ENC_MCO, 
               a.CDE_ENC_ACO, 
               a.CLAIM_TYPE, 
               a.CDE_CLM_DISPOSITION, 
               a.CDE_CLM_STATUS, 
               a.MD_BATCH_SEQ, 
               a.MEASURE, 
               a.TYPE, 
               a.NUM_ICN, 
               a.NUM_DTL,
               a.RNK,
               s.FILE_NAME, 
               s.PROCESS_START_TM
FROM (


-- limit rank to 10 lines
SELECT DISTINCT 
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL,
               RNK

FROM (
-- rank
  SELECT 
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL,
                                          RANK ()
                                            OVER (PARTITION BY RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MD_BATCH_SEQ,
                                                               MEASURE
                                                  ORDER BY
                                                               RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MD_BATCH_SEQ,
                                                               MEASURE,
                                                               TYPE,
                                                               NUM_ICN,
                                                               NUM_DTL)    AS rnk

  FROM (

-- only first claim line

SELECT 

               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL
  FROM (

-- core unpiv

        SELECT 
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL

        FROM (
            SELECT
                RUN_DATE,
                CDE_ENTITY_MODEL, 
                CDE_ENC_MCO, 
                CDE_ENC_ACO, 
                CLAIM_TYPE,
                CDE_CLM_DISPOSITION,
                CDE_CLM_STATUS,
                MD_BATCH_SEQ,
                ClaimFrequencyTypeCode1X AS Claim_Frequency_Code,
                ClaimContractTypeCode1X AS Claim_Contract_Type_Code,
                ClaimAllowableAmount1X AS Allowed_Amount,
                ClaimPaidAmount1X AS Paid_Amount,
                ClaimBilledAmount1X AS Billed_Amount,
                BillingProviderInternalId1X AS Bill_Provider_Internal_ID,
                BillingProviderNPI1X AS Bill_Provider_NPI,
                BillingProviderTaxonomy1X AS Bill_Provider_Taxonomy,
                BillingInternalProviderAddressLocation1X AS Billing_Provider_PIDSL,
                ServicingProviderInternalId1X AS Servicing_Provider_Internal_ID,
                ServicingProviderNPI1X AS Servicing_Provider_NPI,
                ServicingProviderType1X AS Servicing_Provider_Type,
                ServicingProviderLocation1X AS Servicing_Provider_Location,
                ServicingProviderTaxonomy1X AS Servicing_Provider_Taxonomy,
                ServicingInternalProviderAddressLocation1X AS Servicing_Provider_PIDSL,
                FromServiceDate1X AS Statement_Date,
                ToServiceDate1X AS To_Service_Date,
                AdmissionDate1X AS Admission_Date,
                MemberID1X AS Member_ID,
                QuantityBilled1X AS Quantity_Billed,
                AdmittingDiagnosisCode1X AS Admitting_Diagnosis_Code,
                PrimaryDiagnosisCode1X AS Principal_Diag_Code,
                DischargeDate1X AS Discharge_Date,
                TypeOfAdmission1X AS Admission_Type_Code,
                SourceOfAdmission1X AS Admission_Source_Code,
                PatientStatusCode1X AS Patient_Status_Code,
                FacilityTypeCode1X AS Facility_Type_Code,
                ProcedureCode1X AS Procedure_Code,
                ProcedureModCode1X AS Procedure_Mod_Code,
                PlaceOfServiceCode1X AS Place_Of_Service_Code,
                ToothNumber1X AS Tooth_Number,
                NUM_ICN,
                NUM_DTL
            FROM MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837D
        )
        UNPIVOT (
            TYPE
            FOR MEASURE IN (
                Claim_Frequency_Code,
                Claim_Contract_Type_Code,
                Allowed_Amount,
                Paid_Amount,
                Billed_Amount,
                Bill_Provider_Internal_ID,
                Bill_Provider_NPI,
                Bill_Provider_Taxonomy,
                Billing_Provider_PIDSL,
                Servicing_Provider_Internal_ID,
                Servicing_Provider_NPI,
                Servicing_Provider_Type,
                Servicing_Provider_Location,
                Servicing_Provider_Taxonomy,
                Servicing_Provider_PIDSL,
                Statement_Date,
                To_Service_Date,
                Admission_Date,
                Member_ID,
                Quantity_Billed,
                Admitting_Diagnosis_Code,
                Principal_Diag_Code,
                Discharge_Date,
                Admission_Type_Code,
                Admission_Source_Code,
                Patient_Status_Code,
                Facility_Type_Code,
                Procedure_Code,
                Procedure_Mod_Code,
                Place_Of_Service_Code,
                Tooth_Number
            )
) AS UNPIV7D
ORDER BY RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MEASURE, TYPE

-- only first claim line
)
WHERE NUM_DTL = 1    
)
-- add rank
)
-- limit rank to 10 line
WHERE rnk <= 10

ORDER BY 
                                                               RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MEASURE,
                                                               TYPE,
                                                               NUM_ICN,
                                                               RNK
) AS A
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_STATISTIC S ON A.MD_BATCH_SEQ = s.MD_BATCH_SEQ_SPRO;

-----------------

DROP VIEW INF_SENDPRO_TARGET_837_NCPDP_UNPIV_DETAIL;

CREATE VIEW INF_SENDPRO_TARGET_837_NCPDP_UNPIV_DETAIL
AS

SELECT DISTINCT 
               a.RUN_DATE, 
               a.CDE_ENTITY_MODEL, 
               a.CDE_ENC_MCO, 
               a.CDE_ENC_ACO, 
               a.CLAIM_TYPE, 
               a.CDE_CLM_DISPOSITION, 
               a.CDE_CLM_STATUS, 
               a.MD_BATCH_SEQ, 
               a.MEASURE, 
               a.TYPE, 
               a.NUM_ICN, 
               a.NUM_DTL,
               a.RNK,
               s.FILE_NAME, 
               s.PROCESS_START_TM
FROM (


-- limit rank to 10 lines
SELECT DISTINCT 
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL,
               RNK

FROM (
-- rank
  SELECT
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL,
                                            RANK ()
                                            OVER (PARTITION BY RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MD_BATCH_SEQ,
                                                               MEASURE
                                                  ORDER BY
                                                               RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MD_BATCH_SEQ,
                                                               MEASURE,
                                                               TYPE,
                                                               NUM_ICN,
                                                               NUM_DTL)    AS rnk

  FROM (

-- only first claim line

SELECT 

               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL

  FROM (

-- core unpiv

        SELECT 
               RUN_DATE, 
               CDE_ENTITY_MODEL, 
               CDE_ENC_MCO, 
               CDE_ENC_ACO, 
               CLAIM_TYPE, 
               CDE_CLM_DISPOSITION, 
               CDE_CLM_STATUS, 
               MD_BATCH_SEQ, 
               MEASURE, 
               TYPE, 
               NUM_ICN, 
               NUM_DTL

        FROM (
            SELECT
                RUN_DATE,
                CDE_ENTITY_MODEL, 
                CDE_ENC_MCO, 
                CDE_ENC_ACO, 
                CLAIM_TYPE,
                CDE_CLM_DISPOSITION,
                CDE_CLM_STATUS,
                MD_BATCH_SEQ,
                ClaimAllowableAmount1X AS Allowed_Amount,
                ClaimPaidAmount1X AS Paid_Amount,
                ClaimBilledAmount1X AS Billed_Amount,
                BillingProviderInternalId1X AS Bill_Provider_Internal_ID,
                BillingProviderNPI1X AS Bill_Provider_NPI,
                BillingProviderTaxonomy1X AS Bill_Provider_Taxonomy,
                BillingInternalProviderAddressLocation1X AS Billing_Provider_PIDSL,
                FromServiceDate1X AS Statement_Date,
                ToServiceDate1X AS To_Service_Date,
                MemberID1X AS Member_ID,
                QuantityBilled1X AS Quantity_Billed,
                ProcedureCode1X AS Procedure_Code,
                RecordStatus1X AS Record_Status,
                NDC1X AS NDC,
                CompoundNDC1X AS Compound_NDC,
                ScriptWrittenDate1X AS Script_Written_Date,
                DAW1X AS Dispense_As_Written,
                DispenseFee1X AS Dispense_Fee,
                PrescribingProviderInternalId1X AS Prescriber_Provider_ID,
                PrescribingProviderNPI1X AS Prescriber_Provider_NPI,
                PrescribingProviderLocation1X AS Prescriber_Provider_Location,
                PrescriptionNumber1X AS Prescription_Number,
                RefillIndicator1X AS Refill_Indicator,
                PrescriptionOrigin1X AS Prescription_Origin,
                DispenseQuantity1X AS Dispense_Quantity,
                NUM_ICN,
                NUM_DTL
            FROM MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837_NCPDP
        )
        UNPIVOT (
            TYPE
            FOR MEASURE IN (
                Allowed_Amount,
                Paid_Amount,
                Billed_Amount,
                Bill_Provider_Internal_ID,
                Bill_Provider_NPI,
                Bill_Provider_Taxonomy,
                Billing_Provider_PIDSL,
                Statement_Date,
                To_Service_Date,
                Member_ID,
                Quantity_Billed,
                Procedure_Code,
                Record_Status,
                NDC,
                Compound_NDC,
                Script_Written_Date,
                Dispense_As_Written,
                Dispense_Fee,
                Prescriber_Provider_ID,
                Prescriber_Provider_NPI,
                Prescriber_Provider_Location,
                Prescription_Number,
                Refill_Indicator,
                Prescription_Origin,
                Dispense_Quantity
            )
) AS UNPIV7P
ORDER BY RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MEASURE, TYPE

-- only first claim line
)
WHERE NUM_DTL IN (0,1)     -- NCPDP can have 0 detail records (header only claims)
)
-- add rank
)
-- limit rank to 10 line
WHERE rnk <= 10

ORDER BY 
                                                               RUN_DATE,
                                                               CDE_ENTITY_MODEL, 
                                                               CDE_ENC_MCO, 
                                                               CDE_ENC_ACO,
                                                               CLAIM_TYPE,
                                                               CDE_CLM_DISPOSITION,
                                                               CDE_CLM_STATUS,
                                                               MEASURE,
                                                               TYPE,
                                                               NUM_ICN,
                                                               RNK
) AS A
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_STATISTIC S ON A.MD_BATCH_SEQ = s.MD_BATCH_SEQ_SPRO;
