package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.ComentarioDAO;
import com.mycompany.recetagram.dao.RecetaDAO;
import com.mycompany.recetagram.model.Comentario;
import com.mycompany.recetagram.model.Receta;

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
            List<Comentario> comentarios = new ComentarioDAO().listarPorReceta(recetaId);

            request.setAttribute("receta", receta);
            request.setAttribute("comentarios", comentarios);

            request.getRequestDispatcher("verReceta.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
