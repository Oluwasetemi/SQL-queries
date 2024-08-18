CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `sql_invoicing`.`sales_by_client` AS
    SELECT 
        `c`.`client_id` AS `client_id`,
        `c`.`name` AS `name`,
        SUM(`i`.`invoice_total`) AS `total_sales`
    FROM
        (`sql_invoicing`.`clients` `c`
        JOIN `sql_invoicing`.`invoices` `i` ON ((`c`.`client_id` = `i`.`client_id`)))
    GROUP BY `c`.`client_id` , `c`.`name`
    ORDER BY `total_sales`