<?php
session_start();
require_once '../php/db_conn.php';

header('Content-Type: application/json');

// Check if admin is logged in
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
    echo json_encode([
        'success' => false,
        'error' => 'Unauthorized access'
    ]);
    exit;
}

try {
    // GET request - Fetch all verification requests
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $query = "SELECT 
                    u.user_id,
                    u.username,
                    u.email,
                    u.full_name,
                    u.student_id,
                    u.university,
                    u.verification_status,
                    vd.file_path,
                    vd.file_name,
                    vd.uploaded_at
                  FROM users u
                  LEFT JOIN verification_documents vd ON u.user_id = vd.user_id
                  WHERE vd.doc_id IS NOT NULL
                  ORDER BY 
                    CASE u.verification_status
                        WHEN 'pending' THEN 1
                        WHEN 'verified' THEN 2
                        WHEN 'rejected' THEN 3
                    END,
                    vd.uploaded_at DESC";

        $stmt = $conn->query($query);
        $requests = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Get stats
        $statsQuery = "SELECT 
                        COUNT(CASE WHEN verification_status = 'pending' THEN 1 END) as pending,
                        COUNT(CASE WHEN verification_status = 'verified' THEN 1 END) as verified,
                        COUNT(CASE WHEN verification_status = 'rejected' THEN 1 END) as rejected
                       FROM users
                       WHERE user_id IN (SELECT user_id FROM verification_documents)";

        $statsStmt = $conn->query($statsQuery);
        $stats = $statsStmt->fetch(PDO::FETCH_ASSOC);

        echo json_encode([
            'success' => true,
            'requests' => $requests,
            'stats' => $stats
        ]);
    }
    // POST request - Approve or Reject verification
    else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = json_decode(file_get_contents('php://input'), true);

        if (!isset($input['action']) || !isset($input['user_id'])) {
            echo json_encode([
                'success' => false,
                'error' => 'Missing required parameters'
            ]);
            exit;
        }

        $action = $input['action'];
        $user_id = $input['user_id'];

        if ($action === 'approve') {
            $status = 'verified';
        } else if ($action === 'reject') {
            $status = 'rejected';
        } else {
            echo json_encode([
                'success' => false,
                'error' => 'Invalid action'
            ]);
            exit;
        }

        // Update user verification status
        $updateQuery = "UPDATE users 
                       SET verification_status = :status 
                       WHERE user_id = :user_id";

        $stmt = $conn->prepare($updateQuery);
        $stmt->execute([
            ':status' => $status,
            ':user_id' => $user_id
        ]);

        // Create notification for the user
        $message = $status === 'verified'
            ? 'Your verification request has been approved! You are now a verified user.'
            : 'Your verification request has been rejected. Please contact support for more information.';

        $notifQuery = "INSERT INTO notifications (user_id, message, type, created_at) 
                      VALUES (:user_id, :message, 'verification', NOW())";

        $stmt = $conn->prepare($notifQuery);
        $stmt->execute([
            ':user_id' => $user_id,
            ':message' => $message
        ]);

        echo json_encode([
            'success' => true,
            'message' => 'Verification ' . $action . 'd successfully'
        ]);
    }
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'error' => 'Database error: ' . $e->getMessage()
    ]);
}
