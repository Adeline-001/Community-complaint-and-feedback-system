package com.example.controller;

import com.example.dao.ComplaintDAO;
import com.example.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private ComplaintDAO complaintDAO = new ComplaintDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            String notes = request.getParameter("notes");

            if (complaintDAO.updateStatus(id, status, notes)) {
                response.sendRedirect("admin_dashboard.jsp?msg=updated");
            } else {
                response.sendRedirect("admin_dashboard.jsp?error=failed");
            }
        }
    }
}
