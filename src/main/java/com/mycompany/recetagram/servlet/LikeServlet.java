/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.LikeDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
@WebServlet("/receta/like")
public class LikeServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int recetaId = Integer.parseInt(req.getParameter("recetaId"));

        // Tomamos el usuario logueado de sesión
        var u = (com.mycompany.recetagram.model.Usuario) req.getSession().getAttribute("usuarioLogueado");
        if (u == null) {
            res.sendRedirect(req.getContextPath() + "/jsp/logIn.jsp");
            return;
        }
        int usuarioId = u.getId();

        LikeDAO dao = new LikeDAO();

        try {
            if (dao.existeLike(usuarioId, recetaId)) {
                dao.quitarLike(usuarioId, recetaId);
            } else {
                dao.darLike(usuarioId, recetaId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        res.sendRedirect(req.getContextPath() +"/receta/ver?id=" + recetaId);
    }
}
