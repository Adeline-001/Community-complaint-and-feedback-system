<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | Citizen Voice</title>
    <link rel="stylesheet" href="css/style.css?v=1.1">
</head>
<body style="display: flex; justify-content: center; align-items: center; min-height: 100vh;">
    <div class="glass-container" style="width: 100%; max-width: 400px;">
        <h2 style="margin-bottom: 2rem; text-align: center;">Welcome Back</h2>
        
        <% if("invalid".equals(request.getParameter("error"))) { %>
            <p style="color: var(--danger); text-align: center; margin-bottom: 1rem;">Invalid email or password.</p>
        <% } %>

        <% 
            Object msgObj = session.getAttribute("msg");
            String msg = (msgObj != null) ? msgObj.toString() : request.getParameter("msg");
            if (msg == null) msg = request.getParameter("success");
            
            if("registered".equals(msg)) { 
                session.removeAttribute("msg");
        %>
            <div style="background: rgba(16, 185, 129, 0.1); border: 1px solid var(--accent); border-radius: 12px; padding: 1rem; margin-bottom: 2rem;">
                <p style="color: var(--accent); text-align: center; margin-bottom: 0; font-weight: 600;">Account created successfully! Please sign in.</p>
            </div>
        <% } %>

        <form action="auth" method="post">
            <input type="hidden" name="action" value="login">
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <div style="position: relative;">
                    <input type="password" name="password" id="password" required style="padding-right: 40px;">
                    <span id="togglePassword" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); cursor: pointer; font-size: 1.2rem; filter: grayscale(1);">
                        👁️
                    </span>
                </div>
            </div>
            <div class="form-group" style="margin-top: 1.5rem; background: rgba(255,255,255,0.05); padding: 1rem; border-radius: 8px; border: 1px solid rgba(255,255,255,0.1);">
                <label style="color: var(--accent); font-weight: 700; display: block; margin-bottom: 0.5rem;">SIGNING IN AS:</label>
                <select name="role" style="background: var(--bg-dark); color: white; border-color: var(--accent); cursor: pointer;">
                    <option value="user">🏠 Citizen / User</option>
                    <option value="admin">🛡️ Authority (Admin)</option>
                </select>
                <p style="font-size: 0.75rem; color: var(--text-gray); margin-top: 0.5rem; line-height: 1.2;">
                    *Citizens report issues. Admins manage them.
                </p>
            </div>
            <button type="submit" class="btn btn-primary" style="width: 100%;">Sign In</button>
        </form>
        <p style="margin-top: 1.5rem; text-align: center; color: var(--text-gray);">
            New here? <a href="register.jsp" style="color: var(--primary);">Create an account</a>
        </p>
    </div>
    <script>
        const togglePassword = document.querySelector('#togglePassword');
        const password = document.querySelector('#password');

        togglePassword.addEventListener('click', function (e) {
            // toggle the type attribute
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);
            // toggle the eye slash icon
            this.textContent = type === 'password' ? '👁️' : '🙈';
        });
    </script>
</body>
</html>
