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
$data = json_decode(file_get_contents('php://input'), true);
$offer_id = $data['offer_id'] ?? null;

if (!$offer_id) {
    echo json_encode(['success' => false, 'error' => 'Offer ID required']);
    exit();
}

try {
    $conn->beginTransaction();

    // Get offer details and verify ownership
    $offer_stmt = $conn->prepare("
        SELECT lo.*, lr.borrower_id, lr.amount as loan_amount
        FROM loan_offers lo
        JOIN loan_requests lr ON lo.loan_id = lr.loan_id
        WHERE lo.offer_id = ?
    ");
    $offer_stmt->execute([$offer_id]);
    $offer = $offer_stmt->fetch(PDO::FETCH_ASSOC);

    if (!$offer) {
        $conn->rollBack();
        echo json_encode(['success' => false, 'error' => 'Offer not found']);
        exit();
    }

    if ($offer['borrower_id'] != $user_id) {
        $conn->rollBack();
        echo json_encode(['success' => false, 'error' => 'Unauthorized access']);
        exit();
    }

    if ($offer['status'] !== 'pending') {
        $conn->rollBack();
        echo json_encode(['success' => false, 'error' => 'Offer is no longer available']);
        exit();
    }

    // Accept this offer
    $accept_stmt = $conn->prepare("
        UPDATE loan_offers 
        SET status = 'accepted', updated_at = NOW() 
        WHERE offer_id = ?
    ");
    $accept_stmt->execute([$offer_id]);

    // Reject all other offers for this loan
    $reject_stmt = $conn->prepare("
        UPDATE loan_offers 
        SET status = 'rejected', updated_at = NOW() 
        WHERE loan_id = ? AND offer_id != ? AND status = 'pending'
    ");
    $reject_stmt->execute([$offer['loan_id'], $offer_id]);

    // Create notification for the lender
    $notification_stmt = $conn->prepare("
        INSERT INTO notifications (user_id, type, title, message, loan_id, created_at)
        VALUES (?, 'loan_accepted', 'Offer Accepted!', ?, ?, NOW())
    ");
    $message = "Your loan offer of ৳" . number_format($offer['amount'], 2) . " has been accepted. Please proceed to payment.";
    $notification_stmt->execute([$offer['lender_id'], $message, $offer['loan_id']]);

    $conn->commit();

    echo json_encode([
        'success' => true,
        'message' => 'Offer accepted successfully',
        'offer' => $offer
    ]);

} catch (PDOException $e) {
    $conn->rollBack();
    echo json_encode(['success' => false, 'error' => 'Database error: ' . $e->getMessage()]);
}
?>
