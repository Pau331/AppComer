package com.mycompany.recetagram.dao;

import com.mycompany.recetagram.model.Comentario;
import com.mycompany.recetagram.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComentarioDAO {

    public void insertar(Comentario c) throws SQLException {
    String sql = "INSERT INTO comentarios(receta_id, usuario_id, texto) VALUES(?,?,?)";

    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

        ps.setInt(1, c.getRecetaId());
        ps.setInt(2, c.getUsuarioId());
        ps.setString(3, c.getTexto());
        ps.executeUpdate();

        ResultSet rs = ps.getGeneratedKeys();
        if (rs.next()) {
            c.setId(rs.getInt(1));
        }
    }
}


    public List<Comentario> listarPorReceta(int recetaId) throws SQLException {
        List<Comentario> lista = new ArrayList<>();
        String sql = "SELECT c.*, u.username, u.foto_perfil FROM comentarios c " +
                     "JOIN usuarios u ON u.id = c.usuario_id " +
                     "WHERE c.receta_id = ? ORDER BY c.fecha DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recetaId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                Comentario c = new Comentario();
                c.setId(rs.getInt("id"));
                c.setRecetaId(rs.getInt("receta_id"));
                c.setUsuarioId(rs.getInt("usuario_id"));
                c.setTexto(rs.getString("texto"));
                c.setFecha(rs.getTimestamp("fecha"));
                c.setUsuarioNombre(rs.getString("username"));
                c.setUsuarioFoto(rs.getString("foto_perfil"));
                lista.add(c);
            }
        }
        return lista;
    }
    
    public void borrar(int comentarioId, int usuarioId) throws SQLException {
    String sql = "DELETE FROM comentarios WHERE id = ? AND usuario_id = ?";

    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, comentarioId);
        ps.setInt(2, usuarioId);
        ps.executeUpdate();
    }
}
    
    
    public List<Comentario> listarTodos() throws SQLException {
    List<Comentario> lista = new ArrayList<>();
    String sql = "SELECT * FROM comentarios";
    try (Connection conn = DatabaseConnection.getConnection();
         Statement st = conn.createStatement();
         ResultSet rs = st.executeQuery(sql)) {
        while (rs.next()) {
            Comentario c = new Comentario();
            c.setId(rs.getInt("id"));
            c.setRecetaId(rs.getInt("receta_id"));
            c.setUsuarioId(rs.getInt("usuario_id"));
            c.setTexto(rs.getString("texto"));
            c.setFecha(rs.getTimestamp("fecha"));
            lista.add(c);
        }
    }
    return lista;
}

public boolean eliminarPorId(int id) throws SQLException {
    String sql = "DELETE FROM comentarios WHERE id = ?";
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        return ps.executeUpdate() > 0;
    }
}

}
