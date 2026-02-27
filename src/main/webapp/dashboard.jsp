<%@ page import="com.example.model.User" %>
    <%@ page import="com.example.dao.ComplaintDAO" %>
        <%@ page import="com.example.model.Complaint" %>
            <%@ page import="java.util.List" %>
                <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                    <% User user=(User) session.getAttribute("user"); if (user==null) {
                        response.sendRedirect("login.jsp"); return; } ComplaintDAO dao=new ComplaintDAO();
                        List<Complaint> complaints = dao.getComplaintsByUser(user.getId());
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <title>Dashboard | Citizen Voice</title>
                            <link rel="stylesheet" href="css/style.css">
                        </head>

                        <body>
                            <nav class="navbar">
                                <div class="logo">Citizen Voice</div>
                                <div class="nav-links">
                                    <span style="color: white; margin-right: 1rem;">Welcome, <%= user.getName() %>
                                            </span>
                                    <a href="dashboard.jsp">Dashboard</a>
                                    <a href="submit_complaint.jsp">New Complaint</a>
                                    <a href="auth" class="btn btn-primary">Logout</a>
                                </div>
                            </nav>

                            <main style="padding: 3rem 5%;">
                                <div
                                    style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                                    <h2>Your Complaints</h2>
                                    <a href="submit_complaint.jsp" class="btn btn-primary">+ File New Complaint</a>
                                </div>

                                <div class="glass-container">
                                    <div class="table-container">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Subject</th>
                                                    <th>Category</th>
                                                    <th>Status</th>
                                                    <th>Date Submitted</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for(Complaint c : complaints) { %>
                                                    <tr>
                                                        <td>#<%= c.getId() %>
                                                        </td>
                                                        <td>
                                                            <%= c.getSubject() %>
                                                        </td>
                                                        <td>
                                                            <%= c.getCategoryName() %>
                                                        </td>
                                                        <td>
                                                            <span
                                                                class="status-badge status-<%= c.getStatus().toLowerCase().replace(" ", "") %>">
                                                                <%= c.getStatus() %>
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <%= c.getCreatedAt() %>
                                                        </td>
                                                    </tr>
                                                    <% } if(complaints.isEmpty()) { %>
                                                        <tr>
                                                            <td colspan="5"
                                                                style="text-align: center; color: var(--text-gray);">No
                                                                complaints found.</td>
                                                        </tr>
                                                        <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </main>
                        </body>

                        </html>