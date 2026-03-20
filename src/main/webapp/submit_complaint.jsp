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
                        <form action="complaint" method="post">
                            <input type="hidden" name="action" value="submit">
                            <div class="form-group">
                                <label>Category</label>
                                <select name="category" required>
                                    <option value="1">Leaking Pipeline</option>
                                    <option value="2">No Water Supply</option>
                                    <option value="3">Street Light Broken</option>
                                    <option value="4">Frequent Power Cut</option>
                                    <option value="5">Garbage Not Collected</option>
                                    <option value="6">Sewage Blockage</option>
                                    <option value="7">Pothole Repair Request</option>
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
                            <button type="submit" class="btn btn-primary" style="width: 100%;">Submit Complaint</button>
                        </form>
                    </div>
                </main>
            </body>

            </html>