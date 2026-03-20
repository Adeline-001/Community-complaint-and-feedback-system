<%@ page import="com.example.model.Admin" %>
<%@ page import="com.example.dao.ComplaintDAO" %>
<%@ page import="com.example.model.Complaint" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    Admin admin = (Admin) session.getAttribute("admin"); 
    if (admin == null) {
        response.sendRedirect("login.jsp"); 
        return; 
    } 
    ComplaintDAO dao = new ComplaintDAO();
    List<Complaint> complaints = dao.getAllComplaints();
    
    int total = complaints.size();
    int pending = 0;
    int inProgress = 0;
    int resolved = 0;
    int rejected = 0;
    
    for(Complaint c : complaints) {
        String status = c.getStatus() != null ? c.getStatus() : "";
        if(status.equalsIgnoreCase("Pending")) pending++;
        else if(status.equalsIgnoreCase("In Progress")) inProgress++;
        else if(status.equalsIgnoreCase("Resolved")) resolved++;
        else if(status.equalsIgnoreCase("Rejected")) rejected++;
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Citizen Voice</title>
    <!-- CSS cache buster to guarantee the newest horizontal flex styles are loaded -->
    <link rel="stylesheet" href="css/style.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>
    <!-- Animated background -->
    <div class="bg-animation">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        <div class="blob blob-3"></div>
    </div>

    <nav class="navbar">
        <div class="logo"><i class="fa-solid fa-bullhorn"></i> Citizen Voice <span style="font-size: 0.8rem; vertical-align: middle; opacity: 0.7;">ADMIN</span></div>
        <div class="nav-links">
            <span style="color: white; margin-right: 1.5rem;"><i class="fa-solid fa-user-shield"></i> <%= admin.getName() %></span>
            <a href="admin_dashboard.jsp" class="active"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
            <a href="auth" class="btn btn-primary"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <main class="dashboard-main">
        <header class="dashboard-header animate-up">
            <h2><i class="fa-solid fa-gauge-high"></i> Platform Overview</h2>
            <p>Manage and track community complaints efficiently.</p>
        </header>

        <!-- Force horizontal layout directly inline to override any potential cache issues -->
        <section class="stats-grid animate-up delay-1" style="display: flex; flex-direction: row; flex-wrap: nowrap; overflow-x: auto; gap: 1.5rem; margin-bottom: 2.5rem; justify-content: space-between;">
            <div class="stat-card glass-container" style="flex: 1; min-width: 200px;">
                <div class="stat-icon" style="background: rgba(99, 102, 241, 0.2); color: #6366f1;">
                    <i class="fa-solid fa-folder-open"></i>
                </div>
                <div class="stat-info">
                    <h3><%= total %></h3>
                    <p>Total</p>
                </div>
            </div>
            <div class="stat-card glass-container" style="flex: 1; min-width: 200px;">
                <div class="stat-icon" style="background: rgba(234, 179, 8, 0.2); color: #eab308;">
                    <i class="fa-solid fa-clock"></i>
                </div>
                <div class="stat-info">
                    <h3><%= pending %></h3>
                    <p>Pending</p>
                </div>
            </div>
            <div class="stat-card glass-container" style="flex: 1; min-width: 200px;">
                <div class="stat-icon" style="background: rgba(59, 130, 246, 0.2); color: #3b82f6;">
                    <i class="fa-solid fa-spinner"></i>
                </div>
                <div class="stat-info">
                    <h3><%= inProgress %></h3>
                    <p>In Progress</p>
                </div>
            </div>
            <div class="stat-card glass-container" style="flex: 1; min-width: 200px;">
                <div class="stat-icon" style="background: rgba(16, 185, 129, 0.2); color: #10b981;">
                    <i class="fa-solid fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3><%= resolved %></h3>
                    <p>Resolved</p>
                </div>
            </div>
        </section>

        <section class="table-section animate-up delay-2">
            <div class="glass-container table-wrapper">
                <div class="table-header">
                    <h3><i class="fa-solid fa-list-check"></i> Recent Complaints</h3>
                </div>
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
                                <tr class="table-row">
                                    <td><strong>#<%= c.getId() %></strong></td>
                                    <td>
                                        <div class="user-cell">
                                            <div class="avatar"><i class="fa-solid fa-user"></i></div>
                                            <span><%= c.getUserName() %></span>
                                        </div>
                                    </td>
                                    <td><%= c.getSubject() %></td>
                                    <td><span class="category-pill"><%= c.getCategoryName() %></span></td>
                                    <td>
                                        <span class="status-badge status-<%= c.getStatus().toLowerCase().replace(" ", "") %>">
                                            <% if("Pending".equalsIgnoreCase(c.getStatus())) out.print("<i class='fa-solid fa-clock'></i> "); %>
                                            <% if("In Progress".equalsIgnoreCase(c.getStatus())) out.print("<i class='fa-solid fa-spinner fa-spin'></i> "); %>
                                            <% if("Resolved".equalsIgnoreCase(c.getStatus())) out.print("<i class='fa-solid fa-check'></i> "); %>
                                            <% if("Rejected".equalsIgnoreCase(c.getStatus())) out.print("<i class='fa-solid fa-xmark'></i> "); %>
                                            <%= c.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <form action="admin" method="post" class="action-form">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="id" value="<%= c.getId() %>">
                                            <div class="action-group">
                                                <select name="status" class="status-select">
                                                    <option value="Pending" <%="Pending".equals(c.getStatus()) ? "selected" : "" %>>Pending</option>
                                                    <option value="In Progress" <%="In Progress".equals(c.getStatus()) ? "selected" : "" %>>In Progress</option>
                                                    <option value="Resolved" <%="Resolved".equals(c.getStatus()) ? "selected" : "" %>>Resolved</option>
                                                    <option value="Rejected" <%="Rejected".equals(c.getStatus()) ? "selected" : "" %>>Rejected</option>
                                                </select>
                                                <button type="submit" class="btn btn-update" title="Update Status">
                                                    <i class="fa-solid fa-arrows-rotate"></i>
                                                </button>
                                            </div>
                                        </form>
                                    </td>
                                </tr>
                            <% } if(complaints.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="empty-state">
                                        <i class="fa-solid fa-inbox fa-3x"></i>
                                        <p>No complaints found.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>
</body>

</html>