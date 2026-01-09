package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.ComentarioDAO;
import com.mycompany.recetagram.dao.RecetaDAO;
import com.mycompany.recetagram.dao.LikeDAO;
import com.mycompany.recetagram.model.Comentario;
import com.mycompany.recetagram.model.Receta;
import com.mycompany.recetagram.model.Usuario;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/verReceta")
public class VerRecetaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int recetaId = Integer.parseInt(request.getParameter("id"));

            Receta receta = new RecetaDAO().obtenerPorId(recetaId);
            if (receta == null) {
                response.sendRedirect(request.getContextPath() + "/feed");
                return;
            }

            List<Comentario> comentarios = new ComentarioDAO().listarPorReceta(recetaId);

            // Saber si el usuario actual ya dio like
            Usuario u = (Usuario) request.getSession().getAttribute("usuarioLogueado");
            boolean liked = false;
            if (u != null) {
                liked = new LikeDAO().existeLike(u.getId(), recetaId);
            }

            request.setAttribute("receta", receta);
            request.setAttribute("comentarios", comentarios);
            request.setAttribute("liked", liked);

            request.getRequestDispatcher("/jsp/verReceta.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/feed");
        }
    }
}
