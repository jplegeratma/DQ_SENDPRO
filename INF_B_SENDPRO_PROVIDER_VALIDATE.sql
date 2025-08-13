select count(1)
from inf_b_sendpro_provider_validate;

select *
from inf_b_sendpro_provider_validate;


UPDATE inf_b_sendpro_provider_validate t
SET internalId_lookup = NULL;
-- 14588

/*

UPDATE inf_b_sendpro_provider_validate t
SET internalId_lookup = s.ENC_PROV_ID
FROM MHDWDEV.SENDPRO.spro_b_enc_provider_hist s
WHERE s.ENC_PROV_ID NOT IN ('#', '+', '-')
  AND s.ENC_PROV_ID = t.InternalId;

  from Priya
  
select ad.*
from MHDWQA.SENDPRO.RAW_SPRO_837I_CLAIM as h
inner join MHDWQA.SENDPRO.RAW_SPRO_837I_ATTENDING_PROVIDER_DTL ad
on h."FileName"         = ad."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = ad.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ad."PatientControlNum" and
   h."NumDtl"           = ad."NumDtl"
left join MHDWDEV.SENDPRO.spro_b_enc837_provider_hist ap
on ad."ProviderPidsl"= ap.enc_prov_id
and ad."ProviderLocationCode"= (case when length(ap.cde_enc_prov_id_loc) <3 then lpad(ap.cde_enc_prov_id_loc,3,'0')
                                    when length(ap.cde_enc_prov_id_loc) >3 then substr(ap.cde_enc_prov_id_loc,0,3)
                                    else ap.cde_enc_prov_id_loc end)
where ad.RAW_SPRO_CLAIM_SEQ IS NOT NULL;
  
*/

UPDATE inf_b_sendpro_provider_validate t
SET internalId_lookup = s.ENC_PROV_ID
FROM MHDWDEV.SENDPRO.spro_b_enc_provider_hist s
WHERE s.ENC_PROV_ID NOT IN ('#', '+', '-')
  AND s.ENC_PROV_ID = t.InternalId
		          AND t.LocationCode = (
            case when length(CDE_ENC_PROV_ID_LOC) <3 then lpad(CDE_ENC_PROV_ID_LOC,3,'0')
                 when length(CDE_ENC_PROV_ID_LOC) >3 then substr(CDE_ENC_PROV_ID_LOC,0,3)
                 else CDE_ENC_PROV_ID_LOC
             end);


-- PIDSL
UPDATE inf_b_sendpro_provider_validate t
SET PIDSL_lookup = s.ID_PROVIDER_LOCATION
FROM MHDWQA.NW.NW_B_PROVIDER s
WHERE s.ID_PROVIDER_LOCATION NOT IN ('#', '+', '-')
  AND s.ID_PROVIDER_LOCATION = t.PIDSL;





