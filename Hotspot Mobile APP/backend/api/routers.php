<?php
require_once '../config/database.php';

class RouterController {
    private $conn;
    private $table_name = 'routers';

    public function __construct($db) {
        $this->conn = $db;
    }

    public function getRouters($organization_id) {
        $query = "SELECT * FROM " . $this->table_name . " WHERE organization_id = ? ORDER BY created_at DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $organization_id);
        $stmt->execute();

        $routers = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $routers[] = $row;
        }

        return [
            'success' => true,
            'data' => $routers
        ];
    }

    public function addRouter($data, $organization_id) {
        $query = "INSERT INTO " . $this->table_name . " 
                 (name, ip_address, username, password, port, organization_id, location, created_at, updated_at) 
                 VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $data->name);
        $stmt->bindParam(2, $data->ip_address);
        $stmt->bindParam(3, $data->username);
        $stmt->bindParam(4, $data->password);
        $stmt->bindParam(5, $data->port);
        $stmt->bindParam(6, $organization_id);
        $stmt->bindParam(7, $data->location);

        if ($stmt->execute()) {
            $router_id = $this->conn->lastInsertId();
            
            // Test connection
            $connection_status = $this->testConnection($data);
            
            // Update status
            $update_query = "UPDATE " . $this->table_name . " SET status = ? WHERE id = ?";
            $update_stmt = $this->conn->prepare($update_query);
            $status = $connection_status ? 'active' : 'error';
            $update_stmt->bindParam(1, $status);
            $update_stmt->bindParam(2, $router_id);
            $update_stmt->execute();

            return [
                'success' => true,
                'message' => 'Router added successfully',
                'data' => [
                    'id' => $router_id,
                    'status' => $status
                ]
            ];
        } else {
            return [
                'success' => false,
                'message' => 'Failed to add router'
            ];
        }
    }

    public function testConnection($router_data) {
        // Simple socket test to check if the router API port is accessible
        $connection = @fsockopen($router_data->ip_address, $router_data->port, $errno, $errstr, 5);
        
        if ($connection) {
            fclose($connection);
            return true;
        }
        
        return false;
    }

    public function updateRouter($id, $data, $organization_id) {
        $query = "UPDATE " . $this->table_name . " 
                 SET name=?, ip_address=?, username=?, password=?, port=?, location=?, updated_at=NOW() 
                 WHERE id=? AND organization_id=?";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $data->name);
        $stmt->bindParam(2, $data->ip_address);
        $stmt->bindParam(3, $data->username);
        $stmt->bindParam(4, $data->password);
        $stmt->bindParam(5, $data->port);
        $stmt->bindParam(6, $data->location);
        $stmt->bindParam(7, $id);
        $stmt->bindParam(8, $organization_id);

        if ($stmt->execute()) {
            return [
                'success' => true,
                'message' => 'Router updated successfully'
            ];
        } else {
            return [
                'success' => false,
                'message' => 'Failed to update router'
            ];
        }
    }

    public function deleteRouter($id, $organization_id) {
        $query = "DELETE FROM " . $this->table_name . " WHERE id = ? AND organization_id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $id);
        $stmt->bindParam(2, $organization_id);

        if ($stmt->execute()) {
            return [
                'success' => true,
                'message' => 'Router deleted successfully'
            ];
        } else {
            return [
                'success' => false,
                'message' => 'Failed to delete router'
            ];
        }
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
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$database = new Database();
$db = $database->getConnection();
$router = new RouterController($db);

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

switch ($request_method) {
    case 'GET':
        $response = $router->getRouters($organization_id);
        break;
        
    case 'POST':
        $data = json_decode(file_get_contents("php://input"));
        $response = $router->addRouter($data, $organization_id);
        break;
        
    case 'PUT':
        parse_str($_SERVER['QUERY_STRING'], $query_vars);
        $id = $query_vars['id'] ?? null;
        if ($id) {
            $data = json_decode(file_get_contents("php://input"));
            $response = $router->updateRouter($id, $data, $organization_id);
        } else {
            $response = ['success' => false, 'message' => 'Router ID required'];
        }
        break;
        
    case 'DELETE':
        parse_str($_SERVER['QUERY_STRING'], $query_vars);
        $id = $query_vars['id'] ?? null;
        if ($id) {
            $response = $router->deleteRouter($id, $organization_id);
        } else {
            $response = ['success' => false, 'message' => 'Router ID required'];
        }
        break;
        
    default:
        $response = ['success' => false, 'message' => 'Method not allowed'];
        http_response_code(405);
        break;
}

echo json_encode($response);
?>
