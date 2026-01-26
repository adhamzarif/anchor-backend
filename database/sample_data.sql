-- Sample Data for Database
-- 5 Users creating consistent data across all tables
-- Run this after importing db_1.sql

USE db_1;

-- ========================================
-- 1. USERS TABLE (5 new users + 1 admin already exists)
-- ========================================
INSERT INTO
    `users` (
        `user_id`,
        `username`,
        `email`,
        `password_hash`,
        `full_name`,
        `phone`,
        `student_id`,
        `university`,
        `nid_number`,
        `verification_status`,
        `role`,
        `profile_image`,
        `created_at`,
        `updated_at`
    )
VALUES (
        2,
        'sarah_khan',
        'sarah.khan@student.edu',
        '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'Sarah Khan',
        '+8801712345678',
        'SID-2024-001',
        'University of Dhaka',
        '19950315123456789',
        'verified',
        'student',
        NULL,
        '2026-01-15 08:30:00',
        '2026-01-20 10:15:00'
    ),
    (
        3,
        'ahmed_rahman',
        'ahmed.rahman@student.edu',
        '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'Ahmed Rahman',
        '+8801823456789',
        'SID-2024-002',
        'BUET',
        '19960720234567890',
        'verified',
        'student',
        NULL,
        '2026-01-16 09:00:00',
        '2026-01-21 11:30:00'
    ),
    (
        4,
        'fatima_begum',
        'fatima.begum@student.edu',
        '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'Fatima Begum',
        '+8801934567890',
        'SID-2024-003',
        'Jahangirnagar University',
        '19970505345678901',
        'verified',
        'lender',
        NULL,
        '2026-01-17 10:20:00',
        '2026-01-22 14:45:00'
    ),
    (
        5,
        'karim_hossain',
        'karim.hossain@student.edu',
        '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'Karim Hossain',
        '+8801645678901',
        'SID-2024-004',
        'North South University',
        '19980812456789012',
        'verified',
        'lender',
        NULL,
        '2026-01-18 11:45:00',
        '2026-01-23 09:20:00'
    ),
    (
        6,
        'nadia_islam',
        'nadia.islam@student.edu',
        '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'Nadia Islam',
        '+8801756789012',
        'SID-2024-005',
        'IUB',
        '19991201567890123',
        'pending',
        'student',
        NULL,
        '2026-01-19 13:10:00',
        '2026-01-24 16:00:00'
    );

-- ========================================
-- 2. USER_DOCUMENTS TABLE (5 entries)
-- ========================================
INSERT INTO
    `user_documents` (
        `doc_id`,
        `user_id`,
        `doc_type`,
        `file_path`,
        `file_name`,
        `file_size`,
        `mime_type`,
        `verified`,
        `uploaded_at`
    )
VALUES (
        1,
        2,
        'student_id',
        'images/uploads/user_docs/user_2_student_id.jpg',
        'user_2_student_id.jpg',
        245678,
        'image/jpeg',
        1,
        '2026-01-15 08:45:00'
    ),
    (
        2,
        3,
        'student_id',
        'images/uploads/user_docs/user_3_student_id.jpg',
        'user_3_student_id.jpg',
        267890,
        'image/jpeg',
        1,
        '2026-01-16 09:20:00'
    ),
    (
        3,
        4,
        'nid',
        'images/uploads/user_docs/user_4_nid.pdf',
        'user_4_nid.pdf',
        512000,
        'application/pdf',
        1,
        '2026-01-17 10:35:00'
    ),
    (
        4,
        5,
        'student_id',
        'images/uploads/user_docs/user_5_student_id.jpg',
        'user_5_student_id.jpg',
        298765,
        'image/jpeg',
        1,
        '2026-01-18 12:00:00'
    ),
    (
        5,
        6,
        'student_id',
        'images/uploads/user_docs/user_6_student_id.jpg',
        'user_6_student_id.jpg',
        234567,
        'image/jpeg',
        0,
        '2026-01-19 13:25:00'
    );

