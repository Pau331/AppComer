package com.mycompany.recetagram.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseConnection {
    private static final String URL = "jdbc:derby://localhost:1527/recetagram;create=true;user=paula;password=paula";

    public static Connection getConnection() throws SQLException {
        Connection conn = DriverManager.getConnection(URL);

        // Forzar el esquema APP
        try (Statement st = conn.createStatement()) {
            st.execute("SET SCHEMA APP");
        }

        return conn;
    }
}
