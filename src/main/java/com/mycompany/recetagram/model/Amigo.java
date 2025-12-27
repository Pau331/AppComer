package com.mycompany.recetagram.model;

public class Amigo {
    private int id;
    private int usuarioId;
    private int amigoId;
    private String estado;

    // Getters y setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }
    public int getAmigoId() { return amigoId; }
    public void setAmigoId(int amigoId) { this.amigoId = amigoId; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
