<?php
require_once '../config/database.php';

class VoucherController {
    private $conn;
    private $table_vouchers = 'vouchers';
    private $table_packages = 'packages';

    public function __construct($db) {
        $this->conn = $db;
    }

    public function getVouchers($organization_id, $page = 1, $limit = 20) {
        $offset = ($page - 1) * $limit;
        
        $query = "SELECT v.*, p.name as package_name, p.price, p.duration, r.name as router_name 
                 FROM " . $this->table_vouchers . " v 
                 JOIN " . $this->table_packages . " p ON v.package_id = p.id 
                 JOIN routers r ON v.router_id = r.id 
                 WHERE v.organization_id = ? 
                 ORDER BY v.created_at DESC 
                 LIMIT ? OFFSET ?";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $organization_id, PDO::PARAM_INT);
        $stmt->bindParam(2, $limit, PDO::PARAM_INT);
        $stmt->bindParam(3, $offset, PDO::PARAM_INT);
        $stmt->execute();

        $vouchers = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $vouchers[] = $row;
        }

        return [
            'success' => true,
            'data' => $vouchers
        ];
    }

    public function generateVouchers($data, $organization_id) {
        if (!isset($data->package_id, $data->router_id, $data->quantity)) {
            return [
                'success' => false,
                'message' => 'Package ID, Router ID, and quantity are required'
            ];
        }

        // Verify package and router belong to organization
        $verify_query = "SELECT p.id as package_exists, r.id as router_exists 
                        FROM packages p, routers r 
                        WHERE p.id = ? AND p.organization_id = ? 
                        AND r.id = ? AND r.organization_id = ?";
        
        $verify_stmt = $this->conn->prepare($verify_query);
        $verify_stmt->bindParam(1, $data->package_id);
        $verify_stmt->bindParam(2, $organization_id);
        $verify_stmt->bindParam(3, $data->router_id);
        $verify_stmt->bindParam(4, $organization_id);
        $verify_stmt->execute();

        if ($verify_stmt->rowCount() == 0) {
            return [
                'success' => false,
                'message' => 'Invalid package or router'
            ];
        }

        $generated_vouchers = [];
        $prefix = $data->prefix ?? 'HSM';

        try {
            $this->conn->beginTransaction();

            for ($i = 0; $i < $data->quantity; $i++) {
                $username = $this->generateUsername($prefix);
                $password = $this->generatePassword();

                $insert_query = "INSERT INTO " . $this->table_vouchers . " 
                               (username, password, package_id, router_id, organization_id, created_at) 
                               VALUES (?, ?, ?, ?, ?, NOW())";

                $insert_stmt = $this->conn->prepare($insert_query);
                $insert_stmt->bindParam(1, $username);
                $insert_stmt->bindParam(2, $password);
                $insert_stmt->bindParam(3, $data->package_id);
                $insert_stmt->bindParam(4, $data->router_id);
                $insert_stmt->bindParam(5, $organization_id);
                $insert_stmt->execute();

                $generated_vouchers[] = [
                    'id' => $this->conn->lastInsertId(),
                    'username' => $username,
                    'password' => $password,
                    'package_id' => $data->package_id,
                    'router_id' => $data->router_id,
                    'status' => 'unused'
                ];
            }

            $this->conn->commit();

            return [
                'success' => true,
                'message' => $data->quantity . ' vouchers generated successfully',
                'data' => $generated_vouchers
            ];

        } catch (Exception $e) {
            $this->conn->rollBack();
            return [
                'success' => false,
                'message' => 'Failed to generate vouchers: ' . $e->getMessage()
            ];
        }
    }

    public function deleteVoucher($id, $organization_id) {
        $query = "DELETE FROM " . $this->table_vouchers . " WHERE id = ? AND organization_id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $id);
        $stmt->bindParam(2, $organization_id);

        if ($stmt->execute()) {
            return [
                'success' => true,
                'message' => 'Voucher deleted successfully'
            ];
        } else {
            return [
                'success' => false,
                'message' => 'Failed to delete voucher'
            ];
        }
    }

    private function generateUsername($prefix = 'HSM') {
        return $prefix . '-' . strtoupper(substr(md5(uniqid(mt_rand(), true)), 0, 6));
    }

    private function generatePassword($length = 8) {
        $characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $password = '';
        for ($i = 0; $i < $length; $i++) {
            $password .= $characters[rand(0, strlen($characters) - 1)];
        }
        return $password;
    }
}

// Helper function to get organization ID from JWT token
function getOrganizationFromToken($token) {
    $token = str_replace('Bearer ', '', $token);
    $decoded = json_decode(base64_decode($token), true);
    return $decoded['data']['organization_id'] ?? null;
}

// Handle the request
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$database = new Database();
$db = $database->getConnection();
$voucher = new VoucherController($db);

$request_method = $_SERVER["REQUEST_METHOD"];
$headers = getallheaders();
$auth_header = $headers['Authorization'] ?? '';

if (empty($auth_header)) {
    http_response_code(401);
    echo json_encode(['success' => false, 'message' => 'Authorization header required']);
    exit;
}

$organization_id = getOrganizationFromToken($auth_header);
if (!$organization_id) {
    http_response_code(401);
    echo json_encode(['success' => false, 'message' => 'Invalid token']);
    exit;
}

$request_uri = $_SERVER['REQUEST_URI'];

switch ($request_method) {
    case 'GET':
        $page = $_GET['page'] ?? 1;
        $limit = $_GET['limit'] ?? 20;
        $response = $voucher->getVouchers($organization_id, $page, $limit);
        break;
        
    case 'POST':
        if (strpos($request_uri, '/generate') !== false) {
            $data = json_decode(file_get_contents("php://input"));
            $response = $voucher->generateVouchers($data, $organization_id);
        } else {
            $response = ['success' => false, 'message' => 'Invalid endpoint'];
            http_response_code(404);
        }
        break;
        
    case 'DELETE':
        parse_str($_SERVER['QUERY_STRING'], $query_vars);
        $id = $query_vars['id'] ?? null;
        if ($id) {
            $response = $voucher->deleteVoucher($id, $organization_id);
        } else {
            $response = ['success' => false, 'message' => 'Voucher ID required'];
        }
        break;
        
    default:
        $response = ['success' => false, 'message' => 'Method not allowed'];
        http_response_code(405);
        break;
}

echo json_encode($response);
?>
