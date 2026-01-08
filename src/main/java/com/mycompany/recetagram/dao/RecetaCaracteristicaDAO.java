package com.mycompany.recetagram.dao;

import com.mycompany.recetagram.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecetaCaracteristicaDAO {

    // Asociar una característica a una receta
    public void agregarCaracteristicaReceta(int recetaId, int caracteristicaId) throws SQLException {
        String sql = "INSERT INTO receta_caracteristica(receta_id, caracteristica_id) VALUES(?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recetaId);
            ps.setInt(2, caracteristicaId);
            ps.executeUpdate();
        }
    }

    // Listar características de una receta
    public List<String> listarCaracteristicasReceta(int recetaId) throws SQLException {
        List<String> lista = new ArrayList<>();
        String sql = "SELECT c.nombre " +
                     "FROM caracteristicas c " +
                     "JOIN receta_caracteristica rc ON c.id = rc.caracteristica_id " +
                     "WHERE rc.receta_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recetaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(rs.getString("nombre"));
                }
            }
        }
        return lista;
    }

    // Eliminar todas las características de una receta
    public void eliminarCaracteristicasReceta(int recetaId) throws SQLException {
        String sql = "DELETE FROM receta_caracteristica WHERE receta_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recetaId);
            ps.executeUpdate();
        }
    }
}
