<%@ page import="com.example.model.User" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <% User user=(User) session.getAttribute("user"); if (user==null) { response.sendRedirect("login.jsp"); return;
            } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Submit Complaint | Citizen Voice</title>
                <link rel="stylesheet" href="css/style.css?v=1.1">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>
                <nav class="navbar">
                    <div class="logo">Citizen Voice</div>
                    <div class="nav-links">
                        <a href="dashboard.jsp">Dashboard</a>
                        <a href="auth" class="btn btn-primary">Logout</a>
                    </div>
                </nav>

                <main style="padding: 3rem 5%; display: flex; justify-content: center;">
                 <div class="glass-container" style="width: 100%; max-width: 600px;">
                     <h2 style="margin-bottom: 2rem;">File a Complaint</h2>
                     <% String error = request.getParameter("error"); if("failed".equals(error)) { %>
                         <div style="background: rgba(239, 68, 68, 0.2); color: #fca5a5; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; border: 1px solid rgba(239, 68, 68, 0.4);">
                             <i class="fa-solid fa-circle-exclamation"></i> Failed to submit complaint. Please ensure all categories and fields are valid.
                         </div>
                     <% } %>
                     <form action="complaint" method="post" id="complaintForm" onsubmit="return showLoadingState();">
                         <input type="hidden" name="action" value="submit">
                         <div class="form-group">
                             <label>Category</label>
                             <select name="category" required>
                                 <option value="1">Electricity</option>
                                 <option value="2">Water Supply</option>
                                 <option value="3">Roads</option>
                                 <option value="4">Sanitation</option>
                                 <option value="5">Other</option>
                             </select>
                         </div>
                            <div class="form-group">
                                <label>Subject</label>
                                <input type="text" name="subject" placeholder="Brief summary of the issue" required>
                            </div>
                            <div class="form-group">
                                <label>Detailed Description</label>
                                <textarea name="description" rows="5" required></textarea>
                            </div>
                            <button type="submit" id="submitBtn" class="btn btn-primary" style="width: 100%;">Submit Complaint</button>
                        </form>
                    </div>
                </main>
                <script>
                    function showLoadingState() {
                        const btn = document.getElementById('submitBtn');
                        btn.disabled = true;
                        btn.style.opacity = '0.7';
                        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Processing...';
                        return true; 
                    }
                </script>
            </body>

            </html>