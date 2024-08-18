CREATE DEFINER=`root`@`localhost` PROCEDURE `get_payments`(
	client_id INT,
    payment_method_id TINYINT
)
BEGIN
	SELECT *
	FROM payments p
	WHERE p.client_id = IFNULL(client_id, p.client_id) AND
		p.payment_method = IFNULL(payment_method_id, p.payment_method);
END