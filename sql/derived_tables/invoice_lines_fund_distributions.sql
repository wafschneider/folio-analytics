
DROP TABLE IF EXISTS local.invoice_lines_fund_distributions;

-- Create a local table for Fund Distributions

CREATE TABLE local.invoice_lines_fund_distributions AS
WITH funds_distr AS (
SELECT
    id AS invoice_line_id,
	json_extract_path_text(json_array_elements(json_extract_path(data, 'fundDistributions')), 'code') AS fund_distribution_code,
    json_extract_path_text(json_array_elements(json_extract_path(data, 'fundDistributions')), 'fundId') AS fund_distribution_id,
	json_extract_path_text(json_array_elements(json_extract_path(data, 'fundDistributions')), 'distributionType') AS fund_distribution_type,
	json_extract_path_text(json_array_elements(json_extract_path(data, 'fundDistributions')), 'value') AS fund_distribution_value,
	json_extract_path_text(data, 'subTotal') AS invoice_line_sub_total,
	json_extract_path_text(data, 'total') AS invoice_line_total
	FROM
        invoice_lines 
)
SELECT
	
	invoice_line_id AS invoice_line_id,
	fund_distribution_id AS fund_distribution_id,
	ff.fund_status AS finance_fund_status,
	ff.code AS finance_fund_code,
	ff.name AS fund_name,
	ff.id AS fund_type_id,
	fT.name AS fund_type_name,
	fund_distribution_value AS fund_distribution_value,
	fund_distribution_type AS fund_distribution_type,
	invoice_line_sub_total AS invoice_line_sub_total,
	invoice_line_total AS invoice_line_total
FROM funds_distr 

LEFT JOIN finance_funds AS ff
ON ff.id = funds_distr.fund_distribution_id

LEFT JOIN finance_fund_types AS ft
ON ft.id = ff.fund_type_id;

CREATE INDEX ON local.invoice_lines_fund_distributions (invoice_line_id);

CREATE INDEX ON local.invoice_lines_fund_distributions (fund_distribution_id);

CREATE INDEX ON local.invoice_lines_fund_distributions (finance_fund_status);

CREATE INDEX ON local.invoice_lines_fund_distributions (finance_fund_code);

CREATE INDEX ON local.invoice_lines_fund_distributions (fund_name);

CREATE INDEX ON local.invoice_lines_fund_distributions (fund_type_id);

CREATE INDEX ON local.invoice_lines_fund_distributions (fund_type_name);

CREATE INDEX ON local.invoice_lines_fund_distributions (fund_distribution_value);

CREATE INDEX ON local.invoice_lines_fund_distributions (fund_distribution_type);

CREATE INDEX ON local.invoice_lines_fund_distributions (invoice_line_sub_total);

CREATE INDEX ON local.invoice_lines_fund_distributions (invoice_line_total);

VACUUM LOCAL.invoice_lines_fund_distributions;

ANALYZE local.invoice_lines_fund_distributions;

