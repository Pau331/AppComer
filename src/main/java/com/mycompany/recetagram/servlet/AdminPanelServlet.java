package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.*;
import com.mycompany.recetagram.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/panel")
public class AdminPanelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario log = (session == null) ? null : (Usuario) session.getAttribute("usuarioLogueado");

        if (log == null || !log.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            List<Usuario> usuarios = new UsuarioDAO().listarTodos();
            List<Receta> recetas = new RecetaDAO().listarTodas();
            List<Comentario> comentarios = new ComentarioDAO().listarTodos();

            request.setAttribute("usuarios", usuarios);
            request.setAttribute("recetas", recetas);
            request.setAttribute("comentarios", comentarios);

            request.getRequestDispatcher("/jsp/admin.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