-- ========================================
-- 3. LOAN_REQUESTS TABLE (5 entries)
-- ========================================
INSERT INTO
    `loan_requests` (
        `loan_id`,
        `borrower_id`,
        `category`,
        `custom_category`,
        `amount`,
        `duration_months`,
        `custom_duration`,
        `repayment_option`,
        `reason`,
        `interest_rate`,
        `status`,
        `approved_by`,
        `approval_date`,
        `created_at`,
        `updated_at`
    )
VALUES (
        1,
        2,
        'Education',
        NULL,
        15000.00,
        12,
        NULL,
        'installments',
        'Need funds for semester tuition fees and textbooks. I am in my 3rd year of Computer Science and need to complete this semester to maintain my scholarship.',
        5.00,
        'approved',
        1,
        '2026-01-16 10:00:00',
        '2026-01-15 14:30:00',
        '2026-01-20 11:00:00'
    ),
    (
        2,
        3,
        'Medical',
        NULL,
        25000.00,
        6,
        NULL,
        'installments',
        'Emergency medical treatment for my father who was diagnosed with heart condition. Need immediate funds for surgery and medication.',
        3.50,
        'approved',
        1,
        '2026-01-17 11:30:00',
        '2026-01-16 15:45:00',
        '2026-01-21 09:30:00'
    ),
    (
        3,
        6,
        'Technology',
        NULL,
        8000.00,
        8,
        NULL,
        'installments',
        'Purchase laptop for online classes and programming projects. My old laptop broke down and I cannot afford a new one.',
        4.00,
        'approved',
        1,
        '2026-01-20 09:15:00',
        '2026-01-19 16:20:00',
        '2026-01-23 10:45:00'
    ),
    (
        4,
        2,
        'Business',
        'Small Startup',
        30000.00,
        18,
        NULL,
        'installments',
        'Starting a small online tutoring platform to help fellow students. Need funds for website development and initial marketing.',
        6.00,
        'pending',
        NULL,
        NULL,
        '2026-01-22 10:30:00',
        '2026-01-22 10:30:00'
    ),
    (
        5,
        3,
        'Personal',
        'Housing',
        20000.00,
        12,
        NULL,
        'installments',
        'Need to pay advance rent for student accommodation near campus. Current place is too far and affecting my studies.',
        5.50,
        'pending',
        NULL,
        NULL,
        '2026-01-24 11:45:00',
        '2026-01-24 11:45:00'
    );

-- ========================================
-- 4. LOAN_DOCUMENTS TABLE (5 entries)
-- ========================================
INSERT INTO
    `loan_documents` (
        `doc_id`,
        `loan_id`,
        `doc_type`,
        `file_path`,
        `file_name`,
        `file_size`,
        `mime_type`,
        `verified`,
        `uploaded_at`
    )
VALUES (
        1,
        1,
        'student_id',
        'images/uploads/loan_docs/loan_1_student_id.jpg',
        'loan_1_student_id.jpg',
        234567,
        'image/jpeg',
        1,
        '2026-01-15 14:35:00'
    ),
    (
        2,
        1,
        'bill',
        'images/uploads/loan_docs/loan_1_tuition_bill.pdf',
        'loan_1_tuition_bill.pdf',
        456789,
        'application/pdf',
        1,
        '2026-01-15 14:40:00'
    ),
    (
        3,
        2,
        'medical',
        'images/uploads/loan_docs/loan_2_medical_report.pdf',
        'loan_2_medical_report.pdf',
        678901,
        'application/pdf',
        1,
        '2026-01-16 15:50:00'
    ),
    (
        4,
        3,
        'proof',
        'images/uploads/loan_docs/loan_3_broken_laptop.jpg',
        'loan_3_broken_laptop.jpg',
        345678,
        'image/jpeg',
        1,
        '2026-01-19 16:25:00'
    ),
    (
        5,
        4,
        'proof',
        'images/uploads/loan_docs/loan_4_business_plan.pdf',
        'loan_4_business_plan.pdf',
        890123,
        'application/pdf',
        0,
        '2026-01-22 10:35:00'
    );

