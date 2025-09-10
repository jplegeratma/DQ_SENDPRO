
--ICD10_DIAG_CODE

select count(dia."DiagnosisCode")

from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM as h

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL dia
on  h."FileName" = dia."FileName"
and h."PatientControlNum"  = dia."PatientControlNum"
and dia."DiagnosisCodeQual" = 'ABJ'
;


select ICD10Diagnosis_Code1X, count(ICD10Diagnosis_Code1X)
from (

select DiagnosisCode, DiagnosisType,

    CASE WHEN Claim_Type NOT IN ('L','I','O','M','P') THEN 'NOT APP'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
         WHEN DiagnosisType <> 'ClmOtherDiagnosis' THEN 'INVALID'	
         ELSE 'VALID' END ICD10Diagnosis_Code1X

FROM (

select

dia."DiagnosisCode" as DiagnosisCode,
dia."DiagnosisType" as DiagnosisType,

    CASE 
        WHEN "FacilityTypeCode" IN ('11','12') THEN 'I'
        WHEN "FacilityTypeCode" IN ('13','14','22','23','32','33','34','43','81','82','83','85','87','89') 
            OR LEFT("FacilityTypeCode",1) = '7' THEN 'O'
        WHEN "FacilityTypeCode" IN ('18','21','28','86') 
            OR LEFT("FacilityTypeCode",1) = '6' THEN 'L'
        ELSE 'X' 
    END Claim_Type

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

)

)
group by ICD10Diagnosis_Code1X
--where ICD10Diagnosis_Code1X not in ('VALID','INVALID')
;

----


select ICD10Diagnosis_Code1X, count(ICD10Diagnosis_Code1X)
FROM (

select DISTINCT
SubmitterID,
PatientControlNum,
NumDtl,
FileName,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M','P') THEN 'NOT APP'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
         WHEN DiagnosisType <> 'ClmOtherDiagnosis' THEN 'INVALID'	
         ELSE 'VALID' END ICD10Diagnosis_Code1X


         
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
substr(h."AdmissionDateHourDTP",1,8) as AdmissionDTP,

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
--   h.RAW_SPRO_CLAIM_SEQ = atnd.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= atnd."PatientControlNum" and
   h."NumDtl"           = atnd."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_REFERRING_PROVIDER_DTL ref
on h."FileName"         = ref."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = ref.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ref."PatientControlNum" and
   h."NumDtl"           = ref."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_RENDERING_PROVIDER_DTL ren
on h."FileName"         = ren."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = ren.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ren."PatientControlNum" and
   h."NumDtl"           = ren."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OTHER_OPERATING_PHYS_PROVIDER_DTL oop
on h."FileName"         = oop."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = oop.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= oop."PatientControlNum" and
   h."NumDtl"           = oop."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OPERATING_PHYS_PROVIDER_DTL op
on h."FileName"         = op."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = op.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= op."PatientControlNum" and
   h."NumDtl"           = op."NumDtl"

--where FileName NOT IN ( SELECT DISTINCT FileName from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA )

order by
    TransSetControlNum,
    h."SubmitterID",
    FileName,
    h."PatientControlNum",
    to_number(d."NumDtl",4,0)
)
)
)
GROUP BY ICD10Diagnosis_Code1X
;



------------------------------------

--fix CPT
-- try reload after backup


------------

/*
Similarly , for CPT_Code, I validated that the CPT Codes that are available seems to be valid, but may for certain claimns that may not be available
Should we not be populating as NULL instead of INVALID
For whole data, I find only 24 Invalid CPT Codes :     
*/
    select count(distinct "PatientControlNum")--,"SvcLineProcCodeQual","SvcLineProcCode" 
    from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_SERVICE_DTL a 
    left join MHDWQA.NW.NW_B_PROCEDURE  b
    on a."SvcLineProcCode" = b.cde_proc
    where 1=1 
    and   "SvcLineProcCodeQual"='HC'
    and b.cde_proc is  null;

    --and "PatientControlNum"='302942822'
    --and "FileName"='110031447a_pacdrp_03032025144854_test_pd_f19b8e33-c203-4ada-9e9f-57c186b01329.xml'


    select count(1)
    from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM as h
