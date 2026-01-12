package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.AmigoDAO;
import com.mycompany.recetagram.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/social/amigos")
public class AmigosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario yo = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (yo == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
            return;
        }

        try {
            AmigoDAO amigoDAO = new AmigoDAO();
            List<Usuario> amigos = amigoDAO.listarAmigos(yo.getId());

            request.setAttribute("amigos", amigos);
            request.getRequestDispatcher("/jsp/amigos.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error cargando amigos");
        }
    }
}
