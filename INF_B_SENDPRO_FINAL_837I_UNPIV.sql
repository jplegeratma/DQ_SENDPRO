
USE MHTEAM.DWDQ;

CREATE VIEW INF_SENDPRO_TARGET_837I_UNPIV AS

SELECT DISTINCT RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, MEASURE, TYPE, REC_CNT
FROM (
    SELECT RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, MEASURE, TYPE, COUNT(TYPE) AS REC_CNT
    FROM (
        SELECT RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, MEASURE, TYPE
        FROM (
            SELECT
                RUN_DATE,
                CDE_ENTITY_MODEL, 
                CDE_ENC_MCO, 
                CDE_ENC_ACO, 
                CLAIM_TYPE,
                ClaimFrequencyTypeCode1X AS Claim_Frequency_Code,
                ClaimContractTypeCode1X AS Claim_Contract_Type_Code,
                ClaimAllowableAmount1X AS Allowed_Amount,
                ClaimPaidAmount1X AS Paid_Amount,
                ClaimBilledAmount1X AS Billed_Amount,
                BillingProviderInternalId1X AS Bill_Provider_Internal_ID,
                BillingProviderNPI1X AS Bill_Provider_NPI,
                BillingProviderTaxonomy1X AS Bill_Provider_Taxonomy,
                ServicingProviderInternalId1X AS Servicing_Provider_Internal_ID,
                ServicingProviderNPI1X AS Servicing_Provider_NPI,
                ServicingProviderType1X AS Servicing_Provider_Type,
                ServicingProviderLocation1X AS Servicing_Provider_Location,
                ServicingProviderTaxonomy1X AS Servicing_Provider_Taxonomy,
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
                PlaceOfServiceCode1X AS Place_Of_Service_Code
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
                Servicing_Provider_Internal_ID,
                Servicing_Provider_NPI,
                Servicing_Provider_Type,
                Servicing_Provider_Location,
                Servicing_Provider_Taxonomy,
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
                Place_Of_Service_Code
            )
        ) AS INF_SENDPRO_TARGET_837I_UNPIV
    )
    GROUP BY RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, MEASURE, TYPE
)
ORDER BY RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, MEASURE, TYPE;