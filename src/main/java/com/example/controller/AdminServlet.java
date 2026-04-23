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
        } else if ("updateUser".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            com.example.model.User user = new com.example.model.User();
            user.setId(id);
            user.setName(name);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);

            com.example.dao.UserDAO userDAO = new com.example.dao.UserDAO();
            if (userDAO.updateUser(user)) {
                response.sendRedirect("admin_dashboard.jsp?msg=user_updated");
            } else {
                response.sendRedirect("admin_dashboard.jsp?error=user_failed");
            }
        } else if ("deleteUser".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            com.example.dao.UserDAO userDAO = new com.example.dao.UserDAO();
            if (userDAO.deleteUser(id)) {
                response.sendRedirect("admin_dashboard.jsp?msg=user_deleted");
            } else {
                response.sendRedirect("admin_dashboard.jsp?error=user_delete_failed");
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("deleteUser".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            com.example.dao.UserDAO userDAO = new com.example.dao.UserDAO();
            if (userDAO.deleteUser(id)) {
                response.sendRedirect("admin_dashboard.jsp?msg=user_deleted");
            } else {
                response.sendRedirect("admin_dashboard.jsp?error=user_delete_failed");
            }
        }
    }
}
