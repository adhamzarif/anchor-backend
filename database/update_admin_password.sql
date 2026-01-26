-- Update admin password to '123admin'
-- Run this SQL query in phpMyAdmin or MySQL command line

UPDATE users
SET
    password_hash = '$2y$10$wVgcIv8r58kOqHPfkhuyl.v7yq4SvV68PhYHyypvu1VucUwx.PhpG'
WHERE
    email = 'admin@lendora.com';

-- Verify the update
SELECT user_id, username, email, role
FROM users
WHERE
    email = 'admin@lendora.com';