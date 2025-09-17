-- 9/17/26
--Why IOL not showing up in detail

select *
from 
MHTEAM.DWDQ.INF_SENDPRO_CLAIMS_DQ_7_837I_UNPIV_DETAIL
where PatientControlNum = '58344300X00';


-- 9/15/2025
--    Why is update taking so long?

--SELECT DISTINCT FileName from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA;
-- takes seconds?
-- run took 6:19 ?

-- 9/15/25
-- Investigate Priya's question about Principal diag

select * 
from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA
where PatientControlNum = '24304000370101'
--where Claim_Type = 'I'
order by 
FileName,
PatientControlNum,
NumDtl
limit 100
;


select count(1) from (

select FileName, PatientControlNum, NumDtl, count(NumDtl)
from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA
--where Claim_Type = 'I'
group by 
FileName,
PatientControlNum,
NumDtl
having count(NumDtl) > 1
order by 
FileName,
PatientControlNum,
NumDtl
limit 100
)
;



-- 9/12/25
-- Investigate Priya's question about Principal diag

select count(distinct "PatientControlNum")
from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL
where 1=1
and "DiagnosisCodeQual"='ABK'
and "FileName" like '%pd%';

-- 159106

--select count(distinct h."PatientControlNum" || d."NumDtl" || dia."DiagnosisCode")
--select count(distinct h."PatientControlNum" || dia."DiagnosisCode")
select count(distinct h."PatientControlNum" || d."NumDtl")
from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM as h

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_SERVICE_DTL as d
on  h."FileName" = d."FileName"
and h."SubmitterID"        = d."SubmitterID"
and h."PatientControlNum"  = d."PatientControlNum"

--left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL dia
--on  h."FileName" = dia."FileName"
--and h."PatientControlNum"  = dia."PatientControlNum"

--where dia."DiagnosisCodeQual"='ABK'
--and h."FileName" like '%pd%'
;

-- 642203

--diagcode with detail lines
--1,170,274

--diagcode w/o detail lines
--8,475,798

-- NumDtl no diag codes
--1,284,347


select distinct h."PatientControlNum", to_number(d."NumDtl",4,0) as NumDtl, dia."DiagnosisCodeQual", dia."DiagnosisType", dia."DiagnosisCode"
from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM as h

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_SERVICE_DTL as d
on  h."FileName" = d."FileName"
and h."PatientControlNum"  = d."PatientControlNum"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL dia
on  h."FileName" = dia."FileName"
and h."PatientControlNum"  = dia."PatientControlNum"
where h."PatientControlNum" = '58344300X00'
order by h."PatientControlNum", to_number(d."NumDtl",4,0), dia."DiagnosisCodeQual", dia."DiagnosisCode"
;











/*
ok. thank you so much 
 My only concern was on the number reported as Valid in the dashboard which is around 6011 for Admitting Diag Code (ABJ) which is less that what we get out of the query  filtered for ABJ. Number of records is 50761 at line level. and 8321 at header level. So any thoughts on why that could be or could it be that I am doing something wrong.
*/


select count(distinct "PatientControlNum")
from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL
where 1=1
and "DiagnosisCodeQual"='ABJ'
and "FileName" like '%pd%';

-- 8321


select count(distinct d."PatientControlNum" || d."NumDtl")
from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM as h

left join MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_SERVICE_DTL as d
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

where dia."DiagnosisCodeQual"='ABJ'
and h."FileName" like '%pd%'
;

-- 50761




------------

select *
from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL dia
where "DiagnosisCodeQual" IS NOT NULL
;

select distinct "DiagnosisCodeQual"
from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL dia;


select distinct DiagnosisCodeQual
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


-- M

select distinct "DiagnosisCodeQual"
from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM_DIAGNOSIS_DTL dia;


select distinct DiagnosisCodeQual
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
));



----------------------------
-- Repair using updates

-- 837M

--drop table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA_20250825_1;

--create table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA_20250825_2
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

select *
from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7M_QA_UPDATE2
where AdmittingDiagnosisCode1X != 'NOT APP'
;


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
	     WHEN DiagnosisCodeQual != 'ABK' THEN 'NOT APP'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
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
));

--)
--GROUP BY CPT_Code1X
--GROUP BY HIPPS_Code1X;


-- 837I

drop table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_20250825_1

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

