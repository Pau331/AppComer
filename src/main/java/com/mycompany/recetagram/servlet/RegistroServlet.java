/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.UsuarioDAO;
import com.mycompany.recetagram.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "RegistroServlet", urlPatterns = {"/usu/registro"})
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener los parámetros enviados desde registro.html
        // Asegúrate de que los campos 'name' en tu HTML coincidan con estos strings
        String user = request.getParameter("nombre_completo"); // Según tu PDF de la Parte 1
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        String confirmPass = request.getParameter("confirm_password");

        // 2. Lógica de validación (Tarea del Estudiante B)
        if (pass != null && pass.equals(confirmPass)) {
            try {
                // 3. Crear el objeto del Modelo
                Usuario nuevoUsuario = new Usuario();
                nuevoUsuario.setUsername(user);
                nuevoUsuario.setEmail(email);
                nuevoUsuario.setPassword(pass);
                nuevoUsuario.setAdmin(false); // Por defecto es un usuario normal

                // 4. Ejecutar la inserción usando tu clase UsuarioDAO
                UsuarioDAO dao = new UsuarioDAO();
                dao.insertar(nuevoUsuario);

                // 5. Redirigir al Login tras el éxito
                // Se usa contextPath para que la ruta sea siempre correcta
                response.sendRedirect(request.getContextPath() + "/html/login.html");
                
            } catch (SQLException e) {
                // Error de base de datos (ej: usuario o email ya existen)
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/html/registro.html?error=db");
            }
        } else {
            // Error: las contraseñas no coinciden
            response.sendRedirect(request.getContextPath() + "/html/registro.html?error=password");
        }
    }
}