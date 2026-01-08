package com.mycompany.recetagram.dao;

import com.mycompany.recetagram.model.Notificacion;
import com.mycompany.recetagram.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificacionDAO {

    public void insertar(Notificacion n) throws SQLException {
        String sql = "INSERT INTO notificaciones(usuario_destino_id, usuario_origen_id, tipo, leido) VALUES(?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, n.getUsuarioDestinoId());
            ps.setInt(2, n.getUsuarioOrigenId());
            ps.setString(3, n.getTipo());
            ps.setBoolean(4, n.isLeido());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if(rs.next()) n.setId(rs.getInt(1));
        }
    }

    public List<Notificacion> listarPorUsuario(int usuarioId) throws SQLException {
        List<Notificacion> lista = new ArrayList<>();
        String sql = "SELECT * FROM notificaciones WHERE usuario_destino_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                Notificacion n = new Notificacion();
                n.setId(rs.getInt("id"));
                n.setUsuarioDestinoId(rs.getInt("usuario_destino_id"));
                n.setUsuarioOrigenId(rs.getInt("usuario_origen_id"));
                n.setTipo(rs.getString("tipo"));
                n.setLeido(rs.getBoolean("leido"));
                lista.add(n);
            }
        }
        return lista;
    }

    public boolean marcarComoLeido(int notificacionId) throws SQLException {
        String sql = "UPDATE notificaciones SET leido = TRUE WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificacionId);
            return ps.executeUpdate() > 0;
        }
    }

    public int contarNoLeidas(int usuarioId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM notificaciones WHERE usuario_destino_id = ? AND leido = FALSE";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }
}