-- ========================================
-- 5. LOAN_OFFERS TABLE (5 entries)
-- ========================================
INSERT INTO
    `loan_offers` (
        `offer_id`,
        `loan_id`,
        `lender_id`,
        `amount`,
        `interest_rate`,
        `terms`,
        `status`,
        `created_at`,
        `updated_at`
    )
VALUES (
        1,
        1,
        4,
        15000.00,
        5.00,
        'Monthly installments of 1312.50 BDT for 12 months. First payment due February 15, 2026.',
        'accepted',
        '2026-01-17 09:30:00',
        '2026-01-18 10:15:00'
    ),
    (
        2,
        2,
        5,
        25000.00,
        3.50,
        'Monthly installments of 4312.50 BDT for 6 months. Grace period of 1 month before repayment starts.',
        'accepted',
        '2026-01-18 10:45:00',
        '2026-01-19 11:20:00'
    ),
    (
        3,
        3,
        4,
        8000.00,
        4.00,
        'Monthly installments of 1040 BDT for 8 months. Payment due on 1st of each month.',
        'accepted',
        '2026-01-21 08:20:00',
        '2026-01-22 09:00:00'
    ),
    (
        4,
        1,
        5,
        15000.00,
        6.00,
        'Monthly installments of 1325 BDT for 12 months with 6% interest rate.',
        'rejected',
        '2026-01-17 11:00:00',
        '2026-01-18 10:15:00'
    ),
    (
        5,
        2,
        4,
        20000.00,
        4.50,
        'Partial funding offer. Monthly installments of 3450 BDT for 6 months.',
        'rejected',
        '2026-01-18 12:30:00',
        '2026-01-19 11:20:00'
    );

-- ========================================
-- 6. LOAN_CONTRIBUTIONS TABLE (5 entries)
-- ========================================
INSERT INTO
    `loan_contributions` (
        `contrib_id`,
        `contributor_id`,
        `loan_id`,
        `amount`,
        `payment_method`,
        `payment_status`,
        `transaction_id`,
        `contrib_date`
    )
VALUES (
        1,
        4,
        1,
        15000.00,
        'bKash',
        'completed',
        'TXN-LOAN-20260118-001',
        '2026-01-18 11:30:00'
    ),
    (
        2,
        5,
        2,
        25000.00,
        'Nagad',
        'completed',
        'TXN-LOAN-20260119-002',
        '2026-01-19 12:45:00'
    ),
    (
        3,
        4,
        3,
        8000.00,
        'Rocket',
        'completed',
        'TXN-LOAN-20260122-003',
        '2026-01-22 10:15:00'
    ),
    (
        4,
        5,
        1,
        5000.00,
        'bKash',
        'failed',
        'TXN-LOAN-20260117-004',
        '2026-01-17 14:20:00'
    ),
    (
        5,
        4,
        2,
        10000.00,
        'Bank Transfer',
        'pending',
        'TXN-LOAN-20260118-005',
        '2026-01-18 15:30:00'
    );

-- ========================================
-- 7. LOAN_RATINGS TABLE (5 entries)
-- ========================================
INSERT INTO
    `loan_ratings` (
        `rating_id`,
        `rater_id`,
        `ratee_id`,
        `loan_id`,
        `score`,
        `review`,
        `rated_at`
    )
VALUES (
        1,
        4,
        2,
        1,
        5,
        'Excellent borrower! Very communicative and made the first repayment on time. Highly recommend.',
        '2026-01-25 10:00:00'
    ),
    (
        2,
        5,
        3,
        2,
        5,
        'Trustworthy and responsible. Provided all necessary documentation promptly. Would lend again.',
        '2026-01-25 11:30:00'
    ),
    (
        3,
        4,
        6,
        3,
        4,
        'Good borrower. Documentation was complete and communication was clear. Looking forward to timely repayments.',
        '2026-01-25 14:20:00'
    ),
    (
        4,
        2,
        4,
        1,
        5,
        'Amazing lender! Quick response, fair terms, and very understanding. Grateful for the support.',
        '2026-01-25 15:45:00'
    ),
    (
        5,
        3,
        5,
        2,
        5,
        'Very professional and kind lender. Offered grace period for medical emergency. Highly appreciated!',
        '2026-01-25 16:30:00'
    );

