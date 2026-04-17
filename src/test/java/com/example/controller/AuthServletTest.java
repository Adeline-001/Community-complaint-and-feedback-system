package com.example.controller;

import com.example.dao.AdminDAO;
import com.example.dao.UserDAO;
import com.example.model.Admin;
import com.example.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import java.io.IOException;

import static org.mockito.Mockito.*;

class AuthServletTest {

    @Mock
    private UserDAO userDAO;

    @Mock
    private AdminDAO adminDAO;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @InjectMocks
    private AuthServlet authServlet;

    private AutoCloseable closeable;
    private MockedStatic<com.example.util.JwtUtil> mockedJwtUtil;

    @BeforeEach
    void setUp() {
        closeable = MockitoAnnotations.openMocks(this);
        mockedJwtUtil = mockStatic(com.example.util.JwtUtil.class);
    }

    @AfterEach
    void tearDown() throws Exception {
        mockedJwtUtil.close();
        closeable.close();
    }

    @Test
    void doPost_Login_ShouldRedirectToDashboard_WhenCitizensCredentialsAreValid() throws ServletException, IOException {
        // Arrange
        when(request.getParameter("action")).thenReturn("login");
        when(request.getParameter("email")).thenReturn("citizen@example.com");
        when(request.getParameter("password")).thenReturn("password123");
        when(request.getParameter("role")).thenReturn("user");

        User mockUser = new User();
        mockUser.setId(1);
        mockUser.setEmail("citizen@example.com");

        when(userDAO.loginUser("citizen@example.com", "password123")).thenReturn(mockUser);
        when(request.getSession()).thenReturn(session);
        mockedJwtUtil.when(() -> com.example.util.JwtUtil.generateToken(anyString(), anyString(), anyInt())).thenReturn("mockToken");

        // Act
        authServlet.doPost(request, response);

        // Assert
        verify(session).setAttribute("user", mockUser);
        verify(response).addCookie(any(jakarta.servlet.http.Cookie.class));
        verify(response).sendRedirect("dashboard.jsp");
    }

    @Test
    void doPost_Login_ShouldRedirectToLoginWithError_WhenCitizensCredentialsAreInvalid() throws ServletException, IOException {
        // Arrange
        when(request.getParameter("action")).thenReturn("login");
        when(request.getParameter("email")).thenReturn("wrong@example.com");
        when(request.getParameter("password")).thenReturn("wrongpass");
        when(request.getParameter("role")).thenReturn("user");

        when(userDAO.loginUser("wrong@example.com", "wrongpass")).thenReturn(null);

        // Act
        authServlet.doPost(request, response);

        // Assert
        verify(response).sendRedirect("login.jsp?error=invalid");
        verify(session, never()).setAttribute(anyString(), any());
    }
}
