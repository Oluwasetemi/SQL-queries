SELECT * FROM sample.names;

SELECT id,
   SUBSTRING_INDEX(SUBSTRING_INDEX(name, ' ', 1), ' ', -1) AS first_name,
   If(  length(name) - length(replace(name, ' ', ''))>1,  
       SUBSTRING_INDEX(SUBSTRING_INDEX(name, ' ', 2), ' ', -1) ,NULL) 
           as middle_name,
   SUBSTRING_INDEX(SUBSTRING_INDEX(name, ' ', 3), ' ', -1) AS last_name,
	CONCAT(first_name, '-', last_name)
FROM sample.names;