left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_SERVICE_DTL as d
--on  h."TransSetControlNum" = d."TransSetControlNum"
on  h."FileName" = d."FileName"
and h."SubmitterID"        = d."SubmitterID"
and h."PatientControlNum"  = d."PatientControlNum"

    left join MHDWQA.NW.NW_B_PROCEDURE  b
    on d."SvcLineProcCode" = b.cde_proc AND b.CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'CPT%'
    where 1=1 
    and   "SvcLineProcCodeQual"='HC'
    --and b.cde_proc is  null
    ;

--All 1,140,722  
--1,011,102

--NULL  73379
--INVALID 387006
--VALID 646483
--NOT APP 33854

select 646483 + 387006;



select CPT_Code1X, count(CPT_Code1X)
FROM (

select DISTINCT
SubmitterID,
PatientControlNum,
NumDtl,
FileName,
CASE
         WHEN Claim_Type NOT IN ('O','M','D') THEN 'NOT APP'

         WHEN SvcLineProcCode IS NULL THEN 'NULL'
		 WHEN SvcLineProcCode NOT IN (SELECT CDE_PROC FROM MHDWQA.NW.NW_B_PROCEDURE WHERE CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'CPT%') THEN 'INVALID'
         WHEN SvcLineProcCodeQual <> 'HC' THEN 'INVALID'
         ELSE 'VALID' END CPT_Code1X

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
substr(h."AdmissionDateHourDTP",1,8) as AdmissionDTP,

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
--   h.RAW_SPRO_CLAIM_SEQ = atnd.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= atnd."PatientControlNum" and
   h."NumDtl"           = atnd."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_REFERRING_PROVIDER_DTL ref
on h."FileName"         = ref."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = ref.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ref."PatientControlNum" and
   h."NumDtl"           = ref."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_RENDERING_PROVIDER_DTL ren
on h."FileName"         = ren."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = ren.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ren."PatientControlNum" and
   h."NumDtl"           = ren."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OTHER_OPERATING_PHYS_PROVIDER_DTL oop
on h."FileName"         = oop."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = oop.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= oop."PatientControlNum" and
   h."NumDtl"           = oop."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OPERATING_PHYS_PROVIDER_DTL op
on h."FileName"         = op."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = op.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= op."PatientControlNum" and
   h."NumDtl"           = op."NumDtl"

--where FileName NOT IN ( SELECT DISTINCT FileName from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA )

order by
    TransSetControlNum,
    h."SubmitterID",
    FileName,
    h."PatientControlNum",
    to_number(d."NumDtl",4,0)
)
)
)
GROUP BY CPT_Code1X
;


--837P
-- CPT
----------------------------
    select count(1)
    from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_SERVICE_DTL
    where --"PatientControlNum"='302943086';
    "SvcLineProcCodeQual"='HC';
-- 1,803,323


--    select count(distinct "PatientControlNum")--,"SvcLineProcCodeQual","SvcLineProcCode" 
    select count(1) 
    from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_SERVICE_DTL a 
    left join MHDWQA.NW.NW_B_PROCEDURE  b
    on a."SvcLineProcCode" = b.cde_proc
    where 1=1 
    and   "SvcLineProcCodeQual"='HC'
--    and b.cde_proc is not null;
    and b.cde_proc is  null;
-- Pat
-- Null 24
-- Not Null 722732
-- 1
-- Null 30
-- Not Null 1,803,293

    select count(1) 
    from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_SERVICE_DTL a 
    left join MHDWQA.NW.NW_B_PROCEDURE  b
    on a."SvcLineProcCode" = b.cde_proc AND b.CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'CPT%'
    where 1=1 
    and   "SvcLineProcCodeQual"='HC'
    and b.cde_proc is  null;


    select count(1)
    from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM as h
left join MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_SERVICE_DTL as d
--on  h."TransSetControlNum" = d."TransSetControlNum"
on  h."FileName" = d."FileName"
and h."SubmitterID"        = d."SubmitterID"
and h."PatientControlNum"  = d."PatientControlNum"

    left join MHDWQA.NW.NW_B_PROCEDURE  b
    on d."SvcLineProcCode" = b.cde_proc AND b.CDE_PROC NOT IN ('#','+','-') AND UPPER(proc_group) LIKE 'CPT%'
    where 1=1 
    and   "SvcLineProcCodeQual"='HC'
    and b.cde_proc is not null;
    
