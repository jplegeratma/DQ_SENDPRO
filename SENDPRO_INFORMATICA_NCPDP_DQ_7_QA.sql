
select distinct filename
from MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV_DETAIL
order by filename;


select distinct *
from MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV_DETAIL
where filename = 
'110088791b_ncpdp_13032025174041_sit_de_010220250999999919994.xml'
--'110088791b_ncpdp_12032025190924_sit_pd_ebebc531-e430-44c8-8ef8-b7cec6531d4b.xml'


select distinct *
from MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV
where filename = 
'110088791b_ncpdp_13032025174041_sit_de_010220250999999919994.xml'
--'110088791b_ncpdp_12032025190924_sit_pd_ebebc531-e430-44c8-8ef8-b7cec6531d4b.xml'


GRANT SELECT ON MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV_DETAIL TO DI_TEAM_ROLE;
GRANT SELECT ON MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV TO DI_TEAM_ROLE;


SELECT COUNT(1) FROM MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA;
SELECT DISTINCT RUN_DATE, FILENAME FROM MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA;

select count(1) from (
SELECT DISTINCT RUN_DATE, FILENAME, CLAIM_TYPE, SubscriberMemberID, Numdtl,
 FROM MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA
)


SELECT * FROM INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV_DETAIL;

SELECT COUNT(1) FROM INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV_DETAIL;

-- DROP VIEW INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV_DETAIL 



select count(1)
from (
--SELECT DISTINCT * 
SELECT DISTINCT subscribermemberid, numdtl, DOS, NDCServ
 
FROM MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV_DETAIL
where FileName = 
--'110088791b_ncpdp_13032025174041_sit_de_010220250999999919994.xml'
--'110088791b_ncpdp_12032025190924_sit_pd_ebebc531-e430-44c8-8ef8-b7cec6531d4b.xml'
'110031447b_ncpdp_05052025075304_test_pd_d3fe200e-3664-437f-94b9-95d4893ed2e8.xml'
and measure = 'SERVICE_PROVIDER_NPI'
and type = 'VALID'
)

select *
from MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV
where FileName in (
'110031447b_ncpdp_04302025132830_test_de_2cefd7ea-140a-43c6-8f0b-646e82132bdf.xml',
'110031447b_ncpdp_05052025075304_test_pd_d3fe200e-3664-437f-94b9-95d4893ed2e8.xml'
)
order by FileName, MEASURE, TYPE


select count(1)
from (
SELECT DISTINCT * 
FROM MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_QA
where FileName = 
--'110088791b_ncpdp_13032025174041_sit_de_010220250999999919994.xml'
--'110088791b_ncpdp_12032025190924_sit_pd_ebebc531-e430-44c8-8ef8-b7cec6531d4b.xml'
--'110031447b_ncpdp_05052025075304_test_pd_d3fe200e-3664-437f-94b9-95d4893ed2e8.xml'
--'110031447b_ncpdp_04302025132830_test_de_2cefd7ea-140a-43c6-8f0b-646e82132bdf.xml'
'110031447b_ncpdp_05052025075304_test_pd_d3fe200e-3664-437f-94b9-95d4893ed2e8.xml'
)

select distinct FileName from MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_QA
order by FileName;

DROP VIEW INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV_DETAIL;

CREATE VIEW INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV_DETAIL
AS

