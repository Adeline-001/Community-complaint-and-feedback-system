<%@ page import="com.example.model.Admin" %>
<%@ page import="com.example.dao.ComplaintDAO" %>
<%@ page import="com.example.dao.UserDAO" %>
<%@ page import="com.example.dao.MessageDAO" %>
<%@ page import="com.example.model.Complaint" %>
<%@ page import="com.example.model.User" %>
<%@ page import="com.example.model.Message" %>
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
    
    MessageDAO msgDAO = new MessageDAO();
    List<Message> allMessages = msgDAO.getAllMessages();
    int unreadMessages = msgDAO.getUnreadCount();
    
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
                    <button onclick="document.getElementById('messagesModal').style.display='block'" class="btn btn-primary" style="background: rgba(245, 158, 11, 0.1); border: 1px solid rgba(245, 158, 11, 0.3); color: #fbbf24; position: relative;">
                        <i class="fa-solid fa-envelope"></i> Inquiries
                        <% if(unreadMessages > 0) { %>
                            <span style="position: absolute; top: -8px; right: -8px; background: var(--danger); color: white; width: 22px; height: 22px; border-radius: 50%; font-size: 0.75rem; display: flex; align-items: center; justify-content: center; border: 2px solid var(--bg-dark); animation: pulse 2s infinite;">
                                <%= unreadMessages %>
                            </span>
                        <% } %>
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
                                                 <div style="display: flex; flex-direction: column; gap: 0.3rem; margin-top: 0.5rem;">
                                                     <label style="font-size: 0.7rem; margin: 0; opacity: 0.6;">Resolution Notes:</label>
                                                     <div style="display: flex; gap: 0.3rem;">
                                                         <textarea name="notes" class="status-select" placeholder="Enter notes..." style="width: 130px; font-size: 0.8rem; height: 60px; border-radius: 8px; resize: none;"><%= c.getResolutionNotes() != null ? c.getResolutionNotes() : "" %></textarea>
                                                         <button type="submit" class="btn btn-update" title="Save Changes" style="height: 60px;">
                                                             <i class="fa-solid fa-floppy-disk"></i>
                                                         </button>
                                                     </div>
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

    <!-- Community Inquiries Modal -->
    <div id="messagesModal" class="modal">
        <div class="modal-content glass-container" style="max-width: 800px;">
            <span class="close-btn" onclick="document.getElementById('messagesModal').style.display='none'">&times;</span>
            <h2 style="margin-bottom: 1.5rem; color: #fbbf24;"><i class="fa-solid fa-envelope-open-text"></i> Community Inquiries</h2>
            <p style="color: var(--text-gray); margin-bottom: 1.5rem;">Questions and feedback sent via the public landing page contact form.</p>
            <div style="max-height: 500px; overflow-y: auto; padding-right: 10px;">
                <% for(Message m : allMessages) { %>
                    <div class="glass-container" style="margin-bottom: 1rem; border-left: 4px solid <%= m.isRead() ? "rgba(255,255,255,0.1)" : "#fbbf24" %>; background: rgba(255,255,255,0.03);">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.8rem;">
                            <div>
                                <strong style="font-size: 1.1rem; color: #fff;"><%= m.getName() %></strong>
                                <br>
                                <small style="color: var(--text-gray);"><i class="fa-solid fa-at"></i> <%= m.getEmail() %></small>
                            </div>
                            <div style="display: flex; gap: 0.8rem; align-items: center;">
                                <small style="color: var(--text-gray); font-size: 0.8rem;"><%= m.getCreatedAt() %></small>
                                <a href="admin?action=delete_inquiry&id=<%= m.getId() %>" 
                                   onclick="return confirm('Delete this inquiry permanently?')"
                                   class="btn-icon" style="width: 28px; height: 28px; font-size: 0.75rem; background: rgba(239, 68, 68, 0.1); color: var(--danger);" title="Delete Inquiry">
                                    <i class="fa-solid fa-trash-can"></i>
                                </a>
                            </div>
                        </div>
                        <p style="color: var(--text-gray); line-height: 1.5; font-style: italic;">"<%= m.getMessage() %>"</p>
                        
                        <% if(m.getReplyMessage() != null && !m.getReplyMessage().isEmpty()) { %>
                            <div style="margin-top: 1rem; padding: 1rem; background: rgba(16, 185, 129, 0.1); border-radius: 10px; border-left: 3px solid #10b981;">
                                <strong style="color: #6ee7b7; font-size: 0.8rem; text-transform: uppercase;">Current Admin Response:</strong>
                                <p style="color: #d1d5db; font-size: 0.95rem; margin-top: 0.5rem;"><%= m.getReplyMessage() %></p>
                                <small style="display: block; margin-top: 0.5rem; opacity: 0.6; font-size: 0.75rem;"><%= m.getRepliedAt() %></small>
                            </div>
                        <% } %>

                        <div style="margin-top: 1.5rem; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 1rem;">
                            <form action="admin" method="post">
                                <input type="hidden" name="action" value="replyMessage">
                                <input type="hidden" name="id" value="<%= m.getId() %>">
                                <div class="form-group">
                                    <label style="font-size: 0.75rem; color: var(--text-gray); margin-bottom: 0.5rem; display: block;">
                                        <%= (m.getReplyMessage() != null && !m.getReplyMessage().isEmpty()) ? "Update your reply:" : "Write your reply:" %>
                                    </label>
                                    <textarea name="reply" rows="2" placeholder="Type your reply to the citizen..." required style="background: rgba(0,0,0,0.2);"><%= m.getReplyMessage() != null ? m.getReplyMessage() : "" %></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary" style="padding: 0.5rem 1.2rem; font-size: 0.85rem; background: #fbbf24; color: #1e293b; font-weight: bold; border: none;">
                                    <i class="fa-solid fa-reply"></i> <%= (m.getReplyMessage() != null && !m.getReplyMessage().isEmpty()) ? "Update Response" : "Send Reply" %>
                                </button>
                            </form>
                        </div>
                    </div>
                <% } if(allMessages.isEmpty()) { %>
                    <div class="empty-state">No inquiries received yet.</div>
                <% } %>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Citizen Voice. Administrative Control Panel.</p>
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

        // Feedback System
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');
        const error = urlParams.get('error');

        if (msg === 'replied') {
            Swal.fire({
                icon: 'success',
                title: 'Reply Sent!',
                text: 'Your response has been delivered to the citizen.',
                background: '#1e293b',
                color: '#fff',
                confirmButtonColor: '#fbbf24'
            });
        } else if (msg === 'updated') {
            Swal.fire({
                icon: 'success',
                title: 'Complaint Updated',
                text: 'The complaint status and notes have been saved.',
                background: '#1e293b',
                color: '#fff',
                confirmButtonColor: '#6366f1'
            });
        } else if (msg === 'inquiry_deleted') {
            Swal.fire({
                icon: 'success',
                title: 'Inquiry Removed',
                text: 'The inquiry has been deleted from the system.',
                background: '#1e293b',
                color: '#fff',
                confirmButtonColor: '#ef4444'
            });
        } else if (error) {
            Swal.fire({
                icon: 'error',
                title: 'Operation Failed',
                text: 'Something went wrong. Please try again.',
                background: '#1e293b',
                color: '#fff',
                confirmButtonColor: '#ef4444'
            });
        }
    </script>
</body>

</html>