package com.mycompany.recetagram.dao;

import com.mycompany.recetagram.model.Usuario;
import com.mycompany.recetagram.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AmigoDAO {

    /** True si existe amistad aceptada entre u1 y u2 (en cualquier dirección). */
    public boolean sonAmigos(int u1, int u2) throws SQLException {
        if (u1 == u2) return false;

        String sql = "SELECT 1 FROM APP.amigos WHERE " +
                     "((usuario_id=? AND amigo_id=?) OR (usuario_id=? AND amigo_id=?)) " +
                     "AND estado='Aceptado'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, u1);
            ps.setInt(2, u2);
            ps.setInt(3, u2);
            ps.setInt(4, u1);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Obtiene el estado de la relación: null, "Pendiente", o "Aceptado". 
     * Retorna el estado desde la perspectiva de u1 hacia u2. */
    public String getEstadoRelacion(int u1, int u2) throws SQLException {
        if (u1 == u2) return null;

        // Verificar si u1 envió solicitud a u2
        String sql = "SELECT estado FROM APP.amigos WHERE usuario_id=? AND amigo_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, u1);
            ps.setInt(2, u2);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("estado");
            }
        }

        // Verificar si u2 envió solicitud a u1
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, u2);
            ps.setInt(2, u1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String estado = rs.getString("estado");
                    // Si u2 envió solicitud a u1, u1 debe verla como "Solicitud recibida"
                    return estado.equals("Pendiente") ? "Solicitud recibida" : estado;
                }
            }
        }
        
        return null;
    }

    /** Envía solicitud de amistad de u1 a u2. */
    public void enviarSolicitud(int u1, int u2) throws SQLException {
        if (u1 == u2) return;

        String sql = "INSERT INTO APP.amigos(usuario_id, amigo_id, estado) VALUES(?, ?, 'Pendiente')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, u1);
            ps.setInt(2, u2);
            ps.executeUpdate();
        }
    }

    /** Acepta solicitud de amistad. u1 acepta la solicitud que u2 le envió. */
    public void aceptarSolicitud(int u1, int u2) throws SQLException {
        String sql = "UPDATE APP.amigos SET estado='Aceptado' WHERE usuario_id=? AND amigo_id=? AND estado='Pendiente'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, u2);  // u2 envió la solicitud
            ps.setInt(2, u1);  // u1 la recibe
            ps.executeUpdate();
        }
    }

    /** Cancela o rechaza solicitud. Elimina la relación. */
    public void eliminarRelacion(int u1, int u2) throws SQLException {
        String sql = "DELETE FROM APP.amigos WHERE " +
                     "(usuario_id=? AND amigo_id=?) OR (usuario_id=? AND amigo_id=?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, u1);
            ps.setInt(2, u2);
            ps.setInt(3, u2);
            ps.setInt(4, u1);
            ps.executeUpdate();
        }
    }

    /** Lista de amigos del usuario (solo aceptados). */
    public List<Usuario> listarAmigos(int userId) throws SQLException {
        String sql =
            "SELECT u.id, u.username, u.email, u.password, u.foto_perfil, u.biografia, u.isAdmin " +
            "FROM APP.usuarios u " +
            "WHERE u.id IN ( " +
            "   SELECT CASE " +
            "       WHEN a.usuario_id = ? THEN a.amigo_id " +
            "       ELSE a.usuario_id " +
            "   END AS friend_id " +
            "   FROM APP.amigos a " +
            "   WHERE a.estado='Aceptado' AND (a.usuario_id=? OR a.amigo_id=?) " +
            ") " +
            "ORDER BY u.username";

        List<Usuario> amigos = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setFotoPerfil(rs.getString("foto_perfil"));
                    u.setBiografia(rs.getString("biografia"));
                    u.setAdmin(rs.getBoolean("isAdmin"));
                    amigos.add(u);
                }
            }
        }

        return amigos;
    }
}
