package com.mycompany.recetagram.dao;

import com.mycompany.recetagram.model.Usuario;
import com.mycompany.recetagram.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public void insertar(Usuario u) throws SQLException {
        String sql = "INSERT INTO APP.usuarios(username,email,password,foto_perfil,biografia,isAdmin) VALUES(?,?,?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());

            // 1. Calculamos los valores por defecto
            String fotoDefault = (u.getFotoPerfil() == null || u.getFotoPerfil().isEmpty()) 
                                 ? "img/default-avatar.png" : u.getFotoPerfil();
            String bioDefault = (u.getBiografia() == null || u.getBiografia().isEmpty()) 
                                ? "¡Hola! Soy nuevo en Recetagram." : u.getBiografia();

            // 2. IMPORTANTE: Usamos las variables calculadas para la BBDD
            ps.setString(4, fotoDefault); 
            ps.setString(5, bioDefault);
            ps.setBoolean(6, u.isAdmin());

            ps.executeUpdate();

            // 3. Opcional: Actualizamos el objeto 'u' para que la sesión lo tenga listo
            u.setFotoPerfil(fotoDefault);
            u.setBiografia(bioDefault);

            ResultSet rs = ps.getGeneratedKeys();
            if(rs.next()) u.setId(rs.getInt(1));
        }
    }

    public List<Usuario> listarTodos() throws SQLException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM APP.usuarios";
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
    
    public Usuario validar(String username, String password) throws SQLException {
        String sql = "SELECT * FROM APP.usuarios WHERE username = ? AND password = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setAdmin(rs.getBoolean("isAdmin"));
                    u.setFotoPerfil(rs.getString("foto_perfil")); 
                    u.setBiografia(rs.getString("biografia"));
                    return u;
                }
            }
        }
        return null;
    }
    
    public Usuario buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM APP.usuarios WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setFotoPerfil(rs.getString("foto_perfil"));
                    u.setBiografia(rs.getString("biografia"));
                    u.setAdmin(rs.getBoolean("isAdmin"));
                    return u;
                }
            }
        }
        return null;
    }
    
    
    public boolean actualizar(Usuario u) throws SQLException {
    String sql = "UPDATE APP.usuarios SET email = ?, foto_perfil = ?, biografia = ?, username = ? WHERE id = ?";
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, u.getEmail());
        ps.setString(2, u.getFotoPerfil());
        ps.setString(3, u.getBiografia());
        ps.setString(4, u.getUsername());
        ps.setInt(5, u.getId());
        return ps.executeUpdate() > 0;
    }
}
}