-- ========================================
-- 8. REPAYMENTS TABLE (5 entries)
-- ========================================
INSERT INTO
    `repayments` (
        `repay_id`,
        `loan_id`,
        `amount`,
        `repayment_number`,
        `due_date`,
        `repay_date`,
        `status`,
        `payment_method`,
        `transaction_id`,
        `created_at`
    )
VALUES (
        1,
        1,
        1312.50,
        1,
        '2026-02-15',
        '2026-02-14 10:30:00',
        'paid',
        'bKash',
        'TXN-REPAY-20260214-001',
        '2026-01-18 11:30:00'
    ),
    (
        2,
        1,
        1312.50,
        2,
        '2026-03-15',
        NULL,
        'pending',
        NULL,
        NULL,
        '2026-01-18 11:30:00'
    ),
    (
        3,
        2,
        4312.50,
        1,
        '2026-03-18',
        NULL,
        'pending',
        NULL,
        NULL,
        '2026-01-19 12:45:00'
    ),
    (
        4,
        3,
        1040.00,
        1,
        '2026-03-01',
        NULL,
        'pending',
        NULL,
        NULL,
        '2026-01-22 10:15:00'
    ),
    (
        5,
        1,
        1312.50,
        3,
        '2026-04-15',
        NULL,
        'pending',
        NULL,
        NULL,
        '2026-01-18 11:30:00'
    );

-- ========================================
-- 9. CROWDFUNDING_POSTS TABLE (5 entries)
-- ========================================
INSERT INTO
    `crowdfunding_posts` (
        `post_id`,
        `creator_id`,
        `category`,
        `custom_category`,
        `title`,
        `summary`,
        `location`,
        `num_people`,
        `age_group`,
        `amount_needed`,
        `action_plan`,
        `share_receipts`,
        `extra_funds_handling`,
        `status`,
        `approved_by`,
        `approval_date`,
        `created_at`,
        `updated_at`
    )
VALUES (
        1,
        2,
        'Education',
        NULL,
        'Books for Underprivileged Students',
        'Collecting funds to buy textbooks and study materials for 20 underprivileged students in rural areas who cannot afford basic educational resources.',
        'Tangail District',
        20,
        'Children (6-12)',
        12000.00,
        'Purchase books from wholesale suppliers, distribute to identified students through local schools, and provide monthly study material support.',
        'yes',
        'Any extra funds will be used to buy additional notebooks and stationery for the students.',
        'open',
        1,
        '2026-01-16 14:00:00',
        '2026-01-15 09:30:00',
        '2026-01-20 10:30:00'
    ),
    (
        2,
        3,
        'Medical',
        NULL,
        'Cancer Treatment for Village Elder',
        'Help raise funds for chemotherapy treatment for Mr. Abdul Karim, a 65-year-old village elder who served the community for decades but cannot afford cancer treatment.',
        'Comilla District',
        1,
        'Elderly (60+)',
        80000.00,
        'Pay hospital bills directly to DMCH oncology department, cover medication costs, and arrange transportation for treatment sessions.',
        'yes',
        'Remaining funds will be used for post-treatment care and medication.',
        'open',
        1,
        '2026-01-17 15:30:00',
        '2026-01-16 10:45:00',
        '2026-01-21 11:00:00'
    ),
    (
        3,
        6,
        'Emergency',
        'Flood Relief',
        'Emergency Relief for Flood Victims',
        'Urgent assistance needed for 50 families affected by recent floods in Sylhet. Need funds for food, clean water, and temporary shelter materials.',
        'Sylhet Division',
        50,
        'Mixed Ages',
        45000.00,
        'Purchase rice, lentils, water purification tablets, tarpaulins, and hygiene kits. Coordinate with local volunteers for distribution.',
        'yes',
        'Extra funds will be kept in reserve for continued support or medical emergencies among affected families.',
        'open',
        1,
        '2026-01-19 08:45:00',
        '2026-01-18 11:20:00',
        '2026-01-22 09:15:00'
    ),
    (
        4,
        4,
        'Community',
        'Clean Water',
        'Community Water Filtration System',
        'Installing a community water filtration system for a village of 500+ people who currently lack access to clean drinking water.',
        'Rangpur District',
        500,
        'Mixed Ages',
        95000.00,
        'Purchase and install industrial water filtration system, build protection structure, train local maintenance team, and provide 1-year spare parts.',
        'yes',
        'Additional funds will be used for water quality testing equipment and maintenance fund.',
        'pending',
        NULL,
        NULL,
        '2026-01-20 13:50:00',
        '2026-01-20 13:50:00'
    ),
    (
        5,
        5,
        'Medical',
        'Mobile Clinic',
        'Mobile Medical Camp for Remote Areas',
        'Organizing a 3-day mobile medical camp in remote hill areas where people lack access to basic healthcare. Free consultations and medicines for 300+ people.',
        'Bandarban Hill Tracts',
        300,
        'Mixed Ages',
        55000.00,
        'Hire doctors and nurses, rent mobile clinic van, purchase essential medicines, arrange transportation, and provide free health checkups.',
        'yes',
        'Surplus funds will be used to purchase additional medicines or organize follow-up camps.',
        'pending',
        NULL,
        NULL,
        '2026-01-21 15:30:00',
        '2026-01-21 15:30:00'
    );

