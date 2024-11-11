<?php
session_start();

if(isset($_POST['login'])) {
    $username = $_POST['username'];
    $password = $_POST['password'];
    
    // Validasi input
    if(empty($username) || empty($password)) {
        $error = "Username dan password harus diisi!";
    } else {
        // Koneksi ke database
        $conn = mysqli_connect("localhost", "root", "", "manajemen_gula_aren");
        
        // Query check user dengan fungsi PASSWORD MySQL
        $query = "SELECT * FROM users WHERE username = ? AND password = PASSWORD(?)";
        $stmt = mysqli_prepare($conn, $query);
        mysqli_stmt_bind_param($stmt, "ss", $username, $password);
        mysqli_stmt_execute($stmt);
        $result = mysqli_stmt_get_result($stmt);
        
        if($user = mysqli_fetch_assoc($result)) {
            // Login berhasil
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['username'] = $user['username'];
            
            // Redirect ke dashboard
            header("Location: dashboard.php");
            exit();
        } else {
            $error = "Username atau password salah!";
        }
        
        mysqli_close($conn);
    }
}
?>

<!-- Form Login HTML -->
<form method="POST" action="">
    <?php if(isset($error)) echo "<div class='error'>$error</div>"; ?>
    
    <input type="text" name="username" placeholder="Username">
    <input type="password" name="password" placeholder="Password">
    <button type="submit" name="login">Login</button>
</form>
