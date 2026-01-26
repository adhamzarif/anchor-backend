-- Add verification_documents table for user profile verification
-- This table stores verification documents uploaded by users for identity verification
-- Maintains 3NF: All non-key attributes (file_path, file_name, file_size, mime_type, uploaded_at)
-- depend solely on the primary key (doc_id), with no transitive or partial dependencies.
-- Consistent with existing document tables (loan_documents, crowdfunding_documents).

CREATE TABLE IF NOT EXISTS `verification_documents` (
    `doc_id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `doc_type` enum(
        'student_id',
        'nid',
        'passport',
        'other'
    ) DEFAULT 'student_id',
    `file_path` varchar(255) NOT NULL,
    `file_name` varchar(255) NOT NULL,
    `file_size` int(11) DEFAULT NULL CHECK (`file_size` >= 0),
    `mime_type` varchar(100) DEFAULT NULL,
    `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`doc_id`),
    KEY `idx_user_verification` (`user_id`),
    CONSTRAINT `fk_verification_documents_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Note: verification_status is stored in users table to avoid data duplication.
-- This maintains normalization as the status is an attribute of the user, not the document.