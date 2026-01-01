/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.recetagram.servlet;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/usu/logout")
public class LogOutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener la sesión actual si existe
        HttpSession session = request.getSession(false);

        if (session != null) {
            // 2. Lógica de Seguridad: Invalidar (destruir) la sesión
            // Esto borra todos los atributos (como 'usuarioLogueado') del servidor
            session.invalidate(); 
        }

        // 3. Redirigir a la página de inicio (index.html) como indica la API
        // Usamos contextPath para asegurar que la ruta sea correcta
        response.sendRedirect(request.getContextPath() + "/index.html");
    }
}