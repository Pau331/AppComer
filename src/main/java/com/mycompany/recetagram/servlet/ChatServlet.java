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
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/social/chat")
public class ChatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario yo = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (yo == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
            return;
        }

        String withStr = request.getParameter("with");
        Integer withId = null;
        if (withStr != null && !withStr.isBlank()) {
            try {
                withId = Integer.parseInt(withStr);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
                return;
            }
            if (withId == yo.getId()) {
                withId = null; // no chat contigo mismo
            }
        }

        try {
            MensajePrivadoDAO mpDAO = new MensajePrivadoDAO();
            UsuarioDAO usuarioDAO = new UsuarioDAO();

            // 1) Contactos = usuarios con los que ya has hablado
            List<Integer> idsContactos = mpDAO.listarContactos(yo.getId());

            // 2) Si vienes desde Amigos con ?with=ID, lo metemos en la lista aunque no haya mensajes aún
            Set<Integer> set = new LinkedHashSet<>(idsContactos);
            if (withId != null) set.add(withId);

            List<Usuario> contactos = new ArrayList<>();
            for (Integer id : set) {
                Usuario u = usuarioDAO.buscarPorId(id);
                if (u != null) contactos.add(u);
            }

            // 3) Si hay conversación seleccionada
            Usuario conUsuario = null;
            List<MensajePrivado> conversacion = null;

            if (withId != null) {
                conUsuario = usuarioDAO.buscarPorId(withId);
                if (conUsuario != null) {
                    conversacion = mpDAO.listarConversacion(yo.getId(), withId);
                    // marcar como leídos los mensajes que te mandó "conUsuario"
                    mpDAO.marcarLeidos(yo.getId(), withId);
                }
            }

            request.setAttribute("contactos", contactos);
            request.setAttribute("conUsuario", conUsuario);
            request.setAttribute("conversacion", conversacion);

            request.getRequestDispatcher("/jsp/chat.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error cargando chat");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario yo = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (yo == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
            return;
        }

        String conStr = request.getParameter("con");  // id destinatario
        String texto = request.getParameter("texto");

        if (conStr == null || conStr.isBlank() || texto == null || texto.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/social/chat");
            return;
        }

        int conId;
        try {
            conId = Integer.parseInt(conStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
            return;
        }

        if (conId == yo.getId()) {
            response.sendRedirect(request.getContextPath() + "/social/chat");
            return;
        }

        try {
            MensajePrivadoDAO mpDAO = new MensajePrivadoDAO();

            MensajePrivado m = new MensajePrivado();
            m.setRemitenteId(yo.getId());
            m.setDestinatarioId(conId);
            m.setTexto(texto.trim());
            m.setLeido(false);

            mpDAO.insertar(m);

            response.sendRedirect(request.getContextPath() + "/social/chat?with=" + conId);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error enviando mensaje");
        }
    }
}

