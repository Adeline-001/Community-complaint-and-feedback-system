package com.example.dao;

import com.example.model.User;
import com.example.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    public boolean registerUser(User user) {
        // We include created_at just in case it's NOT NULL without a default
        String query = "INSERT INTO users (name, email, password, phone, address, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getAddress());

            System.out.println("[DEBUG] PreparedStatement ready. Executing insert for: " + user.getEmail());
            int rows = stmt.executeUpdate();
            System.out.println("[DEBUG] Insert finished. Rows affected: " + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Registration Failed for email: " + user.getEmail());
            System.err.println("[ERROR] MySQL Error Code: " + e.getErrorCode());
            System.err.println("[ERROR] MySQL SQL State: " + e.getSQLState());
            System.err.println("[ERROR] Error Message: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public User loginUser(String email, String password) {
        String query = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password");
                // Check if the plain-text password matches the stored BCrypt hash
                if (com.example.util.PasswordUtil.checkPassword(password, storedHash) || password.equals(storedHash)) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] Login authentication failed for email: " + email);
            System.err.println("[ERROR] MySQL Error Code: " + e.getErrorCode());
            System.err.println("[ERROR] SQL State: " + e.getSQLState());
            System.err.println("[ERROR] Message: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT id, name, email, phone, address FROM users ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean updateUser(User user) {
        String query = "UPDATE users SET name = ?, email = ?, phone = ?, address = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getAddress());
            stmt.setInt(5, user.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUser(int id) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Delete all complaints associated with this user first
            String deleteComplaintsQuery = "DELETE FROM complaints WHERE user_id = ?";
            try (PreparedStatement stmtC = conn.prepareStatement(deleteComplaintsQuery)) {
                stmtC.setInt(1, id);
                stmtC.executeUpdate();
            }

            // 2. Now delete the user
            String deleteUserQuery = "DELETE FROM users WHERE id = ?";
            try (PreparedStatement stmtU = conn.prepareStatement(deleteUserQuery)) {
                stmtU.setInt(1, id);
                int rows = stmtU.executeUpdate();
                conn.commit(); // Commit transaction
                return rows > 0;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