-- ========================================
-- 10. CROWDFUNDING_DOCUMENTS TABLE (5 entries)
-- ========================================
INSERT INTO
    `crowdfunding_documents` (
        `doc_id`,
        `post_id`,
        `doc_type`,
        `file_path`,
        `file_name`,
        `file_size`,
        `mime_type`,
        `verified`,
        `uploaded_at`
    )
VALUES (
        1,
        1,
        'proof',
        'images/uploads/funding_docs/post_1_school_list.pdf',
        'post_1_school_list.pdf',
        234567,
        'application/pdf',
        1,
        '2026-01-15 09:45:00'
    ),
    (
        2,
        2,
        'medical',
        'images/uploads/funding_docs/post_2_medical_report.pdf',
        'post_2_medical_report.pdf',
        567890,
        'application/pdf',
        1,
        '2026-01-16 11:00:00'
    ),
    (
        3,
        3,
        'proof',
        'images/uploads/funding_docs/post_3_flood_photos.jpg',
        'post_3_flood_photos.jpg',
        456789,
        'image/jpeg',
        1,
        '2026-01-18 11:35:00'
    ),
    (
        4,
        4,
        'proof',
        'images/uploads/funding_docs/post_4_water_test.pdf',
        'post_4_water_test.pdf',
        345678,
        'application/pdf',
        0,
        '2026-01-20 14:05:00'
    ),
    (
        5,
        5,
        'other',
        'images/uploads/funding_docs/post_5_camp_proposal.pdf',
        'post_5_camp_proposal.pdf',
        678901,
        'application/pdf',
        0,
        '2026-01-21 15:45:00'
    );

-- ========================================
-- 11. FUNDING_PURPOSES TABLE (5 entries)
-- ========================================
INSERT INTO
    `funding_purposes` (
        `purpose_id`,
        `post_id`,
        `purpose_type`,
        `custom_purpose`
    )
VALUES (1, 1, 'Education', NULL),
    (
        2,
        2,
        'Medical Treatment',
        NULL
    ),
    (
        3,
        3,
        'Emergency Relief',
        NULL
    ),
    (
        4,
        4,
        'Community Development',
        'Clean Water Access'
    ),
    (
        5,
        5,
        'Healthcare',
        'Mobile Medical Services'
    );

-- ========================================
-- 12. FUND_BREAKDOWN_ITEMS TABLE (5 entries per post = 25 total, showing 5 key ones)
-- ========================================
INSERT INTO
    `fund_breakdown_items` (
        `breakdown_id`,
        `post_id`,
        `item_name`,
        `quantity`,
        `cost_per_unit`,
        `created_at`
    )
