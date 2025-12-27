package com.mycompany.recetagram.model;

import java.sql.Timestamp;

public class Comentario {
    private int id;
    private int recetaId;
    private int usuarioId;
    private String texto;
    private Timestamp fecha;

    // Getters y setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getRecetaId() { return recetaId; }
    public void setRecetaId(int recetaId) { this.recetaId = recetaId; }
    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }
    public String getTexto() { return texto; }
    public void setTexto(String texto) { this.texto = texto; }
    public Timestamp getFecha() { return fecha; }
    public void setFecha(Timestamp fecha) { this.fecha = fecha; }
}
