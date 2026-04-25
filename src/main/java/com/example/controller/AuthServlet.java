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
            // Hash the password before saving for security!
            user.setPassword(com.example.util.PasswordUtil.hashPassword(password));
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
                    // 1. Core HTTP Session for JSP
                    HttpSession session = request.getSession();
                    session.setAttribute("admin", admin);
                    // 2. Generate and store JWT token for security phase requirements
                    String token = com.example.util.JwtUtil.generateToken(admin.getEmail(), "admin", admin.getId());
                    jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("jwt_token", token);
                    cookie.setPath("/");
                    cookie.setMaxAge(86400); // 24 hours
                    response.addCookie(cookie);

                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    System.out.println("[DEBUG] Admin login failed: " + email + " (Invalid credentials)");
                    response.sendRedirect("login.jsp?error=invalid");
                }
            } else {
                User user = userDAO.loginUser(email, password);
                if (user != null) {
                    System.out.println("[DEBUG] Citizen login success: " + email);
                    // 1. Core HTTP Session for JSP
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    // 2. Generate and store JWT token for security phase requirements
                    String token = com.example.util.JwtUtil.generateToken(user.getEmail(), "user", user.getId());
                    jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("jwt_token", token);
                    cookie.setPath("/");
                    cookie.setMaxAge(86400); // 24 hours
                    response.addCookie(cookie);

                    response.sendRedirect("dashboard.jsp");
                } else {
                    System.out.println("[DEBUG] Citizen login failed: " + email + " (Invalid credentials)");
                    response.sendRedirect("login.jsp?error=invalid");
                }
            }
        } else if ("api-login".equals(action)) {
            // Pure REST API Endpoint for the Backend Submission (No Frontend
            // HTML/Redirects)
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            User user = userDAO.loginUser(email, password);
            Admin admin = adminDAO.loginAdmin(email, password);

            if (admin != null) {
                String token = com.example.util.JwtUtil.generateToken(admin.getEmail(), "admin", admin.getId());
                response.getWriter().write("{\"status\":\"success\", \"role\":\"admin\", \"token\":\"" + token + "\"}");
            } else if (user != null) {
                String token = com.example.util.JwtUtil.generateToken(user.getEmail(), "user", user.getId());
                response.getWriter().write("{\"status\":\"success\", \"role\":\"user\", \"token\":\"" + token + "\"}");
            } else {
                response.setStatus(401);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Invalid credentials\"}");
            }
        } else if ("list-users".equals(action)) {
            sendUserList(response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String test = request.getParameter("test");
        if ("register-admin".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            Admin admin = new Admin();
            admin.setName(name);
            admin.setEmail(email);
            if (adminDAO.registerAdmin(admin, password)) {
                response.getWriter().write("Admin created successfully via GET");
            } else {
                response.getWriter().write("Failed to create admin via GET");
            }
            return;
        }

        if ("diag".equals(test)) {
            response.setContentType("text/plain");
            response.getWriter().write("AuthServlet is REACHABLE at: " + request.getRequestURI());
            return;
        }

        if ("list-users".equals(action)) {
            sendUserList(response);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Remove JWT cookie on logout
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("jwt_token", "");
        cookie.setPath("/");
        cookie.setMaxAge(0);
        response.addCookie(cookie);

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
                    .append("\"phone\":\"").append(u.getPhone() != null ? u.getPhone().replace("\"", "\\\"") : "")
                    .append("\",")
                    .append("\"address\":\"").append(u.getAddress() != null ? u.getAddress().replace("\"", "\\\"") : "")
                    .append("\"")
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