VALUES (
        1,
        1,
        'Textbooks (Class 6-10)',
        100,
        80.00,
        '2026-01-15 09:35:00'
    ),
    (
        2,
        1,
        'Notebooks and Stationery Sets',
        20,
        150.00,
        '2026-01-15 09:35:00'
    ),
    (
        3,
        2,
        'Chemotherapy Sessions',
        6,
        12000.00,
        '2026-01-16 10:50:00'
    ),
    (
        4,
        2,
        'Cancer Medications (Monthly)',
        3,
        5000.00,
        '2026-01-16 10:50:00'
    ),
    (
        5,
        2,
        'Hospital Bed and Care',
        15,
        500.00,
        '2026-01-16 10:50:00'
    ),
    (
        6,
        3,
        'Rice (50 kg bags)',
        50,
        300.00,
        '2026-01-18 11:25:00'
    ),
    (
        7,
        3,
        'Tarpaulin Sheets',
        50,
        400.00,
        '2026-01-18 11:25:00'
    ),
    (
        8,
        3,
        'Water Purification Tablets',
        100,
        50.00,
        '2026-01-18 11:25:00'
    ),
    (
        9,
        4,
        'Water Filtration System',
        1,
        75000.00,
        '2026-01-20 13:55:00'
    ),
    (
        10,
        4,
        'Installation and Setup',
        1,
        15000.00,
        '2026-01-20 13:55:00'
    ),
    (
        11,
        5,
        'Doctor Fees (3 days)',
        3,
        8000.00,
        '2026-01-21 15:35:00'
    ),
    (
        12,
        5,
        'Essential Medicines Kit',
        10,
        2500.00,
        '2026-01-21 15:35:00'
    ),
    (
        13,
        5,
        'Mobile Clinic Van Rental',
        3,
        3000.00,
        '2026-01-21 15:35:00'
    ),
    (
        14,
        3,
        'Hygiene Kits (Soap, Sanitizer)',
        50,
        150.00,
        '2026-01-18 11:25:00'
    ),
    (
        15,
        1,
        'Dictionary and Reference Books',
        20,
        100.00,
        '2026-01-15 09:35:00'
    );

-- ========================================
-- 13. CROWDFUNDING_CONTRIBUTIONS TABLE (5 entries)
-- ========================================
INSERT INTO
    `crowdfunding_contributions` (
        `contrib_id`,
        `contributor_id`,
        `post_id`,
        `amount`,
        `payment_method`,
        `payment_status`,
        `transaction_id`,
        `contrib_date`
    )
VALUES (
        1,
        4,
        1,
        2000.00,
        'bKash',
        'completed',
        'TXN-FUND-20260117-001',
        '2026-01-17 10:30:00'
    ),
    (
        2,
        5,
        1,
        1500.00,
        'Nagad',
        'completed',
        'TXN-FUND-20260118-002',
        '2026-01-18 11:45:00'
    ),
    (
        3,
        6,
        2,
        5000.00,
        'bKash',
        'completed',
        'TXN-FUND-20260119-003',
        '2026-01-19 09:20:00'
    ),
    (
        4,
        4,
        3,
        3000.00,
        'Rocket',
        'completed',
        'TXN-FUND-20260220-004',
        '2026-01-20 14:30:00'
    ),
    (
        5,
        2,
        2,
        2500.00,
        'Bank Transfer',
        'completed',
        'TXN-FUND-20260221-005',
        '2026-01-21 08:15:00'
    );

-- ========================================
-- 14. CROWDFUNDING_RATINGS TABLE (5 entries)
-- ========================================
INSERT INTO
    `crowdfunding_ratings` (
        `rating_id`,
        `rater_id`,
        `ratee_id`,
        `post_id`,
        `score`,
        `review`,
        `rated_at`
    )
