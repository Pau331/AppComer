package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.AmigoDAO;
import com.mycompany.recetagram.dao.NotificacionDAO;
import com.mycompany.recetagram.model.Notificacion;
import com.mycompany.recetagram.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/social/toggleAmigo")
public class ToggleAmigoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario yo = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (yo == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
            return;
        }

        String idStr = request.getParameter("id"); // id del usuario visitado
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/explorar");
            return;
        }

        int otroId;
        try {
            otroId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
            return;
        }

        // No permitimos auto-amistad
        if (otroId == yo.getId()) {
            response.sendRedirect(request.getContextPath() + "/usu/perfil");
            return;
        }

        try {
            AmigoDAO amigoDAO = new AmigoDAO();
            NotificacionDAO notifDAO = new NotificacionDAO();
            String estadoActual = amigoDAO.getEstadoRelacion(yo.getId(), otroId);

            if (estadoActual == null) {
                // No hay relación -> Enviar solicitud
                amigoDAO.enviarSolicitud(yo.getId(), otroId);
                
                // Crear notificación
                Notificacion notif = new Notificacion();
                notif.setUsuarioDestinoId(otroId);
                notif.setUsuarioOrigenId(yo.getId());
                notif.setTipo("Solicitud de amistad");
                notif.setLeido(false);
                notifDAO.insertar(notif);
                
            } else {
                // Ya existe relación -> Eliminar (cancelar o rechazar)
                amigoDAO.eliminarRelacion(yo.getId(), otroId);
                
                // Eliminar notificaciones de solicitud en ambas direcciones
                notifDAO.eliminarNotificacion(yo.getId(), otroId, "Solicitud de amistad");
                notifDAO.eliminarNotificacion(otroId, yo.getId(), "Solicitud de amistad");
            }

            // Volvemos al perfil del usuario visitado
            response.sendRedirect(
                    request.getContextPath() + "/usu/usuario?id=" + otroId
            );

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error al actualizar amistad"
            );
        }
    }
}
