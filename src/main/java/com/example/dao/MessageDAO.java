package com.example.dao;

import com.example.model.Message;
import com.example.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {
    public MessageDAO() {
        ensureSchema();
    }

    private void ensureSchema() {
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData meta = conn.getMetaData();
            
            // Try both lowercase and uppercase for better compatibility
            boolean hasReplyMessage = checkColumn(meta, "contact_messages", "reply_message") || 
                                     checkColumn(meta, "CONTACT_MESSAGES", "reply_message");
            
            if (!hasReplyMessage) {
                try (Statement stmt = conn.createStatement()) {
                    stmt.executeUpdate("ALTER TABLE contact_messages ADD COLUMN reply_message TEXT");
                    System.out.println("[DEBUG] Added column 'reply_message'");
                } catch (SQLException e) { 
                    System.err.println("[DEBUG] Failed to add reply_message: " + e.getMessage()); 
                }
            }
            
            boolean hasRepliedAt = checkColumn(meta, "contact_messages", "replied_at") || 
                                   checkColumn(meta, "CONTACT_MESSAGES", "replied_at");
            
            if (!hasRepliedAt) {
                try (Statement stmt = conn.createStatement()) {
                    stmt.executeUpdate("ALTER TABLE contact_messages ADD COLUMN replied_at TIMESTAMP NULL");
                    System.out.println("[DEBUG] Added column 'replied_at'");
                } catch (SQLException e) { 
                    System.err.println("[DEBUG] Failed to add replied_at: " + e.getMessage()); 
                }
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] Schema Migration Failed: " + e.getMessage());
        }
    }

    private boolean checkColumn(DatabaseMetaData meta, String tableName, String columnName) throws SQLException {
        try (ResultSet rs = meta.getColumns(null, null, tableName, columnName)) {
            return rs.next();
        }
    }

    public boolean saveMessage(Message msg) {
        String query = "INSERT INTO contact_messages (name, email, message) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, msg.getName());
            stmt.setString(2, msg.getEmail());
            stmt.setString(3, msg.getMessage());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Failed to save contact message: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Message> getAllMessages() {
        List<Message> messages = new ArrayList<>();
        String query = "SELECT * FROM contact_messages ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Message msg = new Message();
                msg.setId(rs.getInt("id"));
                msg.setName(rs.getString("name"));
                msg.setEmail(rs.getString("email"));
                msg.setMessage(rs.getString("message"));
                msg.setRead(rs.getBoolean("is_read"));
                msg.setCreatedAt(rs.getTimestamp("created_at"));
                
                // Robust check for new columns
                try {
                    msg.setReplyMessage(rs.getString("reply_message"));
                    msg.setRepliedAt(rs.getTimestamp("replied_at"));
                } catch (Exception e) {
                    // Columns don't exist yet, that's okay
                }
                
                messages.add(msg);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("[DEBUG] MessageDAO: Found " + messages.size() + " messages in the database.");
        return messages;
    }

    public int getUnreadCount() {
        String query = "SELECT COUNT(*) FROM contact_messages WHERE is_read = false";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean replyToMessage(int id, String reply) {
        String query = "UPDATE contact_messages SET reply_message = ?, is_read = true, replied_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, reply);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] MessageDAO.replyToMessage failed for ID " + id + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteMessage(int id) {
        String query = "DELETE FROM contact_messages WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateMessage(int id, String newMessage) {
        String query = "UPDATE contact_messages SET message = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, newMessage);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Message> getMessagesByEmail(String email) {
        List<Message> messages = new ArrayList<>();
        String query = "SELECT * FROM contact_messages WHERE email = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Message msg = new Message();
                    msg.setId(rs.getInt("id"));
                    msg.setName(rs.getString("name"));
                    msg.setEmail(rs.getString("email"));
                    msg.setMessage(rs.getString("message"));
                    msg.setRead(rs.getBoolean("is_read"));
                    msg.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    // Robust check for new columns
                    try {
                        msg.setReplyMessage(rs.getString("reply_message"));
                        msg.setRepliedAt(rs.getTimestamp("replied_at"));
                    } catch (Exception e) {
                        // Columns might not exist yet
                    }
                    
                    messages.add(msg);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }
}
