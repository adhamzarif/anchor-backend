<?php
session_start();
header('Content-Type: application/json');
include '../php/db_conn.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['success' => false, 'error' => 'Not logged in']);
    exit();
}

$user_id = $_SESSION['user_id'];
$loan_id = $_GET['loan_id'] ?? null;

if (!$loan_id) {
    echo json_encode(['success' => false, 'error' => 'Loan ID required']);
    exit();
}

try {
    // First verify this loan belongs to the current user
    $verify_stmt = $conn->prepare("
        SELECT borrower_id, amount, status 
        FROM loan_requests 
        WHERE loan_id = ?
    ");
    $verify_stmt->execute([$loan_id]);
    $loan = $verify_stmt->fetch(PDO::FETCH_ASSOC);

    if (!$loan) {
        echo json_encode(['success' => false, 'error' => 'Loan not found']);
        exit();
    }

    if ($loan['borrower_id'] != $user_id) {
        echo json_encode(['success' => false, 'error' => 'Unauthorized access']);
        exit();
    }

    // Get all pending offers for this loan with lender details
    $offers_stmt = $conn->prepare("
        SELECT 
            lo.offer_id,
            lo.amount,
            lo.interest_rate,
            lo.terms,
            lo.status,
            lo.created_at,
            u.user_id as lender_id,
            u.full_name as lender_name,
            u.username as lender_username,
            u.verification_status,
            COALESCE(AVG(lr.score), 0) as lender_rating,
            COUNT(DISTINCT lr.rating_id) as rating_count
        FROM loan_offers lo
        JOIN users u ON lo.lender_id = u.user_id
        LEFT JOIN loan_ratings lr ON lr.ratee_id = u.user_id
        WHERE lo.loan_id = ? AND lo.status = 'pending'
        GROUP BY lo.offer_id, lo.amount, lo.interest_rate, lo.terms, lo.status, lo.created_at,
                 u.user_id, u.full_name, u.username, u.verification_status
        ORDER BY lo.created_at DESC
    ");
    $offers_stmt->execute([$loan_id]);
    $offers = $offers_stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'loan' => $loan,
        'offers' => $offers
    ]);

} catch (PDOException $e) {
    echo json_encode(['success' => false, 'error' => 'Database error: ' . $e->getMessage()]);
}
?>
