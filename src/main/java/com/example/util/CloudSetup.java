package com.example.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.stream.Collectors;

/**
 * Run this class once to set up your tables on the Aiven Cloud database.
 */
public class CloudSetup {
    private static final String URL = System.getenv("DB_URL") != null ? System.getenv("DB_URL")
            : "jdbc:mysql://mysql-127361a7-niwemugeniadeline98-4119.c.aivencloud.com:18535/complaint_system?useSSL=true&allowMultiQueries=true";
    private static final String USER = "avnadmin";
    private static final String PASS = System.getenv("DB_PASS");

    public static void main(String[] args) {
        if (PASS == null || PASS.isEmpty()) {
            System.err.println("ERROR: DB_PASS environment variable is not set!");
            System.err.println(
                    "Please set DB_PASS in your IntelliJ Run Configuration environment variables (Edit Configurations -> Environment variables).");
            return;
        }

        System.out.println("Starting Cloud Database Setup...");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
                    Statement stmt = conn.createStatement()) {

                System.out.println("Connected to Aiven! Reading database_setup.sql...");

                // Read the SQL file
                BufferedReader reader = new BufferedReader(new FileReader("database_setup.sql"));
                String sql = reader.lines().collect(Collectors.joining("\n"));
                reader.close();

                // Split by semicolon and filter out comments/empty lines
                String[] queries = sql.split(";");
                for (String query : queries) {
                    String trimmedQuery = query.trim();
                    if (!trimmedQuery.isEmpty() && !trimmedQuery.startsWith("--")) {
                        System.out.println("Executing: "
                                + (trimmedQuery.length() > 50 ? trimmedQuery.substring(0, 50) + "..." : trimmedQuery));
                        stmt.execute(trimmedQuery);
                    }
                }

                System.out.println("\nSUCCESS: All tables created successfully on Aiven!");

            }
        } catch (Exception e) {
            System.err.println("\nERROR during setup: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
