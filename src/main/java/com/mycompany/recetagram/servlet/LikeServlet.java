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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int recetaId = Integer.parseInt(request.getParameter("recetaId"));
            new LikeDAO().darLike(recetaId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("verReceta?id=" + request.getParameter("recetaId"));
    }
}
