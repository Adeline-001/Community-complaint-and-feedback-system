<%@ page import="com.example.model.Admin" %>
    <%@ page import="com.example.dao.ComplaintDAO" %>
        <%@ page import="com.example.model.Complaint" %>
            <%@ page import="java.util.List" %>
                <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                    <% Admin admin=(Admin) session.getAttribute("admin"); if (admin==null) {
                        response.sendRedirect("login.jsp"); return; } ComplaintDAO dao=new ComplaintDAO();
                        List<Complaint> complaints = dao.getAllComplaints();
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <title>Admin Dashboard | Citizen Voice</title>
                            <link rel="stylesheet" href="css/style.css">
                        </head>

                        <body>
                            <nav class="navbar">
                                <div class="logo">Citizen Voice <span
                                        style="font-size: 0.8rem; vertical-align: middle; opacity: 0.7;">ADMIN</span>
                                </div>
                                <div class="nav-links">
                                    <span style="color: white; margin-right: 1rem;">Admin: <%= admin.getName() %></span>
                                    <a href="admin_dashboard.jsp">Dashboard</a>
                                    <a href="auth" class="btn btn-primary">Logout</a>
                                </div>
                            </nav>

                            <main style="padding: 3rem 5%;">
                                <h2 style="margin-bottom: 2rem;">All Community Complaints</h2>

                                <div class="glass-container">
                                    <div class="table-container">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Citizen</th>
                                                    <th>Subject</th>
                                                    <th>Category</th>
                                                    <th>Status</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for(Complaint c : complaints) { %>
                                                    <tr>
                                                        <td>#<%= c.getId() %>
                                                        </td>
                                                        <td>
                                                            <%= c.getUserName() %>
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
                                                            <form action="admin" method="post"
                                                                style="display: flex; gap: 0.5rem;">
                                                                <input type="hidden" name="action" value="updateStatus">
                                                                <input type="hidden" name="id" value="<%= c.getId() %>">
                                                                <select name="status"
                                                                    style="padding: 0.2rem; font-size: 0.8rem; width: auto;">
                                                                    <option value="Pending" <%="Pending"
                                                                        .equals(c.getStatus()) ? "selected" : "" %>
                                                                        >Pending</option>
                                                                    <option value="In Progress" <%="In Progress"
                                                                        .equals(c.getStatus()) ? "selected" : "" %>>In
                                                                        Progress</option>
                                                                    <option value="Resolved" <%="Resolved"
                                                                        .equals(c.getStatus()) ? "selected" : "" %>
                                                                        >Resolved</option>
                                                                    <option value="Rejected" <%="Rejected"
                                                                        .equals(c.getStatus()) ? "selected" : "" %>
                                                                        >Rejected</option>
                                                                </select>
                                                                <button type="submit" class="btn btn-primary"
                                                                    style="padding: 0.2rem 0.5rem; font-size: 0.8rem;">Update</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                    <% } if(complaints.isEmpty()) { %>
                                                        <tr>
                                                            <td colspan="6"
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