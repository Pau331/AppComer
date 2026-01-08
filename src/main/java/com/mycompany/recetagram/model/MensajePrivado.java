package com.mycompany.recetagram.model;

import java.sql.Timestamp;

public class MensajePrivado {
    private int id;
    private int remitenteId;
    private int destinatarioId;
    private String texto;
    private Timestamp fecha;
    private boolean leido;

    // Getters y setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getRemitenteId() { return remitenteId; }
    public void setRemitenteId(int remitenteId) { this.remitenteId = remitenteId; }
    public int getDestinatarioId() { return destinatarioId; }
    public void setDestinatarioId(int destinatarioId) { this.destinatarioId = destinatarioId; }
    public String getTexto() { return texto; }
    public void setTexto(String texto) { this.texto = texto; }
    public Timestamp getFecha() { return fecha; }
    public void setFecha(Timestamp fecha) { this.fecha = fecha; }
    public boolean isLeido() { return leido; }
    public void setLeido(boolean leido) { this.leido = leido; }
}
