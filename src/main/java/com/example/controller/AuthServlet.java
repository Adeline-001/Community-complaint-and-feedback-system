package com.example.controller;

import com.example.dao.AdminDAO;
import com.example.dao.UserDAO;
import com.example.model.Admin;
import com.example.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private AdminDAO adminDAO = new AdminDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("register".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password);
            user.setPhone(phone);
            user.setAddress(address);

            System.out.println("[DEBUG] Attempting to register user: " + email);
            if (userDAO.registerUser(user)) {
                System.out.println("[DEBUG] Registration success for: " + email);
                HttpSession session = request.getSession();
                session.setAttribute("msg", "registered");
                response.sendRedirect("login.jsp?msg=registered");
            } else {
                System.out.println("[DEBUG] Registration failed for: " + email + " (UserDAO returned false)");
                response.sendRedirect("register.jsp?error=exists");
            }
        } else if ("register-admin".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            Admin admin = new Admin();
            admin.setName(name);
            admin.setEmail(email);

            System.out.println("[DEBUG] Attempting to register ADMIN: " + email);
            if (adminDAO.registerAdmin(admin, password)) {
                System.out.println("[DEBUG] Admin Registration success for: " + email);
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"success\", \"message\":\"Admin created successfully\"}");
            } else {
                System.out.println("[DEBUG] Admin Registration failed for: " + email);
                response.setStatus(500);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to create admin\"}");
            }
        } else if ("login".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            if ("admin".equals(role)) {
                Admin admin = adminDAO.loginAdmin(email, password);
                if (admin != null) {
                    System.out.println("[DEBUG] Admin login success: " + email);
                    HttpSession session = request.getSession();
                    session.setAttribute("admin", admin);
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    System.out.println("[DEBUG] Admin login failed: " + email + " (Invalid credentials)");
                    response.sendRedirect("login.jsp?error=invalid");
                }
            } else {
                User user = userDAO.loginUser(email, password);
                if (user != null) {
                    System.out.println("[DEBUG] Citizen login success: " + email);
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    response.sendRedirect("dashboard.jsp");
                } else {
                    System.out.println("[DEBUG] Citizen login failed: " + email + " (Invalid credentials)");
                    response.sendRedirect("login.jsp?error=invalid");
                }
            }
        } else if ("list-users".equals(action)) {
            sendUserList(response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String test = request.getParameter("test");
        if ("diag".equals(test)) {
            response.setContentType("text/plain");
            response.getWriter().write("AuthServlet is REACHABLE at: " + request.getRequestURI());
            return;
        }

        String action = request.getParameter("action");
        if ("list-users".equals(action)) {
            sendUserList(response);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("landing.jsp");
    }

    private void sendUserList(HttpServletResponse response) throws IOException {
        List<User> users = userDAO.getAllUsers();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < users.size(); i++) {
            User u = users.get(i);
            json.append("{")
                    .append("\"id\":").append(u.getId()).append(",")
                    .append("\"name\":\"").append(u.getName().replace("\"", "\\\"")).append("\",")
                    .append("\"email\":\"").append(u.getEmail().replace("\"", "\\\"")).append("\",")
                    .append("\"phone\":\"").append(u.getPhone() != null ? u.getPhone().replace("\"", "\\\"") : "").append("\",")
                    .append("\"address\":\"").append(u.getAddress() != null ? u.getAddress().replace("\"", "\\\"") : "").append("\"")
                    .append("}");
            if (i < users.size() - 1)
                json.append(",");
        }
        json.append("]");
        
        String result = json.toString();
        System.out.println("[DEBUG] API list-users Response: " + result);
        response.getWriter().write(result);
        response.getWriter().flush();
    }
}
