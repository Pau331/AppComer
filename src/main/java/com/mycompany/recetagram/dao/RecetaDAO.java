package com.mycompany.recetagram.dao;

import com.mycompany.recetagram.model.Receta;
import com.mycompany.recetagram.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecetaDAO {

    public void insertar(Receta r) throws SQLException {
        String sql = "INSERT INTO recetas(usuario_id, titulo, pasos, tiempo_preparacion, dificultad, likes) VALUES(?,?,?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getUsuarioId());
            ps.setString(2, r.getTitulo());
            ps.setString(3, r.getPasos());
            ps.setInt(4, r.getTiempoPreparacion());
            ps.setString(5, r.getDificultad());
            ps.setInt(6, r.getLikes());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if(rs.next()) r.setId(rs.getInt(1));
        }
    }

    public List<Receta> listarTodos() throws SQLException {
        List<Receta> lista = new ArrayList<>();
        String sql = "SELECT * FROM recetas";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while(rs.next()){
                Receta r = new Receta();
                r.setId(rs.getInt("id"));
                r.setUsuarioId(rs.getInt("usuario_id"));
                r.setTitulo(rs.getString("titulo"));
                r.setPasos(rs.getString("pasos"));
                r.setTiempoPreparacion(rs.getInt("tiempo_preparacion"));
                r.setDificultad(rs.getString("dificultad"));
                r.setLikes(rs.getInt("likes"));
                lista.add(r);
            }
        }
        return lista;
    }
}
