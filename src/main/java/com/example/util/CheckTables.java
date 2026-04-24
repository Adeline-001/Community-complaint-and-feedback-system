package com.example.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class CheckTables {
    private static final String URL = System.getenv("DB_URL") != null ? System.getenv("DB_URL")
            : "jdbc:mysql://mysql-127361a7-niwemugeniadeline98-4119.c.aivencloud.com:18535/complaint_system?useSSL=true&allowPublicKeyRetrieval=true&verifyServerCertificate=false";
    private static final String USER = "avnadmin";
    private static final String PASS = System.getenv("DB_PASS");

    public static void main(String[] args) {
        if (PASS == null || PASS.isEmpty()) {
            System.err.println("ERROR: DB_PASS environment variable is not set!");
            System.err.println(
                    "Please set DB_PASS in your IntelliJ Run Configuration environment variables (Edit Configurations -> Environment variables).");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
                    Statement stmt = conn.createStatement()) {

                System.out.println("Connected to Aiven! Listing tables...");
                ResultSet rs = stmt.executeQuery("SHOW TABLES");
                while (rs.next()) {
                    System.out.println("Table: " + rs.getString(1));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
