CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `sql_invoicing`.`client_balance` AS
    SELECT 
        `c`.`client_id` AS `client_id`,
        `c`.`name` AS `name`,
        SUM((`i`.`invoice_total` - `i`.`payment_total`)) AS `balance`
    FROM
        (`sql_invoicing`.`clients` `c`
        JOIN `sql_invoicing`.`invoices` `i` ON ((`c`.`client_id` = `i`.`client_id`)))
    GROUP BY `c`.`client_id` , `c`.`name`