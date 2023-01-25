BEGIN;

CREATE TABLE phone (
  phone_owner  TEXT,
  phone_number TEXT
);

INSERT INTO phone VALUES
('Omar Little','410-719-9009'),
('Russell Bell','410-617-7308'),
('Avon Barksdale','410-385-2983');

SET anon.transparent_dynamic_masking TO true;

CREATE ROLE jimmy LOGIN;

GRANT USAGE ON SCHEMA public TO jimmy;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO jimmy;

SECURITY LABEL FOR anon ON ROLE jimmy IS 'MASKED';

SECURITY LABEL FOR anon ON COLUMN phone.phone_owner
IS 'MASKED WITH VALUE $$CONFIDENTIAL$$ ';

SECURITY LABEL FOR anon ON COLUMN phone.phone_number
IS 'MASKED WITH FUNCTION anon.hash(phone_number)';

SET anon.transparent_dynamic_masking TO true;

COPY phone TO stdout;

SET ROLE jimmy;

COPY phone TO stdout;

-- TODO
-- COPY (SELECT * FROM phone) TO stdout;

ROLLBACK;