-- ALL 1,803,323
-- NOT NULL 804,228
-- NULL 999,095

----------
-- CPT
INVALID 999,095
VALID 804,228


-- HIPPS

    select "SvcLineProcCodeQual","SvcLineProcCode"  -- distinct  "SvcLineProcCodeQual" 
    from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_SERVICE_DTL
    where --"PatientControlNum"='302943086';
    "SvcLineProcCodeQual"='HP';

    select count(1)
    from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_SERVICE_DTL
    where --"PatientControlNum"='302943086';
    "SvcLineProcCodeQual"='HP';
-- 0


----------------------------
-- Repair using updates

-- 837M

create table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA_20250825_2
as select * from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA;


-- INVALID 1803323

select CPT_Code1X, count(CPT_Code1X)
--select HIPPS_Code1X, count(HIPPS_Code1X)
FROM
MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA
group by CPT_Code1X;

-- CPT
-- Valid 804229
-- Invalid 999104

-- after
-- Valid 1803303
-- Invalid 30

select CPT_Code1X, count(CPT_Code1X)
--select HIPPS_Code1X, count(HIPPS_Code1X)
FROM
MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UPDATE
group by CPT_Code1X;

--CPT
-- Valid 1803293
-- Invlaid 30

select HIPPS_Code1X, count(HIPPS_Code1X)
FROM
MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA
group by HIPPS_Code1X;

--Invalid 1803333

select HIPPS_Code1X, count(HIPPS_Code1X)
FROM
MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UPDATE
group by HIPPS_Code1X;

--Invalid 1803323


select count(1) from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA;
--1803333

select count(1) from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UPDATE;
--1803323

-- written by github co-pilot
UPDATE INF_B_SENDPRO_CLAIMS_DQ_7M_QA
SET
    PrincipalDiagnosisCode1X = u.PrincipalDiagnosisCode1X,
    ICD10Diagnosis_Code1X    = u.ICD10Diagnosis_Code1X
FROM INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UPDATE u
WHERE
    INF_B_SENDPRO_CLAIMS_DQ_7M_QA.PatientControlNum = u.PatientControlNum
    AND INF_B_SENDPRO_CLAIMS_DQ_7M_QA.NumDtl = u.NumDtl
    AND INF_B_SENDPRO_CLAIMS_DQ_7M_QA.FileName = u.FileName;



--select CPT_Code1X, count(CPT_Code1X)
--select HIPPS_Code1X, count(HIPPS_Code1X)

--FROM (

drop table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UPDATE;

create table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UPDATE
AS

SELECT DISTINCT
RUN_DATE,
TransSetControlNum,
SubmitterID,
PatientControlNum,
claim_type,
NumDtl,
FileName,
Record_Type,

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')
	AND DiagnosisCode IS NOT NULL 
	AND DiagnosisCode IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) 
	AND DiagnosisCodeQual='ABK'
    AND DiagnosisType = 'ClmPrincipalDiagnosis'	
        THEN 1 ELSE 0 END PrincipalDiagnosisCode1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT APP'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
	     WHEN DiagnosisCodeQual != 'ABK' THEN 'INVALID'
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
--    AND DiagnosisType = 'ClmOtherDiagnosis'
    AND DiagnosisCodeQual IN ('ABK','ABN','ABJ','ABF','APR')
        THEN 1 ELSE 0 END ICD10Diagnosis_Code1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M','P') THEN 'NOT APP'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
--         WHEN DiagnosisType <> 'ClmOtherDiagnosis' THEN 'INVALID'
         WHEN DiagnosisCodeQual NOT IN ('ABK','ABN','ABJ','ABF','APR') THEN 'INVALID'         
         ELSE 'VALID' END ICD10Diagnosis_Code1X
         
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

 'M' as Claim_Type,

--    CASE 
--        WHEN "FacilityTypeCode" IN ('11','12') THEN 'I'
--        WHEN "FacilityTypeCode" IN ('13','14','22','23','32','33','34','43','81','82','83','85','87','89') 
--            OR LEFT("FacilityTypeCode",1) = '7' THEN 'O'
--        WHEN "FacilityTypeCode" IN ('18','21','28','86') 
--            OR LEFT("FacilityTypeCode",1) = '6' THEN 'L'
--        ELSE 'X' 
--    END Claim_Type,

