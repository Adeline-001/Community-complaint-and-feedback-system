package com.example.controller;

import com.example.dao.ComplaintDAO;
import com.example.model.Complaint;
import com.example.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/complaint")
public class ComplaintServlet extends HttpServlet {
    private ComplaintDAO complaintDAO = new ComplaintDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        String action = request.getParameter("action");

        // API Submission Logic (for Postman)
        if ("submit-api".equals(action)) {
            String userIdStr = request.getParameter("userId");
            int userId = -1;
            
            if (userIdStr != null) {
                userId = Integer.parseInt(userIdStr);
            } else if (user != null) {
                userId = user.getId();
            }

            if (userId == -1) {
                response.setStatus(401);
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"error\", \"message\":\"User not authenticated or userId missing\"}");
                return;
            }

            Complaint c = new Complaint();
            c.setUserId(userId);
            c.setCategoryId(Integer.parseInt(request.getParameter("category")));
            c.setSubject(request.getParameter("subject"));
            c.setDescription(request.getParameter("description"));

            response.setContentType("application/json");
            if (complaintDAO.submitComplaint(c)) {
                response.getWriter().write("{\"status\":\"success\", \"message\":\"Complaint submitted successfully via API\"}");
            } else {
                response.setStatus(500);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to submit complaint via API\"}");
            }
            return;
        }

        // Web Interface Logic
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("submit".equals(action)) {
            Complaint c = new Complaint();
            c.setUserId(user.getId());
            c.setCategoryId(Integer.parseInt(request.getParameter("category")));
            c.setSubject(request.getParameter("subject"));
            c.setDescription(request.getParameter("description"));

            if (complaintDAO.submitComplaint(c)) {
                response.sendRedirect("dashboard.jsp?msg=success");
            } else {
                response.sendRedirect("submit_complaint.jsp?error=failed");
            }
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String subject = request.getParameter("subject");
            String description = request.getParameter("description");

            Complaint c = new Complaint();
            c.setId(id);
            c.setUserId(user.getId());
            c.setSubject(subject);
            c.setDescription(description);

            if (complaintDAO.updateComplaint(c)) {
                response.sendRedirect("dashboard.jsp?msg=updated");
            } else {
                response.sendRedirect("edit_complaint.jsp?id=" + id + "&error=failed");
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (complaintDAO.deleteComplaint(id, user.getId())) {
                response.sendRedirect("dashboard.jsp?msg=deleted");
            } else {
                response.sendRedirect("dashboard.jsp?error=delete_failed");
            }
        }
    }
}