-- limit rank to 10 lines
SELECT *
FROM (
-- rank
  SELECT *,
                                            RANK ()
                                            OVER (PARTITION BY RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               MEASURE
                                                  ORDER BY
                                                               RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               MEASURE,
                                                               TYPE,
                                                               PATIENTCONTROLNUM,
                                                               NUMDTL)    AS rnk

  FROM (

-- only first claim line

SELECT *
  FROM (

-- core unpiv

SELECT RUN_DATE, FILENAME, CLAIM_TYPE, MEASURE, TYPE, SubscriberMemberID, Numdtl,
PAHdrSendingEntityID,
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
PrescriberSecID

FROM (
    SELECT 
RUN_DATE,
claim_type,
PAHdrSendingEntityID,
Filename,
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
	SUBSCRIBERMEMBERID1X AS Cardholder_Id,
	NDCSERV1X            AS NDC,
	COMPNDPRODCODE1X     AS Compound_NDC,
	ADJUDICATIONDATE1X   AS Adjudication_Date, 
	SERVPROVNPI1X        AS Service_Provider_NPI,
	SERVPROVSECID1X      AS Service_Provider_ID,
    PRESCRIBERNPI1X      AS Prescriber_Provider_NPI,
    PRESCRIBERSECID1X    AS Prescriber_Provider_ID,
    SubscriberMemberID,
    Numdtl
    FROM MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA
)
UNPIVOT (
TYPE
FOR MEASURE IN (
 	Cardholder_Id,
	NDC,
	Compound_NDC,
	Adjudication_Date,
	Service_Provider_NPI,
	Service_Provider_ID,
    Prescriber_Provider_NPI,
    Prescriber_Provider_ID
 )
) AS UNPIV
ORDER BY RUN_DATE, FILENAME, CLAIM_TYPE, MEASURE, TYPE

)
-- only first claim line
    WHERE NUMDTL = 1
    )
-- add rank
)
-- limit rank to 10 line
WHERE rnk <= 10
ORDER BY 
                                                               RUN_DATE,
                                                               FILENAME,
                                                               CLAIM_TYPE,
                                                               MEASURE,
                                                               TYPE,
                                                               PATIENTCONTROLNUM,
                                                               RNK
;


/*
------------
-- use this if seperate QA state from detail data
CREATE VIEW INF_SENDPRO_NCPDP_DQ_QA_6_UNPIV_DETAIL_JOIN
AS
select DISTINCT d.MEASURE,d.TYPE, 
v.claim_type,
v.run_date,
v.PAHdrSendingEntityID,
v.Filename,
v.SubscriberMemberID,
v.Numdtl,
v.DOS,
v.ServProvNPI,
v.NDCServ,
v.ProdCode01,
v.ProdCode02,
v.ProdCode03,
v.CompndProdCode01,
v.CompndProdCode02,
v.CompndProdCode03,
v.AdjudicationDate,
v.TransID,
v.TransIDCrossRef
from MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_6_QA v
LEFT JOIN  INF_SENDPRO_NCPDP_DQ_QA_6_UNPIV_DETAIL d
ON  d.FILENAME = v.FILENAME
AND d.SubscriberMemberID = v.SubscriberMemberID
AND d.NumDtl = v.NumDtl;

------------

-- no detail use with join back to detail data
CREATE VIEW INF_SENDPRO_NCPDP_DQ_QA_6_UNPIV_DETAIL
AS
SELECT RUN_DATE, FILENAME, CLAIM_TYPE, MEASURE, TYPE, SubscriberMemberID, Numdtl
FROM (
    SELECT
    RUN_DATE,
    FILENAME, 
    CLAIM_TYPE,
	SERVPROVNPI1X        AS Service_Provider_Id,
	SUBSCRIBERMEMBERID1X AS Cardholder_Id,
	NDCSERV1X            AS NDC,
	COMPNDPRODCODE1X     AS Compound_NDC,
	ADJUDICATIONDATE1X   AS Adjudication_Date, 
    SubscriberMemberID,
    Numdtl
    FROM MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_6_QA
)
UNPIVOT (
TYPE
FOR MEASURE IN (
    Service_Provider_Id,
	Cardholder_Id,
	NDC,
	Compound_NDC,
	Adjudication_Date 
)
) AS INF_SENDPRO_NCPDP_DQ_QA_6_UNPIV
ORDER BY RUN_DATE, FILENAME, CLAIM_TYPE, MEASURE, TYPE;
*/
------------

--DROP VIEW INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV;

select count(1)
SELECT * 
FROM INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV
where FileName = 
--'110088791b_ncpdp_13032025174041_sit_de_010220250999999919994.xml'
--'110088791b_ncpdp_12032025190924_sit_pd_ebebc531-e430-44c8-8ef8-b7cec6531d4b.xml'
'110031447b_ncpdp_05052025075304_test_pd_d3fe200e-3664-437f-94b9-95d4893ed2e8.xml'

