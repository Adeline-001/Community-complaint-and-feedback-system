package com.example.dao;

import com.example.model.Complaint;
import com.example.util.DBConnection;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

class ComplaintDAOTest {

    private Connection mockConnection;
    private PreparedStatement mockPreparedStatement;
    private ResultSet mockResultSet;
    private MockedStatic<DBConnection> mockedDBConnection;

    private ComplaintDAO complaintDAO;

    @BeforeEach
    void setUp() throws SQLException {
        mockConnection = mock(Connection.class);
        mockPreparedStatement = mock(PreparedStatement.class);
        mockResultSet = mock(ResultSet.class);

        mockedDBConnection = mockStatic(DBConnection.class);
        mockedDBConnection.when(DBConnection::getConnection).thenReturn(mockConnection);
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockConnection.prepareStatement(anyString(), anyInt())).thenReturn(mockPreparedStatement); // for generated keys

        complaintDAO = new ComplaintDAO();
    }

    @AfterEach
    void tearDown() {
        mockedDBConnection.close();
    }

    @Test
    void submitComplaint_ShouldReturnTrue_WhenInsertSucceeds() throws SQLException {
        // Arrange
        Complaint complaint = new Complaint();
        complaint.setUserId(1);
        complaint.setCategoryId(2);
        complaint.setSubject("Noise Issue");
        complaint.setDescription("Loud music at night.");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);
        when(mockPreparedStatement.getGeneratedKeys()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(101); // Mock generated ID

        // Act
        boolean result = complaintDAO.submitComplaint(complaint);

        // Assert
        assertThat(result).isTrue();
        verify(mockPreparedStatement).setInt(1, 1);
        verify(mockPreparedStatement).setInt(2, 2);
        verify(mockPreparedStatement).setString(3, "Noise Issue");
        verify(mockPreparedStatement).setString(4, "Loud music at night.");
    }

    @Test
    void updateStatus_ShouldReturnTrue_WhenStatusIsUpdated() throws SQLException {
        // Arrange
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        // Act
        boolean result = complaintDAO.updateStatus(1, "Resolved", "Handled");

        // Assert
        assertThat(result).isTrue();
        verify(mockPreparedStatement).setString(1, "Resolved");
        verify(mockPreparedStatement).setString(2, "Handled");
        // We also need to verify Timestamp setting which is index 3, but wait
        // The implementation does:
        // if ("Resolved".equals(status)) stmt.setTimestamp(3, new Timestamp(...));
        // stmt.setInt(4, complaintId);
        verify(mockPreparedStatement).setInt(4, 1);
    }
}
