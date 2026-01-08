package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.*;
import com.mycompany.recetagram.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/delete")
public class AdminDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario log = (session == null) ? null : (Usuario) session.getAttribute("usuarioLogueado");

        if (log == null || !log.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String tipo = request.getParameter("tipo"); // usuario|receta|comentario
        int id = Integer.parseInt(request.getParameter("id"));

        try {
            if ("usuario".equals(tipo)) new UsuarioDAO().eliminarPorId(id);
            if ("receta".equals(tipo)) new RecetaDAO().eliminarPorId(id);
            if ("comentario".equals(tipo)) new ComentarioDAO().eliminarPorId(id);

            response.sendRedirect(request.getContextPath() + "/admin/panel");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}

