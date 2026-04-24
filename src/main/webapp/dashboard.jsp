<%@ page import="com.example.model.User" %>
<%@ page import="com.example.dao.ComplaintDAO" %>
<%@ page import="com.example.dao.MessageDAO" %>
<%@ page import="com.example.model.Complaint" %>
<%@ page import="com.example.model.Message" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    User user = (User) session.getAttribute("user"); 
    if (user == null) {
        response.sendRedirect("login.jsp"); 
        return; 
    } 
    ComplaintDAO dao = new ComplaintDAO();
    List<Complaint> complaints = dao.getComplaintsByUser(user.getId());
    
    MessageDAO mDAO = new MessageDAO();
    List<Message> userMessages = mDAO.getMessagesByEmail(user.getEmail());
    System.out.println("[DEBUG] dashboard.jsp: Fetching inquiries for email: " + user.getEmail() + ". Found: " + userMessages.size());
    
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
            <a href="javascript:void(0);" onclick="document.getElementById('inquiriesModal').style.display='block'"><i class="fa-solid fa-envelope"></i> My Inquiries</a>
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
                <div style="margin-top: 1.5rem; display: flex; gap: 1rem;">
                    <a href="submit_complaint.jsp" class="btn btn-primary" style="box-shadow: 0 10px 20px rgba(16, 185, 129, 0.3);">
                        <i class="fa-solid fa-plus-circle"></i> New Complaint
                    </a>
                    <button onclick="document.getElementById('inquiriesModal').style.display='block'" class="btn btn-primary" style="background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.3); color: white; position: relative;">
                        <i class="fa-solid fa-envelope-open-text"></i> My Inquiries
                        <% if(!userMessages.isEmpty()) { %>
                            <span style="position: absolute; top: -8px; right: -8px; background: var(--accent); color: white; width: 20px; height: 20px; border-radius: 50%; font-size: 0.7rem; display: flex; align-items: center; justify-content: center; border: 2px solid #1e293b;">
                                <%= userMessages.size() %>
                            </span>
                        <% } %>
                    </button>
                </div>
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
            <% } else if("inquiry_deleted".equals(msg)) { %>
                <script>
                    Swal.fire({
                        icon: 'success',
                        title: 'Inquiry Deleted',
                        text: 'Your support inquiry has been removed.',
                        background: '#1e293b',
                        color: '#fff'
                    });
                </script>
            <% } else if("inquiry_updated".equals(msg)) { %>
                <script>
                    Swal.fire({
                        icon: 'success',
                        title: 'Inquiry Updated',
                        text: 'Your message has been modified successfully.',
                        background: '#1e293b',
                        color: '#fff'
                    });
                </script>
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
                                             <div class="resolution-note">
                                                 <strong><i class="fa-solid fa-comment-dots"></i> Admin Reply:</strong><br>
                                                 <%= c.getResolutionNotes() %>
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

    <!-- My Inquiries Modal -->
    <div id="inquiriesModal" class="modal">
        <div class="modal-content glass-container" style="max-width: 800px;">
            <span class="close-btn" onclick="document.getElementById('inquiriesModal').style.display='none'">&times;</span>
            <h2 style="margin-bottom: 1.5rem; color: var(--accent);"><i class="fa-solid fa-envelope-open-text"></i> My Inquiries & Support</h2>
            <p style="color: var(--text-gray); margin-bottom: 1.5rem;">View your questions and replies from the administration.</p>
            
            <div style="max-height: 500px; overflow-y: auto; padding-right: 10px;">
                <% for(Message m : userMessages) { %>
                    <div class="glass-container inquiry-card" style="margin-bottom: 1.5rem; background: rgba(255,255,255,0.03); position: relative;">
                        <div class="inquiry-header">
                            <span><i class="fa-solid fa-paper-plane"></i> Sent Inquiry</span>
                            <div style="display: flex; gap: 0.8rem; align-items: center;">
                                <span><%= m.getCreatedAt() %></span>
                                <button onclick="editInquiry('<%= m.getId() %>', '<%= m.getMessage().replace("'", "\\'").replace("\n", " ").replace("\r", " ") %>')" class="btn-icon" style="width: 28px; height: 28px; font-size: 0.75rem; background: rgba(99, 102, 241, 0.1); color: var(--primary);" title="Edit Inquiry">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button onclick="deleteInquiry('<%= m.getId() %>')" class="btn-icon" style="width: 28px; height: 28px; font-size: 0.75rem; background: rgba(239, 68, 68, 0.1); color: var(--danger);" title="Delete Inquiry">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>
                            </div>
                        </div>
                        <p class="inquiry-message">"<%= m.getMessage() %>"</p>
                        
                        <% if(m.getReplyMessage() != null && !m.getReplyMessage().isEmpty()) { %>
                            <div class="admin-reply-box">
                                <div class="reply-header">
                                    <i class="fa-solid fa-reply-all"></i> Administrative Response
                                </div>
                                <p style="color: #fff; line-height: 1.5;"><%= m.getReplyMessage() %></p>
                                <small style="display: block; margin-top: 0.8rem; opacity: 0.6; font-size: 0.75rem;"><%= m.getRepliedAt() %></small>
                            </div>
                        <% } else { %>
                            <div style="background: rgba(255, 255, 255, 0.05); padding: 1rem; border-radius: 10px; font-size: 0.85rem; color: var(--text-gray); border: 1px dashed rgba(255,255,255,0.1);">
                                <i class="fa-solid fa-hourglass-half fa-spin"></i> Awaiting administrative review...
                            </div>
                        <% } %>
                    </div>
                <% } if(userMessages.isEmpty()) { %>
                    <div style="text-align: center; padding: 3rem; color: var(--text-gray);">
                        <i class="fa-regular fa-message fa-3x" style="opacity: 0.3; margin-bottom: 1rem; display: block;"></i>
                        <p>No support inquiries found matching your email: <strong><%= user.getEmail() %></strong></p>
                        <p style="font-size: 0.8rem; margin-top: 1rem; opacity: 0.6;">Note: Inquiries are matched by the email address you used in the contact form.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Citizen Voice. Empowering communities through transparency.</p>
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

        function deleteInquiry(id) {
            Swal.fire({
                title: 'Delete Inquiry?',
                text: "Your message and any replies will be permanently removed.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ef4444',
                confirmButtonText: 'Yes, delete it',
                background: '#1e293b',
                color: '#fff'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = `complaint?action=delete_inquiry&id=${id}`;
                }
            });
        }

        function editInquiry(id, currentMessage) {
            Swal.fire({
                title: 'Edit Inquiry',
                input: 'textarea',
                inputValue: currentMessage,
                inputLabel: 'Update your message to the administration',
                showCancelButton: true,
                confirmButtonColor: '#6366f1',
                background: '#1e293b',
                color: '#fff',
                inputValidator: (value) => {
                    if (!value) return 'You need to write something!'
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'complaint';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'edit_inquiry';
                    
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'id';
                    idInput.value = id;
                    
                    const msgInput = document.createElement('input');
                    msgInput.type = 'hidden';
                    msgInput.name = 'message';
                    msgInput.value = result.value;
                    
                    form.appendChild(actionInput);
                    form.appendChild(idInput);
                    form.appendChild(msgInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
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