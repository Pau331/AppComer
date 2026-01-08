package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.MensajePrivadoDAO;
import com.mycompany.recetagram.dao.UsuarioDAO;
import com.mycompany.recetagram.model.MensajePrivado;
import com.mycompany.recetagram.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/social/chat")
public class ChatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario log = (session == null) ? null : (Usuario) session.getAttribute("usuarioLogueado");
        if (log == null) {
            response.sendRedirect(request.getContextPath() + "/html/login.html");
            return;
        }

        MensajePrivadoDAO mpDAO = new MensajePrivadoDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();

        try {
            List<Integer> contactosIds = mpDAO.listarContactos(log.getId());
            List<Usuario> contactos = new ArrayList<>();
            for (Integer id : contactosIds) {
                Usuario u = usuarioDAO.buscarPorId(id);
                if (u != null) contactos.add(u);
            }

            String conStr = request.getParameter("con");
            Integer conId = (conStr == null || conStr.isBlank()) ? null : Integer.parseInt(conStr);

            // si no hay seleccionado, el primero
            if (conId == null && !contactos.isEmpty()) conId = contactos.get(0).getId();

            List<MensajePrivado> conversacion = new ArrayList<>();
            Usuario conUsuario = null;
            if (conId != null) {
                conUsuario = usuarioDAO.buscarPorId(conId);
                conversacion = mpDAO.listarConversacion(log.getId(), conId);
                mpDAO.marcarLeidos(log.getId(), conId);
            }

            request.setAttribute("contactos", contactos);
            request.setAttribute("conUsuario", conUsuario);
            request.setAttribute("conversacion", conversacion);

            request.getRequestDispatcher("/jsp/chat.jsp").forward(request, response);

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

        String texto = request.getParameter("texto");
        String conStr = request.getParameter("con");

        if (texto == null || texto.isBlank() || conStr == null) {
            response.sendRedirect(request.getContextPath() + "/social/chat");
            return;
        }

        int conId = Integer.parseInt(conStr);

        try {
            MensajePrivado m = new MensajePrivado();
            m.setRemitenteId(log.getId());
            m.setDestinatarioId(conId);
            m.setTexto(texto);
            m.setFecha(new Timestamp(System.currentTimeMillis()));
            m.setLeido(false);

            new MensajePrivadoDAO().insertar(m);

            response.sendRedirect(request.getContextPath() + "/social/chat?con=" + conId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}

