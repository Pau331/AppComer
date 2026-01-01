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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/usu/perfil")
public class PerfilServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Recuperar la sesión actual
        HttpSession session = request.getSession(false);
        
        // 2. Comprobar si existe el usuario (Seguridad)
        if (session != null && session.getAttribute("usuarioLogueado") != null) {
            // El usuario está identificado, la app "sabe que es él"
            Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
            
            // 3. Pasar el objeto a la vista (JSP)
            request.setAttribute("perfil", u);
            request.getRequestDispatcher("/jsp/perfil.jsp").forward(request, response);
        } else {
            // Si no hay sesión, redirigir al login
            response.sendRedirect(request.getContextPath() + "/html/login.html");
        }
    }
}