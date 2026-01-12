package com.mycompany.recetagram.dao;

import com.mycompany.recetagram.model.Receta;
import com.mycompany.recetagram.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecetaDAO {

    public void crearReceta(Receta r) throws SQLException {
        String sql = "INSERT INTO recetas(usuario_id, titulo, pasos, tiempo_preparacion, dificultad, foto) VALUES(?,?,?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getUsuarioId());
            ps.setString(2, r.getTitulo());
            ps.setString(3, r.getPasos());
            ps.setInt(4, r.getTiempoPreparacion());
            ps.setString(5, r.getDificultad());
            ps.setString(6, r.getFoto());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) r.setId(rs.getInt(1));
        }
    }

    public void borrarReceta(int recetaId, int usuarioId) throws SQLException {
        String sql = "DELETE FROM recetas WHERE id=? AND usuario_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recetaId);
            ps.setInt(2, usuarioId);
            ps.executeUpdate();
        }
    }

    public List<Receta> listarRecetas(int usuarioId) throws SQLException {
        List<Receta> lista = new ArrayList<>();
        String sql = "SELECT r.* FROM recetas r " +
                "JOIN amigos a ON r.usuario_id = a.amigo_id " +
                "WHERE a.usuario_id = ? AND a.estado = 'Aceptado' " +
                "ORDER BY r.id DESC";

        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, usuarioId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Receta r = new Receta();
                        r.setId(rs.getInt("id"));
                        r.setUsuarioId(rs.getInt("usuario_id"));
                        r.setTitulo(rs.getString("titulo"));
                        r.setPasos(rs.getString("pasos"));
                        r.setTiempoPreparacion(rs.getInt("tiempo_preparacion"));
                        r.setDificultad(rs.getString("dificultad"));
                        r.setFoto(rs.getString("foto"));
                        lista.add(r);
                    }
                }
            }
        }
        return lista;
    }

    public Receta obtenerPorId(int id) throws SQLException {
        String sql = "SELECT r.*, (SELECT COUNT(*) FROM likes l WHERE l.receta_id = r.id) AS likes_count " +
                "FROM recetas r WHERE r.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Receta r = new Receta();
                r.setId(rs.getInt("id"));
                r.setUsuarioId(rs.getInt("usuario_id"));
                r.setTitulo(rs.getString("titulo"));
                r.setPasos(rs.getString("pasos"));
                r.setTiempoPreparacion(rs.getInt("tiempo_preparacion"));
                r.setDificultad(rs.getString("dificultad"));
                r.setFoto(rs.getString("foto"));
                r.setLikes(rs.getInt("likes_count"));
                return r;
            }
        }
        return null;
    }

    // ✅ CORREGIDO: trae foto + likes reales
    public List<Receta> listarTodas() throws SQLException {
        List<Receta> lista = new ArrayList<>();
        String sql = "SELECT r.*, (SELECT COUNT(*) FROM likes l WHERE l.receta_id = r.id) AS likes_count " +
                "FROM recetas r ORDER BY r.id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Receta r = new Receta();
                r.setId(rs.getInt("id"));
                r.setUsuarioId(rs.getInt("usuario_id"));
                r.setTitulo(rs.getString("titulo"));
                r.setPasos(rs.getString("pasos"));
                r.setTiempoPreparacion(rs.getInt("tiempo_preparacion"));
                r.setDificultad(rs.getString("dificultad"));
                r.setFoto(rs.getString("foto"));
                r.setLikes(rs.getInt("likes_count"));
                lista.add(r);
            }
        }
        return lista;
    }

    public boolean eliminarPorId(int id) throws SQLException {
        String sql = "DELETE FROM recetas WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ✅ CORREGIDO: trae foto + likes reales
    public List<Receta> buscarPorTituloLike(String q) throws SQLException {
        List<Receta> lista = new ArrayList<>();
        String sql = "SELECT r.*, (SELECT COUNT(*) FROM likes l WHERE l.receta_id = r.id) AS likes_count " +
                "FROM recetas r WHERE LOWER(r.titulo) LIKE ? ORDER BY r.id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + (q == null ? "" : q.toLowerCase()) + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Receta r = new Receta();
                    r.setId(rs.getInt("id"));
                    r.setUsuarioId(rs.getInt("usuario_id"));
                    r.setTitulo(rs.getString("titulo"));
                    r.setPasos(rs.getString("pasos"));
                    r.setTiempoPreparacion(rs.getInt("tiempo_preparacion"));
                    r.setDificultad(rs.getString("dificultad"));
                    r.setFoto(rs.getString("foto"));
                    r.setLikes(rs.getInt("likes_count"));
                    lista.add(r);
                }
            }
        }
        return lista;
    }

    public List<Receta> obtenerRecetasPorUsuario(int usuarioId) throws SQLException {
        List<Receta> lista = new ArrayList<>();
        String sql = "SELECT r.*, (SELECT COUNT(*) FROM likes l WHERE l.receta_id = r.id) AS likes_count " +
                "FROM recetas r WHERE r.usuario_id = ? ORDER BY r.id DESC";

        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, usuarioId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Receta r = new Receta();
                        r.setId(rs.getInt("id"));
                        r.setUsuarioId(rs.getInt("usuario_id"));
                        r.setTitulo(rs.getString("titulo"));
                        r.setPasos(rs.getString("pasos"));
                        r.setTiempoPreparacion(rs.getInt("tiempo_preparacion"));
                        r.setDificultad(rs.getString("dificultad"));
                        r.setFoto(rs.getString("foto"));
                        r.setLikes(rs.getInt("likes_count"));
                        lista.add(r);
                    }
                }
            }
        }
        return lista;
    }

    public List<Receta> buscarPorCaracteristicas(String[] caracteristicas, String q) throws SQLException {
        List<Receta> lista = new ArrayList<>();
        
        // Construir SQL dinámicamente según número de características
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.id, r.usuario_id, r.titulo, r.pasos, r.tiempo_preparacion, r.dificultad, r.foto, ")
           .append("(SELECT COUNT(*) FROM likes l WHERE l.receta_id = r.id) AS likes_count ")
           .append("FROM recetas r ")
           .append("WHERE r.id IN (")
           .append("  SELECT rc.receta_id ")
           .append("  FROM receta_caracteristica rc ")
           .append("  INNER JOIN caracteristicas c ON rc.caracteristica_id = c.id ")
           .append("  WHERE c.nombre IN (");
        
        // Agregar placeholders
        for (int i = 0; i < caracteristicas.length; i++) {
            sql.append("?");
            if (i < caracteristicas.length - 1) sql.append(",");
        }
        sql.append(") ")
           .append("  GROUP BY rc.receta_id ")
           .append("  HAVING COUNT(DISTINCT c.id) = ?")
           .append(") ");
        
        // Si hay búsqueda por texto también
        if (q != null && !q.isBlank()) {
            sql.append("AND LOWER(r.titulo) LIKE ? ");
        }
        
        sql.append("ORDER BY r.id DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            // Setear características
            for (String caract : caracteristicas) {
                ps.setString(paramIndex++, caract);
            }
            
            // Setear contador de características
            ps.setInt(paramIndex++, caracteristicas.length);
            
            // Setear búsqueda de texto si existe
            if (q != null && !q.isBlank()) {
                ps.setString(paramIndex, "%" + q.toLowerCase() + "%");
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Receta r = new Receta();
                    r.setId(rs.getInt("id"));
                    r.setUsuarioId(rs.getInt("usuario_id"));
                    r.setTitulo(rs.getString("titulo"));
                    r.setPasos(rs.getString("pasos"));
                    r.setTiempoPreparacion(rs.getInt("tiempo_preparacion"));
                    r.setDificultad(rs.getString("dificultad"));
                    r.setFoto(rs.getString("foto"));
                    r.setLikes(rs.getInt("likes_count"));
                    lista.add(r);
                }
            }
        }
        return lista;
    }
}
