CREATE TABLE keepcoding.ivr_summary AS (

WITH base_query AS (
  SELECT -- GENERA EL TIPO DE DOCUMENTO 
    detail.calls_ivr_id,
    MAX(COALESCE(document_type, 'UNKNOWN')) AS document_type,
    MAX(COALESCE(document_identification, 'UNKNOWN')) AS document_identification,
    MAX(COALESCE(customer_phone, 'UNKNOWN')) AS customer_phone,
    MAX(COALESCE(billing_account_id, 'UNKNOWN')) AS billing_account_id
  FROM 
   keepcoding.ivr_detail AS detail
  WHERE
    (
      document_type IS DISTINCT FROM 'UNKNOWN'
      AND document_identification IS DISTINCT FROM 'UNKNOWN'
      AND customer_phone IS DISTINCT FROM 'UNKNOWN'
      AND billing_account_id IS DISTINCT FROM 'UNKNOWN'
    )
    OR (
      customer_phone = 'UNKNOWN'
      AND (document_type IS DISTINCT FROM 'UNKNOWN')
      AND (document_identification IS DISTINCT FROM 'UNKNOWN')
      AND (billing_account_id IS DISTINCT FROM 'UNKNOWN')
    )
  GROUP BY detail.calls_ivr_id
)

SELECT 
  doc.calls_ivr_id AS ivr_id,
  detail.calls_phone_number AS phone_number,

  detail.calls_ivr_result AS ivr_result,



    CASE
    WHEN detail.calls_vdn_label LIKE 'ATC' THEN 'FRONT'
    WHEN detail.calls_vdn_label LIKE 'TECH' THEN 'TECH'
    WHEN detail.calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
    ELSE 'RESTO'
  END AS vdn_aggregation,

  detail.calls_start_date AS start_date,
  detail.calls_end_date AS end_date,
  detail.calls_total_duration AS total_duration,
  detail.calls_customer_segment AS customer_segment,
  detail.calls_ivr_language AS ivr_language,
  detail.calls_steps_module AS steps_module,
  detail.calls_module_aggregation AS module_aggregation,

---- 
  doc.document_type,
  doc.document_identification,
  doc.customer_phone,
  doc.billing_account_id,
  
  
  ---
  CASE
    WHEN modules.module_name = 'AVERIA_MASIVA' THEN 1
    ELSE 0
  END AS masiva_lg,
  
  ---
  
  MAX(CASE
    WHEN steps.step_name = 'CUSTOMERINFOBYPHONE.TX' AND steps.step_description_error = 'UNKNOWN' THEN 1
    ELSE 0
  END) AS info_by_phone_lg,
  MAX(CASE
    WHEN steps.step_name = 'CUSTOMERINFOBYDNI.TX' AND steps.step_description_error = 'UNKNOWN' THEN 1
    ELSE 0
  END) AS info_by_dni_lg
FROM 
  base_query AS doc
LEFT JOIN 
 keepcoding.ivr_detail AS detail
ON 
  doc.calls_ivr_id = detail.calls_ivr_id
LEFT JOIN 
  keepcoding.ivr_modules AS modules
ON 
  doc.calls_ivr_id = modules.ivr_id AND modules.module_name = 'AVERIA_MASIVA'
LEFT JOIN 
  keepcoding.ivr_steps AS steps
ON 
  doc.calls_ivr_id = steps.ivr_id
  AND (steps.step_name = 'CUSTOMERINFOBYPHONE.TX' AND steps.step_description_error = 'UNKNOWN'
    OR steps.step_name = 'CUSTOMERINFOBYDNI.TX' AND steps.step_description_error = 'UNKNOWN')
GROUP BY
  doc.calls_ivr_id,
  doc.document_type,
  doc.document_identification,
  doc.customer_phone,
  doc.billing_account_id,
  detail.calls_phone_number,
  detail.calls_ivr_result,
  vdn_aggregation,
  detail.calls_start_date,
  detail.calls_end_date,
  detail.calls_total_duration,
  detail.calls_customer_segment,
  detail.calls_ivr_language,
  detail.calls_steps_module,
  detail.calls_module_aggregation,
  masiva_lg);
