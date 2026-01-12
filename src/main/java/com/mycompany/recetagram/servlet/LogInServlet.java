
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


@WebServlet("/usu/login")
public class LogInServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Obtener parámetros del formulario 
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        
        UsuarioDAO dao = new UsuarioDAO();
        try {
            // 2. Validar contra la base de datos 
            Usuario u = dao.validar(user, pass);
            
            if (u != null) {
                // Verificar si el usuario está baneado
                if (u.isBaneado()) {
                    request.setAttribute("error", "Tu cuenta ha sido suspendida. Contacta al administrador.");
                    request.getRequestDispatcher("/jsp/logIn.jsp").forward(request, response);
                    return;
                }
                
                // 3. Éxito: Crear sesión y guardar al usuario 
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", u);
                session.setAttribute("loginSuccess", "Bienvenido/a " + u.getUsername() + "! 👋");
                
                // Redirigir
                response.sendRedirect(request.getContextPath() + "/receta/feed");

            } else {
                // 4. Error: Volver al login con un mensaje 
                request.setAttribute("error", "Usuario o contraseña incorrectos");
                request.getRequestDispatcher("/jsp/logIn.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
