package com.mycompany.recetagram.dao;

import com.mycompany.recetagram.util.DatabaseConnection;
import java.sql.*;

public class LikeDAO {

    public boolean existeLike(int usuarioId, int recetaId) throws SQLException {
        String sql = "SELECT 1 FROM likes WHERE usuario_id=? AND receta_id=?";
        try (Connection c = DatabaseConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, recetaId);
            return ps.executeQuery().next();
        }
    }

    public void darLike(int usuarioId, int recetaId) throws SQLException {
        String sql = "INSERT INTO likes(usuario_id, receta_id) VALUES (?,?)";
        try (Connection c = DatabaseConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, recetaId);
            ps.executeUpdate();
        }
    }

    public void quitarLike(int usuarioId, int recetaId) throws SQLException {
        String sql = "DELETE FROM likes WHERE usuario_id=? AND receta_id=?";
        try (Connection c = DatabaseConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, recetaId);
            ps.executeUpdate();
        }
    }

    public void actualizarContador(int recetaId, int delta) throws SQLException {
        String sql = "UPDATE recetas SET likes = likes + ? WHERE id=?";
        try (Connection c = DatabaseConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, delta);
            ps.setInt(2, recetaId);
            ps.executeUpdate();
        }
    }
}