--to_date(d."ServiceDTP",'YYYYMMDD') as DOS_FROM_DATE,
--to_date(substr(h."StatementDTP",1,8),'YYYYMMDD') as DOS_FROM_DATE,

h."ClaimFrequencyCode" as ClaimFrequencyCode,

    CASE
        WHEN h."ClaimFrequencyCode" IN ('1','2','3','4','5') THEN 'O'
        WHEN h."ClaimFrequencyCode" IN ('7') THEN 'A'
        WHEN h."ClaimFrequencyCode" IN ('8') THEN 'V'
        ELSE 'X'
    END AS Record_Type,

h."AdmissionDTP" as AdmissionDTP,
-- h."StatementDTP" as StatementDTP,

to_number(d."SvcLineChargeAmt", 12,2) as SvcLineChargeAmt,
-- a."AdjReasonCode01" as AdjReasonCode01,

h."BillingProvNPI" as BillingProvNPI,

dia."DiagnosisCode" as AdmittingDiagnosisCode,

h."FacilityTypeCode" as FacilityTypeCode,
--h."AdmissionTypeCode" as AdmissionTypeCode,
--h."AdmissionSourceCode" as AdmissionSourceCode,

dia."DiagnosisCodeQual" as DiagnosisCodeQual,
-- strip off leading 0
--CASE WHEN LEFT(d."SvcLineRevenueCode",1) != '0' then d."SvcLineRevenueCode" ELSE SUBSTR(d."SvcLineRevenueCode",2,3) END as SvcLineRevenueCode,
CASE WHEN LEFT(a."SvcLineAdjRevenueCode",1) != '0' then a."SvcLineAdjRevenueCode" ELSE SUBSTR(a."SvcLineAdjRevenueCode",2,3) END as SvcLineAdjRevenueCode,
--h."PatientStatusCode" as PatientStatusCode,

--dpvt."PrincipalDiagnosisCode" as PrincipalDiagnosisCode,
--d."MultipleProcedureCode" as MultipleProcedureCode,
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

h."ContractTypeCode" as ContractTypeCode,

-- Billing Provider
trim(h."ProviderInternalId") as ProviderInternalId,
upper(trim(h."ProviderPidsl")) as ProviderPidsl,

trim(bp."ProviderInternalId") as ProviderInternalId_bp,
upper(trim(bp."ProviderPidsl")) as ProviderPidsl_bp,

trim(ref."ReferringProvNPI")      as ref_ReferringProvNPI,
trim(ref."ProviderInternalId")    as ref_ProviderInternalId,
upper(trim(ref."ProviderPidsl"))         as ref_ProviderPidsl,
trim(ref."ProviderLocationCode")  as ref_ProviderLocationCode,

trim(ren."RenderingProvNPI")      as ren_RenderingProvNPI,
trim(ren."ProviderInternalId")    as ren_ProviderInternalId,
upper(trim(ren."ProviderPidsl"))         as ren_ProviderPidsl,
trim(ren."ProviderLocationCode")  as ren_ProviderLocationCode,

trim(sup."SupervisingProvNPI")    as sup_SupervisingProvNPI,
trim(sup."ProviderInternalId")    as sup_ProviderInternalId,
upper(trim(sup."ProviderPidsl"))         as sup_ProviderPidsl,
trim(sup."ProviderLocationCode")  as sup_ProviderLocationCode,

-- this is confusing OrderingProvID is NPI
trim(ord."OrderingProvID")        as ord_OrderingProvID,
trim(ord."ProviderInternalId")    as ord_ProviderInternalId,
upper(trim(ord."ProviderPidsl"))         as ord_ProviderPidsl,
trim(ord."ProviderLocationCode")  as ord_ProviderLocationCode

from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM as h

left join MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_SERVICE_DTL as d
on  h."FileName"           = d."FileName"
and h."SubmitterID"        = d."SubmitterID"
and h."PatientControlNum"  = d."PatientControlNum"

left join MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_SVCLN_ADJUDICATION_DTL as a
on  h."FileName"           = a."FileName"
and h."PatientControlNum"  = a."PatientControlNum"
and d."NumDtl"             = a."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_DIAGNOSIS_DTL dia
on  h."FileName"            = dia."FileName"
and h."PatientControlNum"   = dia."PatientControlNum"
and dia."DiagnosisCodeQual" = 'ABJ'

