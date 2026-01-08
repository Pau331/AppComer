package com.mycompany.recetagram.dao;

import com.mycompany.recetagram.model.Amigo;
import com.mycompany.recetagram.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AmigoDAO {

    public void insertar(Amigo a) throws SQLException {
        String sql = "INSERT INTO amigos(usuario_id, amigo_id, estado) VALUES(?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, a.getUsuarioId());
            ps.setInt(2, a.getAmigoId());
            ps.setString(3, a.getEstado());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if(rs.next()) a.setId(rs.getInt(1));
        }
    }

    public List<Amigo> listarPorUsuario(int usuarioId) throws SQLException {
        List<Amigo> lista = new ArrayList<>();
        String sql = "SELECT * FROM amigos WHERE usuario_id=? OR amigo_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, usuarioId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                Amigo a = new Amigo();
                a.setId(rs.getInt("id"));
                a.setUsuarioId(rs.getInt("usuario_id"));
                a.setAmigoId(rs.getInt("amigo_id"));
                a.setEstado(rs.getString("estado"));
                lista.add(a);
            }
        }
        return lista;
    }
}