-- select *
select count(1)
--select distinct "FileName"
FROM MHDWQA.SENDPRO.RAW_SPRO_NCPDP_CLAIM h
where "FileName" = 
--'110088791b_ncpdp_13032025174041_sit_de_010220250999999919994.xml'
--'110088791b_ncpdp_12032025190924_sit_pd_ebebc531-e430-44c8-8ef8-b7cec6531d4b.xml'
'110031447b_ncpdp_05052025075304_test_pd_d3fe200e-3664-437f-94b9-95d4893ed2e8.xml'
;

select count(1)
from (
SELECT DISTINCT * 
FROM MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_QA
where FileName = 
--'110088791b_ncpdp_13032025174041_sit_de_010220250999999919994.xml'
--'110088791b_ncpdp_12032025190924_sit_pd_ebebc531-e430-44c8-8ef8-b7cec6531d4b.xml'
'110031447b_ncpdp_05052025075304_test_pd_d3fe200e-3664-437f-94b9-95d4893ed2e8.xml'
)

select count(1)
from (
SELECT DISTINCT * 
FROM MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA
where FileName = 
--'110088791b_ncpdp_13032025174041_sit_de_010220250999999919994.xml'
--'110088791b_ncpdp_12032025190924_sit_pd_ebebc531-e430-44c8-8ef8-b7cec6531d4b.xml'
'110031447b_ncpdp_05052025075304_test_pd_d3fe200e-3664-437f-94b9-95d4893ed2e8.xml'
)


DROP VIEW INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV;

-- 7/9 added benchmark

CREATE VIEW INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV
AS

SELECT DISTINCT RUN_DATE, FILENAME, CLAIM_TYPE, MEASURE, PAHdrSendingEntityID, TYPE, REC_CNT,
L.BENCHMARK_THRESHOLD
FROM (
SELECT DISTINCT RUN_DATE, FILENAME, CLAIM_TYPE, MEASURE, PAHdrSendingEntityID, TYPE, COUNT(TYPE) AS REC_CNT
FROM (
SELECT RUN_DATE, FILENAME, CLAIM_TYPE, PAHdrSendingEntityID, MEASURE, TYPE
FROM (
    SELECT
    RUN_DATE,
    FILENAME, 
    CLAIM_TYPE,
    PAHdrSendingEntityID,
	SUBSCRIBERMEMBERID1X AS Cardholder_Id,
	NDCSERV1X            AS NDC,
	COMPNDPRODCODE1X     AS Compound_NDC,
	ADJUDICATIONDATE1X   AS Adjudication_Date, 
	SERVPROVNPI1X        AS Service_Provider_NPI,
	SERVPROVSECID1X      AS Service_Provider_ID,
    PRESCRIBERNPI1X      AS Prescriber_Provider_NPI,
    PRESCRIBERSECID1X    AS Prescriber_Provider_ID
    
    FROM MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_QA
)
UNPIVOT (
TYPE
FOR MEASURE IN (
	Cardholder_Id,
	NDC,
	Compound_NDC,
	Adjudication_Date, 
	Service_Provider_NPI,
	Service_Provider_ID,
    Prescriber_Provider_NPI,
    Prescriber_Provider_ID
)
) AS INF_SENDPRO_NCPDP_DQ_QA_7_UNPIV
ORDER BY RUN_DATE, FILENAME, CLAIM_TYPE, MEASURE, TYPE
)
GROUP BY RUN_DATE, FILENAME, CLAIM_TYPE, PAHdrSendingEntityID, MEASURE, TYPE
) A
JOIN INF_B_SENDPRO_LOOKUP L ON A.MEASURE = L.BENCHMARK
ORDER BY FILENAME, CLAIM_TYPE, MEASURE, TYPE;

--------------

GRANT SELECT ON MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_BI_STATS_7_QA TO DI_TEAM_ROLE;
GRANT SELECT ON MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_BI_7_QA TO DI_TEAM_ROLE;
GRANT SELECT ON MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_QA TO DI_TEAM_ROLE;
GRANT SELECT ON MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA TO DI_TEAM_ROLE;

SELECT * FROM MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_BI_STATS_7_QA;

SELECT * FROM MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_BI_7_QA;

SELECT * FROM MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_QA;

