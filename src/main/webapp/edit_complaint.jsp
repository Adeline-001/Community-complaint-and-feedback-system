<%@ page import="com.example.model.User" %>
<%@ page import="com.example.model.Complaint" %>
<%@ page import="com.example.dao.ComplaintDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    User user = (User) session.getAttribute("user"); 
    if (user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    } 
    int id = Integer.parseInt(request.getParameter("id"));
    ComplaintDAO dao = new ComplaintDAO();
    Complaint complaint = dao.getComplaintById(id);
    if (complaint == null || complaint.getUserId() != user.getId() || !"Pending".equalsIgnoreCase(complaint.getStatus())) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Complaint | Citizen Voice</title>
    <link rel="stylesheet" href="css/style.css">
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
            <h2 style="margin-bottom: 2rem;">Edit Complaint #<%= complaint.getId() %></h2>
            <form action="complaint" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= complaint.getId() %>">
                <div class="form-group">
                    <label>Category</label>
                    <select name="category" required disabled>
                        <option value="<%= complaint.getCategoryId() %>" selected><%= complaint.getCategoryName() %></option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Subject</label>
                    <input type="text" name="subject" value="<%= complaint.getSubject() %>" required>
                </div>
                <div class="form-group">
                    <label>Detailed Description</label>
                    <textarea name="description" rows="5" required><%= complaint.getDescription() %></textarea>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%;">Update Complaint</button>
            </form>
        </div>
    </main>
</body>
</html>
