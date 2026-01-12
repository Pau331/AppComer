package com.mycompany.recetagram.util;


import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DatabaseInit {

    private static final String URL =
        "jdbc:derby://localhost:1527/recetagram;create=true;user=paula;password=paula";

    public static void main(String[] args) {
        try (Connection conn = DriverManager.getConnection(URL)) {

            BufferedReader reader = new BufferedReader(
                new InputStreamReader(
                    DatabaseInit.class
                        .getClassLoader()
                        .getResourceAsStream("schema.sql")
                )
            );

            StringBuilder sql = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.startsWith("--") && !line.isEmpty()) {
                    sql.append(line).append(" ");
                }
                if (line.endsWith(";")) {
                    String stmtSQL = sql.toString().trim();
                    // Quitar el ';' final
                    if (stmtSQL.endsWith(";")) {
                        stmtSQL = stmtSQL.substring(0, stmtSQL.length() - 1);
                    }
                    try (Statement st = conn.createStatement()) {
                        st.execute(stmtSQL);
                    }
                    sql.setLength(0);
                }
            }

            System.out.println("Tablas creadas correctamente");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

    
