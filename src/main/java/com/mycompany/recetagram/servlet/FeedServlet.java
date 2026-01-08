package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.RecetaDAO;
import com.mycompany.recetagram.model.Receta;
import com.mycompany.recetagram.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException; 
import java.util.List;

@WebServlet("/feed")
public class FeedServlet extends HttpServlet {

    private static final long serialVersionUID = 1L; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener usuario logueado
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
        if (u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Obtener recetas de amigos
        RecetaDAO rDAO = new RecetaDAO();
        try {
            List<Receta> recetas = rDAO.listarRecetas(u.getId());
            request.setAttribute("recetas", recetas);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "No se pudieron cargar las recetas.");
        }

        // Forward a JSP
        request.getRequestDispatcher("menu.jsp").forward(request, response);
    }
}