select enc.enc_claim_no, enc.enc_claim_suffix, dia.dsc_diag_long
from mhdwqa.nw.nw_encounter_hist enc
join mhdwqa.nw.nw_diagnosis dia on enc.e_code_diag_seq = dia.diag_seq 
where dsc_diag_long is not null and trim(dsc_diag_long) != '' and dsc_diag_long != 'Unknown'
--order by enc_claim_no, enc_claim_suffix, dsc_diag_long
limit 10;


--select count(distinct "PatientControlNum" || "NumDtl")
select count("PatientControlNum" || "NumDtl")
from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM_DIAGNOSIS_DTL
where 1=1
and "DiagnosisCodeQual"='ABK'
and "FileName" like '%pd%';

-- distinct
-- 159106
--not
--159115


select count(distinct PatientControlNum || NumDtl)
--select count(PatientControlNum || NumDtl)
from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA
where 1=1
and PrincipalDiagnosisCode1X ='VALID'
and FileName like '%pd%';

-- 326927

select count(distinct PatientControlNum || NumDtl)
from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE
where 1=1
and PrincipalDiagnosisCode1X ='VALID'
and FileName like '%pd%';

select count(1)
from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA;
-- 1153259

select count(1)
from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE;
-- 2304270

select count(1) from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE;

select AdmittingDiagnosisCode1X, count(AdmittingDiagnosisCode1X)
FROM
MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA
--where FileName like '%pd%'
group by AdmittingDiagnosisCode1X;

--NULL	0
--INVALID	0
--VALID	9261
-- afer changing to ILMO 25999
--NOT APP	1143998

-- pd
--VALID	5867
--NOT APP	636701


select AdmittingDiagnosisCode1X, count(AdmittingDiagnosisCode1X)
FROM
MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE
group by AdmittingDiagnosisCode1X;

--NULL	0
--INVALID	0
--VALID	27272
--NOT APP	2276998

select AdmittingDiagnosisCode1X, count(AdmittingDiagnosisCode1X)
FROM
MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE_2
group by AdmittingDiagnosisCode1X;

--NULL	0
--INVALID	0
--VALID	75796
--NOT APP	2271760

select count(1)
from (
select distinct
u.run_date,
u.transsetcontrolnum,
u.submitterid,
u.PatientControlNum,
u.claim_type,
u.NumDtl,
u.FileName,
u.record_type,
u.admittingdiagnosiscode1x
from INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE_2 u
);
--1152475
-- 2347556

select
u.run_date,
u.transsetcontrolnum,
u.submitterid,
u.PatientControlNum,
u.claim_type,
u.NumDtl,
u.FileName,
u.record_type,
u.admittingdiagnosiscode1,
u.admittingdiagnosiscode1x,
u.principaldiagnosiscode1,
u.principaldiagnosiscode1x,
u.icd10diagnosis_code1,
u.icd10diagnosis_code1x,
count(u.admittingdiagnosiscode1x)
from INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE_2 u
where PATIENTCONTROLNUM = '10021200X00'
and numdtl = 1
and filename = '110025617d_pacdri_14032025081719_test_pd_1c93d3a7-fc17-4696-a72d-7c2c559592d8.xml'
group by
u.run_date,
u.transsetcontrolnum,
u.submitterid,
u.PatientControlNum,
u.claim_type,
u.NumDtl,
u.FileName,
u.record_type,
u.admittingdiagnosiscode1,
u.admittingdiagnosiscode1x,
u.principaldiagnosiscode1,
u.principaldiagnosiscode1x,
u.icd10diagnosis_code1,
u.icd10diagnosis_code1x
--having count(u.admittingdiagnosiscode1x) > 1
order by
u.run_date,
u.transsetcontrolnum,
u.submitterid,
u.PatientControlNum,
u.claim_type,
u.NumDtl,
u.FileName,
u.record_type,
u.admittingdiagnosiscode1,
u.admittingdiagnosiscode1x,
u.principaldiagnosiscode1,
u.principaldiagnosiscode1x,
u.icd10diagnosis_code1,
u.icd10diagnosis_code1x
limit 10
;


select *
from INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE_2
where AdmittingDiagnosisCode1X != 'NOT APP'
and claim_type != 'I';



select count(1) from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA;
--1140765

select count(1) from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE;
--1140722

-- written by github co-pilot
UPDATE INF_B_SENDPRO_CLAIMS_DQ_7_QA
SET
    AdmittingDiagnosisCode1X = u.AdmittingDiagnosisCode1X
