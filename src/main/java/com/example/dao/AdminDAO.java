package com.example.dao;

import com.example.model.Admin;
import com.example.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAO {
    public Admin loginAdmin(String email, String password) {
        String query = "SELECT * FROM admins WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password");
                boolean match1 = com.example.util.PasswordUtil.checkPassword(password, storedHash);
                boolean match2 = password.equals(storedHash);
                System.out.println("[DEBUG] Admin login check for " + email + ": BCryptMatch=" + match1
                        + ", PlainMatch=" + match2);
                if (match1 || match2) {
                    Admin admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setName(rs.getString("name"));
                    admin.setEmail(rs.getString("email"));
                    return admin;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerAdmin(Admin admin, String plainPassword) {
        String hashedPassword = com.example.util.PasswordUtil.hashPassword(plainPassword);
        String query = "INSERT INTO admins (name, email, password) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, admin.getName());
            stmt.setString(2, admin.getEmail());
            stmt.setString(3, hashedPassword);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
