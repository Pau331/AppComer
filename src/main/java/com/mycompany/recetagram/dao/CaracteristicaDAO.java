package com.mycompany.recetagram.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CaracteristicaDAO {

    private Connection conn;

    public CaracteristicaDAO(Connection conn) {
        this.conn = conn;
    }

    // Crear una característica nueva
    public void crearCaracteristica(String nombre) throws SQLException {
        String sql = "INSERT INTO caracteristicas(nombre) VALUES(?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.executeUpdate();
        }
    }

    // Listar todas las características
    public List<String> listarCaracteristicas() throws SQLException {
        List<String> lista = new ArrayList<>();
        String sql = "SELECT nombre FROM caracteristicas";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                lista.add(rs.getString("nombre"));
            }
        }
        return lista;
    }

    // Eliminar característica por nombre
    public void eliminarCaracteristica(String nombre) throws SQLException {
        String sql = "DELETE FROM caracteristicas WHERE nombre = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.executeUpdate();
        }
    }
}
