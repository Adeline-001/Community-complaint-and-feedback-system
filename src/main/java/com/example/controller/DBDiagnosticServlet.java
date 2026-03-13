package com.example.controller;

import com.example.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/db-test")
public class DBDiagnosticServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>Database Diagnostic</h1>");

        try (Connection conn = DBConnection.getConnection()) {
            out.println("<p style='color: #10b981; font-weight: bold;'>✅ Connection Successful!</p>");
            out.println("<p><b>Database:</b> " + conn.getCatalog() + "</p>");
            out.println("<p><b>URL:</b> " + conn.getMetaData().getURL() + "</p>");
            out.println("<p><b>User:</b> " + conn.getMetaData().getUserName() + "</p>");

            // 1. Table Check
            out.println("<h2>Table Check</h2>");
            String[] commonTables = {"users", "complaints", "admins", "categories"};
            DatabaseMetaData dbmd = conn.getMetaData();
            out.println("<ul>");
            for (String table : commonTables) {
                try (ResultSet rs = dbmd.getTables(null, null, table, null)) {
                    if (rs.next()) {
                        out.println("<li style='color: #10b981;'>✅ Table '" + table + "' exists.</li>");
                    } else {
                        out.println("<li style='color: #ef4444;'>❌ Table '" + table + "' is MISSING!</li>");
                    }
                }
            }
            out.println("</ul>");

            // 2. Column Check
            out.println("<h2>Column Check</h2>");
            checkTable(conn, out, "users");
            checkTable(conn, out, "admins");

            // 3. Test Row Insertion (User)
            out.println("<h2>Registration Test (Citizen)</h2>");
            testInsert(conn, out, "users", "test_user_" + System.currentTimeMillis() + "@diag.com");

            // 4. Test Row Insertion (Admin)
            out.println("<h2>Registration Test (Admin)</h2>");
            testInsert(conn, out, "admins", "test_admin_" + System.currentTimeMillis() + "@diag.com");

            out.println("</body></html>");
        } catch (SQLException e) {
            out.println("<p style='color: #ef4444; font-weight: bold;'>❌ Connection Failed!</p>");
            out.println("<p>Check your <b>DBConnection.java</b> credentials.</p>");
            out.println("<pre style='background: #fee2e2; padding: 1rem; border-radius: 8px;'>");
            e.printStackTrace(out);
            out.println("</pre>");
            out.println("</body></html>");
        }
    }

    private void checkTable(Connection conn, PrintWriter out, String tableName) throws SQLException {
        out.println("<h3>Table: " + tableName + "</h3>");
        DatabaseMetaData dbmd = conn.getMetaData();
        try (ResultSet rs = dbmd.getColumns(null, null, tableName, null)) {
            out.println("<table border='1' style='border-collapse: collapse; width: 100%; text-align: left; margin-bottom: 1rem;'>");
            out.println("<tr style='background: #f1f5f9; color: #334155;'><th>Column</th><th>Type</th><th>Size</th><th>Nullable</th></tr>");
            boolean found = false;
            while (rs.next()) {
                found = true;
                out.println("<tr><td>" + rs.getString("COLUMN_NAME") + "</td><td>" + rs.getString("TYPE_NAME") + "</td><td>" + rs.getInt("COLUMN_SIZE") + "</td><td>" + rs.getString("IS_NULLABLE") + "</td></tr>");
            }
            out.println("</table>");
            if (!found) out.println("<p style='color: #ef4444;'>❌ Table '" + tableName + "' not found!</p>");
        }
    }

    private void testInsert(Connection conn, PrintWriter out, String table, String email) {
        String sql = "INSERT INTO " + table + " (name, email, password) VALUES (?, ?, ?)";
        if (table.equals("users")) {
            sql = "INSERT INTO users (name, email, password, phone, address, created_at) VALUES (?, ?, ?, '000', 'Test', NOW())";
        }
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, "Diagnostic");
            pst.setString(2, email);
            pst.setString(3, "pass123");
            pst.executeUpdate();
            out.println("<p style='color: #10b981;'>✅ Successfully inserted test in " + table + ": " + email + "</p>");
            
            try (PreparedStatement del = conn.prepareStatement("DELETE FROM " + table + " WHERE email = ?")) {
                del.setString(1, email);
                del.executeUpdate();
            }
        } catch (SQLException e) {
            out.println("<p style='color: #ef4444;'>❌ INSERT TEST FAILED for " + table + "!</p>");
            out.println("<pre style='background: #fee2e2; padding: 0.5rem;'>Error: " + e.getMessage() + "</pre>");
        }
    }
}
