BEGIN;

--SET client_min_messages TO 'DEBUG4';

CREATE SCHEMA store;
CREATE SCHEMA catalog;

CREATE TABLE store.customer (
  id INT UNIQUE,
  name TEXT,
  email TEXT DEFAULT NULL,
  birth DATE DEFAULT NULL
);

INSERT INTO store.customer
VALUES
  (248593,'Omar Little','omar1981@hotmail.com', '1981-06-20')
;

SECURITY LABEL FOR anon ON COLUMN store.customer.id
IS 'MASKED WITH VALUE NULL';

SECURITY LABEL FOR anon ON COLUMN store.customer.name
IS 'MASKED WITH VALUE $$CONFIDENTIAL$$';

CREATE TABLE catalog.product (
  id INT UNIQUE NOT NULL,
  name TEXT,
  description TEXT,
  price INT NOT NULL DEFAULT 0
);

INSERT INTO catalog.product
VALUES
 ( 939, 'Nail Gun', 'Used to drive nails into wood', 130)
;

SECURITY LABEL FOR anon ON COLUMN catalog.product.id
IS 'MASKED WITH VALUE NULL';

SECURITY LABEL FOR anon ON COLUMN catalog.product.name
IS 'MASKED WITH VALUE $$CONFIDENTIAL$$';

SECURITY LABEL FOR anon ON COLUMN catalog.product.description
IS 'MASKED WITH VALUE NULL';


CREATE ROLE melanie LOGIN;

GRANT USAGE ON SCHEMA store TO melanie;
GRANT SELECT ON ALL TABLES IN SCHEMA store TO melanie;

GRANT USAGE ON SCHEMA catalog TO melanie;
GRANT SELECT ON ALL TABLES IN SCHEMA catalog TO melanie;

SET anon.transparent_dynamic_masking TO true;



SECURITY LABEL FOR anon ON ROLE melanie IS 'MASKED';

CREATE FUNCTION insert_into_catalog()
RETURNS VOID
AS $body$
BEGIN
  INSERT INTO catalog.product VALUES ( 0, '', '', 0);
END
$body$
  LANGUAGE 'plpgsql';

SET ROLE melanie;

--
-- Read Queries
--
SELECT 1;

SAVEPOINT before_explain;

EXPLAIN SELECT 1;

ROLLBACK TO before_explain;

SELECT id, name FROM store.customer LIMIT 1;

SELECT * FROM catalog.product LIMIT 1;

-- TODO
SELECT id,name FROM (
  SELECT * FROM (
    SELECT *
    FROM store.customer LIMIT 1
  ) as sub2
) as sub1;

--
-- Write Queries
--

SAVEPOINT before_truncate;

TRUNCATE store.customer;

ROLLBACK TO before_truncate;

SET ROLE postgres;

GRANT ALL PRIVILEGES ON TABLE catalog.product TO melanie;

SET ROLE melanie;

TRUNCATE catalog.product;

ROLLBACK TO before_truncate;

--SELECT insert_into_catalog();

ROLLBACK TO before_truncate;

ROLLBACK;