left join MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_DIAGNOSIS_PVT dpvt
on  h."FileName"           = dpvt."FileName"
and h."PatientControlNum"  = dpvt."PatientControlNum"

 left join MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_ENC_ATTRIBUTE_DTL ctvd
 on  h."FileName"           = ctvd."FileName"
 and h."PatientControlNum"  = ctvd."PatientControlNum"
 and d."NumDtl"             = ctvd."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837P_BILLING_PROVIDER_DTL bp
on bp."TransSetControlNum"  = h."TransSetControlNum" and
   bp."SendProTransId"      = h."SendProTransId" and
   bp.RAW_SPRO_BPROV_SEQ    = h.RAW_SPRO_BPROV_SEQ

left join MHDWQA.SENDPRO.RAW_SPRO_837P_REFERRING_PROVIDER_DTL ref
on h."FileName"         = ref."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = ref.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ref."PatientControlNum" and
   h."NumDtl"           = ref."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837P_RENDERING_PROVIDER_DTL ren
on h."FileName"         = ren."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = ren.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ren."PatientControlNum" and
   h."NumDtl"           = ren."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837P_SUPERVISING_PROVIDER_DTL sup
on h."FileName"         = sup."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = sup.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= sup."PatientControlNum" and
   h."NumDtl"           = sup."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837P_SVCLN_ORDERING_PROVIDER_DTL ord
on h."FileName"         = ord."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = ord.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ord."PatientControlNum" and
   h."NumDtl"           = ord."NumDtl"

--where FileName NOT IN ( SELECT DISTINCT FileName from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA )
  
order by
    TransSetControlNum,
--    ImplementationConventionRef,
    h."SubmitterID",
    FileName,
    h."PatientControlNum",
    to_number(d."NumDtl",4,0)
))

--)
--GROUP BY CPT_Code1X
--GROUP BY HIPPS_Code1X;


-- 837I
create table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_20250825_2
as select * from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA;

truncate table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA;

select count(1) from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA;
1140765

select count(1) from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_20250825_1;
1140765

insert into MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA
select * from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_20250825_1;


------------
-- chack counts after updates


