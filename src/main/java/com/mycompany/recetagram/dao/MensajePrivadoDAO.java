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
    
    // lista “contactos” con los que has hablado
    public List<Integer> listarContactos(int usuarioId) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        String sql =
            "SELECT DISTINCT CASE WHEN remitente_id=? THEN destinatario_id ELSE remitente_id END AS otro " +
            "FROM mensajes_privados WHERE remitente_id=? OR destinatario_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, usuarioId);
            ps.setInt(3, usuarioId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ids.add(rs.getInt("otro"));
        }
        return ids;
    }
    
    public void marcarLeidos(int destinatarioId, int remitenteId) throws SQLException {
        String sql = "UPDATE mensajes_privados SET leido=TRUE WHERE destinatario_id=? AND remitente_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, destinatarioId);
            ps.setInt(2, remitenteId);
            ps.executeUpdate();
        }
    }
    
    
    // conversación entre 2 usuarios
    public List<MensajePrivado> listarConversacion(int u1, int u2) throws SQLException {
        List<MensajePrivado> lista = new ArrayList<>();
        String sql =
            "SELECT * FROM mensajes_privados " +
            "WHERE (remitente_id=? AND destinatario_id=?) OR (remitente_id=? AND destinatario_id=?) " +
            "ORDER BY fecha ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, u1);
            ps.setInt(2, u2);
            ps.setInt(3, u2);
            ps.setInt(4, u1);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MensajePrivado m = new MensajePrivado();
                m.setId(rs.getInt("id"));
                m.setRemitenteId(rs.getInt("remitente_id"));
                m.setDestinatarioId(rs.getInt("destinatario_id"));
                m.setTexto(rs.getString("texto"));
                m.setFecha(rs.getTimestamp("fecha"));
                m.setLeido(rs.getBoolean("leido"));
                lista.add(m);
            }
        return lista;
        }
}}

