package com.example.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Scanner;

public class CloudSetup {
    private static final String BASE_URL = "jdbc:mysql://mysql-127361a7-niwemugeniadeline98-4119.c.aivencloud.com:18535/defaultdb?useSSL=true&allowMultiQueries=true";
    private static final String USER = "avnadmin";
    private static final String TARGET_DB = "complaint_system";

    public static void main(String[] args) {
        String pass = System.getenv("DB_PASS");
        if (pass == null || pass.isEmpty()) {
            System.out.println("--- Cloud Database Setup Fix ---");
            System.out.print("Please Enter Aiven MySQL password: ");
            Scanner scanner = new Scanner(System.in);
            if (scanner.hasNext())
                pass = scanner.next();
        }

        if (pass == null || pass.isEmpty())
            return;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(BASE_URL, USER, pass);
                    Statement stmt = conn.createStatement()) {

                System.out.println("CONNECTED to Aiven.");

                // 1. Force recreate database
                System.out.println("Ensuring database " + TARGET_DB + " exists...");
                stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS " + TARGET_DB);
                stmt.execute("USE " + TARGET_DB);

                // 2. Read SQL file and remove comments line-by-line
                System.out.println("Reading and cleaning database_setup.sql...");
                BufferedReader reader = new BufferedReader(new FileReader("database_setup.sql"));
                StringBuilder cleanSql = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    String trimmed = line.trim();
                    if (!trimmed.isEmpty() && !trimmed.startsWith("--") && !trimmed.startsWith("#")) {
                        cleanSql.append(line).append("\n");
                    }
                }
                reader.close();

                // 3. Execute queries
                String[] queries = cleanSql.toString().split(";");
                int count = 0;
                for (String qRaw : queries) {
                    String q = qRaw.trim();
                    if (q.isEmpty() || q.toUpperCase().startsWith("USE ")
                            || q.toUpperCase().startsWith("CREATE DATABASE ")) {
                        continue;
                    }

                    try {
                        System.out.print("Executing query " + (++count) + ": "
                                + (q.length() > 60 ? q.substring(0, 60).replace("\n", " ") + "..."
                                        : q.replace("\n", " ")));
                        stmt.execute(q);
                        System.out.println(" [OK]");
                    } catch (Exception e) {
                        System.out.println(" [FAILED]");
                        System.err.println("   Error: " + e.getMessage());
                    }
                }

                System.out.println("\nSUCCESS: " + count + " queries processed.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
