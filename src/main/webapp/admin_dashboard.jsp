<%@ page import="com.example.model.Admin" %>
<%@ page import="com.example.dao.ComplaintDAO" %>
<%@ page import="com.example.dao.UserDAO" %>
<%@ page import="com.example.model.Complaint" %>
<%@ page import="com.example.model.User" %>
<%@ page import="java.util.List" %>
<% 
    Admin admin = (Admin) session.getAttribute("admin"); 
    if (admin == null) {
        response.sendRedirect("login.jsp"); 
        return; 
    } 
    ComplaintDAO dao = new ComplaintDAO();
    UserDAO userDAO = new UserDAO();
    List<User> allUsers = userDAO.getAllUsers();
    
    String searchQuery = request.getParameter("search");
    String statusFilter = request.getParameter("filter");
    List<Complaint> complaints;

    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        complaints = dao.searchComplaints(searchQuery);
    } else if (statusFilter != null && !statusFilter.trim().isEmpty() && !"All".equalsIgnoreCase(statusFilter)) {
        complaints = dao.filterByStatus(statusFilter);
    } else {
        complaints = dao.getAllComplaints();
    }
    List<Complaint> recentlyUpdated = dao.getRecentlyModifiedComplaints();
    
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
    <!-- Anti-cache versioning to ensure styles are updated immediately -->
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
        <!-- Distinct Admin Hero Section -->
        <section class="hero-section animate-up" style="border-color: rgba(239, 68, 68, 0.3);">
            <img src="img/admin_hero.png" alt="Admin Command Center" class="hero-bg">
            <div class="hero-overlay" style="background: linear-gradient(90deg, rgba(15, 23, 42, 0.95) 20%, rgba(220, 38, 38, 0.4) 100%);"></div>
            <div class="hero-content">
                <span class="hero-badge" style="background: rgba(239, 68, 68, 0.15); color: #fca5a5; border-color: rgba(239, 68, 68, 0.4);"><i class="fa-solid fa-shield-halved"></i> Administrator Access</span>
                <h1 style="background: linear-gradient(135deg, #fff, #fca5a5); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">Command Center</h1>
                <p>Monitor platform health, manage community concerns, and provide high-impact resolutions in real-time.</p>
                <div style="margin-top: 1.5rem; display: flex; gap: 1rem;">
                    <button onclick="document.getElementById('usersModal').style.display='block'" class="btn btn-primary" style="background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.3); color: white;">
                        <i class="fa-solid fa-users"></i> View Registered Citizens
                    </button>
                    <button onclick="document.getElementById('activityModal').style.display='block'" class="btn btn-primary" style="background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.3); color: #6ee7b7;">
                        <i class="fa-solid fa-clock-rotate-left"></i> System Activity
                    </button>
                </div>
            </div>
        </section>

        <!-- Stats Grid directly after hero -->
        <section class="stats-grid animate-up delay-1">
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
            <!-- New Incredible Floating Search Panel -->
            <div class="search-panel">
                <form action="admin_dashboard.jsp" method="get">
                    <div class="search-input-group">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" name="search" placeholder="Search by citizen name or subject..." value="<%= searchQuery != null ? searchQuery : "" %>">
                    </div>
                    <div class="filter-group">
                        <i class="fa-solid fa-filter" style="color: var(--primary);"></i>
                        <select name="filter" onchange="this.form.submit()" class="status-select">
                            <option value="All">All Categories</option>
                            <option value="Pending" <%="Pending".equalsIgnoreCase(statusFilter) ? "selected" : ""%>>Pending</option>
                            <option value="In Progress" <%="In Progress".equalsIgnoreCase(statusFilter) ? "selected" : ""%>>In Progress</option>
                            <option value="Resolved" <%="Resolved".equalsIgnoreCase(statusFilter) ? "selected" : ""%>>Resolved</option>
                            <option value="Rejected" <%="Rejected".equalsIgnoreCase(statusFilter) ? "selected" : ""%>>Rejected</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary" style="padding: 0.8rem 2rem; border-radius: 100px;">Search</button>
                </form>
            </div>

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
                                <th>Description</th>
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
                                    <td><%= c.getDescription() %></td>
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
                                            <div class="action-group" style="flex-direction: column; gap: 0.5rem;">
                                                <select name="status" class="status-select" style="width: 130px;">
                                                    <option value="Pending" <%="Pending".equals(c.getStatus()) ? "selected" : "" %>>Pending</option>
                                                    <option value="In Progress" <%="In Progress".equals(c.getStatus()) ? "selected" : "" %>>In Progress</option>
                                                    <option value="Resolved" <%="Resolved".equals(c.getStatus()) ? "selected" : "" %>>Resolved</option>
                                                    <option value="Rejected" <%="Rejected".equals(c.getStatus()) ? "selected" : "" %>>Rejected</option>
                                                </select>
                                                <div style="display: flex; gap: 0.3rem;">
                                                    <input type="text" name="notes" class="status-select" placeholder="Resolution notes..." value="<%= c.getResolutionNotes() != null ? c.getResolutionNotes() : "" %>" style="width: 130px; font-size: 0.8rem;">
                                                    <button type="submit" class="btn btn-update" title="Update Status">
                                                        <i class="fa-solid fa-arrows-rotate"></i>
                                                    </button>
                                                </div>
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

    <!-- Users Modal -->
    <div id="usersModal" class="modal">
        <div class="modal-content glass-container">
            <span class="close-btn" onclick="document.getElementById('usersModal').style.display='none'">&times;</span>
            <h2 style="margin-bottom: 1.5rem; color: var(--primary);"><i class="fa-solid fa-users"></i> Registered Citizens</h2>
            <div class="table-container" style="max-height: 400px; overflow-y: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(User u : allUsers) { %>
                            <tr class="table-row">
                                <td><strong>#<%= u.getId() %></strong></td>
                                <td>
                                    <div class="user-cell">
                                        <div class="avatar"><i class="fa-solid fa-user"></i></div>
                                        <span><%= u.getName() %></span>
                                    </div>
                                </td>
                                <td><%= u.getEmail() %></td>
                                <td><%= u.getPhone() != null && !u.getPhone().isEmpty() ? u.getPhone() : "N/A" %></td>
                                <td>
                                    <div style="display: flex; gap: 0.8rem;">
                                        <button onclick="editUser(<%= u.getId() %>, '<%= u.getName().replace("'", "\\'") %>', '<%= u.getEmail().replace("'", "\\'") %>', '<%= u.getPhone() != null ? u.getPhone().replace("'", "\\'") : "" %>', '<%= u.getAddress() != null ? u.getAddress().replace("'", "\\'") : "" %>')" 
                                                class="btn-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary); font-size: 0.9rem;" title="Edit User">
                                            <i class="fa-solid fa-user-pen"></i>
                                        </button>
                                        <a href="admin?action=deleteUser&id=<%= u.getId() %>" 
                                           onclick="return confirm('Are you sure you want to delete this user? This may fail if they have active complaints.')"
                                           class="btn-icon" style="background: rgba(239, 68, 68, 0.1); color: var(--danger); font-size: 0.9rem;" title="Delete User">
                                            <i class="fa-solid fa-user-xmark"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } if(allUsers.isEmpty()) { %>
                            <tr>
                                <td colspan="5" class="empty-state">No users registered yet.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div id="editUserModal" class="modal">
        <div class="modal-content glass-container" style="max-width: 500px;">
            <span class="close-btn" onclick="document.getElementById('editUserModal').style.display='none'">&times;</span>
            <h2 style="margin-bottom: 1.5rem; color: var(--primary);"><i class="fa-solid fa-user-pen"></i> Edit Citizen Data</h2>
            <form action="admin" method="post">
                <input type="hidden" name="action" value="updateUser">
                <input type="hidden" name="id" id="editUserId">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" id="editUserName" required>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" id="editUserEmail" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" id="editUserPhone">
                </div>
                <div class="form-group">
                    <label>Address</label>
                    <textarea name="address" id="editUserAddress" rows="3"></textarea>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Save Changes</button>
            </form>
        </div>
    </div>

    <!-- System Activity Modal -->
    <div id="activityModal" class="modal">
        <div class="modal-content glass-container" style="max-width: 900px;">
            <span class="close-btn" onclick="document.getElementById('activityModal').style.display='none'">&times;</span>
            <h2 style="margin-bottom: 1.5rem; color: var(--accent);"><i class="fa-solid fa-clock-rotate-left"></i> Recent Community Activity</h2>
            <p style="color: var(--text-gray); margin-bottom: 1.5rem;">Showing the latest complaints that have been edited or updated by citizens.</p>
            <div class="table-container" style="max-height: 400px; overflow-y: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>Time</th>
                            <th>Citizen</th>
                            <th>Modification</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Complaint c : recentlyUpdated) { %>
                            <tr class="table-row">
                                <td style="font-size: 0.85rem; color: var(--text-gray);"><%= c.getUpdatedAt() %></td>
                                <td>
                                    <div class="user-cell">
                                        <div class="avatar" style="background: var(--accent);"><i class="fa-solid fa-user"></i></div>
                                        <span><%= c.getUserName() %></span>
                                    </div>
                                </td>
                                <td>
                                    <strong>Updated:</strong> <%= c.getSubject() %><br>
                                    <small style="opacity: 0.7;"><%= c.getDescription().length() > 50 ? c.getDescription().substring(0, 50) + "..." : c.getDescription() %></small>
                                </td>
                                <td>
                                    <span class="status-badge status-<%= c.getStatus().toLowerCase().replace(" ", "") %>" style="font-size: 0.75rem;">
                                        <%= c.getStatus() %>
                                    </span>
                                </td>
                            </tr>
                        <% } if(recentlyUpdated.isEmpty()) { %>
                            <tr>
                                <td colspan="4" class="empty-state">No recent modifications found.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2024 Citizen Voice. Administrative Control Panel.</p>
        <div class="footer-links">
            <span><i class="fa-solid fa-shield-halved"></i> System Admin Mode</span>
            <span><i class="fa-solid fa-server"></i> v1.8 Stable Release</span>
        </div>
    </footer>

    <script>
        function editUser(id, name, email, phone, address) {
            document.getElementById('editUserId').value = id;
            document.getElementById('editUserName').value = name;
            document.getElementById('editUserEmail').value = email;
            document.getElementById('editUserPhone').value = phone;
            document.getElementById('editUserAddress').value = address;
            document.getElementById('editUserModal').style.display = 'block';
        }

        // Close modals when clicking outside
        window.onclick = function(event) {
            if (event.target.className === 'modal') {
                event.target.style.display = 'none';
            }
        }
    </script>
</body>

</html>