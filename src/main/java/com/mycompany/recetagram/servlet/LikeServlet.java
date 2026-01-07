/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.LikeDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
@WebServlet("/like")
public class LikeServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int recetaId = Integer.parseInt(req.getParameter("recetaId"));
        int usuarioId = (int) req.getSession().getAttribute("usuarioId");

        LikeDAO dao = new LikeDAO();

        try {
            if (dao.existeLike(usuarioId, recetaId)) {
                dao.quitarLike(usuarioId, recetaId);
                dao.actualizarContador(recetaId, -1);
            } else {
                dao.darLike(usuarioId, recetaId);
                dao.actualizarContador(recetaId, +1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        res.sendRedirect("verReceta?id=" + recetaId);
    }
}
