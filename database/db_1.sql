-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:55000
-- Generation Time: Jan 26, 2026 at 07:15 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_1`
--

-- --------------------------------------------------------

--
-- Table structure for table `crowdfunding_contributions`
--

CREATE TABLE `crowdfunding_contributions` (
  `contrib_id` int(11) NOT NULL,
  `contributor_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL CHECK (`amount` > 0),
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` enum('pending','completed','failed') DEFAULT 'pending',
  `transaction_id` varchar(255) DEFAULT NULL,
  `contrib_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `crowdfunding_contributions`
--

INSERT INTO `crowdfunding_contributions` (`contrib_id`, `contributor_id`, `post_id`, `amount`, `payment_method`, `payment_status`, `transaction_id`, `contrib_date`) VALUES
(1, 4, 1, 2000.00, 'bKash', 'completed', 'TXN-FUND-20260117-001', '2026-01-17 04:30:00'),
(2, 5, 1, 1500.00, 'Nagad', 'completed', 'TXN-FUND-20260118-002', '2026-01-18 05:45:00'),
(3, 6, 2, 5000.00, 'bKash', 'completed', 'TXN-FUND-20260119-003', '2026-01-19 03:20:00'),
(4, 4, 3, 3000.00, 'Rocket', 'completed', 'TXN-FUND-20260220-004', '2026-01-20 08:30:00'),
(5, 2, 2, 2500.00, 'Bank Transfer', 'completed', 'TXN-FUND-20260221-005', '2026-01-21 02:15:00'),
(7, 7, 5, 1009.00, 'mobile (bkash)', 'completed', 'TXN69777851d4d8cE04E7', '2026-01-26 14:21:05'),
(8, 7, 4, 78.00, 'card (ending 7890)', 'completed', 'TXN6977790b960d14FFE9', '2026-01-26 14:24:11'),
(9, 7, 3, 7000.00, 'mobile (upay)', 'completed', 'TXN697779ed488aeFDF4F', '2026-01-26 14:27:57'),
(10, 7, 1, 3000.01, 'mobile (upay)', 'completed', 'TXN69777a120df295FC31', '2026-01-26 14:28:34'),
(11, 7, 4, 890.00, 'mobile (rocket)', 'completed', 'TXN69777c124c9533F0C8', '2026-01-26 14:37:06'),
(12, 7, 4, 7890.00, 'mobile (dbbl)', 'completed', 'TXN69777c867e8a7DAB28', '2026-01-26 14:39:02'),
(13, 7, 3, 989.00, 'mobile (nagad)', 'completed', 'TXN69777c9f6f0ea9F94F', '2026-01-26 14:39:27'),
(14, 7, 1, 7658.00, 'card (ending 1111)', 'completed', 'TXN69777d1d5d8c87AD79', '2026-01-26 14:41:33');

--
-- Triggers `crowdfunding_contributions`
--
DELIMITER $$
CREATE TRIGGER `trg_update_post_status_on_funding` AFTER INSERT ON `crowdfunding_contributions` FOR EACH ROW BEGIN
    DECLARE total_raised DECIMAL(10, 2);
    DECLARE post_amount DECIMAL(10, 2);
    
    SELECT COALESCE(SUM(amount), 0), (SELECT amount_needed FROM crowdfunding_posts WHERE post_id = NEW.post_id)
    INTO total_raised, post_amount
    FROM crowdfunding_contributions
    WHERE post_id = NEW.post_id AND payment_status = 'completed';
    
    IF total_raised >= post_amount AND (SELECT status FROM crowdfunding_posts WHERE post_id = NEW.post_id) = 'open' THEN
        UPDATE crowdfunding_posts 
        SET status = 'funded' 
        WHERE post_id = NEW.post_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `crowdfunding_documents`
--

