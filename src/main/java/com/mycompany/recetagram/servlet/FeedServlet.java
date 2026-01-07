package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.RecetaDAO;
import com.mycompany.recetagram.model.Receta;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/feed")
public class FeedServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            List<Receta> recetas = new RecetaDAO().listarTodas();
            request.setAttribute("recetas", recetas);
            request.getRequestDispatcher("feed.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

