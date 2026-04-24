package com.example.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Priority: Environment Variables (for Hosting) -> Local Constants
    private static final String URL = System.getenv("DB_URL") != null ? System.getenv("DB_URL")
            : "jdbc:mysql://mysql-127361a7-niwemugeniadeline98-4119.c.aivencloud.com:18535/complaint_system?useSSL=true&allowPublicKeyRetrieval=true&verifyServerCertificate=false&connectTimeout=10000";
    private static final String USERNAME = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "avnadmin";
    private static final String PASSWORD = System.getenv("DB_PASS"); // Removed hardcoded secret for security

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
