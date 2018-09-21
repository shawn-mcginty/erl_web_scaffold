DROP DATABASE sbox_dev;
CREATE DATABASE sbox_dev;
CREATE USER sbox WITH PASSWORD 'sbox1';
GRANT ALL PRIVILEGES ON DATABASE sbox_dev to sbox;

\c sbox_dev

CREATE EXTENSION pgcrypto;

\c sbox_dev sbox

CREATE TABLE Users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL,
    pword VARCHAR(255) NOT NULL
);

CREATE UNIQUE INDEX user_email
ON Users (email);

CREATE TABLE Sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    expires TIMESTAMP NOT NULL
);

CREATE UNIQUE INDEX session_user_id
ON Sessions (user_id);

-- test data
--    - test users
INSERT INTO Users (email, pword) VALUES ('test@foo.com', '9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08');