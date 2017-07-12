CREATE OR REPLACE FUNCTION get_sum(
 a NUMERIC, 
 b NUMERIC) 
RETURNS NUMERIC AS $$
BEGIN
 RETURN a + b;
END; $$
 
LANGUAGE plpgsql;