/*

UPDATE inf_b_sendpro_provider_validate t
SET LocationCode_lookup = s.CDE_ENC_PROV_ID_LOC
FROM MHDWDEV.SENDPRO.spro_b_enc_provider_hist s
WHERE t.LocationCode = CDE_ENC_PROV_ID_LOC
AND t.LocationCode IS NOT NULL
AND t.LocationCode = '110087758A';


SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ref_ProviderInternalId
        
		
		          AND ref_ProviderLocationCode = (
            case when length(CDE_ENC_PROV_ID_LOC) <3 then lpad(CDE_ENC_PROV_ID_LOC,3,'0')
                 when length(CDE_ENC_PROV_ID_LOC) >3 then substr(CDE_ENC_PROV_ID_LOC,0,3)
                 else CDE_ENC_PROV_ID_LOC
             end)

UPDATE inf_b_sendpro_provider_lookup t
SET LocationCode_lookup = s.ID_PROVIDER_LOCATION
FROM MHDWQA.NW.NW_B_PROVIDER s
WHERE s.ID_PROVIDER_LOCATION NOT IN ('#', '+', '-')
AND s.ID_PROVIDER_LOCATION = t.LocationCode
  AND t.LocationCode IS NOT NULL;

UPDATE inf_b_sendpro_provider_lookup t
SET LocationCode_lookup = LocationCode
WHERE length(t.LocationCode) = 3
  AND t.LocationCode_lookup IS NULL
  ;

UPDATE inf_b_sendpro_provider_lookup t
SET NPI_lookup = CASE 
    WHEN NOT MHTEAM.DWDQ.VALIDATE_NPI_LUHN_PY(NPI) THEN NULL
    ELSE NPI
END;
  
UPDATE inf_b_sendpro_provider_lookup t
SET LOCATIONCODE_lookup = 
            CASE WHEN length(t.LocationCode) <3 THEN lpad(s.ID_PROVIDER_LOCATION,3,'0')
                 WHEN length(t.LocationCode) >3 THEN substr(s.ID_PROVIDER_LOCATION,0,3)
                 ELSE s.ID_PROVIDER_LOCATION 
                 END          
FROM MHDWQA.NW.NW_B_PROVIDER s
WHERE s.ID_PROVIDER_LOCATION NOT IN ('#', '+', '-');

  
UPDATE inf_b_sendpro_provider_lookup t
SET LOCATIONCODE_lookup = 
            CASE WHEN length(t.LocationCode) <3 THEN lpad(s.ID_PROVIDER_LOCATION,3,'0')
                 WHEN length(t.LocationCode) >3 THEN substr(s.ID_PROVIDER_LOCATION,0,3)
                 ELSE s.ID_PROVIDER_LOCATION 
                 END          
FROM MHDWQA.NW.NW_B_PROVIDER s
WHERE s.ID_PROVIDER_LOCATION NOT IN ('#', '+', '-');
--  AND t.LocationCode = 
--            CASE WHEN length(t.LocationCode) <3 THEN lpad(s.ID_PROVIDER_LOCATION,3,'0')
--                 WHEN length(t.LocationCode) >3 THEN substr(s.ID_PROVIDER_LOCATION,0,3)
--                 ELSE s.ID_PROVIDER_LOCATION 
--                 END;


s.ID_PROVIDER_LOCATION
FROM MHDWQA.NW.NW_B_PROVIDER s
WHERE s.ID_PROVIDER_LOCATION NOT IN ('#', '+', '-')
  AND s.ID_PROVIDER_LOCATION = t.LocationCode;

		 WHEN ( NOT MHTEAM.DWDQ.VALIDATE_NPI_LUHN_PY(oop_OtherOperProvNPI) ) THEN 'INVALID'
         ELSE 'VALID' END oop_OtherOperProvNPI1X,


	    WHEN op_ProviderPidsl IS NOT NULL
        AND op_ProviderPidsl IN (SELECT ID_PROVIDER_LOCATION from MHDWQA.NW.NW_B_PROVIDER ap 
--          WHERE ID_PROVIDER_LOCATION NOT IN ('#','+','-') 
            WHERE ID_PROVIDER_LOCATION = op_ProviderPidsl


         WHEN (op_ProviderInternalId IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = op_ProviderInternalId
		 
		           AND op_ProviderLocationCode = (
            case when length(ID_PROVIDER_LOCATION) <3 then lpad(ID_PROVIDER_LOCATION,3,'0')
                 when length(ID_PROVIDER_LOCATION) >3 then substr(ID_PROVIDER_LOCATION,0,3)
                 else ID_PROVIDER_LOCATION 
             end)

         WHEN (oop_OtherOperProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT MHTEAM.DWDQ.VALIDATE_NPI_LUHN_PY(oop_OtherOperProvNPI) ) THEN 'INVALID'
         ELSE 'VALID' END oop_OtherOperProvNPI1X,
*/

select *
from inf_b_sendpro_provider_validate;


drop table inf_b_sendpro_provider_validate;

