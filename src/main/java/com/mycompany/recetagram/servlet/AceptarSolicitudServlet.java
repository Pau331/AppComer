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

@WebServlet("/social/aceptarSolicitud")
public class AceptarSolicitudServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario yo = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (yo == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
            return;
        }

        String idStr = request.getParameter("id"); // id del usuario que envió la solicitud
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/receta/explorar");
            return;
        }

        int otroId;
        try {
            otroId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
            return;
        }

        try {
            AmigoDAO amigoDAO = new AmigoDAO();
            NotificacionDAO notifDAO = new NotificacionDAO();
            
            // Aceptar la solicitud
            amigoDAO.aceptarSolicitud(yo.getId(), otroId);
            
            // Eliminar la notificación de "Solicitud de amistad"
            notifDAO.eliminarNotificacion(yo.getId(), otroId, "Solicitud de amistad");
            
            // Crear notificación para el otro usuario
            Notificacion notif = new Notificacion();
            notif.setUsuarioDestinoId(otroId);
            notif.setUsuarioOrigenId(yo.getId());
            notif.setTipo("Eres amigo de...");
            notif.setLeido(false);
            notifDAO.insertar(notif);

            // Volver al perfil del usuario
            response.sendRedirect(
                    request.getContextPath() + "/usu/usuario?id=" + otroId
            );

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error al aceptar solicitud"
            );
        }
    }
}
