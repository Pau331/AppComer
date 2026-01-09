package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.ComentarioDAO;
import com.mycompany.recetagram.model.Comentario;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/comentario")
public class ComentarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int recetaId = Integer.parseInt(request.getParameter("recetaId"));

            var u = (com.mycompany.recetagram.model.Usuario) request.getSession().getAttribute("usuarioLogueado");
            if (u == null) {
                response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
                return;
            }
            int usuarioId = u.getId();

            String texto = request.getParameter("texto");
            if (texto != null) texto = texto.trim();
            if (texto == null || texto.isEmpty()) {
                response.sendRedirect("verReceta?id=" + recetaId);
                return;
            }

            Comentario c = new Comentario();
            c.setRecetaId(recetaId);
            c.setUsuarioId(usuarioId);
            c.setTexto(texto);
            c.setFecha(new Timestamp(System.currentTimeMillis()));

            new ComentarioDAO().insertar(c);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("verReceta?id=" + request.getParameter("recetaId"));
    }
}
