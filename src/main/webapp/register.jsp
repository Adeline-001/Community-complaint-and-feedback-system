<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Register | Citizen Voice</title>
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body style="display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 2rem;">
        <div class="glass-container" style="width: 100%; max-width: 500px;">
            <h2 style="margin-bottom: 2rem; text-align: center;">Join the Community</h2>
            
            <% if("exists".equals(request.getParameter("error"))) { %>
                <p style="color: var(--danger); text-align: center; margin-bottom: 1rem;">Email already registered or registration failed.</p>
            <% } %>

            <form action="auth" method="post">
                <input type="hidden" name="action" value="register">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" required>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone">
                </div>
                <div class="form-group">
                    <label>Address</label>
                    <textarea name="address" rows="3"></textarea>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%;">Create Account</button>
            </form>
            <p style="margin-top: 1.5rem; text-align: center; color: var(--text-gray);">
                Already have an account? <a href="login.jsp" style="color: var(--primary);">Sign in</a>
            </p>
        </div>
    </body>

    </html>