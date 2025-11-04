
USE MHTEAM.DWDQ;

DROP VIEW INF_SENDPRO_TARGET_837_NCPDP_UNPIV;

CREATE VIEW INF_SENDPRO_TARGET_837_NCPDP_UNPIV AS

SELECT DISTINCT RUN_DATE, A.CDE_ENTITY_MODEL, A.CDE_ENC_MCO, A.CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, A.MD_BATCH_SEQ, MEASURE, TYPE, REC_CNT,
s.FILE_NAME, s.PROCESS_START_TM, L.BENCHMARK_THRESHOLD
FROM (

SELECT DISTINCT RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MD_BATCH_SEQ, MEASURE, TYPE, REC_CNT
FROM (
    SELECT RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MD_BATCH_SEQ, MEASURE, TYPE, COUNT(TYPE) AS REC_CNT
    FROM (
        SELECT RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MD_BATCH_SEQ, MEASURE, TYPE
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
                BillingProviderInternalId1X AS Billing_Provider_Internal_ID,
                BillingProviderNPI1X AS Billing_Provider_NPI,
                BillingProviderTaxonomy1X AS Billing_Provider_Taxonomy,
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
                DispenseQuantity1X AS Dispense_Quantity
            FROM MHTEAM.DWDQ.INF_B_SENDPRO_TARGET_837_NCPDP
        )
        UNPIVOT (
            TYPE
            FOR MEASURE IN (
                Allowed_Amount,
                Paid_Amount,
                Billed_Amount,
                Billing_Provider_Internal_ID,
                Billing_Provider_NPI,
                Billing_Provider_Taxonomy,
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
        ) AS INF_SENDPRO_TARGET_837_NCPDP_UNPIV
    )
    GROUP BY RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MD_BATCH_SEQ, MEASURE, TYPE
)
ORDER BY RUN_DATE, CDE_ENTITY_MODEL, CDE_ENC_MCO, CDE_ENC_ACO, CLAIM_TYPE, CDE_CLM_DISPOSITION, CDE_CLM_STATUS, MD_BATCH_SEQ, MEASURE, TYPE

) AS A
LEFT JOIN MHDWQA.SENDPRO.SPRO_B_ENC_STATISTIC S ON A.MD_BATCH_SEQ = s.MD_BATCH_SEQ_SPRO
LEFT JOIN MHTEAM.DWDQ.INF_B_SENDPRO_LOOKUP L ON A.MEASURE = L.BENCHMARK;