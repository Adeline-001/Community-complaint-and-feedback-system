package com.example.dao;

import com.example.model.Complaint;
import com.example.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {
    public boolean submitComplaint(Complaint complaint) {
        String query = "INSERT INTO complaints (user_id, category_id, subject, description) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, complaint.getUserId());
            stmt.setInt(2, complaint.getCategoryId());
            stmt.setString(3, complaint.getSubject());
            stmt.setString(4, complaint.getDescription());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Complaint> getComplaintsByUser(int userId) {
        List<Complaint> complaints = new ArrayList<>();
        String query = "SELECT c.*, cat.name as category_name FROM complaints c " +
                "JOIN categories cat ON c.category_id = cat.id " +
                "WHERE c.user_id = ? ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                complaints.add(mapResultSetToComplaint(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public List<Complaint> getAllComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        String query = "SELECT c.*, cat.name as category_name, u.name as user_name FROM complaints c " +
                "JOIN categories cat ON c.category_id = cat.id " +
                "JOIN users u ON c.user_id = u.id ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement()) {
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                complaints.add(mapResultSetToComplaint(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public boolean updateStatus(int complaintId, String status) {
        String query = "UPDATE complaints SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setInt(2, complaintId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Complaint getComplaintById(int id) {
        String query = "SELECT c.*, cat.name as category_name FROM complaints c " +
                "JOIN categories cat ON c.category_id = cat.id " +
                "WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToComplaint(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateComplaint(Complaint complaint) {
        String query = "UPDATE complaints SET subject = ?, description = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, complaint.getSubject());
            stmt.setString(2, complaint.getDescription());
            stmt.setInt(3, complaint.getId());
            stmt.setInt(4, complaint.getUserId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteComplaint(int id, int userId) {
        String query = "DELETE FROM complaints WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Complaint mapResultSetToComplaint(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setId(rs.getInt("id"));
        c.setUserId(rs.getInt("user_id"));
        c.setCategoryId(rs.getInt("category_id"));
        c.setSubject(rs.getString("subject"));
        c.setDescription(rs.getString("description"));
        c.setStatus(rs.getString("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        c.setCategoryName(rs.getString("category_name"));
        try {
            c.setUserName(rs.getString("user_name"));
        } catch (SQLException ignored) {
        }
        return c;
    }
}
