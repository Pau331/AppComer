package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.NotificacionDAO;
import com.mycompany.recetagram.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/notificacion/marcarLeido")
public class MarcarNotificacionLeidaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int id = Integer.parseInt(idParam);
        NotificacionDAO ndao = new NotificacionDAO();
        try (PrintWriter out = resp.getWriter()) {
            boolean ok = ndao.marcarComoLeido(id);
            int restantes = ndao.contarNoLeidas(u.getId());
            out.print("{\"ok\":" + ok + ",\"restantes\":" + restantes + "}");
        } catch (SQLException e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
