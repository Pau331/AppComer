/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.RecetaDAO;
import com.mycompany.recetagram.model.Receta;
import com.mycompany.recetagram.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/receta")
public class RecetaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Recuperar usuario logueado
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/html/login.html");
            return;
        }

        // Recuperar datos del formulario
        String titulo = request.getParameter("titulo");
        String pasos = request.getParameter("pasos");
        int tiempo = Integer.parseInt(request.getParameter("tiempo"));
        String dificultad = request.getParameter("dificultad");

        // Crear objeto receta
        Receta receta = new Receta();
        receta.setTitulo(titulo);
        receta.setPasos(pasos);
        receta.setTiempoPreparacion(tiempo);
        receta.setDificultad(dificultad);
        receta.setUsuarioId(usuario.getId()); // <--- Asociamos al usuario logueado

        try {
            RecetaDAO dao = new RecetaDAO();
            dao.crearReceta(receta);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Redirigir al feed después de crear
        response.sendRedirect(request.getContextPath() + "/menu.jsp");
    }
}