select CPT_Code1X, count(CPT_Code1X)
FROM
MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA
group by CPT_Code1X;
-- this still shows (O','M','D') in CPT

-- CPT
--NULL	73381
--INVALID	387015
--VALID	646515
--NOT APP	33854

-- after
--NULL	103636
--INVALID	26539
--VALID	1010586
--NOT APP	4

select CPT_Code1X, count(CPT_Code1X)
FROM
MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE
group by CPT_Code1X;

--CPT
--NULL	103634
--INVALID	26539
--VALID	1010545
--NOT APP	4


select HIPPS_Code1X, count(HIPPS_Code1X)
FROM
MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA
group by HIPPS_Code1X;

--NULL	103636
--INVALID	1011322
--VALID	25803
--NOT APP	4

select HIPPS_Code1X, count(HIPPS_Code1X)
FROM
MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE
group by HIPPS_Code1X;

--NULL	103634
--INVALID	1011281
--VALID	25803
--NOT APP	4

select count(1) from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA;
--1140765

select count(1) from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_20250825_1;
--1140765

select count(1) from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE;
--1140722

-- written by github co-pilot
UPDATE INF_B_SENDPRO_CLAIMS_DQ_7_QA
SET
    AdmittingDiagnosisCode1X = u.AdmittingDiagnosisCode1X,
    PrincipalDiagnosisCode1X = u.PrincipalDiagnosisCode1X,
    ICD10Diagnosis_Code1X    = u.ICD10Diagnosis_Code1X
FROM INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE u
WHERE
    INF_B_SENDPRO_CLAIMS_DQ_7_QA.PatientControlNum = u.PatientControlNum
    AND INF_B_SENDPRO_CLAIMS_DQ_7_QA.NumDtl = u.NumDtl
    AND INF_B_SENDPRO_CLAIMS_DQ_7_QA.FileName = u.FileName;

-- 1140765

-- drop table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE;


create table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE
AS

SELECT DISTINCT
RUN_DATE,
TransSetControlNum,
SubmitterID,
PatientControlNum,
claim_type,
NumDtl,
FileName,
Record_Type,


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
    CASE WHEN Claim_Type IN ('I') AND DiagnosisCode IS NOT NULL 
	AND DiagnosisCode IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','**','+','-')) 
	AND DiagnosisCodeQual='ABJ'
        THEN 1 ELSE 0 END AdmittingDiagnosisCode1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('I') THEN 'NOT APP'
--	     WHEN DiagnosisCodeQual != 'ABJ' THEN 'DiagnosisCodeQual NOT ABJ'
	     WHEN DiagnosisCodeQual != 'ABJ' THEN 'INVALID'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END AdmittingDiagnosisCode1X,

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

--  DI
    CASE WHEN Claim_Type IN ('L','I','O','M')
	AND DiagnosisCode IS NOT NULL 
	AND DiagnosisCode IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') )
    AND DiagnosisCodeQual='ABK'
    AND DiagnosisType = 'ClmPrincipalDiagnosis'	
        THEN 1 ELSE 0 END PrincipalDiagnosisCode1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT APP'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
         WHEN DiagnosisCodeQual != 'ABK' THEN 'INVALID'
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
--    AND DiagnosisType = 'ClmOtherDiagnosis'	
    AND DiagnosisCodeQual IN ('ABK','ABN','ABJ','ABF','APR')
        THEN 1 ELSE 0 END ICD10Diagnosis_Code1,
--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M','P') THEN 'NOT APP'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
--         WHEN DiagnosisType <> 'ClmOtherDiagnosis' THEN 'INVALID'	
         WHEN DiagnosisCodeQual NOT IN ('ABK','ABN','ABJ','ABF','APR') THEN 'INVALID'         
         ELSE 'VALID' END ICD10Diagnosis_Code1X
         
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
substr(h."AdmissionDateHourDTP",1,8) as AdmissionDTP,

h."StatementDTP" as StatementDTP,

to_number(d."SvcLineChargeAmt", 12,2) as SvcLineChargeAmt,
-- a."AdjReasonCode01" as AdjReasonCode01,

h."BillingProvNPI" as BillingProvNPI,

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
--   h.RAW_SPRO_CLAIM_SEQ = atnd.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= atnd."PatientControlNum" and
   h."NumDtl"           = atnd."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_REFERRING_PROVIDER_DTL ref
on h."FileName"         = ref."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = ref.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ref."PatientControlNum" and
   h."NumDtl"           = ref."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_RENDERING_PROVIDER_DTL ren
on h."FileName"         = ren."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = ren.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ren."PatientControlNum" and
   h."NumDtl"           = ren."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OTHER_OPERATING_PHYS_PROVIDER_DTL oop
on h."FileName"         = oop."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = oop.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= oop."PatientControlNum" and
   h."NumDtl"           = oop."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OPERATING_PHYS_PROVIDER_DTL op
on h."FileName"         = op."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = op.RAW_SPRO_CLAIM_SEQ and
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
--------------
-- Look at some of the Invalids

select distinct SVCLINEPROCCODEQUAL
--Select * 

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
substr(h."AdmissionDateHourDTP",1,8) as AdmissionDTP,

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
--   h.RAW_SPRO_CLAIM_SEQ = atnd.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= atnd."PatientControlNum" and
   h."NumDtl"           = atnd."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_REFERRING_PROVIDER_DTL ref
on h."FileName"         = ref."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = ref.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ref."PatientControlNum" and
   h."NumDtl"           = ref."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_RENDERING_PROVIDER_DTL ren
on h."FileName"         = ren."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = ren.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ren."PatientControlNum" and
   h."NumDtl"           = ren."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OTHER_OPERATING_PHYS_PROVIDER_DTL oop
on h."FileName"         = oop."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = oop.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= oop."PatientControlNum" and
   h."NumDtl"           = oop."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OPERATING_PHYS_PROVIDER_DTL op
on h."FileName"         = op."FileName" and
--   h.RAW_SPRO_CLAIM_SEQ = op.RAW_SPRO_CLAIM_SEQ and
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

-- HC where PatientControlNum = '302878159'
--where PatientControlNum = '032230601000060002700'
;