CREATE TABLE `crowdfunding_documents` (
  `doc_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `doc_type` enum('student_id','nid','bill','proof','medical','other') NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_size` int(11) DEFAULT NULL CHECK (`file_size` >= 0),
  `mime_type` varchar(100) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT 0,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `crowdfunding_documents`
--

INSERT INTO `crowdfunding_documents` (`doc_id`, `post_id`, `doc_type`, `file_path`, `file_name`, `file_size`, `mime_type`, `verified`, `uploaded_at`) VALUES
(1, 1, 'proof', 'images/uploads/funding_docs/post_1_school_list.pdf', 'post_1_school_list.pdf', 234567, 'application/pdf', 1, '2026-01-15 03:45:00'),
(2, 2, 'medical', 'images/uploads/funding_docs/post_2_medical_report.pdf', 'post_2_medical_report.pdf', 567890, 'application/pdf', 1, '2026-01-16 05:00:00'),
(3, 3, 'proof', 'images/uploads/funding_docs/post_3_flood_photos.jpg', 'post_3_flood_photos.jpg', 456789, 'image/jpeg', 1, '2026-01-18 05:35:00'),
(4, 4, 'proof', 'images/uploads/funding_docs/post_4_water_test.pdf', 'post_4_water_test.pdf', 345678, 'application/pdf', 0, '2026-01-20 08:05:00'),
(5, 5, 'other', 'images/uploads/funding_docs/post_5_camp_proposal.pdf', 'post_5_camp_proposal.pdf', 678901, 'application/pdf', 0, '2026-01-21 09:45:00'),
(6, 6, 'other', 'images/uploads/funding/69778502c94cf_cover_large-tsunami-wave-crashing-into-city.jpg', 'large-tsunami-wave-crashing-into-city.jpg', 14149117, 'image/jpeg', 0, '2026-01-26 15:15:14'),
(7, 6, 'proof', 'images/uploads/funding/69778502c9fe7_fund_paper_2.jpg', 'paper_2.jpg', 1024946, 'image/jpeg', 0, '2026-01-26 15:15:14'),
(8, 7, 'other', 'images/uploads/funding/697786be64345_cover_large-tsunami-wave-crashing-into-city.jpg', 'large-tsunami-wave-crashing-into-city.jpg', 14149117, 'image/jpeg', 0, '2026-01-26 15:22:38'),
(9, 7, 'proof', 'images/uploads/funding/697786be669f7_fund_paper_2.jpg', 'paper_2.jpg', 1024946, 'image/jpeg', 0, '2026-01-26 15:22:38');

-- --------------------------------------------------------

--
-- Table structure for table `crowdfunding_posts`
--

CREATE TABLE `crowdfunding_posts` (
  `post_id` int(11) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `category` varchar(50) NOT NULL,
  `custom_category` varchar(100) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `summary` text NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `num_people` int(11) DEFAULT NULL CHECK (`num_people` is null or `num_people` >= 0),
  `age_group` varchar(50) DEFAULT NULL,
  `amount_needed` decimal(10,2) NOT NULL CHECK (`amount_needed` > 0),
  `action_plan` text DEFAULT NULL,
  `share_receipts` enum('yes','no') DEFAULT 'yes',
  `extra_funds_handling` text DEFAULT NULL,
  `status` enum('pending','approved','open','closed','funded','rejected') DEFAULT 'pending',
  `approved_by` int(11) DEFAULT NULL,
  `approval_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `crowdfunding_posts`
--

INSERT INTO `crowdfunding_posts` (`post_id`, `creator_id`, `category`, `custom_category`, `title`, `summary`, `location`, `num_people`, `age_group`, `amount_needed`, `action_plan`, `share_receipts`, `extra_funds_handling`, `status`, `approved_by`, `approval_date`, `created_at`, `updated_at`) VALUES
(1, 2, 'Education', NULL, 'Books for Underprivileged Students', 'Collecting funds to buy textbooks and study materials for 20 underprivileged students in rural areas who cannot afford basic educational resources.', 'Tangail District', 20, 'Children (6-12)', 12000.00, 'Purchase books from wholesale suppliers, distribute to identified students through local schools, and provide monthly study material support.', 'yes', 'Any extra funds will be used to buy additional notebooks and stationery for the students.', 'funded', 1, '2026-01-16 08:00:00', '2026-01-15 03:30:00', '2026-01-26 14:41:33'),
(2, 3, 'Medical', NULL, 'Cancer Treatment for Village Elder', 'Help raise funds for chemotherapy treatment for Mr. Abdul Karim, a 65-year-old village elder who served the community for decades but cannot afford cancer treatment.', 'Comilla District', 1, 'Elderly (60+)', 80000.00, 'Pay hospital bills directly to DMCH oncology department, cover medication costs, and arrange transportation for treatment sessions.', 'yes', 'Remaining funds will be used for post-treatment care and medication.', 'open', 1, '2026-01-17 09:30:00', '2026-01-16 04:45:00', '2026-01-21 05:00:00'),
(3, 6, 'Emergency', 'Flood Relief', 'Emergency Relief for Flood Victims', 'Urgent assistance needed for 50 families affected by recent floods in Sylhet. Need funds for food, clean water, and temporary shelter materials.', 'Sylhet Division', 50, 'Mixed Ages', 45000.00, 'Purchase rice, lentils, water purification tablets, tarpaulins, and hygiene kits. Coordinate with local volunteers for distribution.', 'yes', 'Extra funds will be kept in reserve for continued support or medical emergencies among affected families.', 'open', 1, '2026-01-19 02:45:00', '2026-01-18 05:20:00', '2026-01-22 03:15:00'),
(4, 4, 'Community', 'Clean Water', 'Community Water Filtration System', 'Installing a community water filtration system for a village of 500+ people who currently lack access to clean drinking water.', 'Rangpur District', 500, 'Mixed Ages', 95000.00, 'Purchase and install industrial water filtration system, build protection structure, train local maintenance team, and provide 1-year spare parts.', 'yes', 'Additional funds will be used for water quality testing equipment and maintenance fund.', 'open', 1, '2026-01-26 08:46:34', '2026-01-20 07:50:00', '2026-01-26 08:46:34'),
(5, 5, 'Medical', 'Mobile Clinic', 'Mobile Medical Camp for Remote Areas', 'Organizing a 3-day mobile medical camp in remote hill areas where people lack access to basic healthcare. Free consultations and medicines for 300+ people.', 'Bandarban Hill Tracts', 300, 'Mixed Ages', 55000.00, 'Hire doctors and nurses, rent mobile clinic van, purchase essential medicines, arrange transportation, and provide free health checkups.', 'yes', 'Surplus funds will be used to purchase additional medicines or organize follow-up camps.', 'open', 1, '2026-01-26 08:46:30', '2026-01-21 09:30:00', '2026-01-26 08:46:30'),
(6, 7, 'emergency', NULL, 'flood', 'ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg', 'f', 34, '6', 29999.98, 'f', 'yes', '', 'pending', NULL, NULL, '2026-01-26 15:15:14', '2026-01-26 15:15:14'),
(7, 7, 'emergency', NULL, 'flood', 'dddddddddddddddddddddddgggggggggggggggggggggggggggggghhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh', 'd', 56, '40', 11999.98, 'fhsjdhf', 'yes', 'd', 'pending', NULL, NULL, '2026-01-26 15:22:38', '2026-01-26 15:22:38');

-- --------------------------------------------------------

--
-- Table structure for table `crowdfunding_ratings`
--

CREATE TABLE `crowdfunding_ratings` (
  `rating_id` int(11) NOT NULL,
  `rater_id` int(11) NOT NULL,
  `ratee_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `score` int(11) NOT NULL CHECK (`score` between 1 and 5),
  `review` text DEFAULT NULL,
  `rated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `crowdfunding_ratings`
--

INSERT INTO `crowdfunding_ratings` (`rating_id`, `rater_id`, `ratee_id`, `post_id`, `score`, `review`, `rated_at`) VALUES
(1, 4, 2, 1, 5, 'Transparent and well-organized campaign. Received receipts for all book purchases. Great initiative!', '2026-01-24 04:30:00'),
(2, 5, 2, 1, 5, 'Sarah is doing amazing work helping underprivileged students. All funds were used as promised.', '2026-01-24 05:45:00'),
(3, 6, 3, 2, 5, 'Very genuine cause. Ahmed provided hospital bills and regular updates on the treatment progress.', '2026-01-24 07:20:00'),
(4, 4, 6, 3, 4, 'Good relief effort. Photos and receipts shared regularly. Slight delay in distribution but overall good.', '2026-01-24 09:00:00'),
(5, 2, 3, 2, 5, 'Heartwarming to see community coming together. All receipts shared transparently. Excellent!', '2026-01-24 10:15:00');

-- --------------------------------------------------------

--
-- Table structure for table `funding_purposes`
--

CREATE TABLE `funding_purposes` (
  `purpose_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `purpose_type` varchar(50) NOT NULL,
  `custom_purpose` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `funding_purposes`
--

INSERT INTO `funding_purposes` (`purpose_id`, `post_id`, `purpose_type`, `custom_purpose`) VALUES
(1, 1, 'Education', NULL),
(2, 2, 'Medical Treatment', NULL),
(3, 3, 'Emergency Relief', NULL),
(4, 4, 'Community Development', 'Clean Water Access'),
(5, 5, 'Healthcare', 'Mobile Medical Services'),
(6, 6, 'medical', NULL),
(7, 7, 'food', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `fund_breakdown_items`
--

CREATE TABLE `fund_breakdown_items` (
  `breakdown_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL CHECK (`quantity` > 0),
  `cost_per_unit` decimal(10,2) NOT NULL CHECK (`cost_per_unit` >= 0),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fund_breakdown_items`
--

INSERT INTO `fund_breakdown_items` (`breakdown_id`, `post_id`, `item_name`, `quantity`, `cost_per_unit`, `created_at`) VALUES
(1, 1, 'Textbooks (Class 6-10)', 100, 80.00, '2026-01-15 03:35:00'),
(2, 1, 'Notebooks and Stationery Sets', 20, 150.00, '2026-01-15 03:35:00'),
(3, 2, 'Chemotherapy Sessions', 6, 12000.00, '2026-01-16 04:50:00'),
(4, 2, 'Cancer Medications (Monthly)', 3, 5000.00, '2026-01-16 04:50:00'),
(5, 2, 'Hospital Bed and Care', 15, 500.00, '2026-01-16 04:50:00'),
(6, 3, 'Rice (50 kg bags)', 50, 300.00, '2026-01-18 05:25:00'),
(7, 3, 'Tarpaulin Sheets', 50, 400.00, '2026-01-18 05:25:00'),
(8, 3, 'Water Purification Tablets', 100, 50.00, '2026-01-18 05:25:00'),
(9, 4, 'Water Filtration System', 1, 75000.00, '2026-01-20 07:55:00'),
(10, 4, 'Installation and Setup', 1, 15000.00, '2026-01-20 07:55:00'),
(11, 5, 'Doctor Fees (3 days)', 3, 8000.00, '2026-01-21 09:35:00'),
(12, 5, 'Essential Medicines Kit', 10, 2500.00, '2026-01-21 09:35:00'),
(13, 5, 'Mobile Clinic Van Rental', 3, 3000.00, '2026-01-21 09:35:00'),
(14, 3, 'Hygiene Kits (Soap, Sanitizer)', 50, 150.00, '2026-01-18 05:25:00'),
(15, 1, 'Dictionary and Reference Books', 20, 100.00, '2026-01-15 03:35:00');

-- --------------------------------------------------------

--
-- Table structure for table `loan_contributions`
--

CREATE TABLE `loan_contributions` (
  `contrib_id` int(11) NOT NULL,
  `contributor_id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL CHECK (`amount` > 0),
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` enum('pending','completed','failed') DEFAULT 'pending',
  `transaction_id` varchar(255) DEFAULT NULL,
  `contrib_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loan_contributions`
--

INSERT INTO `loan_contributions` (`contrib_id`, `contributor_id`, `loan_id`, `amount`, `payment_method`, `payment_status`, `transaction_id`, `contrib_date`) VALUES
(1, 4, 1, 15000.00, 'bKash', 'completed', 'TXN-LOAN-20260118-001', '2026-01-18 05:30:00'),
(2, 5, 2, 25000.00, 'Nagad', 'completed', 'TXN-LOAN-20260119-002', '2026-01-19 06:45:00'),
(3, 4, 3, 8000.00, 'Rocket', 'completed', 'TXN-LOAN-20260122-003', '2026-01-22 04:15:00'),
(4, 5, 1, 5000.00, 'bKash', 'failed', 'TXN-LOAN-20260117-004', '2026-01-17 08:20:00'),
(5, 4, 2, 10000.00, 'Bank Transfer', 'pending', 'TXN-LOAN-20260118-005', '2026-01-18 09:30:00');

--
-- Triggers `loan_contributions`
--
DELIMITER $$
CREATE TRIGGER `trg_update_loan_status_on_funding` AFTER INSERT ON `loan_contributions` FOR EACH ROW BEGIN
    DECLARE total_funded DECIMAL(10, 2);
    DECLARE loan_amount DECIMAL(10, 2);
    
    SELECT COALESCE(SUM(amount), 0), (SELECT amount FROM loan_requests WHERE loan_id = NEW.loan_id)
    INTO total_funded, loan_amount
    FROM loan_contributions
    WHERE loan_id = NEW.loan_id AND payment_status = 'completed';
    
    IF total_funded >= loan_amount AND (SELECT status FROM loan_requests WHERE loan_id = NEW.loan_id) = 'approved' THEN
        UPDATE loan_requests 
        SET status = 'funded' 
        WHERE loan_id = NEW.loan_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `loan_documents`
--

CREATE TABLE `loan_documents` (
  `doc_id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `doc_type` enum('student_id','nid','bill','proof','medical','other') NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_size` int(11) DEFAULT NULL CHECK (`file_size` >= 0),
  `mime_type` varchar(100) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT 0,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loan_documents`
--

INSERT INTO `loan_documents` (`doc_id`, `loan_id`, `doc_type`, `file_path`, `file_name`, `file_size`, `mime_type`, `verified`, `uploaded_at`) VALUES
(1, 1, 'student_id', 'images/uploads/loan_docs/loan_1_student_id.jpg', 'loan_1_student_id.jpg', 234567, 'image/jpeg', 1, '2026-01-15 08:35:00'),
(2, 1, 'bill', 'images/uploads/loan_docs/loan_1_tuition_bill.pdf', 'loan_1_tuition_bill.pdf', 456789, 'application/pdf', 1, '2026-01-15 08:40:00'),
(3, 2, 'medical', 'images/uploads/loan_docs/loan_2_medical_report.pdf', 'loan_2_medical_report.pdf', 678901, 'application/pdf', 1, '2026-01-16 09:50:00'),
(4, 3, 'proof', 'images/uploads/loan_docs/loan_3_broken_laptop.jpg', 'loan_3_broken_laptop.jpg', 345678, 'image/jpeg', 1, '2026-01-19 10:25:00'),
(5, 4, 'proof', 'images/uploads/loan_docs/loan_4_business_plan.pdf', 'loan_4_business_plan.pdf', 890123, 'application/pdf', 0, '2026-01-22 04:35:00'),
(6, 6, 'proof', 'images/uploads/loans/6977815b89818_paper_2.jpg', 'paper_2.jpg', 1024946, 'image/jpeg', 0, '2026-01-26 14:59:39'),
(7, 7, 'bill', 'images/uploads/loans/69778d805deff_paper_2.jpg', 'paper_2.jpg', 1024946, 'image/jpeg', 0, '2026-01-26 15:51:28');

-- --------------------------------------------------------

--
-- Table structure for table `loan_offers`
--

CREATE TABLE `loan_offers` (
  `offer_id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `lender_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL CHECK (`amount` > 0),
  `interest_rate` decimal(5,2) DEFAULT NULL CHECK (`interest_rate` is null or `interest_rate` >= 0),
  `terms` text DEFAULT NULL,
  `status` enum('pending','accepted','rejected','withdrawn') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loan_offers`
--

INSERT INTO `loan_offers` (`offer_id`, `loan_id`, `lender_id`, `amount`, `interest_rate`, `terms`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 15000.00, 5.00, 'Monthly installments of 1312.50 BDT for 12 months. First payment due February 15, 2026.', 'accepted', '2026-01-17 03:30:00', '2026-01-18 04:15:00'),
(2, 2, 5, 25000.00, 3.50, 'Monthly installments of 4312.50 BDT for 6 months. Grace period of 1 month before repayment starts.', 'accepted', '2026-01-18 04:45:00', '2026-01-19 05:20:00'),
(3, 3, 4, 8000.00, 4.00, 'Monthly installments of 1040 BDT for 8 months. Payment due on 1st of each month.', 'accepted', '2026-01-21 02:20:00', '2026-01-22 03:00:00'),
(4, 1, 5, 15000.00, 6.00, 'Monthly installments of 1325 BDT for 12 months with 6% interest rate.', 'rejected', '2026-01-17 05:00:00', '2026-01-18 04:15:00'),
(5, 2, 4, 20000.00, 4.50, 'Partial funding offer. Monthly installments of 3450 BDT for 6 months.', 'rejected', '2026-01-18 06:30:00', '2026-01-19 05:20:00');

-- --------------------------------------------------------

--
-- Table structure for table `loan_ratings`
--

CREATE TABLE `loan_ratings` (
  `rating_id` int(11) NOT NULL,
  `rater_id` int(11) NOT NULL,
  `ratee_id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `score` int(11) NOT NULL CHECK (`score` between 1 and 5),
  `review` text DEFAULT NULL,
  `rated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loan_ratings`
--

INSERT INTO `loan_ratings` (`rating_id`, `rater_id`, `ratee_id`, `loan_id`, `score`, `review`, `rated_at`) VALUES
(1, 4, 2, 1, 5, 'Excellent borrower! Very communicative and made the first repayment on time. Highly recommend.', '2026-01-25 04:00:00'),
(2, 5, 3, 2, 5, 'Trustworthy and responsible. Provided all necessary documentation promptly. Would lend again.', '2026-01-25 05:30:00'),
(3, 4, 6, 3, 4, 'Good borrower. Documentation was complete and communication was clear. Looking forward to timely repayments.', '2026-01-25 08:20:00'),
(4, 2, 4, 1, 5, 'Amazing lender! Quick response, fair terms, and very understanding. Grateful for the support.', '2026-01-25 09:45:00'),
(5, 3, 5, 2, 5, 'Very professional and kind lender. Offered grace period for medical emergency. Highly appreciated!', '2026-01-25 10:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `loan_requests`
--

CREATE TABLE `loan_requests` (
  `loan_id` int(11) NOT NULL,
  `borrower_id` int(11) NOT NULL,
  `category` varchar(50) NOT NULL,
  `custom_category` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL CHECK (`amount` > 0),
  `duration_months` int(11) DEFAULT NULL CHECK (`duration_months` is null or `duration_months` > 0),
  `custom_duration` varchar(50) DEFAULT NULL,
  `repayment_option` enum('installments','onetime') DEFAULT 'installments',
  `reason` text NOT NULL,
  `interest_rate` decimal(5,2) DEFAULT 0.00 CHECK (`interest_rate` >= 0),
  `status` enum('pending','approved','funded','active','repaid','defaulted','rejected') DEFAULT 'pending',
  `approved_by` int(11) DEFAULT NULL,
  `approval_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loan_requests`
--

INSERT INTO `loan_requests` (`loan_id`, `borrower_id`, `category`, `custom_category`, `amount`, `duration_months`, `custom_duration`, `repayment_option`, `reason`, `interest_rate`, `status`, `approved_by`, `approval_date`, `created_at`, `updated_at`) VALUES
(1, 2, 'Education', NULL, 15000.00, 12, NULL, 'installments', 'Need funds for semester tuition fees and textbooks. I am in my 3rd year of Computer Science and need to complete this semester to maintain my scholarship.', 5.00, 'funded', 1, '2026-01-16 04:00:00', '2026-01-15 08:30:00', '2026-01-26 08:07:41'),
(2, 3, 'Medical', NULL, 25000.00, 6, NULL, 'installments', 'Emergency medical treatment for my father who was diagnosed with heart condition. Need immediate funds for surgery and medication.', 3.50, 'funded', 1, '2026-01-17 05:30:00', '2026-01-16 09:45:00', '2026-01-26 08:07:41'),
(3, 6, 'Technology', NULL, 8000.00, 8, NULL, 'installments', 'Purchase laptop for online classes and programming projects. My old laptop broke down and I cannot afford a new one.', 4.00, 'funded', 1, '2026-01-20 03:15:00', '2026-01-19 10:20:00', '2026-01-26 08:07:41'),
(4, 2, 'Business', 'Small Startup', 30000.00, 18, NULL, 'installments', 'Starting a small online tutoring platform to help fellow students. Need funds for website development and initial marketing.', 6.00, 'approved', 1, '2026-01-26 08:46:24', '2026-01-22 04:30:00', '2026-01-26 08:46:24'),
(5, 3, 'Personal', 'Housing', 20000.00, 12, NULL, 'installments', 'Need to pay advance rent for student accommodation near campus. Current place is too far and affecting my studies.', 5.50, 'approved', 1, '2026-01-26 08:46:20', '2026-01-24 05:45:00', '2026-01-26 08:46:20'),
(6, 7, 'accidents', NULL, 100.00, 1, NULL, 'installments', 'goods', 0.00, 'pending', NULL, NULL, '2026-01-26 14:59:39', '2026-01-26 14:59:39'),
(7, 7, 'other', NULL, 600.00, 6, NULL, 'installments', 'dddddddddd', 0.00, 'approved', 1, '2026-01-26 16:59:28', '2026-01-26 15:51:28', '2026-01-26 16:59:28');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` enum('loan_offer','loan_accepted','contribution','approval','rejection','repayment','rating','system') NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `loan_id` int(11) DEFAULT NULL,
  `post_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `type`, `title`, `message`, `loan_id`, `post_id`, `is_read`, `created_at`) VALUES
(1, 2, 'loan_accepted', 'Loan Offer Accepted', 'Your loan request for 15000 BDT has been accepted by a lender. Funds will be transferred soon.', 1, NULL, 1, '2026-01-18 04:20:00'),
(2, 4, 'contribution', 'Contribution Received', 'Sarah Khan made a contribution of 2000 BDT to your crowdfunding campaign.', NULL, 1, 1, '2026-01-17 04:35:00'),
(3, 3, 'approval', 'Loan Request Approved', 'Your loan request for 25000 BDT has been approved by the admin. It is now visible to lenders.', 2, NULL, 1, '2026-01-17 05:35:00'),
(4, 2, 'loan_offer', 'New Loan Offer Received', 'You have received a new loan offer of 15000 BDT from a lender. Review and respond.', 1, NULL, 0, '2026-01-17 03:35:00'),
(5, 6, 'approval', 'Crowdfunding Post Approved', 'Your crowdfunding campaign \"Emergency Relief for Flood Victims\" has been approved and is now live.', NULL, 3, 0, '2026-01-19 03:00:00'),
(6, 3, 'approval', 'Loan Request Approved', 'Your loan request has been approved by admin.', 5, NULL, 0, '2026-01-26 08:46:20'),
(7, 2, 'approval', 'Loan Request Approved', 'Your loan request has been approved by admin.', 4, NULL, 0, '2026-01-26 08:46:24'),
(8, 5, 'approval', 'Fundraiser Approved', 'Your fundraiser has been approved and is now live!', NULL, 5, 0, '2026-01-26 08:46:30'),
(9, 4, 'approval', 'Fundraiser Approved', 'Your fundraiser has been approved and is now live!', NULL, 4, 0, '2026-01-26 08:46:34'),
(10, 5, 'contribution', 'New Donation Received', 'You received a new donation of ৳1,009.00 for your fundraiser!', NULL, 5, 0, '2026-01-26 14:21:05'),
(11, 4, 'contribution', 'New Donation Received', 'You received a new donation of ৳78.00 for your fundraiser!', NULL, 4, 0, '2026-01-26 14:24:11'),
(12, 6, 'contribution', 'New Donation Received', 'You received a new donation of ৳7,000.00 for your fundraiser!', NULL, 3, 0, '2026-01-26 14:27:57'),
(13, 2, 'contribution', 'New Donation Received', 'You received a new donation of ৳3,000.01 for your fundraiser!', NULL, 1, 0, '2026-01-26 14:28:34'),
(14, 4, 'contribution', 'New Donation Received', 'You received a new donation of ৳890.00 for your fundraiser!', NULL, 4, 0, '2026-01-26 14:37:06'),
(15, 4, 'contribution', 'New Donation Received', 'You received a new donation of ৳7,890.00 for your fundraiser!', NULL, 4, 0, '2026-01-26 14:39:02'),
(16, 6, 'contribution', 'New Donation Received', 'You received a new donation of ৳989.00 for your fundraiser!', NULL, 3, 0, '2026-01-26 14:39:27'),
(17, 2, 'contribution', 'New Donation Received', 'You received a new donation of ৳7,658.00 for your fundraiser!', NULL, 1, 0, '2026-01-26 14:41:33'),
(18, 7, 'approval', 'Loan Request Approved', 'Your loan request has been approved by admin.', 7, NULL, 0, '2026-01-26 16:59:28');

-- --------------------------------------------------------

--
-- Table structure for table `repayments`
--

CREATE TABLE `repayments` (
  `repay_id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL CHECK (`amount` > 0),
  `repayment_number` int(11) DEFAULT NULL CHECK (`repayment_number` > 0),
  `due_date` date DEFAULT NULL,
  `repay_date` timestamp NULL DEFAULT NULL,
  `status` enum('pending','paid','overdue','partial') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `repayments`
--

INSERT INTO `repayments` (`repay_id`, `loan_id`, `amount`, `repayment_number`, `due_date`, `repay_date`, `status`, `payment_method`, `transaction_id`, `created_at`) VALUES
(1, 1, 1312.50, 1, '2026-02-15', '2026-02-14 04:30:00', 'paid', 'bKash', 'TXN-REPAY-20260214-001', '2026-01-18 05:30:00'),
(2, 1, 1312.50, 2, '2026-03-15', NULL, 'pending', NULL, NULL, '2026-01-18 05:30:00'),
(3, 2, 4312.50, 1, '2026-03-18', NULL, 'pending', NULL, NULL, '2026-01-19 06:45:00'),
(4, 3, 1040.00, 1, '2026-03-01', NULL, 'pending', NULL, NULL, '2026-01-22 04:15:00'),
(5, 1, 1312.50, 3, '2026-04-15', NULL, 'pending', NULL, NULL, '2026-01-18 05:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(128) NOT NULL,
  `user_id` int(11) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `last_activity` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `last_activity`) VALUES
('sess_ahmed_20260126_002', 3, '192.168.1.102', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36', '2026-01-26 03:45:00'),
('sess_fatima_20260126_003', 4, '192.168.1.103', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36', '2026-01-26 05:20:00'),
('sess_karim_20260126_004', 5, '192.168.1.104', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15', '2026-01-26 02:15:00'),
('sess_nadia_20260126_005', 6, '192.168.1.105', 'Mozilla/5.0 (iPad; CPU OS 15_0 like Mac OS X) AppleWebKit/605.1.15', '2026-01-26 06:00:00'),
('sess_sarah_20260126_001', 2, '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', '2026-01-26 04:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `student_id` varchar(50) DEFAULT NULL,
  `university` varchar(100) DEFAULT NULL,
  `nid_number` varchar(50) DEFAULT NULL,
  `verification_status` enum('pending','verified','rejected') DEFAULT 'pending',
  `role` enum('student','admin','lender') DEFAULT 'student',
  `profile_image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password_hash`, `full_name`, `phone`, `student_id`, `university`, `nid_number`, `verification_status`, `role`, `profile_image`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin@lendora.com', '$2y$10$wVgcIv8r58kOqHPfkhuyl.v7yq4SvV68PhYHyypvu1VucUwx.PhpG', 'Admin User', NULL, NULL, NULL, NULL, 'verified', 'admin', NULL, '2026-01-22 10:49:09', '2026-01-26 08:11:34'),
(2, 'sarah_khan', 'sarah.khan@student.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sarah Khan', '+8801712345678', 'SID-2024-001', 'University of Dhaka', '19950315123456789', 'verified', 'student', NULL, '2026-01-15 02:30:00', '2026-01-20 04:15:00'),
(3, 'ahmed_rahman', 'ahmed.rahman@student.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ahmed Rahman', '+8801823456789', 'SID-2024-002', 'BUET', '19960720234567890', 'verified', 'student', NULL, '2026-01-16 03:00:00', '2026-01-21 05:30:00'),
(4, 'fatima_begum', 'fatima.begum@student.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Fatima Begum', '+8801934567890', 'SID-2024-003', 'Jahangirnagar University', '19970505345678901', 'verified', 'lender', NULL, '2026-01-17 04:20:00', '2026-01-22 08:45:00'),
(5, 'karim_hossain', 'karim.hossain@student.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Karim Hossain', '+8801645678901', 'SID-2024-004', 'North South University', '19980812456789012', 'verified', 'lender', NULL, '2026-01-18 05:45:00', '2026-01-23 03:20:00'),
(6, 'nadia_islam', 'nadia.islam@student.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Nadia Islam', '+8801756789012', 'SID-2024-005', 'IUB', '19991201567890123', 'pending', 'student', NULL, '2026-01-19 07:10:00', '2026-01-24 10:00:00'),
(7, 'user1', 'user1@gmail.com', '$2y$10$kS/YHSJcjOGlP1xkzFmRbeVtPzZAi1sILphgfkUSP9wUesoBdUL3S', 'user1', '1234', '1234', 'uni', '1234', 'pending', 'student', NULL, '2026-01-26 08:41:25', '2026-01-26 08:41:25');

-- --------------------------------------------------------

--
-- Table structure for table `user_documents`
--

CREATE TABLE `user_documents` (
  `doc_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `doc_type` enum('student_id','nid','bill','proof','medical','other') NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_size` int(11) DEFAULT NULL CHECK (`file_size` >= 0),
  `mime_type` varchar(100) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT 0,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_documents`
--

INSERT INTO `user_documents` (`doc_id`, `user_id`, `doc_type`, `file_path`, `file_name`, `file_size`, `mime_type`, `verified`, `uploaded_at`) VALUES
(1, 2, 'student_id', 'images/uploads/user_docs/user_2_student_id.jpg', 'user_2_student_id.jpg', 245678, 'image/jpeg', 1, '2026-01-15 02:45:00'),
(2, 3, 'student_id', 'images/uploads/user_docs/user_3_student_id.jpg', 'user_3_student_id.jpg', 267890, 'image/jpeg', 1, '2026-01-16 03:20:00'),
(3, 4, 'nid', 'images/uploads/user_docs/user_4_nid.pdf', 'user_4_nid.pdf', 512000, 'application/pdf', 1, '2026-01-17 04:35:00'),
(4, 5, 'student_id', 'images/uploads/user_docs/user_5_student_id.jpg', 'user_5_student_id.jpg', 298765, 'image/jpeg', 1, '2026-01-18 06:00:00'),
(5, 6, 'student_id', 'images/uploads/user_docs/user_6_student_id.jpg', 'user_6_student_id.jpg', 234567, 'image/jpeg', 0, '2026-01-19 07:25:00');

-- --------------------------------------------------------

--
-- Table structure for table `verification_documents`
--

CREATE TABLE `verification_documents` (
  `doc_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `doc_type` enum('student_id','nid','passport','other') DEFAULT 'student_id',
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_size` int(11) DEFAULT NULL CHECK (`file_size` >= 0),
  `mime_type` varchar(100) DEFAULT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `verification_documents`
--

INSERT INTO `verification_documents` (`doc_id`, `user_id`, `doc_type`, `file_path`, `file_name`, `file_size`, `mime_type`, `uploaded_at`) VALUES
(1, 7, 'student_id', 'images/uploads/verification/verification_7_1769451121.jpg', 'verification_7_1769451121.jpg', 1024946, 'image/jpeg', '2026-01-26 18:12:01');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_crowdfunding_posts`
-- (See below for the actual view)
--
CREATE TABLE `vw_crowdfunding_posts` (
`post_id` int(11)
,`creator_id` int(11)
,`category` varchar(50)
,`custom_category` varchar(100)
,`title` varchar(255)
,`summary` text
,`location` varchar(255)
,`num_people` int(11)
,`age_group` varchar(50)
,`amount_needed` decimal(10,2)
,`action_plan` text
,`share_receipts` enum('yes','no')
,`extra_funds_handling` text
,`status` enum('pending','approved','open','closed','funded','rejected')
,`approved_by` int(11)
,`approval_date` timestamp
,`created_at` timestamp
,`updated_at` timestamp
,`creator_name` varchar(100)
,`creator_email` varchar(100)
,`creator_verified` enum('pending','verified','rejected')
,`amount_raised` decimal(32,2)
,`is_fully_funded` int(1)
,`funding_percentage` decimal(38,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_fund_breakdown_items`
-- (See below for the actual view)
--
CREATE TABLE `vw_fund_breakdown_items` (
`breakdown_id` int(11)
,`post_id` int(11)
,`item_name` varchar(255)
,`quantity` int(11)
,`cost_per_unit` decimal(10,2)
,`total_cost` decimal(20,2)
,`created_at` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_loan_requests`
-- (See below for the actual view)
--
CREATE TABLE `vw_loan_requests` (
`loan_id` int(11)
,`borrower_id` int(11)
,`category` varchar(50)
,`custom_category` varchar(100)
,`amount` decimal(10,2)
,`duration_months` int(11)
,`custom_duration` varchar(50)
,`repayment_option` enum('installments','onetime')
,`reason` text
,`interest_rate` decimal(5,2)
,`status` enum('pending','approved','funded','active','repaid','defaulted','rejected')
,`approved_by` int(11)
,`approval_date` timestamp
,`created_at` timestamp
,`updated_at` timestamp
,`borrower_name` varchar(100)
,`borrower_email` varchar(100)
,`borrower_verified` enum('pending','verified','rejected')
,`amount_funded` decimal(32,2)
,`is_fully_funded` int(1)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_crowdfunding_posts`
--
DROP TABLE IF EXISTS `vw_crowdfunding_posts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_crowdfunding_posts`  AS SELECT `cp`.`post_id` AS `post_id`, `cp`.`creator_id` AS `creator_id`, `cp`.`category` AS `category`, `cp`.`custom_category` AS `custom_category`, `cp`.`title` AS `title`, `cp`.`summary` AS `summary`, `cp`.`location` AS `location`, `cp`.`num_people` AS `num_people`, `cp`.`age_group` AS `age_group`, `cp`.`amount_needed` AS `amount_needed`, `cp`.`action_plan` AS `action_plan`, `cp`.`share_receipts` AS `share_receipts`, `cp`.`extra_funds_handling` AS `extra_funds_handling`, `cp`.`status` AS `status`, `cp`.`approved_by` AS `approved_by`, `cp`.`approval_date` AS `approval_date`, `cp`.`created_at` AS `created_at`, `cp`.`updated_at` AS `updated_at`, `u`.`full_name` AS `creator_name`, `u`.`email` AS `creator_email`, `u`.`verification_status` AS `creator_verified`, coalesce(sum(`cc`.`amount`),0) AS `amount_raised`, CASE WHEN coalesce(sum(`cc`.`amount`),0) >= `cp`.`amount_needed` THEN 1 ELSE 0 END AS `is_fully_funded`, CASE WHEN `cp`.`amount_needed` > 0 THEN round(coalesce(sum(`cc`.`amount`),0) / `cp`.`amount_needed` * 100,2) ELSE 0 END AS `funding_percentage` FROM ((`crowdfunding_posts` `cp` join `users` `u` on(`cp`.`creator_id` = `u`.`user_id`)) left join `crowdfunding_contributions` `cc` on(`cp`.`post_id` = `cc`.`post_id` and `cc`.`payment_status` = 'completed')) GROUP BY `cp`.`post_id` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_fund_breakdown_items`
--
DROP TABLE IF EXISTS `vw_fund_breakdown_items`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_fund_breakdown_items`  AS SELECT `fund_breakdown_items`.`breakdown_id` AS `breakdown_id`, `fund_breakdown_items`.`post_id` AS `post_id`, `fund_breakdown_items`.`item_name` AS `item_name`, `fund_breakdown_items`.`quantity` AS `quantity`, `fund_breakdown_items`.`cost_per_unit` AS `cost_per_unit`, `fund_breakdown_items`.`quantity`* `fund_breakdown_items`.`cost_per_unit` AS `total_cost`, `fund_breakdown_items`.`created_at` AS `created_at` FROM `fund_breakdown_items` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_loan_requests`
--
DROP TABLE IF EXISTS `vw_loan_requests`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_loan_requests`  AS SELECT `lr`.`loan_id` AS `loan_id`, `lr`.`borrower_id` AS `borrower_id`, `lr`.`category` AS `category`, `lr`.`custom_category` AS `custom_category`, `lr`.`amount` AS `amount`, `lr`.`duration_months` AS `duration_months`, `lr`.`custom_duration` AS `custom_duration`, `lr`.`repayment_option` AS `repayment_option`, `lr`.`reason` AS `reason`, `lr`.`interest_rate` AS `interest_rate`, `lr`.`status` AS `status`, `lr`.`approved_by` AS `approved_by`, `lr`.`approval_date` AS `approval_date`, `lr`.`created_at` AS `created_at`, `lr`.`updated_at` AS `updated_at`, `u`.`full_name` AS `borrower_name`, `u`.`email` AS `borrower_email`, `u`.`verification_status` AS `borrower_verified`, coalesce(sum(`lc`.`amount`),0) AS `amount_funded`, CASE WHEN coalesce(sum(`lc`.`amount`),0) >= `lr`.`amount` THEN 1 ELSE 0 END AS `is_fully_funded` FROM ((`loan_requests` `lr` join `users` `u` on(`lr`.`borrower_id` = `u`.`user_id`)) left join `loan_contributions` `lc` on(`lr`.`loan_id` = `lc`.`loan_id` and `lc`.`payment_status` = 'completed')) GROUP BY `lr`.`loan_id` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `crowdfunding_contributions`
--
ALTER TABLE `crowdfunding_contributions`
  ADD PRIMARY KEY (`contrib_id`),
  ADD KEY `idx_contributor` (`contributor_id`),
  ADD KEY `idx_post` (`post_id`),
  ADD KEY `idx_status` (`payment_status`),
  ADD KEY `idx_contrib_date` (`contrib_date`);

--
-- Indexes for table `crowdfunding_documents`
--
ALTER TABLE `crowdfunding_documents`
  ADD PRIMARY KEY (`doc_id`),
  ADD KEY `idx_post` (`post_id`),
  ADD KEY `idx_doc_type` (`doc_type`),
  ADD KEY `idx_verified` (`verified`);

--
-- Indexes for table `crowdfunding_posts`
--
ALTER TABLE `crowdfunding_posts`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `idx_creator` (`creator_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_approved_by` (`approved_by`);

--
-- Indexes for table `crowdfunding_ratings`
--
ALTER TABLE `crowdfunding_ratings`
  ADD PRIMARY KEY (`rating_id`),
  ADD UNIQUE KEY `unique_post_rating` (`post_id`,`rater_id`),
  ADD KEY `idx_rater` (`rater_id`),
  ADD KEY `idx_ratee` (`ratee_id`),
  ADD KEY `idx_post` (`post_id`);

--
-- Indexes for table `funding_purposes`
--
ALTER TABLE `funding_purposes`
  ADD PRIMARY KEY (`purpose_id`),
  ADD KEY `idx_post` (`post_id`),
  ADD KEY `idx_purpose_type` (`purpose_type`);

--
-- Indexes for table `fund_breakdown_items`
--
ALTER TABLE `fund_breakdown_items`
  ADD PRIMARY KEY (`breakdown_id`),
  ADD UNIQUE KEY `unique_item_post` (`post_id`,`item_name`),
  ADD KEY `idx_post` (`post_id`);

--
-- Indexes for table `loan_contributions`
--
ALTER TABLE `loan_contributions`
  ADD PRIMARY KEY (`contrib_id`),
  ADD KEY `idx_contributor` (`contributor_id`),
  ADD KEY `idx_loan` (`loan_id`),
  ADD KEY `idx_status` (`payment_status`),
  ADD KEY `idx_contrib_date` (`contrib_date`);

--
-- Indexes for table `loan_documents`
--
ALTER TABLE `loan_documents`
  ADD PRIMARY KEY (`doc_id`),
  ADD KEY `idx_loan` (`loan_id`),
  ADD KEY `idx_doc_type` (`doc_type`),
  ADD KEY `idx_verified` (`verified`);

--
-- Indexes for table `loan_offers`
--
ALTER TABLE `loan_offers`
  ADD PRIMARY KEY (`offer_id`),
  ADD UNIQUE KEY `unique_lender_loan` (`loan_id`,`lender_id`),
  ADD KEY `idx_loan` (`loan_id`),
  ADD KEY `idx_lender` (`lender_id`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `loan_ratings`
--
ALTER TABLE `loan_ratings`
  ADD PRIMARY KEY (`rating_id`),
  ADD UNIQUE KEY `unique_loan_rating` (`loan_id`,`rater_id`),
  ADD KEY `idx_rater` (`rater_id`),
  ADD KEY `idx_ratee` (`ratee_id`),
  ADD KEY `idx_loan` (`loan_id`);

--
-- Indexes for table `loan_requests`
--
ALTER TABLE `loan_requests`
  ADD PRIMARY KEY (`loan_id`),
  ADD KEY `idx_borrower` (`borrower_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_approved_by` (`approved_by`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `loan_id` (`loan_id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_read` (`is_read`),
  ADD KEY `idx_created` (`created_at`),
  ADD KEY `idx_type` (`type`);

--
-- Indexes for table `repayments`
--
ALTER TABLE `repayments`
  ADD PRIMARY KEY (`repay_id`),
  ADD KEY `idx_loan` (`loan_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_due_date` (`due_date`),
  ADD KEY `idx_repay_date` (`repay_date`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_last_activity` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_verification` (`verification_status`),
  ADD KEY `idx_role` (`role`);

--
-- Indexes for table `user_documents`
--
ALTER TABLE `user_documents`
  ADD PRIMARY KEY (`doc_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_doc_type` (`doc_type`),
  ADD KEY `idx_verified` (`verified`);

--
-- Indexes for table `verification_documents`
--
ALTER TABLE `verification_documents`
  ADD PRIMARY KEY (`doc_id`),
  ADD KEY `idx_user_verification` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `crowdfunding_contributions`
--
ALTER TABLE `crowdfunding_contributions`
  MODIFY `contrib_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `crowdfunding_documents`
--
ALTER TABLE `crowdfunding_documents`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `crowdfunding_posts`
--
ALTER TABLE `crowdfunding_posts`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `crowdfunding_ratings`
--
ALTER TABLE `crowdfunding_ratings`
  MODIFY `rating_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `funding_purposes`
--
ALTER TABLE `funding_purposes`
  MODIFY `purpose_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `fund_breakdown_items`
--
ALTER TABLE `fund_breakdown_items`
  MODIFY `breakdown_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `loan_contributions`
--
ALTER TABLE `loan_contributions`
  MODIFY `contrib_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `loan_documents`
--
ALTER TABLE `loan_documents`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `loan_offers`
--
ALTER TABLE `loan_offers`
  MODIFY `offer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `loan_ratings`
--
ALTER TABLE `loan_ratings`
  MODIFY `rating_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `loan_requests`
--
ALTER TABLE `loan_requests`
  MODIFY `loan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `repayments`
--
ALTER TABLE `repayments`
  MODIFY `repay_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `user_documents`
--
ALTER TABLE `user_documents`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `verification_documents`
--
ALTER TABLE `verification_documents`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `crowdfunding_contributions`
--
ALTER TABLE `crowdfunding_contributions`
  ADD CONSTRAINT `crowdfunding_contributions_ibfk_1` FOREIGN KEY (`contributor_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `crowdfunding_contributions_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `crowdfunding_posts` (`post_id`) ON DELETE CASCADE;

--
-- Constraints for table `crowdfunding_documents`
--
ALTER TABLE `crowdfunding_documents`
  ADD CONSTRAINT `crowdfunding_documents_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `crowdfunding_posts` (`post_id`) ON DELETE CASCADE;

--
-- Constraints for table `crowdfunding_posts`
--
ALTER TABLE `crowdfunding_posts`
  ADD CONSTRAINT `crowdfunding_posts_ibfk_1` FOREIGN KEY (`creator_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `crowdfunding_posts_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `crowdfunding_ratings`
--
ALTER TABLE `crowdfunding_ratings`
  ADD CONSTRAINT `crowdfunding_ratings_ibfk_1` FOREIGN KEY (`rater_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `crowdfunding_ratings_ibfk_2` FOREIGN KEY (`ratee_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `crowdfunding_ratings_ibfk_3` FOREIGN KEY (`post_id`) REFERENCES `crowdfunding_posts` (`post_id`) ON DELETE CASCADE;

--
-- Constraints for table `funding_purposes`
--
ALTER TABLE `funding_purposes`
  ADD CONSTRAINT `funding_purposes_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `crowdfunding_posts` (`post_id`) ON DELETE CASCADE;

--
-- Constraints for table `fund_breakdown_items`
--
ALTER TABLE `fund_breakdown_items`
  ADD CONSTRAINT `fund_breakdown_items_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `crowdfunding_posts` (`post_id`) ON DELETE CASCADE;

--
-- Constraints for table `loan_contributions`
--
ALTER TABLE `loan_contributions`
  ADD CONSTRAINT `loan_contributions_ibfk_1` FOREIGN KEY (`contributor_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loan_contributions_ibfk_2` FOREIGN KEY (`loan_id`) REFERENCES `loan_requests` (`loan_id`) ON DELETE CASCADE;

--
-- Constraints for table `loan_documents`
--
ALTER TABLE `loan_documents`
  ADD CONSTRAINT `loan_documents_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `loan_requests` (`loan_id`) ON DELETE CASCADE;

--
-- Constraints for table `loan_offers`
--
ALTER TABLE `loan_offers`
  ADD CONSTRAINT `loan_offers_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `loan_requests` (`loan_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loan_offers_ibfk_2` FOREIGN KEY (`lender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `loan_ratings`
--
ALTER TABLE `loan_ratings`
  ADD CONSTRAINT `loan_ratings_ibfk_1` FOREIGN KEY (`rater_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loan_ratings_ibfk_2` FOREIGN KEY (`ratee_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loan_ratings_ibfk_3` FOREIGN KEY (`loan_id`) REFERENCES `loan_requests` (`loan_id`) ON DELETE CASCADE;

--
-- Constraints for table `loan_requests`
--
ALTER TABLE `loan_requests`
  ADD CONSTRAINT `loan_requests_ibfk_1` FOREIGN KEY (`borrower_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loan_requests_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`loan_id`) REFERENCES `loan_requests` (`loan_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `notifications_ibfk_3` FOREIGN KEY (`post_id`) REFERENCES `crowdfunding_posts` (`post_id`) ON DELETE SET NULL;

--
-- Constraints for table `repayments`
--
ALTER TABLE `repayments`
  ADD CONSTRAINT `repayments_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `loan_requests` (`loan_id`) ON DELETE CASCADE;

--
-- Constraints for table `sessions`
--
ALTER TABLE `sessions`
  ADD CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_documents`
--
ALTER TABLE `user_documents`
  ADD CONSTRAINT `user_documents_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `verification_documents`
--
ALTER TABLE `verification_documents`
  ADD CONSTRAINT `fk_verification_documents_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