VALUES (
        1,
        4,
        2,
        1,
        5,
        'Transparent and well-organized campaign. Received receipts for all book purchases. Great initiative!',
        '2026-01-24 10:30:00'
    ),
    (
        2,
        5,
        2,
        1,
        5,
        'Sarah is doing amazing work helping underprivileged students. All funds were used as promised.',
        '2026-01-24 11:45:00'
    ),
    (
        3,
        6,
        3,
        2,
        5,
        'Very genuine cause. Ahmed provided hospital bills and regular updates on the treatment progress.',
        '2026-01-24 13:20:00'
    ),
    (
        4,
        4,
        6,
        3,
        4,
        'Good relief effort. Photos and receipts shared regularly. Slight delay in distribution but overall good.',
        '2026-01-24 15:00:00'
    ),
    (
        5,
        2,
        3,
        2,
        5,
        'Heartwarming to see community coming together. All receipts shared transparently. Excellent!',
        '2026-01-24 16:15:00'
    );

-- ========================================
-- 15. NOTIFICATIONS TABLE (5 entries)
-- ========================================
INSERT INTO
    `notifications` (
        `notification_id`,
        `user_id`,
        `type`,
        `title`,
        `message`,
        `loan_id`,
        `post_id`,
        `is_read`,
        `created_at`
    )
VALUES (
        1,
        2,
        'loan_accepted',
        'Loan Offer Accepted',
        'Your loan request for 15000 BDT has been accepted by a lender. Funds will be transferred soon.',
        1,
        NULL,
        1,
        '2026-01-18 10:20:00'
    ),
    (
        2,
        4,
        'contribution',
        'Contribution Received',
        'Sarah Khan made a contribution of 2000 BDT to your crowdfunding campaign.',
        NULL,
        1,
        1,
        '2026-01-17 10:35:00'
    ),
    (
        3,
        3,
        'approval',
        'Loan Request Approved',
        'Your loan request for 25000 BDT has been approved by the admin. It is now visible to lenders.',
        2,
        NULL,
        1,
        '2026-01-17 11:35:00'
    ),
    (
        4,
        2,
        'loan_offer',
        'New Loan Offer Received',
        'You have received a new loan offer of 15000 BDT from a lender. Review and respond.',
        1,
        NULL,
        0,
        '2026-01-17 09:35:00'
    ),
    (
        5,
        6,
        'approval',
        'Crowdfunding Post Approved',
        'Your crowdfunding campaign "Emergency Relief for Flood Victims" has been approved and is now live.',
        NULL,
        3,
        0,
        '2026-01-19 09:00:00'
    );

-- ========================================
-- 16. SESSIONS TABLE (5 entries)
-- ========================================
INSERT INTO
    `sessions` (
        `session_id`,
        `user_id`,
        `ip_address`,
        `user_agent`,
        `last_activity`
    )
VALUES (
        'sess_sarah_20260126_001',
        2,
        '192.168.1.101',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        '2026-01-26 10:30:00'
    ),
    (
        'sess_ahmed_20260126_002',
        3,
        '192.168.1.102',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        '2026-01-26 09:45:00'
    ),
    (
        'sess_fatima_20260126_003',
        4,
        '192.168.1.103',
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
        '2026-01-26 11:20:00'
    ),
    (
        'sess_karim_20260126_004',
        5,
        '192.168.1.104',
        'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15',
        '2026-01-26 08:15:00'
    ),
    (
        'sess_nadia_20260126_005',
        6,
        '192.168.1.105',
        'Mozilla/5.0 (iPad; CPU OS 15_0 like Mac OS X) AppleWebKit/605.1.15',
        '2026-01-26 12:00:00'
    );

-- ========================================
-- SUMMARY
-- ========================================
-- Total Data Inserted:
-- - 5 Users (+ 1 admin already exists)
-- - 5 User Documents
-- - 5 Loan Requests
-- - 5 Loan Documents
-- - 5 Loan Offers
-- - 5 Loan Contributions
-- - 5 Loan Ratings
-- - 5 Repayments
-- - 5 Crowdfunding Posts
-- - 5 Crowdfunding Documents
-- - 5 Funding Purposes
-- - 15 Fund Breakdown Items
-- - 5 Crowdfunding Contributions
-- - 5 Crowdfunding Ratings
-- - 5 Notifications
-- - 5 Sessions
-- ========================================

SELECT 'Sample data inserted successfully!' AS Status;