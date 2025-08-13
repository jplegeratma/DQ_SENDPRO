


-- SQL based

SELECT value from table(split('80840123456789', ''));

SELECT VALUE
FROM TABLE(SPLIT('apple,banana,cherry', ','));


SELECT table1.value
  FROM TABLE(SPLIT_TO_TABLE('a.b', '.')) AS table1
  ORDER BY table1.value;


WITH 
            digits AS (
                SELECT SPLIT_TO_TABLE('80840' || LEFT(npi, 9), '') AS digit, SEQ4() AS pos
            ),
            luhn_calc AS (
                SELECT
                    digit::INTEGER AS d,
                    pos,
                    CASE
                        WHEN MOD(pos, 2) = 0 THEN d
                        ELSE
                            CASE
                                WHEN d * 2 > 9 THEN d * 2 - 9
                                ELSE d * 2
                            END
                    END AS luhn_val
                FROM digits
                WHERE digit <> ''
            )

select 
BillingProvNPI,
         
    CASE
        WHEN LENGTH(npi) != 10 OR npi NOT RLIKE '^[0-9]{10}$' THEN FALSE
        ELSE
            -- Concatenate the prefix '80840' with the first 9 digits of the NPI
            -- The 10th digit is the check digit
            SELECT
                MOD(SUM(luhn_val), 10) = npi::VARCHAR::RIGHT(1)::INTEGER
            FROM luhn_calc
    END luhn_valid     

    from (
select 
h."BillingProvNPI" as BillingProvNPI.
h."BillingProvNPI" as npi
from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM as h
limit 100
);

------------------------------------

CREATE OR REPLACE FUNCTION VALIDATE_NPI_LUHN(npi VARCHAR)
RETURNS BOOLEAN
LANGUAGE SQL
AS
$$
    -- NPI must be 10 digits and start with a valid prefix (usually 1 or 2)
    -- The Luhn check for NPI uses a prefix of '80840' before the NPI for calculation
    -- See: https://www.cms.gov/Regulations-and-Guidance/Administrative-Simplification/NationalProvIdentStand/downloads/NPIcheckdigit.pdf

    -- Only proceed if NPI is 10 digits
    CASE
        WHEN LENGTH(npi) != 10 OR npi NOT RLIKE '^[0-9]{10}$' THEN FALSE
        ELSE
            -- Concatenate the prefix '80840' with the first 9 digits of the NPI
            -- The 10th digit is the check digit
            WITH digits AS (
                SELECT SPLIT_TO_TABLE('80840' || LEFT(npi, 9), '') AS digit, SEQ4() AS pos
            ),
            luhn_calc AS (
                SELECT
                    digit::INTEGER AS d,
                    pos,
                    CASE
                        WHEN MOD(pos, 2) = 0 THEN d
                        ELSE
                            CASE
                                WHEN d * 2 > 9 THEN d * 2 - 9
                                ELSE d * 2
                            END
                    END AS luhn_val
                FROM digits
                WHERE digit <> ''
            )
            SELECT
                MOD(SUM(luhn_val), 10) = npi::VARCHAR::RIGHT(1)::INTEGER
            FROM luhn_calc
    END
$$;

-----------------

-- Python

-- filepath: validate_npi_luhn.py
CREATE OR REPLACE FUNCTION VALIDATE_NPI_LUHN_PY(npi STRING)
RETURNS BOOLEAN
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
HANDLER = 'luhn_check'
AS
$$
def luhn_check(npi):
    # NPI must be 10 digits
    if npi is None or len(npi) != 10 or not npi.isdigit():
        return False

    # Prepend '80840' to the first 9 digits of the NPI
    base = '80840' + npi[:9]
    digits = [int(d) for d in base]

    # Apply Luhn algorithm
    total = 0
    # Luhn: right to left, double every other digit starting from the right
    # For NPI, the rightmost digit of base is position 1
    for i in range(len(digits)-1, -1, -1):
        d = digits[i]
        if (len(digits) - i) % 2 == 1:
            d = d * 2
            if d > 9:
                d -= 9
        total += d

    # Calculate check digit
    check_digit = (10 - (total % 10)) % 10

    # Compare to the last digit of the NPI
    return check_digit == int(npi[-1])

