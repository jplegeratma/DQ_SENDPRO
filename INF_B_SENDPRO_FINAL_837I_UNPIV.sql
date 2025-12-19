
USE MHTEAM.DWDQ;

DROP VIEW INF_SENDPRO_TARGET_837I_UNPIV;

CREATE VIEW INF_SENDPRO_TARGET_837I_UNPIV AS

SELECT DISTINCT RUN_DATE, A.CDE_ENTITY_MODEL, A.CDE_ENC_MCO, A.CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, A.MD_BATCH_SEQ, MEASURE, TYPE, REC_CNT,
s.FILE_NAME, s.PROCESS_START_TM, L.BENCHMARK_THRESHOLD
FROM (

SELECT DISTINCT RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MD_BATCH_SEQ, FILE_NAME, MEASURE, TYPE, REC_CNT
FROM (
    SELECT RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MD_BATCH_SEQ, FILE_NAME, MEASURE, TYPE, COUNT(TYPE) AS REC_CNT
    FROM (
        SELECT RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MD_BATCH_SEQ, FILE_NAME, MEASURE, TYPE
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
                h."FileName" AS FILE_NAME,
                ClaimFrequencyTypeCode1X AS Claim_Frequency_Code,
                ClaimContractTypeCode1X AS Claim_Contract_Type_Code,
                ClaimAllowableAmount1X AS Allowed_Amount,
                ClaimPaidAmount1X AS Paid_Amount,
                ClaimBilledAmount1X AS Billed_Amount,
                BillingProviderInternalId1X AS Billing_Provider_Internal_ID,
                BillingProviderNPI1X AS Billing_Provider_NPI,
                BillingProviderTaxonomy1X AS Billing_Provider_Taxonomy,
                BillingInternalProviderAddressLocation1X AS Billing_Provider_Internal_Address_Location,
                ServicingProviderInternalId1X AS Servicing_Provider_Internal_ID,
                ServicingProviderNPI1X AS Servicing_Provider_NPI,
                ServicingProviderType1X AS Servicing_Provider_Type,
                ServicingProviderLocation1X AS Servicing_Provider_Location,
                ServicingProviderTaxonomy1X AS Servicing_Provider_Taxonomy,
                ServicingInternalProviderAddressLocation1X AS Servicing_Provider_Internal_Address_Location,
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
                PricingMethod1X AS Pricing_Method_Code
            FROM MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837I tar
            JOIN MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM h
            ON tar.num_icn = h."PatientControlNum"
            AND tar.ID_SUBMITTER = h."SubmitterID"
        )
        UNPIVOT (
            TYPE
            FOR MEASURE IN (
                Claim_Frequency_Code,
                Claim_Contract_Type_Code,
                Allowed_Amount,
                Paid_Amount,
                Billed_Amount,
                Billing_Provider_Internal_ID,
                Billing_Provider_NPI,
                Billing_Provider_Taxonomy,
                Billing_Provider_Internal_Address_Location,
                Servicing_Provider_Internal_ID,
                Servicing_Provider_NPI,
                Servicing_Provider_Type,
                Servicing_Provider_Location,
                Servicing_Provider_Taxonomy,
                Servicing_Provider_Internal_Address_Location,
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
        ) AS INF_SENDPRO_TARGET_837I_UNPIV
    )
    GROUP BY RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MD_BATCH_SEQ, FILE_NAME, MEASURE, TYPE
)
ORDER BY RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MD_BATCH_SEQ, FILE_NAME, MEASURE, TYPE

) AS A
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_STATISTIC S ON A.MD_BATCH_SEQ = S.MD_BATCH_SEQ_SPRO AND A.FILE_NAME = S.FILE_NAME
LEFT JOIN MHTEAM.DWDQ.INF_B_SENDPRO_LOOKUP L ON A.MEASURE = L.BENCHMARK;