--    PrincipalDiagnosisCode1X = u.PrincipalDiagnosisCode1X,
--    ICD10Diagnosis_Code1X    = u.ICD10Diagnosis_Code1X
FROM INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE_2 u
WHERE
    INF_B_SENDPRO_CLAIMS_DQ_7_QA.PatientControlNum = u.PatientControlNum
    AND INF_B_SENDPRO_CLAIMS_DQ_7_QA.NumDtl = u.NumDtl
    AND INF_B_SENDPRO_CLAIMS_DQ_7_QA.FileName = u.FileName;

-- 1140765

-- drop table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE_2;


select count(1) from MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE_2;

create table MHTEAM.DWDQ.INF_B_SENDPRO_CLAIMS_DQ_7_QA_UPDATE_2
AS

--select count(1)
--from (

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
    CASE WHEN Claim_Type IN ('L','I','O') AND DiagnosisCode IS NOT NULL 
	AND DiagnosisCode IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','**','+','-')) 
	AND DiagnosisCodeQual='ABJ'
        THEN 1 ELSE 0 END AdmittingDiagnosisCode1,
--  Ex

    CASE WHEN Claim_Type NOT IN ('L','I','O') THEN 'NOT APP'
--    CASE WHEN Claim_Type NOT IN ('I') THEN 'NOT APP'
	     WHEN DiagnosisCodeQual != 'ABJ' THEN 'NOT APP'
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
         WHEN DiagnosisCodeQual != 'ABK' THEN 'NOT APP'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
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

--where PATIENTCONTROLNUM = '10021200X00'
--and numdtl = 1

   
order by
    TransSetControlNum,
    h."SubmitterID",
    FileName,
    h."PatientControlNum",
    to_number(d."NumDtl",4,0)
)
)


--)
;

---------------
-- look at mix of Diag codes and claim lines
-- 9/16 take out the numdtl


SELECT DISTINCT
RUN_DATE,
TransSetControlNum,
SubmitterID,
PatientControlNum,
claim_type,
--NumDtl,
FileName,
Record_Type,
DiagnosisCodeQual,
DiagnosisCode,
DiagnosisType,
--  Ex

    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT APP'
--    CASE WHEN Claim_Type NOT IN ('I') THEN 'NOT APP'
	     WHEN DiagnosisCodeQual != 'ABJ' THEN 'NOT APP'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','**','+','-','$','  ')) THEN 'INVALID'
         ELSE 'VALID' END AdmittingDiagnosisCode1X,

--  Ex
    CASE WHEN Claim_Type NOT IN ('L','I','O','M') THEN 'NOT APP'
         WHEN DiagnosisCode IS NULL THEN 'NULL'
         WHEN DiagnosisCodeQual != 'ABK' THEN 'NOT APP'
		 WHEN DiagnosisCode NOT IN (SELECT CDE_DIAG from MHDWQA.NW.NW_B_DIAGNOSIS where CDE_ICD_VERSION=10 and CDE_DIAG NOT IN ('#','+','-') ) THEN 'INVALID'
         WHEN DiagnosisType <> 'ClmPrincipalDiagnosis' THEN 'INVALID'	
         ELSE 'VALID' END PrincipalDiagnosisCode1X,

--  ICD10 Diagnosis
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

--where PATIENTCONTROLNUM = '10021200X00'
--and numdtl = 1

   
order by
    TransSetControlNum,
    h."SubmitterID",
    FileName,
    h."PatientControlNum",
--    to_number(d."NumDtl",4,0),
dia."DiagnosisCode",
dia."DiagnosisCodeQual"
)
)
where PatientControlNum = '58344300X00'
order by
    TransSetControlNum,
    SubmitterID,
    FileName,
    PatientControlNum,
--    NumDtl,
    DiagnosisCode,
    DiagnosisCodeQual
limit 100;




select *
from mhdwqa.nw.nw_enc_surgical_group
limit 100;

select *
from mhdwqa.nw.nw_b_diagnosis_group
limit 100;

select *
from mhdwqa.nw.nw_b_procedure
limit 100;


-- single codes
select *
from mhdwqa.nw.nw_b_procedure_mfr_group
limit 100;

select *
from mhdwqa.nw.nw_enc_attribute
limit 100;

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


---------------
-- check for ABJ in M
select distinct DiagnosisCodeQual
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

  
order by
    TransSetControlNum,
--    ImplementationConventionRef,
    h."SubmitterID",
    FileName,
    h."PatientControlNum",
    to_number(d."NumDtl",4,0)
))
;


