package com.mycompany.recetagram.model;

public class Receta {
    private int id;
    private int usuarioId;
    private String titulo;
    private String pasos;
    private int tiempoPreparacion;
    private String dificultad;
    private int likes;
    private String foto;


    // Getters y setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    public String getPasos() { return pasos; }
    public void setPasos(String pasos) { this.pasos = pasos; }
    public int getTiempoPreparacion() { return tiempoPreparacion; }
    public void setTiempoPreparacion(int tiempoPreparacion) { this.tiempoPreparacion = tiempoPreparacion; }
    public String getDificultad() { return dificultad; }
    public void setDificultad(String dificultad) { this.dificultad = dificultad; }
    public int getLikes() { return likes; }
    public void setLikes(int likes) { this.likes = likes; }
    public String getFotoPerfil() { return foto; }
    public void setFotoPerfil(String foto) { this.foto = foto; }
   
}

