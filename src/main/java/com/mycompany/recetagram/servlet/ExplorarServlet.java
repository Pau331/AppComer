package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.RecetaDAO;
import com.mycompany.recetagram.dao.UsuarioDAO;
import com.mycompany.recetagram.model.Receta;
import com.mycompany.recetagram.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/social/explorar")
public class ExplorarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario log = (session == null) ? null : (Usuario) session.getAttribute("usuarioLogueado");
        if (log == null) {
            response.sendRedirect(request.getContextPath() + "/html/login.html");
            return;
        }

        String q = request.getParameter("q");

        RecetaDAO recetaDAO = new RecetaDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();

        try {
            List<Receta> recetas = (q == null || q.isBlank()) ? recetaDAO.listarTodas() : recetaDAO.buscarPorTituloLike(q);
            List<Usuario> usuarios = (q == null || q.isBlank()) ? usuarioDAO.listarTodos() : usuarioDAO.buscarPorUsernameLike(q);

            request.setAttribute("q", q == null ? "" : q);
            request.setAttribute("recetas", recetas);
            request.setAttribute("usuarios", usuarios);

            request.getRequestDispatcher("/jsp/explorar.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}

