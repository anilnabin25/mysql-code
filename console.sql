mysql -u root --password=password@123


SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       COUNT(item_master_id) AS total_stocks,
       MAX(created_at)       AS created_at
FROM `stocks`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`;



SELECT s.expiry,
       s.item_master_id,
       s.lot_number,
       s.total_stocks,
       s.created_at,
       item_masters.item_category,
       item_masters.name,
       item_masters.amount,
       item_masters.price_tax_excluded,
       item_masters.tax_percent
FROM (SELECT `stocks`.`expiry`,
             `stocks`.`item_master_id`,
             `stocks`.`lot_number`,
             COUNT(item_master_id) AS total_stocks,
             MAX(created_at)       AS created_at
      FROM `stocks`
      WHERE `stocks`.`storage_id` = 1
        AND `stocks`.`stock_status` = 0
      GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`) AS s
         INNER JOIN `item_masters` ON `item_masters`.`id` = s.`item_master_id`
ORDER BY s.created_at DESC;

# sub query
SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       COUNT(stocks.item_master_id) AS total_stocks,
       MAX(stocks.created_at)       AS created_at,
       item_masters.item_category,
       item_masters.name,
       item_masters.amount,
       item_masters.price_tax_excluded,
       item_masters.tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`;

select count(*)
from stocks


# query with subquery
    with subqueryTable as (SELECT `stocks`.`expiry`,
                              `stocks`.`item_master_id`,
                              `stocks`.`lot_number`,
                              COUNT(item_master_id) AS total_stocks,
                              MAX(created_at)       AS created_at
                       FROM `stocks`
                       WHERE `stocks`.`storage_id` = 1
                         AND `stocks`.`stock_status` = 0
                       GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`)
SELECT stocks.expiry,
       stocks.item_master_id,
       stocks.lot_number,
       stocks.total_stocks,
       stocks.created_at,
       item_masters.item_category,
       item_masters.name,
       item_masters.amount,
       item_masters.price_tax_excluded,
       item_masters.tax_percent
FROM subqueryTable AS stocks
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id` /* loading for inspect */
ORDER BY stocks.created_at DESC
limit 10 offset 0;


# creating view for the sub query
CREATE VIEW in_stock AS
SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       COUNT(item_master_id) AS total_stocks,
       MAX(created_at)       AS created_at
FROM `stocks`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`;


# query with using view
SELECT stocks.expiry,
       stocks.item_master_id,
       stocks.lot_number,
       stocks.total_stocks,
       stocks.created_at,
       item_masters.item_category,
       item_masters.name,
       item_masters.amount,
       item_masters.price_tax_excluded,
       item_masters.tax_percent
FROM in_stock AS stocks
         INNER JOIN item_masters ON item_masters.id = stocks.item_master_id
ORDER BY stocks.created_at DESC;


# count Query
select count(*)
from (SELECT stocks.expiry,
             stocks.item_master_id,
             stocks.lot_number,
             stocks.total_stocks,
             stocks.created_at,
             item_masters.item_category,
             item_masters.name,
             item_masters.amount,
             item_masters.price_tax_excluded,
             item_masters.tax_percent
      FROM in_stock AS stocks
               INNER JOIN item_masters ON item_masters.id = stocks.item_master_id
      ORDER BY stocks.created_at DESC) as newtable;

# Query currently we are running
SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       count(item_master_id)             as total_stocks,
       max(stocks.created_at)            as created_at,
       (item_masters.item_category)      as item_masters_category,
       (item_masters.name)               as item_masters_name,
       (item_masters.amount)             as item_masters_amount,
       (item_masters.price_tax_excluded) as tax_excluded_price,
       (item_masters.tax_percent)        as item_masters_tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc;


SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       count(item_master_id)                      as total_stocks,
       max(stocks.created_at)                     as created_at,
       (item_masters.item_category)               as item_masters_category,
       (item_masters.name)                        as item_masters_name,
       (item_masters.amount)                      as item_masters_amount,
       (item_masters.price_tax_excluded)          as tax_excluded_price,
       (item_masters.tax_percent)                 as item_masters_tax_percent,
       `stocks`.`id`                              AS t0_r0,
       `item_masters`.`id`                        AS t1_r0,
       `item_masters`.`uid`                       AS t1_r1,
       `item_masters`.`company_id`                AS t1_r2,
       `item_masters`.`name`                      AS t1_r3,
       `item_masters`.`buying_price_tax_excluded` AS t1_r4,
       `item_masters`.`price_tax_excluded`        AS t1_r5,
       `item_masters`.`tax_percent`               AS t1_r6,
       `item_masters`.`amount`                    AS t1_r7,
       `item_masters`.`number_of_packages`        AS t1_r8,
       `item_masters`.`item_category`             AS t1_r9,
       `item_masters`.`supplier_id`               AS t1_r10,
       `item_masters`.`created_at`                AS t1_r11,
       `item_masters`.`updated_at`                AS t1_r12
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc;


SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       count(item_master_id)             as total_stocks,
       max(stocks.created_at)            as created_at,
       (item_masters.item_category)      as item_masters_category,
       (item_masters.name)               as item_masters_name,
       (item_masters.amount)             as item_masters_amount,
       (item_masters.price_tax_excluded) as tax_excluded_price,
       (item_masters.tax_percent)        as item_masters_tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc;


# LIMIT 10 OFFSET 0


SELECT COUNT(stocks.expiry, stocks.item_master_id, stocks.lot_number, stocks.total_stocks, stocks.created_at,
             item_masters.item_category, item_masters.name, item_masters.amount, item_masters.price_tax_excluded,
             item_masters.tax_percent)
FROM (SELECT `stocks`.`expiry`,
             `stocks`.`item_master_id`,
             `stocks`.`lot_number`,
             COUNT(item_master_id) AS total_stocks,
             MAX(created_at)       AS created_at
      FROM `stocks`
      WHERE `stocks`.`storage_id` = 1
        AND `stocks`.`stock_status` = 0
      GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`) AS stocks
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`



SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       count(item_master_id)             as total_stocks,
       max(stocks.created_at)            as created_at,
       (item_masters.item_category)      as item_masters_category,
       (item_masters.name)               as item_masters_name,
       (item_masters.amount)             as item_masters_amount,
       (item_masters.price_tax_excluded) as tax_excluded_price,
       (item_masters.tax_percent)        as item_masters_tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc;


SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       count(item_master_id)             as total_stocks,
       max(stocks.created_at)            as created_at,
       (item_masters.item_category)      as item_masters_category,
       (item_masters.name)               as item_masters_name,
       (item_masters.amount)             as item_masters_amount,
       (item_masters.price_tax_excluded) as tax_excluded_price,
       (item_masters.tax_percent)        as item_masters_tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc
LIMIT 10 OFFSET 0;


show tables;

with in_storage as (SELECT `stocks`.`expiry`,
                           `stocks`.`item_master_id`,
                           `stocks`.`lot_number`,
                           COUNT(stocks.item_master_id) AS total_stocks,
                           MAX(stocks.created_at)       AS created_at,
                           item_masters.item_category,
                           item_masters.name,
                           item_masters.amount,
                           item_masters.price_tax_excluded,
                           item_masters.tax_percent
                    FROM `stocks`
                             INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
                    WHERE `stocks`.`storage_id` = 1
                      AND `stocks`.`stock_status` = 0
                    GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`)

select *
from in_storage;



with table1 as (SELECT stocks.expiry,
                       stocks.item_master_id,
                       stocks.lot_number,
                       COUNT(stocks.item_master_id) AS total_stocks,
                       MAX(stocks.created_at)       AS created_at
                FROM stocks
                WHERE storage_id = 1
                  AND stock_status = 0
                GROUP BY expiry,
                         item_master_id,
                         lot_number)

SELECT s.expiry,
       s.item_master_id,
       s.lot_number,
       total_stocks,
       s.created_at,
       im.item_category,
       im.name,
       im.amount,
       im.price_tax_excluded,
       im.tax_percent
FROM table1 AS s
         INNER JOIN item_masters AS im ON im.id = s.item_master_id
ORDER BY s.created_at DESC;



SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       max(`stocks`.`storage_id`)        as storage_id,
       max(`stocks`.`stock_status`)      as stock_status,
       count(stocks.item_master_id)      as total_stocks,
       max(stocks.created_at)            as created_at,
       (item_masters.item_category)      as item_masters_category,
       (item_masters.name)               as item_masters_name,
       (item_masters.amount)             as item_masters_amount,
       (item_masters.price_tax_excluded) as tax_excluded_price,
       (item_masters.tax_percent)        as item_masters_tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
# WHERE `stocks`.`storage_id` = 1
#   AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc;


CREATE TABLE stocks_in_memory
(
    id             bigint   NOT NULL AUTO_INCREMENT PRIMARY KEY,
    referable_id   bigint,
    referable_type varchar(255),
    stock_status   int DEFAULT 0,
    item_master_id bigint   NOT NULL,
    lot_number     varchar(255),
    storage_id     bigint   NOT NULL,
    expiry         date     NOT NULL,
    cart_status    int DEFAULT 0,
    created_at     datetime NOT NULL,
    updated_at     datetime NOT NULL
) ENGINE = MEMORY;

DROP PROCEDURE LoopDemo;
Delimiter //
CREATE procedure loopDemo()
label:
BEGIN
    DECLARE val INT;
    DECLARE result VARCHAR(255);
    SET val = 1;
    SET result = '';
    loop_label:
    LOOP
        IF val > 10 THEN
            LEAVE loop_label;
        END IF;
        SET result = CONCAT(result, val, ',');
        SET val = val + 1;
        ITERATE loop_label;
    END LOOP;
    SELECT result;
END//


call loopDemo;
//

show tables;


# Drop procedure test;
# DELIMITER ;
# create procedure test()
# begin
#     DECLARE n INT DEFAULT 0;
#     DECLARE i INT DEFAULT 0;
#     SELECT COUNT(*) FROM stocks INTO n;
#     SET i = 0;
#     WHILE i < n
#         DO
#             INSERT INTO stocks_in_memory SELECT (ID, VAL) FROM stocks LIMIT i,1;
#             SET i = i + 1;
#         END WHILE;
#
# end;


DELIMITER //

CREATE PROCEDURE CopyStocksDataToMemory()
BEGIN

    SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'stocks_in_memory';

    -- Create the in-memory table
    CREATE TABLE IF NOT EXISTS stocks_in_memory
    (
        id             bigint   NOT NULL AUTO_INCREMENT PRIMARY KEY,
        referable_id   bigint,
        referable_type varchar(255),
        stock_status   int DEFAULT 0,
        item_master_id bigint   NOT NULL,
        lot_number     varchar(255),
        storage_id     bigint   NOT NULL,
        expiry         date     NOT NULL,
        cart_status    int DEFAULT 0,
        created_at     datetime NOT NULL,
        updated_at     datetime NOT NULL
    ) ENGINE = MEMORY;

    -- Copy data from stocks table to stocks_in_memory table
    INSERT INTO stocks_in_memory SELECT * FROM stocks;
END //

DELIMITER ;

CALL CopyStocksDataToMemory();

select *
from stocks_in_memory;

DELETE
FROM stocks_in_memory
where 1;

SHOW VARIABLES LIKE 'max_heap_table_size';



ALTER TABLE stocks
    DROP INDEX index_stocks_on_expiry_and_item_master_id_and_lot_number;
CREATE INDEX index_stocks_on_expiry_and_item_master_id_and_lot_number ON stocks (expiry, item_master_id, lot_number);
SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       count(stocks.item_master_id)      as total_stocks,
       max(stocks.created_at)            as created_at,
       (item_masters.item_category)      as item_masters_category,
       (item_masters.name)               as item_masters_name,
       (item_masters.amount)             as item_masters_amount,
       (item_masters.price_tax_excluded) as tax_excluded_price,
       (item_masters.tax_percent)        as item_masters_tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc;


# mysqld --verbose --help


# for the max_heap_size
select @@max_heap_table_size;
#  output 16777216
#  max_heap_table_size in mb
select @@max_heap_table_size / 1048576 as MB;

SET @@max_heap_table_size = 104857600;

# for the temp table size

select @@tmp_table_size;
# output 16777216
SET @@tmp_table_size = 104857600;



select count(*)
from stocks;
# 2334431


SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       count(stocks.item_master_id)      as total_stocks,
       max(stocks.created_at)            as created_at,
       (item_masters.item_category)      as item_masters_category,
       (item_masters.name)               as item_masters_name,
       (item_masters.amount)             as item_masters_amount,
       (item_masters.price_tax_excluded) as tax_excluded_price,
       (item_masters.tax_percent)        as item_masters_tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
  AND (item_masters.name like '%test%')
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc;



SELECT s.expiry,
       s.item_master_id,
       s.lot_number,
       COUNT(s.item_master_id) AS total_stocks,
       MAX(s.created_at)       AS created_at,
       im.item_category        AS item_masters_category,
       im.name                 AS item_masters_name,
       im.amount               AS item_masters_amount,
       im.price_tax_excluded   AS tax_excluded_price,
       im.tax_percent          AS item_masters_tax_percent
FROM stocks AS s
         INNER JOIN
     item_masters AS im ON im.id = s.item_master_id
WHERE s.storage_id = 1
  AND s.stock_status = 0
  AND im.name LIKE '%test%'
GROUP BY s.expiry,
         s.item_master_id,
         s.lot_number
ORDER BY created_at DESC;

SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       count(stocks.item_master_id)      as total_stocks,
       max(stocks.created_at)            as created_at,
       (item_masters.item_category)      as item_masters_category,
       (item_masters.name)               as item_masters_name,
       (item_masters.amount)             as item_masters_amount,
       (item_masters.price_tax_excluded) as tax_excluded_price,
       (item_masters.tax_percent)        as item_masters_tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
  AND (item_masters.name like '%test%')
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc;



select count(id)
from stocks;

SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       count(stocks.item_master_id)      as total_stocks,
       max(stocks.created_at)            as created_at,
       (item_masters.item_category)      as item_masters_category,
       (item_masters.name)               as item_masters_name,
       (item_masters.amount)             as item_masters_amount,
       (item_masters.price_tax_excluded) as tax_excluded_price,
       (item_masters.tax_percent)        as item_masters_tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc;

DELETE
FROM stocks
WHERE id > 99999;


ALTER TABLE stocks_visit_histories
    DROP CONSTRAINT fk_rails_3e08e8139b;

alter table invoices_stocks
    drop constraint fk_rails_988c3df8ab


select COLUMN_NAME, INDEX_NAME, NON_UNIQUE, SEQ_IN_INDEX, INDEX_TYPE
from INFORMATION_SCHEMA.STATISTICS
where TABLE_SCHEMA = 'oxmart_development'
  and TABLE_NAME = 'stocks';


ALTER TABLE stocks
    ADD lot_number_expiry_item_master_id VARCHAR(255) AFTER lot_number;

SELECT distinct (`stocks`.`expiry`),
#     distinct (`stocks`.`item_master_id`),
#        distinct (`stocks`.`lot_number`),
                count(stocks.item_master_id)      as total_stocks,
                max(stocks.created_at)            as created_at,
                (item_masters.item_category)      as item_masters_category,
                (item_masters.name)               as item_masters_name,
                (item_masters.amount)             as item_masters_amount,
                (item_masters.price_tax_excluded) as tax_excluded_price,
                (item_masters.tax_percent)        as item_masters_tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`lot_number_expiry_item_master_id`
ORDER BY created_at desc;


select count(id)
from stocks;

update stocks
SET lot_number_expiry_item_master_id = CONCAT(expiry, '-', item_master_id, '-', lot_number)
where id > 0
  and id <= 1000000;
update stocks
SET lot_number_expiry_item_master_id = CONCAT(expiry, '-', item_master_id, '-', lot_number)
where id > 1000000
  and id <= 2000000;
update stocks
SET lot_number_expiry_item_master_id = CONCAT(expiry, '-', item_master_id, '-', lot_number)
where id > 2000000
  and id <= 3000000;
update stocks
SET lot_number_expiry_item_master_id = CONCAT(expiry, '-', item_master_id, '-', lot_number)
where id > 3000000
  and id <= 4000000;
update stocks
SET lot_number_expiry_item_master_id = CONCAT(expiry, '-', item_master_id, '-', lot_number)
where id > 4000000
  and id <= 5000000;
update stocks
SET lot_number_expiry_item_master_id = CONCAT(expiry, '-', item_master_id, '-', lot_number)
where id > 5000000
  and id <= 6000000;
update stocks
SET lot_number_expiry_item_master_id = CONCAT(expiry, '-', item_master_id, '-', lot_number)
where id > 6000000
  and id <= 7000000;
update stocks
SET lot_number_expiry_item_master_id = CONCAT(expiry, '-', item_master_id, '-', lot_number)
where id > 7000000
  and id <= 8000000;

update stocks
SET lot_number_expiry_item_master_id = CONCAT(expiry, '-', item_master_id, '-', lot_number)
where id = 1313033;

CREATE INDEX index_stocks_on_name ON stocks (name);
ALTER TABLE stocks
    ADD lot_number_expiry_item_master_id VARCHAR(255) AFTER lot_number;


SELECT max(`stocks`.`expiry`),
       max(`stocks`.`item_master_id`),
       max(`stocks`.`lot_number`),
       COUNT(stocks.item_master_id)         AS total_stocks,
       MAX(stocks.created_at)               AS created_at,
       max(item_masters.item_category)      AS item_masters_category,
       max(item_masters.name)               AS item_masters_name,
       max(item_masters.amount)             AS item_masters_amount,
       max(item_masters.price_tax_excluded) AS tax_excluded_price,
       max(item_masters.tax_percent)        AS item_masters_tax_percent,
       `stocks`.`lot_number_expiry_item_master_id`
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`lot_number_expiry_item_master_id`
limit 10;



SELECT max(`stocks`.`expiry`),
       max(`stocks`.`item_master_id`),
       max(`stocks`.`lot_number`),
       COUNT(stocks.item_master_id) AS total_stocks,
       MAX(stocks.created_at)       AS created_at,
       stocks.lot_number_expiry_item_master_id
FROM stocks
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY stocks.lot_number_expiry_item_master_id
LIMIT 10;

ALTER TABLE `oxmart_development`.`stocks`
    ADD INDEX `index_stocks_on_lot_number_expiry_item_master_id` (`lot_number_expiry_item_master_id`);


SELECT max(`stocks`.`expiry`)         as expiry,
       max(`stocks`.`item_master_id`) as item_master_id,
       max(`stocks`.`lot_number`)     as lot_number,
       COUNT(stocks.item_master_id)   AS total_stocks,
       MAX(stocks.created_at)         AS created_at,
       stocks.lot_number_expiry_item_master_id
FROM stocks
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY stocks.lot_number_expiry_item_master_id
limit 10 offset 10;



ALTER TABLE `oxmart_development`.`stocks`
    ADD INDEX `index_on_stocks_expiry_and_item_master_id_and_storage_id_and_lot` (`expiry`, `item_master_id`,
                                                                                  `storage_id`, `lot_number`,
                                                                                  `stock_status`);

# index_on_stocks_expiry_and_item_master_id_and_storage_id_and_lot_number_and_stock_status


SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       count(item_master_id)             as total_stocks,
       max(stocks.created_at)            as created_at,
       (item_masters.item_category)      as item_masters_category,
       (item_masters.name)               as item_masters_name,
       (item_masters.amount)             as item_masters_amount,
       (item_masters.price_tax_excluded) as tax_excluded_price,
       (item_masters.tax_percent)        as item_masters_tax_percent
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc
LIMIT 10 OFFSET 0;


SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       COUNT(item_master_id) AS total_stocks,
       MAX(created_at)       AS created_at
FROM `stocks`
WHERE `stocks`.`storage_id` = 1
  AND `stocks`.`stock_status` = 0
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`

SELECT expiry,
       item_master_id,
       lot_number,
       COUNT(item_master_id) AS total_stocks,
       MAX(created_at)       AS created_at
FROM stocks
WHERE storage_id = 1
  AND stock_status = 0
GROUP BY expiry, item_master_id, lot_number


SELECT expiry,
       item_master_id,
       lot_number,
#     (SELECT COUNT(*) FROM stocks AS s
#      WHERE s.expiry = stocks.expiry
#        AND s.item_master_id = stocks.item_master_id
#        AND s.lot_number = stocks.lot_number
#        AND s.storage_id = 1
#        AND s.stock_status = 0
#      LIMIT 100) AS total_stocks,
       MAX(created_at) AS created_at
FROM stocks
WHERE storage_id = 1
  AND stock_status = 0
GROUP BY expiry, item_master_id, lot_number;

SELECT expiry,
#     item_master_id,
       lot_number
FROM stocks
WHERE storage_id = 1
  AND stock_status = 0
GROUP BY expiry, lot_number
limit 100;

select id, expiry, item_master_id, lot_number
from stocks;


ALTER TABLE `oxmart_development`.`stocks`
    ADD INDEX `index_on_stocks_expiry_and_lot` (`expiry`, `lot_number`);


SELECT expiry,
       item_master_id,
       lot_number,
       LEAST(COUNT(item_master_id), 100) AS total_stocks,
       MAX(created_at)                   AS created_at
FROM stocks
WHERE storage_id = 1
  AND stock_status = 0
GROUP BY expiry, item_master_id, lot_number;


SELECT expiry,
       item_master_id,
       lot_number,
       COUNT(item_master_id) AS total_stocks,
       MAX(created_at)       AS created_at
FROM stocks
WHERE storage_id = 1
  AND stock_status = 0
GROUP BY expiry, item_master_id, lot_number
HAVING COUNT(item_master_id) <= 100;


#  query has error
# SELECT
#     expiry,
#     item_master_id,
#     lot_number,
#     IF(count_reached_100 = 1, 100, COUNT(*)) AS total_stocks,
#     MAX(created_at) AS created_at
# FROM
#     (
#         SELECT
#             expiry,
#             item_master_id,
#             lot_number,
#             MAX(created_at) AS created_at,
#             (SELECT COUNT(*) FROM stocks AS s
#              WHERE s.expiry = stocks.expiry
#                AND s.item_master_id = stocks.item_master_id
#                AND s.lot_number = stocks.lot_number
#                AND s.storage_id = 1
#                AND s.stock_status = 0) AS count_reached_100
#         FROM
#             stocks
#         WHERE
#                 storage_id = 1
#           AND stock_status = 0
#         GROUP BY
#             expiry, item_master_id, lot_number
#     ) AS grouped_data
# GROUP BY
#     expiry, item_master_id, lot_number
# HAVING
#         count_reached_100 != 100 OR count_reached_100 IS NULL;

SELECT expiry,
       item_master_id,
       lot_number,
       IF(COUNT(*) = 100, 100, COUNT(*)) AS total_stocks,
       MAX(created_at)                   AS created_at
FROM stocks
WHERE storage_id = 1
  AND stock_status = 0
GROUP BY expiry, item_master_id, lot_number
HAVING COUNT(*) < 100
    OR MAX(created_at) IS NULL;



SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`storage_id`,
       `stocks`.`lot_number`,
       count(item_master_id)  as total_stocks,
       min(stocks.created_at) as created_at,
       max(stocks.id)         as id
FROM `stocks`
         INNER JOIN `item_masters` ON `item_masters`.`id` = `stocks`.`item_master_id`
WHERE `stocks`.`storage_id` IN (1, 2, 3, 4, 5)
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`storage_id`, `stocks`.`lot_number`,
         `stocks`.`stock_status`
ORDER BY created_at desc
LIMIT 10 OFFSET 0;


SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`storage_id`,
       `stocks`.`lot_number`,
       count(item_master_id)  as total_stocks,
       min(stocks.created_at) as created_at,
       max(stocks.id)         as id
FROM `stocks`
WHERE `stocks`.`storage_id` = 4
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`
ORDER BY created_at desc
LIMIT 120 OFFSET 0;



SELECT CONCAT(expiry, '_', item_master_id, '_', lot_number) AS Group1,
       expiry,
       item_master_id,
       lot_number
FROM stocks
WHERE storage_id = 1
  AND stock_status = 0
group by Group1;

# GROUP BY expiry, lot_number, item_master_id;

SELECT count(id)
FROM stocks
WHERE storage_id = 1
  AND stock_status = 0;



ALTER TABLE `oxmart_development`.`stocks`
    ADD INDEX `index_on_stocks_storage_id_and_stock_status` (`expiry`, `lot_number`);

ALTER TABLE `oxmart_development`.`stocks`
    ADD INDEX `index_on_stocks_expiry_and_lot_number_and_item_master_id` (`expiry`, `lot_number`, `item_master_id`);

ALTER TABLE `oxmart_development`.`stocks`
    ADD INDEX `index_on_stocks_created_at` (`created_at`);

ALTER TABLE `oxmart_development`.`stocks`
    ADD INDEX `index_on_stocks_stock_status` (`stock_status`);

ALTER TABLE `oxmart_development`.`stocks`
    ADD INDEX `index_on_stocks_storage_id_and_stock_status` (`storage_id`, `stock_status`);



# WHERE storage_id = 1
#   AND stock_status = 0

select COLUMN_NAME, INDEX_NAME, NON_UNIQUE, SEQ_IN_INDEX, INDEX_TYPE
from INFORMATION_SCHEMA.STATISTICS
where TABLE_SCHEMA = 'oxmart_development'
  and TABLE_NAME = 'stocks';


# CLEB16A35C

SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       `stocks`.`storage_id`,
       `stocks`.`stock_status`,
       COUNT(`stocks`.`item_master_id`) AS total_stocks,
       MAX(`stocks`.`created_at`)       AS created_at
FROM `stocks`
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`, `stocks`.`storage_id`,
         `stocks`.`stock_status`;

SELECT `stocks`.`expiry`,
       `stocks`.`item_master_id`,
       `stocks`.`lot_number`,
       `stocks`.`storage_id`,
       `stocks`.`stock_status`,
       COUNT(`stocks`.`item_master_id`) AS total_stocks,
       MAX(`stocks`.`created_at`)       AS created_at
FROM `stocks`
# WHERE `stocks`.`storage_id` = 1
#   AND `stocks`.`stock_status` = 0
#   AND (`item_masters`.`name` like '%test%')
GROUP BY `stocks`.`expiry`, `stocks`.`item_master_id`, `stocks`.`lot_number`, `stocks`.`storage_id`,
         `stocks`.`stock_status`;


#  insert data to the summary table from stock summary
INSERT INTO stocks_summaries
SELECT MAX(`stocks`.`id`)               AS id,
       `stocks`.`expiry`                AS expiry,
       `stocks`.`item_master_id`        AS item_master_id,
       `stocks`.`lot_number`            AS lot_number,
       `stocks`.`storage_id`            AS storage_id,
       `stocks`.`stock_status`          AS stock_status,
       COUNT(`stocks`.`item_master_id`) AS total_stocks,
       MAX(`stocks`.`created_at`)       AS created_at,
       MAX(`stocks`.`created_at`)       AS updated_at,
       MAX(`stocks`.`created_at`)       AS stock_created_at
FROM `stocks`
GROUP BY `stocks`.`expiry`,
         `stocks`.`item_master_id`,
         `stocks`.`lot_number`,
         `stocks`.`storage_id`,
         `stocks`.`stock_status`;


CREATE TRIGGER after_stock_created
    after INSERT
    ON stocks
    FOR EACH ROW
begin
    #     INSERT INTO stocks_summaries
#     SET action         = 'update',
#         employeeNumber = OLD.employeeNumber,
#         lastname       = OLD.lastname,
#         changedat      = NOW();


end;


CREATE TRIGGER update_or_insert_stocks_summaries_on_create
    AFTER INSERT
    ON stocks
    FOR EACH ROW
BEGIN
    -- Update existing row if stock combination already exists
    UPDATE stocks_summaries
    SET total_stocks = total_stocks + 1
    WHERE expiry = NEW.expiry
      AND item_master_id = NEW.item_master_id
      AND lot_number = NEW.lot_number
      AND storage_id = NEW.storage_id
      AND stock_status = NEW.stock_status;

    -- Insert new row if stock combination does not exist
    IF ROW_COUNT() = 0 THEN
        INSERT INTO stocks_summaries
        VALUES (NEW.expiry, NEW.item_master_id, NEW.lot_number, NEW.storage_id, NEW.stock_status, 1, NEW.created_at,
                NOW(), Now());
    END IF;
END;

INSERT INTO `stocks`(`referable_id`, `referable_type`, `stock_status`, `item_master_id`, `lot_number`, `storage_id`,
                     `expiry`, `cart_status`, `created_at`, `updated_at`)
VALUES (null, null, 2, 37, 'R00000', 1, '2023-06-09', 0, '2023-03-09 10:41:20.257749', '2023-03-09 10:41:20.257749')



CREATE TRIGGER update_or_insert_stocks_summaries_on_create
    AFTER INSERT
    ON stocks
    FOR EACH ROW
BEGIN
    INSERT INTO stocks_summaries('expiry', 'item_master_id', 'lot_number', 'storage_id', 'stock_status', 'total_stocks',
                                 'stock_created_at', 'created_at', 'updated_at')
    VALUES (NEW.expiry, NEW.item_master_id, NEW.lot_number, NEW.storage_id, NEW.stock_status, 1, NEW.created_at, NOW(),
            NOW());
END;

DELIMITER $$
CREATE TRIGGER update_or_insert_stocks_summaries_on_create AFTER INSERT ON
    stocks FOR EACH ROW
BEGIN
    INSERT INTO stocks_summaries(
        expiry,
        item_master_id,
        lot_number,
        storage_id,
        stock_status,
        total_stocks,
        created_at
    )
    VALUES(
              NEW.expiry,
              NEW.item_master_id,
              NEW.lot_number,
              NEW.storage_id,
              NEW.stock_status,
              1,
              NEW.created_at
          );
END $$

DELIMITER ;


