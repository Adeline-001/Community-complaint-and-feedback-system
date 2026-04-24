package com.example.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Scanner;

public class CheckTables {
    private static final String URL = System.getenv("DB_URL") != null ? System.getenv("DB_URL")
            : "jdbc:mysql://mysql-127361a7-niwemugeniadeline98-4119.c.aivencloud.com:18535/complaint_system?useSSL=true&allowPublicKeyRetrieval=true&verifyServerCertificate=false";
    private static final String USER = "avnadmin";

    public static void main(String[] args) {
        String pass = System.getenv("DB_PASS");

        if (pass == null || pass.isEmpty()) {
            System.out.println("--- Database Content Check ---");
            System.out.print("Please Type your Aiven MySQL password and press ENTER: ");
            Scanner scanner = new Scanner(System.in);
            if (scanner.hasNext()) {
                pass = scanner.next();
            }
        }

        if (pass == null || pass.isEmpty()) {
            System.err.println("ERROR: No password provided.");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(URL, USER, pass);
                    Statement stmt = conn.createStatement()) {

                System.out.println("\n--- USERS IN CLOUD ---");
                ResultSet rsUsers = stmt.executeQuery("SELECT id, name, email FROM users");
                while (rsUsers.next()) {
                    System.out.println("ID: " + rsUsers.getInt("id") + " | Name: " + rsUsers.getString("name")
                            + " | Email: " + rsUsers.getString("email"));
                }

                System.out.println("\n--- ADMINS IN CLOUD ---");
                ResultSet rsAdmins = stmt.executeQuery("SELECT id, name, email, password FROM admins");
                while (rsAdmins.next()) {
                    System.out.println("ID: " + rsAdmins.getInt("id") + " | Name: " + rsAdmins.getString("name")
                            + " | Email: " + rsAdmins.getString("email") + " | Pwd: " + rsAdmins.getString("password"));
                }

                System.out.println("\n--- COMPLAINTS IN CLOUD ---");
                ResultSet rsComplaints = stmt.executeQuery("SELECT id, subject, status FROM complaints");
                while (rsComplaints.next()) {
                    System.out.println("ID: " + rsComplaints.getInt("id") + " | Subject: "
                            + rsComplaints.getString("subject") + " | Status: " + rsComplaints.getString("status"));
                }
            }
        } catch (Exception e) {
            System.err.println("\nERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
