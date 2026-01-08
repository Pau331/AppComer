package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.RecetaDAO;
import com.mycompany.recetagram.model.Receta;
import com.mycompany.recetagram.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException; 
import java.util.ArrayList;
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
            response.sendRedirect(request.getContextPath() + "/html/login.html");
            return;
        }

        RecetaDAO rDAO = new RecetaDAO();
        List<Receta> recetas = new ArrayList<>();
        try {
            recetas = rDAO.listarRecetas(u.getId());
            System.out.println("Recetas encontradas: " + recetas.size()); // Para depurar
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("recetas", recetas);

        // Forward al JSP principal
        request.getRequestDispatcher("/jsp/menu.jsp").forward(request, response);


    }
}