create table inf_b_sendpro_provider_validate
as
select internalId, NULL as internalId_lookup, Pidsl, NULL as Pidsl_lookup, LocationCode
--select internalId, NULL as internalId_lookup, Pidsl, NULL as Pidsl_lookup, LocationCode, NULL as LocationCode_lookup
from (
WITH AF AS (

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
substr(h."AdmissionDateHourDTP",1,8),'YYYYMMDD' as AdmissionDTP,
--to_date(substr(h."AdmissionDateHourDTP",1,8),'YYYYMMDD') as AdmissionDTP,

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
   h.RAW_SPRO_CLAIM_SEQ = atnd.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= atnd."PatientControlNum" and
   h."NumDtl"           = atnd."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_REFERRING_PROVIDER_DTL ref
on h."FileName"         = ref."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = ref.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ref."PatientControlNum" and
   h."NumDtl"           = ref."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_RENDERING_PROVIDER_DTL ren
on h."FileName"         = ren."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = ren.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ren."PatientControlNum" and
   h."NumDtl"           = ren."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OTHER_OPERATING_PHYS_PROVIDER_DTL oop
on h."FileName"         = oop."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = oop.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= oop."PatientControlNum" and
   h."NumDtl"           = oop."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OPERATING_PHYS_PROVIDER_DTL op
on h."FileName"         = op."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = op.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= op."PatientControlNum" and
   h."NumDtl"           = op."NumDtl"

order by
    TransSetControlNum,
    h."SubmitterID",
    FileName,
    h."PatientControlNum",
    to_number(d."NumDtl",4,0)
)
select 
ProviderInternalId as internalId, ProviderPidsl as Pidsl, NULL as LocationCode, BillingProvNPI as NPI
from af
UNION
select 
ProviderInternalId_bp as internalId, NULL as LocationCode, ProviderPidsl_bp as Pidsl, NULL as NPI
from af
UNION
select 
at_ProviderInternalId as internalId, at_ProviderPidsl as Pidsl, at_ProviderLocationCode as LocationCode, at_AttendingProvNPI as NPI
from af
UNION
select 
ref_ProviderInternalId as internalId, ref_ProviderPidsl as Pidsl, ref_ProviderLocationCode as LocationCode, ref_ReferringProvNPI as NPI
from af
UNION
select 
ren_ProviderInternalId as internalId, ren_ProviderPidsl as Pidsl, ren_ProviderLocationCode as LocationCode, ren_RenderingProvNPI as NPI
from af
UNION
select 
oop_ProviderInternalId as internalId, oop_ProviderPidsl as Pidsl, oop_ProviderLocationCode as LocationCode, oop_OtherOperProvNPI as NPI
from af
UNION
select 
op_ProviderInternalId as internalId, op_ProviderPidsl as Pidsl, op_ProviderLocationCode as LocationCode, op_OperatingProvNPI as NPI
from af
);


/*
ProviderInternalId,
ProviderPidsl,
BillingProvNPI,

ProviderInternalId_bp,
ProviderPidsl_bp,

at_AttendingProvNPI,
at_ProviderInternalId,
at_ProviderPidsl,
at_ProviderLocationCode,

ref_ReferringProvNPI,
ref_ProviderInternalId,
ref_ProviderPidsl,
ref_ProviderLocationCode,

ren_RenderingProvNPI,
ren_ProviderInternalId,
ren_ProviderPidsl,
ren_ProviderLocationCode,

oop_OtherOperProvNPI,
oop_ProviderInternalId,
oop_ProviderPidsl,
oop_ProviderLocationCode,

op_OperatingProvNPI,
op_ProviderInternalId,
op_ProviderPidsl,
op_ProviderLocationCode
*/

-----------------

select *
from (

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
substr(h."AdmissionDateHourDTP",1,8),'YYYYMMDD' as AdmissionDTP,
--to_date(substr(h."AdmissionDateHourDTP",1,8),'YYYYMMDD') as AdmissionDTP,

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
   h.RAW_SPRO_CLAIM_SEQ = atnd.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= atnd."PatientControlNum" and
   h."NumDtl"           = atnd."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_REFERRING_PROVIDER_DTL ref
on h."FileName"         = ref."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = ref.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ref."PatientControlNum" and
   h."NumDtl"           = ref."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_RENDERING_PROVIDER_DTL ren
on h."FileName"         = ren."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = ren.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= ren."PatientControlNum" and
   h."NumDtl"           = ren."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OTHER_OPERATING_PHYS_PROVIDER_DTL oop
on h."FileName"         = oop."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = oop.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= oop."PatientControlNum" and
   h."NumDtl"           = oop."NumDtl"

left join MHDWQA.SENDPRO.RAW_SPRO_837I_OPERATING_PHYS_PROVIDER_DTL op
on h."FileName"         = op."FileName" and
   h.RAW_SPRO_CLAIM_SEQ = op.RAW_SPRO_CLAIM_SEQ and
   h."PatientControlNum"= op."PatientControlNum" and
   h."NumDtl"           = op."NumDtl"

order by
    TransSetControlNum,
    h."SubmitterID",
    FileName,
    h."PatientControlNum",
    to_number(d."NumDtl",4,0)
)
