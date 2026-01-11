package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.AmigoDAO;
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

@WebServlet("/social/usuario")
public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario yo = (session == null) ? null : (Usuario) session.getAttribute("usuarioLogueado");
        if (yo == null) {
            response.sendRedirect(request.getContextPath() + "/html/login.html");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Si te abres a ti mismo, mándalo al perfil privado
        if (id == yo.getId()) {
            response.sendRedirect(request.getContextPath() + "/usu/perfil");
            return;
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        RecetaDAO recetaDAO = new RecetaDAO();
        AmigoDAO amigoDAO = new AmigoDAO();

        try {
            Usuario u = usuarioDAO.buscarPorId(id);
            if (u == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // recetas del usuario (método lo añadimos abajo si no lo tienes)
            List<Receta> recetas = recetaDAO.listarPorUsuario(id);

            boolean esAmigo = amigoDAO.sonAmigos(yo.getId(), id);

            request.setAttribute("u", u);
            request.setAttribute("recetas", recetas);
            request.setAttribute("esAmigo", esAmigo);

            request.getRequestDispatcher("/jsp/usuario.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
