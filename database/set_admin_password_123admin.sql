-- Quick fix: Set admin password to '123admin'
-- Run this immediately to fix your login issue

USE db;

UPDATE users
SET
    password_hash = '$2y$10$wVgcIv8r58kOqHPfkhuyl.v7yq4SvV68PhYHyypvu1VucUwx.PhpG'
WHERE
    email = 'admin@lendora.com';

-- Verify the update
SELECT
    user_id,
    username,
    email,
    role,
    CASE
        WHEN password_hash = '$2y$10$wVgcIv8r58kOqHPfkhuyl.v7yq4SvV68PhYHyypvu1VucUwx.PhpG' THEN 'Password is 123admin ✓'
        ELSE 'Password NOT updated ✗'
    END as password_status
FROM users
WHERE
    email = 'admin@lendora.com';