#return luhn_check(NPI)
$$;

--SELECT VALIDATE_NPI_LUHN_PY('1234567893') ; --AS is_valid;
SELECT VALIDATE_NPI_LUHN_PY('2234567893') ; --AS is_valid;


-- Java

-- filepath: validate_npi_luhn_java.sql
CREATE OR REPLACE FUNCTION VALIDATE_NPI_LUHN_JAVA(npi STRING)
RETURNS BOOLEAN
LANGUAGE JAVA
RUNTIME_VERSION = '11'
HANDLER = 'ValidateNpiLuhn.validateNpiLuhn'
AS
$$
public class ValidateNpiLuhn {
    public static Boolean validateNpiLuhn(String npi) {
        if (npi == null || npi.length() != 10 || !npi.matches("\\d{10}")) {
            return false;
        }

        String base = "80840" + npi.substring(0, 9);
        int total = 0;
        int len = base.length();

        for (int i = len - 1; i >= 0; i--) {
            int d = Character.getNumericValue(base.charAt(i));
            // Luhn: double every other digit from the right (rightmost is position 1)
            if ((len - i) % 2 == 1) {
                d *= 2;
                if (d > 9) {
                    d -= 9;
                }
            }
            total += d;
        }

        int checkDigit = (10 - (total % 10)) % 10;
        return checkDigit == Character.getNumericValue(npi.charAt(9));
    }
}
$$;

SELECT VALIDATE_NPI_LUHN_JAVA('1234567893') ; --AS is_valid;
SELECT VALIDATE_NPI_LUHN_JAVA('2234567893') ; --AS is_valid;

------------------

drop table test_python_udf

--create temp table test_python_udf
--as

select 
BillingProvNPI,
/*
    CASE  
         WHEN (BillingProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ENC_PROV_ID from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ENC_PROV_ID NOT IN ('#','+','-') AND ENC_PROV_ID = BillingProvNPI) )
         THEN 'INVALID'
         ELSE 'VALID' END BillingProvNPI_ENC_PROV_ID,


    CASE  
         WHEN (BillingProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ID_NPI from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ID_NPI NOT IN ('#','+','-') AND ID_NPI = BillingProvNPI) )
         THEN 'INVALID'
         ELSE 'VALID' END BillingProvNPI_NPI_ID,

*/

    CASE  
         WHEN (BillingProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT VALIDATE_NPI_LUHN_PY(BillingProvNPI) ) THEN 'INVALID'
         ELSE 'VALID' END BillingProvNPI_NPI_ID,

VALIDATE_NPI_LUHN_PY(BillingProvNPI) AS BillingProvNPI_valid

         
         from (
select 
h."BillingProvNPI" as BillingProvNPI
from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM as h
limit 100
);

select count(1) from test_python_udf;

select * from test_python_udf
where BillingProvNPI_valid = TRUE;


-- ID_NPI

select count(1) from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM;

select 
BillingProvNPI,

    CASE  
         WHEN (BillingProvNPI IS NULL ) THEN 'NULL'
		 WHEN ( NOT EXISTS (SELECT ID_NPI from MHDWDEV.SENDPRO.spro_b_enc_provider_hist where ID_NPI NOT IN ('#','+','-') AND ID_NPI = BillingProvNPI) )
         THEN 'INVALID'
         ELSE 'VALID' END BillingProvNPI
from (
select 
h."BillingProvNPI" as BillingProvNPI
from MHDWQA.SENDPRO.RAW_SPRO_837P_CLAIM as h
limit 100
);



left join MHDWQA.SENDPRO.RAW_SPRO_837P_BILLING_PROVIDER_DTL bp
on bp."TransSetControlNum"  = h."TransSetControlNum" and
   bp."SendProTransId"      = h."SendProTransId" and
   bp.RAW_SPRO_BPROV_SEQ    = h.RAW_SPRO_BPROV_SEQ





