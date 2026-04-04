package com.example.util;

import java.sql.Connection;
import java.sql.Statement;

public class DatabaseMigrator {
    public static void main(String[] args) {
        System.out.println("Applying Phase 8 Database Schema Updates...");
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Add resolution_notes column if missing
            try {
                stmt.execute("ALTER TABLE complaints ADD COLUMN resolution_notes TEXT");
                System.out.println("✅ Added column: resolution_notes");
            } catch (Exception e) {
                System.out.println("ℹ️ Column resolution_notes already exists or could not be added.");
            }

            // Add resolved_at column if missing
            try {
                stmt.execute("ALTER TABLE complaints ADD COLUMN resolved_at TIMESTAMP NULL");
                System.out.println("✅ Added column: resolved_at");
            } catch (Exception e) {
                System.out.println("ℹ️ Column resolved_at already exists or could not be added.");
            }

            System.out.println("Database migration completed successfully!");
            
        } catch (Exception e) {
            System.err.println("Database migration failed!");
            e.printStackTrace();
        }
    }
}
