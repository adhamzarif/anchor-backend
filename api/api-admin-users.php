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
    // GET request - Fetch all users
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $query = "SELECT 
                    u.user_id,
                    u.username,
                    u.email,
                    u.full_name,
                    u.student_id,
                    u.university,
                    u.verification_status,
                    u.role,
                    u.created_at,
                    (SELECT COUNT(*) FROM loan_requests WHERE borrower_id = u.user_id) as loan_count,
                    (SELECT COUNT(*) FROM crowdfunding_posts WHERE creator_id = u.user_id) as funding_count
                  FROM users u
                  WHERE u.role != 'admin'
                  ORDER BY u.created_at DESC";

        $stmt = $conn->query($query);
        $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            'success' => true,
            'users' => $users,
            'total' => count($users)
        ]);
    }
    // DELETE request - Delete user account
    else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
        $input = json_decode(file_get_contents('php://input'), true);

        if (!isset($input['user_id'])) {
            echo json_encode([
                'success' => false,
                'error' => 'Missing user_id parameter'
            ]);
            exit;
        }

        $user_id = $input['user_id'];

        // Prevent deleting admin accounts
        $checkQuery = "SELECT role FROM users WHERE user_id = :user_id";
        $stmt = $conn->prepare($checkQuery);
        $stmt->execute([':user_id' => $user_id]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            echo json_encode([
                'success' => false,
                'error' => 'User not found'
            ]);
            exit;
        }

        if ($user['role'] === 'admin') {
            echo json_encode([
                'success' => false,
                'error' => 'Cannot delete admin accounts'
            ]);
            exit;
        }

        // Delete user - CASCADE will handle all related data
        // Thanks to foreign key constraints with ON DELETE CASCADE:
        // - loan_requests (borrower_id)
        // - crowdfunding_posts (creator_id)
        // - loan_offers (lender_id)
        // - crowdfunding_contributions (contributor_id)
        // - loan_documents (via loan_requests cascade)
        // - crowdfunding_documents (via crowdfunding_posts cascade)
        // - ratings (rater_id, rated_user_id)
        // - notifications (user_id)
        // - verification_documents (user_id)

        $deleteQuery = "DELETE FROM users WHERE user_id = :user_id";
        $stmt = $conn->prepare($deleteQuery);
        $stmt->execute([':user_id' => $user_id]);

        echo json_encode([
            'success' => true,
            'message' => 'User account and all associated data deleted successfully'
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'error' => 'Invalid request method'
        ]);
    }
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'error' => 'Database error: ' . $e->getMessage()
    ]);
}
