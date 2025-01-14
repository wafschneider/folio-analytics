DROP TABLE IF EXISTS feesfines_accounts_actions;

-- Create a derived table that takes feesfines_accounts as the main table
-- join all transaction data from the feesfines_actions table
-- add patron group information from user_group table
CREATE TABLE feesfines_accounts_actions AS
SELECT
    fa.id AS fine_account_id,
    json_extract_path_text(fa.data, 'amount')::numeric(12,2) AS fine_account_amount,
    json_extract_path_text(fa.data, 'dateCreated') AS fine_date,
    json_extract_path_text(fa.data, 'dateUpdated') AS fine_updated_date,
    json_extract_path_text(fa.data, 'feeFineId') AS fee_fine_id,
    json_extract_path_text(fa.data, 'ownerId') AS owner_id,
    json_extract_path_text(fa.data, 'feeFineOwner') AS fee_fine_owner,
    json_extract_path_text(fa.data, 'feeFineType') AS fee_fine_type,
    json_extract_path_text(fa.data, 'materialTypeId') AS material_type_id,
    json_extract_path_text(fa.data, 'materialType') AS material_type,
    json_extract_path_text(fa.data, 'payment_status') AS payment_status,
    json_extract_path_text(fa.data, 'status', 'name') AS fine_status, -- open or closed
    json_extract_path_text(fa.data, 'userId') AS account_user_id,
    ff.id AS transaction_id,
    json_extract_path_text(ff.data, 'accountId') AS account_id,
    json_extract_path_text(ff.data, 'amountAction')::numeric(12,2) AS transaction_amount,
    json_extract_path_text(ff.data, 'balance')::numeric(12,2) AS account_balance,
    json_extract_path_text(ff.data, 'typeAction') AS type_action,
    json_extract_path_text(ff.data, 'dateAction') AS transaction_date,
    json_extract_path_text(ff.data, 'createdAt') AS transaction_location,
    json_extract_path_text(ff.data, 'transactionInformation') AS transaction_information,
    json_extract_path_text(ff.data, 'source') AS operator_id,
    json_extract_path_text(ff.data, 'paymentMethod') AS payment_method,
    uu.id AS user_id,
    uu.patron_group AS user_patron_group_id,
    ug.id AS patron_group_id,
    ug.group AS patron_group_name
FROM
    feesfines_accounts AS fa
    LEFT JOIN feesfines_feefineactions AS ff ON fa.id = json_extract_path_text(ff.data, 'accountId')
    LEFT JOIN user_users AS uu ON json_extract_path_text(fa.data, 'userId') = uu.id
    LEFT JOIN user_groups AS ug ON uu.patron_group = ug.id;

