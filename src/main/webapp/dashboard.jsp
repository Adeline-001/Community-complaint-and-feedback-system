<%@ page import="com.example.model.User" %>
<%@ page import="com.example.dao.ComplaintDAO" %>
<%@ page import="com.example.model.Complaint" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    User user = (User) session.getAttribute("user"); 
    if (user == null) {
        response.sendRedirect("login.jsp"); 
        return; 
    } 
    ComplaintDAO dao = new ComplaintDAO();
    List<Complaint> complaints = dao.getComplaintsByUser(user.getId());
    
    int total = complaints.size();
    int pending = 0;
    int inProgress = 0;
    int resolved = 0;
    
    for(Complaint c : complaints) {
        String status = c.getStatus() != null ? c.getStatus() : "";
        if(status.equalsIgnoreCase("Pending")) pending++;
        else if(status.equalsIgnoreCase("In Progress")) inProgress++;
        else if(status.equalsIgnoreCase("Resolved")) resolved++;
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Citizen Dashboard | Citizen Voice</title>
    <!-- Anti-cache query parameter to ensure latest CSS -->
    <link rel="stylesheet" href="css/style.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>
    <!-- Animated background -->
    <div class="bg-animation">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        <div class="blob blob-3"></div>
    </div>

    <nav class="navbar">
        <div class="logo"><i class="fa-solid fa-bullhorn"></i> Citizen Voice <span style="font-size: 0.8rem; vertical-align: middle; opacity: 0.7;">USER</span></div>
        <div class="nav-links">
            <span style="color: white; margin-right: 1.5rem;"><i class="fa-solid fa-user"></i> <%= user.getName() %></span>
            <a href="dashboard.jsp" class="active"><i class="fa-solid fa-chart-pie"></i> Dashboard</a>
            <a href="submit_complaint.jsp"><i class="fa-solid fa-pen-to-square"></i> New Complaint</a>
            <a href="auth" class="btn btn-primary"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <main class="dashboard-main">
        <!-- New Incredible Hero Section -->
        <section class="hero-section animate-up">
            <img src="img/hero.png" alt="Community Hero" class="hero-bg">
            <div class="hero-overlay" style="background: linear-gradient(90deg, rgba(16, 185, 129, 0.9) 0%, rgba(15, 23, 42, 0.6) 60%);"></div>
            <div class="hero-content">
                <span class="hero-badge" style="background: rgba(255,255,255,0.2); color: white; border-color: rgba(255,255,255,0.3);"><i class="fa-solid fa-user-check"></i> Citizen Engagement Portal</span>
                <h1 style="background: none; -webkit-text-fill-color: initial; color: white; text-shadow: 0 2px 10px rgba(0,0,0,0.3);">My Dashboard</h1>
                <p style="color: rgba(255,255,255,0.9);">Track your submitted complaints, view community feedback, and help us build a better environment.</p>
            </div>
        </section>

        <!-- Stats Grid matching Admin Style -->
        <section class="stats-grid animate-up delay-1">
            <div class="stat-card glass-container" style="flex: 1; min-width: 200px;">
                <div class="stat-icon" style="background: rgba(99, 102, 241, 0.2); color: #6366f1;">
                    <i class="fa-solid fa-folder-open"></i>
                </div>
                <div class="stat-info">
                    <h3><%= total %></h3>
                    <p>Total Submissions</p>
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
            <% String msg = request.getParameter("msg"); 
               if("success".equals(msg)) { %>
                <div style="background: rgba(16, 185, 129, 0.2); color: #6ee7b7; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; border: 1px solid rgba(16, 185, 129, 0.4); display: flex; align-items: center; gap: 0.5rem;">
                    <i class="fa-solid fa-circle-check"></i> Your complaint was saved successfully!
                </div>
            <% } else if("updated".equals(msg)) { %>
                <div style="background: rgba(59, 130, 246, 0.2); color: #93c5fd; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; border: 1px solid rgba(59, 130, 246, 0.4); display: flex; align-items: center; gap: 0.5rem;">
                    <i class="fa-solid fa-pen-to-square"></i> Your complaint was updated successfully.
                </div>
            <% } else if("deleted".equals(msg)) { %>
                <div style="background: rgba(239, 68, 68, 0.2); color: #fca5a5; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; border: 1px solid rgba(239, 68, 68, 0.4); display: flex; align-items: center; gap: 0.5rem;">
                    <i class="fa-solid fa-trash"></i> Complaint deleted successfully.
                </div>
            <% } %>

            <!-- Floating control panel for actions -->
            <div class="search-panel">
                <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
                    <div style="display: flex; align-items: center; gap: 0.8rem;">
                        <i class="fa-solid fa-list-check" style="font-size: 1.2rem; color: var(--primary);"></i>
                        <h3 style="margin: 0; font-size: 1.2rem;">My Recent Activity</h3>
                    </div>
                    <a href="submit_complaint.jsp" class="btn btn-primary" style="padding: 0.6rem 1.5rem; font-size: 0.95rem; border-radius: 100px;">
                        <i class="fa-solid fa-plus"></i> File New Complaint
                    </a>
                </div>
            </div>

            <div class="glass-container table-wrapper">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Subject</th>
                                <th>Category</th>
                                <th>Status</th>
                                <th>Date Submitted</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Complaint c : complaints) { %>
                                <tr class="table-row">
                                    <td><strong>#<%= c.getId() %></strong></td>
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
                                        <% if(c.getResolutionNotes() != null && !c.getResolutionNotes().isEmpty()) { %>
                                            <div class="resolution-note" style="margin-top: 0.5rem; font-size: 0.8rem; color: var(--text-gray); border-top: 1px solid rgba(255,255,255,0.1); padding-top: 0.3rem;">
                                                <strong>Admin:</strong> <%= c.getResolutionNotes() %>
                                            </div>
                                        <% } %>
                                    </td>
                                    <td style="color: var(--text-gray); font-size: 0.9rem;"><%= c.getCreatedAt() %></td>
                                    <td>
                                        <div class="action-group" style="gap: 1rem;">
                                            <% if ("Pending".equalsIgnoreCase(c.getStatus())) { %>
                                                <a href="edit_complaint.jsp?id=<%= c.getId() %>" class="btn-update" style="text-decoration: none; padding: 0.4rem 0.8rem; display: inline-flex; align-items: center; gap: 0.3rem;">
                                                    <i class="fa-regular fa-pen-to-square"></i> Edit
                                                </a>
                                                <a href="javascript:void(0);" style="color: var(--danger); font-size: 1.1rem; transition: transform 0.2s; display: inline-flex;" title="Delete" onclick="confirmDelete('<%= c.getId() %>')">
                                                    <i class="fa-regular fa-trash-can"></i>
                                                </a>
                                            <% } else { %>
                                                <span style="color: var(--text-gray); font-style: italic; font-size: 0.85rem;">Read only</span>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                            <% } if(complaints.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="empty-state">
                                        <i class="fa-solid fa-folder-open fa-3x"></i>
                                        <p>You haven't submitted any complaints yet.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>

    <footer class="footer">
        <p>&copy; 2024 Citizen Voice. Empowering communities through transparency.</p>
        <div class="footer-links">
            <span><i class="fa-solid fa-code"></i> Built with Java Servlets & JSP</span>
            <span><i class="fa-solid fa-database"></i> Secured with MySQL</span>
            <span><i class="fa-solid fa-lock"></i> BCrypt Encrypted</span>
        </div>
    </footer>
    <script>
        function confirmDelete(complaintId) {
            Swal.fire({
                title: 'Delete Complaint?',
                text: "This action cannot be undone!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ef4444',
                cancelButtonColor: '#475569',
                confirmButtonText: '<i class="fa-solid fa-trash"></i> Yes, delete it',
                background: 'rgba(30, 41, 59, 0.95)',
                color: '#f8fafc',
                backdrop: `rgba(0,0,0,0.6)`
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = `complaint?action=delete&id=${complaintId}`;
                }
            })
        }
    </script>
</body>

</html>