package com.example.filter;

import com.example.util.JwtUtil;
import io.jsonwebtoken.Claims;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// Protect both JSP dashboards and specific API routes
@WebFilter(urlPatterns = {"/dashboard.jsp", "/admin_dashboard.jsp", "/submit_complaint.jsp", "/edit_complaint.jsp"})
public class JwtFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
            
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Extract JWT from Cookies
        String jwtToken = null;
        Cookie[] cookies = httpRequest.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("jwt_token".equals(cookie.getName())) {
                    jwtToken = cookie.getValue();
                    break;
                }
            }
        }

        // Validate Token
        if (jwtToken != null) {
            Claims claims = JwtUtil.validateTokenAndGetClaims(jwtToken);
            if (claims != null) {
                // Token is valid! Ensure the HTTP Session matches the JWT logic for JSP rendering compatibility
                HttpSession session = httpRequest.getSession();
                String role = claims.get("role", String.class);
                
                // If the user tries to access admin_dashboard but isn't an admin
                if (httpRequest.getRequestURI().contains("admin_dashboard") && !"admin".equals(role)) {
                    httpResponse.sendRedirect("login.jsp?error=unauthorized");
                    return;
                }
                
                // Token checked out, proceed with request
                chain.doFilter(request, response);
                return;
            }
        }

        // If no valid token found, deny access and send to login
        System.out.println("[JWT FILTER] Blocked unauthenticated access to: " + httpRequest.getRequestURI());
        httpResponse.sendRedirect("login.jsp?error=unauthorized");
    }
}