SELECT * FROM MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA
order by Filename;

-- DROP VIEW MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_BI_STATS_7_QA

CREATE VIEW MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_BI_STATS_7_QA
AS
SELECT DISTINCT
RUN_DATE,
claim_type,
Filename,
PAHdrSendingEntityID,

SUM_SUBSCRIBERMEMBERID1/SUM_TOT_REX PCT_SUBSCRIBERMEMBERID1,
SUM_NDCSERV1/SUM_TOT_REX PCT_NDCSERV1,
SUM_COMPNDPRODCODE1/SUM_TOT_REX PCT_COMPNDPRODCODE1,
SUM_ADJUDICATIONDATE1/SUM_TOT_REX PCT_ADJUDICATIONDATE1,
SUM_SERVPROVNPI1/SUM_TOT_REX PCT_SERVPROVNPI1,
SUM_SERVPROVSECID1/SUM_TOT_REX PCT_SERVPROVSECID1,
SUM_PRESCRIBERNPI1/SUM_TOT_REX PCT_PRESCRIBERNPI1,
SUM_PRESCRIBERSECID1/SUM_TOT_REX PCT_PRESCRIBERSECID1,

SUM_SUBSCRIBERMEMBERID1,
SUM_NDCSERV1,
SUM_COMPNDPRODCODE1,
SUM_ADJUDICATIONDATE1,
SUM_SERVPROVNPI1,
SUM_SERVPROVSECID1,
SUM_PRESCRIBERNPI1,
SUM_PRESCRIBERSECID1,

SUM_TOT_REX
FROM (
SELECT
RUN_DATE,
claim_type,
Filename,
PAHdrSendingEntityID,
SUM(SUBSCRIBERMEMBERID1) SUM_SUBSCRIBERMEMBERID1,
SUM(NDCSERV1) SUM_NDCSERV1,
SUM(COMPNDPRODCODE1) SUM_COMPNDPRODCODE1,
SUM(ADJUDICATIONDATE1) SUM_ADJUDICATIONDATE1,
SUM(SERVPROVNPI1) SUM_SERVPROVNPI1,
SUM(SERVPROVSECID1) SUM_SERVPROVSECID1,
SUM(PRESCRIBERNPI1) SUM_PRESCRIBERNPI1,
SUM(PRESCRIBERSECID1) SUM_PRESCRIBERSECID1,
SUM(TOT_REX) SUM_TOT_REX
FROM MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_BI_7_QA A
LEFT JOIN MHDWQA.SENDPRO.RAW_SPRO_NCPDP_STATISTICS S
--ON  A.SendProTransId       = S."SendProTransId"
--AND A.PAHdrSendingEntityID = S."PAHdrSendingEntityID"
--AND A.PAHdrBatchNum        = S."PAHdrBatchNum"
ON A.Filename             = S."FileName"

GROUP BY
RUN_DATE,
claim_type,
Filename,
PAHdrSendingEntityID
)
ORDER BY
RUN_DATE,
claim_type,
Filename
;

--DROP VIEW MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_BI_7_QA;

CREATE VIEW MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_BI_7_QA
AS
SELECT
RUN_DATE,
claim_type,
Filename,
PAHdrSendingEntityID,
SubscriberMemberID,
Numdtl,
DOS,
ServProvNPI,
ServProvSecID,
PrescriberNPI,
PrescriberSecID,
	SUBSCRIBERMEMBERID1,
	NDCSERV1,
	COMPNDPRODCODE1,
	ADJUDICATIONDATE1,
	SERVPROVNPI1,
	SERVPROVSECID1,
    PRESCRIBERNPI1,
    PRESCRIBERSECID1,
TOT_REX
FROM MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA;

--DROP VIEW MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_QA;


CREATE VIEW MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_QA
AS
SELECT
RUN_DATE,
claim_type,
Filename,
PAHdrSendingEntityID,
SubscriberMemberID,
Numdtl,
DOS,
NDCServ,
ServProvNPI,
ServProvSecID,
PrescriberNPI,
PrescriberSecID,
	SUBSCRIBERMEMBERID1X,
	NDCSERV1X,
	COMPNDPRODCODE1X,
	ADJUDICATIONDATE1X,
	SERVPROVNPI1X,
	SERVPROVSECID1X,
    PRESCRIBERNPI1X,
    PRESCRIBERSECID1X
