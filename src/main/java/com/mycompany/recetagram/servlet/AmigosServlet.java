package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.AmigoDAO;
import com.mycompany.recetagram.dao.UsuarioDAO;
import com.mycompany.recetagram.model.Amigo;
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario log = (session == null) ? null : (Usuario) session.getAttribute("usuarioLogueado");
        if (log == null) {
            response.sendRedirect(request.getContextPath() + "/html/login.html");
            return;
        }

        String q = request.getParameter("q");

        AmigoDAO amigoDAO = new AmigoDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();

        try {
            List<Usuario> encontrados = (q == null || q.isBlank()) ? List.of() : usuarioDAO.buscarPorUsernameLike(q);

            List<Amigo> solicitudes = amigoDAO.listarSolicitudesRecibidas(log.getId());
            List<Amigo> amigos = amigoDAO.listarAmigosAceptados(log.getId());

            request.setAttribute("q", q == null ? "" : q);
            request.setAttribute("encontrados", encontrados);
            request.setAttribute("solicitudes", solicitudes);
            request.setAttribute("amigos", amigos);

            request.getRequestDispatcher("/jsp/amigos.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario log = (session == null) ? null : (Usuario) session.getAttribute("usuarioLogueado");
        if (log == null) {
            response.sendRedirect(request.getContextPath() + "/html/login.html");
            return;
        }

        String accion = request.getParameter("accion");
        AmigoDAO amigoDAO = new AmigoDAO();

        try {
            if ("solicitar".equals(accion)) {
                int targetId = Integer.parseInt(request.getParameter("targetId"));
                if (targetId != log.getId() && !amigoDAO.existeRelacion(log.getId(), targetId)) {
                    Amigo a = new Amigo();
                    a.setUsuarioId(log.getId());
                    a.setAmigoId(targetId);
                    a.setEstado("Pendiente");
                    amigoDAO.insertar(a);
                }

            } else if ("aceptar".equals(accion)) {
                int amistadId = Integer.parseInt(request.getParameter("amistadId"));
                amigoDAO.actualizarEstado(amistadId, "Aceptado");

            } else if ("rechazar".equals(accion)) {
                int amistadId = Integer.parseInt(request.getParameter("amistadId"));
                amigoDAO.actualizarEstado(amistadId, "Rechazado");
            }

            response.sendRedirect(request.getContextPath() + "/social/amigos");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}

