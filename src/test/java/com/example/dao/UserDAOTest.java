package com.example.dao;

import com.example.model.User;
import com.example.util.DBConnection;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;
import org.mockito.Mockito;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

class UserDAOTest {

    private Connection mockConnection;
    private PreparedStatement mockPreparedStatement;
    private ResultSet mockResultSet;
    private MockedStatic<DBConnection> mockedDBConnection;

    private UserDAO userDAO;

    @BeforeEach
    void setUp() throws SQLException {
        mockConnection = mock(Connection.class);
        mockPreparedStatement = mock(PreparedStatement.class);
        mockResultSet = mock(ResultSet.class);

        // Mock DBConnection.getConnection() to return our mock connection
        mockedDBConnection = mockStatic(DBConnection.class);
        mockedDBConnection.when(DBConnection::getConnection).thenReturn(mockConnection);
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);

        userDAO = new UserDAO();
    }

    @AfterEach
    void tearDown() {
        mockedDBConnection.close();
    }

    @Test
    void registerUser_ShouldReturnTrue_WhenInsertIsSuccessful() throws SQLException {
        // Arrange
        User user = new User();
        user.setName("John Doe");
        user.setEmail("john@example.com");
        user.setPassword("password123");
        user.setPhone("1234567890");
        user.setAddress("123 Main St");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1); // 1 row affected

        // Act
        boolean result = userDAO.registerUser(user);

        // Assert
        assertThat(result).isTrue();
        verify(mockPreparedStatement).setString(1, "John Doe");
        verify(mockPreparedStatement).setString(2, "john@example.com");
        verify(mockPreparedStatement).setString(3, "password123");
        verify(mockPreparedStatement).executeUpdate();
    }

    @Test
    void registerUser_ShouldReturnFalse_WhenInsertFails() throws SQLException {
        // Arrange
        User user = new User();
        when(mockPreparedStatement.executeUpdate()).thenReturn(0); // 0 rows affected

        // Act
        boolean result = userDAO.registerUser(user);

        // Assert
        assertThat(result).isFalse();
    }

    @Test
    void loginUser_ShouldReturnUser_WhenCredentialsAreValid() throws SQLException {
        // Arrange
        String email = "john@example.com";
        String password = "password123";

        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getString("password")).thenReturn("password123"); // plain text matches
        when(mockResultSet.getInt("id")).thenReturn(1);
        when(mockResultSet.getString("name")).thenReturn("John Doe");
        when(mockResultSet.getString("email")).thenReturn(email);

        // Act
        User user = userDAO.loginUser(email, password);

        // Assert
        assertThat(user).isNotNull();
        assertThat(user.getName()).isEqualTo("John Doe");
        assertThat(user.getEmail()).isEqualTo(email);
        verify(mockPreparedStatement).setString(1, email);
    }

    @Test
    void loginUser_ShouldReturnNull_WhenCredentialsAreInvalid() throws SQLException {
        // Arrange
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(false); // User not found

        // Act
        User user = userDAO.loginUser("wrong@example.com", "wrongpass");

        // Assert
        assertThat(user).isNull();
    }
}