FROM MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA;
/*
	SUBSCRIBERMEMBERID1,
	SUBSCRIBERMEMBERID1X,
	NDCSERV1,
	NDCSERV1X,
	COMPNDPRODCODE1,
	COMPNDPRODCODE1X,
	ADJUDICATIONDATE1,
	ADJUDICATIONDATE1X,
	SERVPROVNPI1,
	SERVPROVNPI1X,
	SERVPROVSECID1,
	SERVPROVSECID1X,
    PRESCRIBERNPI1,
    PRESCRIBERNPI1X,
    PRESCRIBERSECID1,
    PRESCRIBERSECID1X
*/
------------------------

DROP TABLE MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA;


select count(1)
from (select distinct *

--SELECT * 
FROM MHTEAM.DWDQ.INF_SENDPRO_NCPDP_DQ_QA_7_QA
where FileName = 
--'110088791b_ncpdp_13032025174041_sit_de_010220250999999919994.xml'
--'110088791b_ncpdp_12032025190924_sit_pd_ebebc531-e430-44c8-8ef8-b7cec6531d4b.xml'
'110031447b_ncpdp_05052025075304_test_pd_d3fe200e-3664-437f-94b9-95d4893ed2e8.xml'
order by subscribermemberid, numdtl

)

select count(1)
from (select distinct *

SELECT * 
FROM MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA
where FileName = 
--'110088791b_ncpdp_13032025174041_sit_de_010220250999999919994.xml'
--'110088791b_ncpdp_12032025190924_sit_pd_ebebc531-e430-44c8-8ef8-b7cec6531d4b.xml'
'110031447b_ncpdp_05052025075304_test_pd_d3fe200e-3664-437f-94b9-95d4893ed2e8.xml'
order by subscribermemberid, numdtl


)


-- select *
select count(1)
--select distinct "FileName"
FROM MHDWQA.SENDPRO.RAW_SPRO_NCPDP_CLAIM h
where "FileName" = 
--'110088791b_ncpdp_13032025174041_sit_de_010220250999999919994.xml'
--'110088791b_ncpdp_12032025190924_sit_pd_ebebc531-e430-44c8-8ef8-b7cec6531d4b.xml'
'110031447b_ncpdp_05052025075304_test_pd_d3fe200e-3664-437f-94b9-95d4893ed2e8.xml'
;


TRUNCATE TABLE MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA;


-- 8/7/2025
-- switching to incremental

--CREATE TABLE MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA
--AS

-- using  MHTEAM.DWDQ.VALIDATE_NPI_LUHN_PY(BillingProvNPI) and MHDWQA.NW.NW_PROVIDER

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
		AND MHTEAM.DWDQ.VALIDATE_NPI_LUHN_PY(ServProvNPI)        
        THEN 1 ELSE 0 END ServProvNPI1,

--  Ex
    CASE  
         WHEN (ServProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT MHTEAM.DWDQ.VALIDATE_NPI_LUHN_PY(ServProvNPI) ) THEN 'INVALID'
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
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ServProvSecID
        
        )
        THEN 1 ELSE 0 END ServProvSecID1,

--  Ex
    CASE  
         WHEN (ServProvSecID IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = ServProvSecID) )
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
		AND MHTEAM.DWDQ.VALIDATE_NPI_LUHN_PY(PrescriberNPI)        
        THEN 1 ELSE 0 END PrescriberNPI1,

--  Ex
    CASE  
         WHEN (PrescriberNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT MHTEAM.DWDQ.VALIDATE_NPI_LUHN_PY(PrescriberNPI) ) THEN 'INVALID'
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
        
        SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = PrescriberSecID
        
        )
        THEN 1 ELSE 0 END PrescriberSecID1,

--  Ex
    CASE  
         WHEN (PrescriberSecID IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = PrescriberSecID) )
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

    where FileName NOT IN ( SELECT DISTINCT FileName from MHTEAM.DWDQ.INF_B_SENDPRO_NCPDP_DQ_7_QA )
    
    );
