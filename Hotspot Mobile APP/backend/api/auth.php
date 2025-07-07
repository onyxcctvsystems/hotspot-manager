<?php
require_once '../config/database.php';

class AuthController {
    private $conn;
    private $table_users = 'users';
    private $table_organizations = 'organizations';

    public function __construct($db) {
        $this->conn = $db;
    }

    public function login() {
        $data = json_decode(file_get_contents("php://input"));

        if (!empty($data->email) && !empty($data->password)) {
            $query = "SELECT u.*, o.name as organization_name, o.business_type, o.subscription_plan 
                     FROM " . $this->table_users . " u 
                     JOIN " . $this->table_organizations . " o ON u.organization_id = o.id 
                     WHERE u.email = ? AND u.active = 1";
            
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(1, $data->email);
            $stmt->execute();

            if ($stmt->rowCount() > 0) {
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                
                if (password_verify($data->password, $row['password'])) {
                    $token = $this->generateJWT($row['id'], $row['organization_id']);
                    
                    $response = [
                        'success' => true,
                        'message' => 'Login successful',
                        'data' => [
                            'user' => [
                                'id' => $row['id'],
                                'email' => $row['email'],
                                'name' => $row['name'],
                                'organization_id' => $row['organization_id'],
                                'role' => $row['role']
                            ],
                            'organization' => [
                                'id' => $row['organization_id'],
                                'name' => $row['organization_name'],
                                'business_type' => $row['business_type'],
                                'subscription_plan' => $row['subscription_plan']
                            ],
                            'token' => $token
                        ]
                    ];
                } else {
                    $response = [
                        'success' => false,
                        'message' => 'Invalid credentials'
                    ];
                }
            } else {
                $response = [
                    'success' => false,
                    'message' => 'User not found or inactive'
                ];
            }
        } else {
            $response = [
                'success' => false,
                'message' => 'Email and password are required'
            ];
        }

        http_response_code($response['success'] ? 200 : 400);
        echo json_encode($response);
    }

    public function register() {
        $data = json_decode(file_get_contents("php://input"));

        if (!empty($data->email) && !empty($data->password) && !empty($data->name) && !empty($data->organization)) {
            // Check if email already exists
            $query = "SELECT id FROM " . $this->table_users . " WHERE email = ?";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(1, $data->email);
            $stmt->execute();

            if ($stmt->rowCount() > 0) {
                $response = [
                    'success' => false,
                    'message' => 'Email already exists'
                ];
            } else {
                try {
                    $this->conn->beginTransaction();

                    // Create organization
                    $org_query = "INSERT INTO " . $this->table_organizations . " 
                                 (name, business_type, address, phone, email, subscription_plan, created_at, updated_at) 
                                 VALUES (?, ?, ?, ?, ?, 'basic', NOW(), NOW())";
                    
                    $org_stmt = $this->conn->prepare($org_query);
                    $org_stmt->bindParam(1, $data->organization->name);
                    $org_stmt->bindParam(2, $data->organization->business_type);
                    $org_stmt->bindParam(3, $data->organization->address);
                    $org_stmt->bindParam(4, $data->organization->phone);
                    $org_stmt->bindParam(5, $data->organization->email);
                    $org_stmt->execute();

                    $organization_id = $this->conn->lastInsertId();

                    // Create user
                    $user_query = "INSERT INTO " . $this->table_users . " 
                                  (email, password, name, organization_id, role, active, created_at, updated_at) 
                                  VALUES (?, ?, ?, ?, 'admin', 1, NOW(), NOW())";
                    
                    $user_stmt = $this->conn->prepare($user_query);
                    $hashed_password = password_hash($data->password, PASSWORD_DEFAULT);
                    $user_stmt->bindParam(1, $data->email);
                    $user_stmt->bindParam(2, $hashed_password);
                    $user_stmt->bindParam(3, $data->name);
                    $user_stmt->bindParam(4, $organization_id);
                    $user_stmt->execute();

                    $user_id = $this->conn->lastInsertId();

                    $this->conn->commit();

                    $token = $this->generateJWT($user_id, $organization_id);

                    $response = [
                        'success' => true,
                        'message' => 'Registration successful',
                        'data' => [
                            'user' => [
                                'id' => $user_id,
                                'email' => $data->email,
                                'name' => $data->name,
                                'organization_id' => $organization_id,
                                'role' => 'admin'
                            ],
                            'organization' => [
                                'id' => $organization_id,
                                'name' => $data->organization->name,
                                'business_type' => $data->organization->business_type,
                                'subscription_plan' => 'basic'
                            ],
                            'token' => $token
                        ]
                    ];
                } catch (Exception $e) {
                    $this->conn->rollBack();
                    $response = [
                        'success' => false,
                        'message' => 'Registration failed: ' . $e->getMessage()
                    ];
                }
            }
        } else {
            $response = [
                'success' => false,
                'message' => 'All fields are required'
            ];
        }

        http_response_code($response['success'] ? 201 : 400);
        echo json_encode($response);
    }

    private function generateJWT($user_id, $organization_id) {
        $secret_key = "your_jwt_secret_key_here";
        $issuer_claim = "hotspot_manager";
        $audience_claim = "hotspot_users";
        $issuedat_claim = time();
        $notbefore_claim = $issuedat_claim;
        $expire_claim = $issuedat_claim + (24 * 60 * 60); // 24 hours

        $token = array(
            "iss" => $issuer_claim,
            "aud" => $audience_claim,
            "iat" => $issuedat_claim,
            "nbf" => $notbefore_claim,
            "exp" => $expire_claim,
            "data" => array(
                "user_id" => $user_id,
                "organization_id" => $organization_id
            )
        );

        return base64_encode(json_encode($token));
    }
}

// Handle the request
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$database = new Database();
$db = $database->getConnection();
$auth = new AuthController($db);

$request_method = $_SERVER["REQUEST_METHOD"];
$request_uri = $_SERVER['REQUEST_URI'];

if ($request_method == 'POST') {
    if (strpos($request_uri, '/login') !== false) {
        $auth->login();
    } elseif (strpos($request_uri, '/register') !== false) {
        $auth->register();
    }
} else {
    http_response_code(405);
    echo json_encode(array("message" => "Method not allowed"));
}
?>
