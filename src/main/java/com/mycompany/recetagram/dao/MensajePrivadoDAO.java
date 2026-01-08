package com.mycompany.recetagram.dao;

import com.mycompany.recetagram.model.MensajePrivado;
import com.mycompany.recetagram.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MensajePrivadoDAO {

    public void insertar(MensajePrivado m) throws SQLException {
        String sql = "INSERT INTO mensajes_privados(remitente_id, destinatario_id, texto, fecha, leido) VALUES(?,?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, m.getRemitenteId());
            ps.setInt(2, m.getDestinatarioId());
            ps.setString(3, m.getTexto());
            ps.setTimestamp(4, m.getFecha());
            ps.setBoolean(5, m.isLeido());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if(rs.next()) m.setId(rs.getInt(1));
        }
    }

    public List<MensajePrivado> listarPorUsuario(int usuarioId) throws SQLException {
        List<MensajePrivado> lista = new ArrayList<>();
        String sql = "SELECT * FROM mensajes_privados WHERE remitente_id=? OR destinatario_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, usuarioId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                MensajePrivado m = new MensajePrivado();
                m.setId(rs.getInt("id"));
                m.setRemitenteId(rs.getInt("remitente_id"));
                m.setDestinatarioId(rs.getInt("destinatario_id"));
                m.setTexto(rs.getString("texto"));
                m.setFecha(rs.getTimestamp("fecha"));
                m.setLeido(rs.getBoolean("leido"));
                lista.add(m);
            }
        }
        return lista;
    }
}
