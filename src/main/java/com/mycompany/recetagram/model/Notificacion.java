package com.mycompany.recetagram.model;

public class Notificacion {
    private int id;
    private int usuarioDestinoId;
    private int usuarioOrigenId;
    private String tipo;
    private boolean leido;

    // Getters y setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUsuarioDestinoId() { return usuarioDestinoId; }
    public void setUsuarioDestinoId(int usuarioDestinoId) { this.usuarioDestinoId = usuarioDestinoId; }
    public int getUsuarioOrigenId() { return usuarioOrigenId; }
    public void setUsuarioOrigenId(int usuarioOrigenId) { this.usuarioOrigenId = usuarioOrigenId; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public boolean isLeido() { return leido; }
    public void setLeido(boolean leido) { this.leido = leido; }
}
