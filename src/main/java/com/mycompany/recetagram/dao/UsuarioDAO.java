package com.mycompany.recetagram.dao;

import com.mycompany.recetagram.model.Usuario;
import com.mycompany.recetagram.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public void insertar(Usuario u) throws SQLException {
        String sql = "INSERT INTO usuarios(username,email,password,foto_perfil,biografia,isAdmin) VALUES(?,?,?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getFotoPerfil());
            ps.setString(5, u.getBiografia());
            ps.setBoolean(6, u.isAdmin());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if(rs.next()) u.setId(rs.getInt(1));
        }
    }

    public List<Usuario> listarTodos() throws SQLException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setPassword(rs.getString("password"));
                u.setFotoPerfil(rs.getString("foto_perfil"));
                u.setBiografia(rs.getString("biografia"));
                u.setAdmin(rs.getBoolean("isAdmin"));
                lista.add(u);
            }
        }
        return lista;
    }
}
