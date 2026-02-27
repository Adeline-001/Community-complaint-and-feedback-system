<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | Citizen Voice</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body style="display: flex; justify-content: center; align-items: center; min-height: 100vh;">
    <div class="glass-container" style="width: 100%; max-width: 400px;">
        <h2 style="margin-bottom: 2rem; text-align: center;">Welcome Back</h2>
        
        <% if("invalid".equals(request.getParameter("error"))) { %>
            <p style="color: var(--danger); text-align: center; margin-bottom: 1rem;">Invalid email or password.</p>
        <% } %>

        <form action="auth" method="post">
            <input type="hidden" name="action" value="login">
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <div class="form-group">
                <label>Login As</label>
                <select name="role">
                    <option value="user">Citizen</option>
                    <option value="admin">Authority (Admin)</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary" style="width: 100%;">Sign In</button>
        </form>
        <p style="margin-top: 1.5rem; text-align: center; color: var(--text-gray);">
            New here? <a href="register.jsp" style="color: var(--primary);">Create an account</a>
        </p>
    </div>
</body>
</html>
