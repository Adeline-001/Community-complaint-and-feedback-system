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

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
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
        }
    }
}
