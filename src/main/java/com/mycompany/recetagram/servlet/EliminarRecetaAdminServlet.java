package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.RecetaDAO;
import com.mycompany.recetagram.dao.NotificacionDAO;
import com.mycompany.recetagram.model.Usuario;
import com.mycompany.recetagram.model.Receta;
import com.mycompany.recetagram.model.Notificacion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/eliminarReceta")
public class EliminarRecetaAdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario admin = (Usuario) session.getAttribute("usuarioLogueado");
        
        // Verificar que sea admin
        if (admin == null || !admin.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }
        
        String idStr = request.getParameter("recetaId");
        if (idStr == null || idStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de receta requerido");
            return;
        }
        
        try {
            int recetaId = Integer.parseInt(idStr);
            RecetaDAO recetaDAO = new RecetaDAO();
            NotificacionDAO notifDAO = new NotificacionDAO();
            
            try {
                // Obtener la receta antes de eliminarla para saber el autor y título
                Receta receta = recetaDAO.buscarPorId(recetaId);
                
                if (receta != null) {
                    // Crear notificación para el autor
                    Notificacion notif = new Notificacion();
                    notif.setUsuarioDestinoId(receta.getUsuarioId());
                    notif.setUsuarioOrigenId(admin.getId());
                    notif.setTipo("Receta eliminada");
                    notif.setMensaje("Tu receta \"" + receta.getTitulo() + "\" fue eliminada por no cumplir las políticas de Recetagram");
                    notif.setLeido(false);
                    notifDAO.insertar(notif);
                }
                
                // Eliminar la receta
                recetaDAO.eliminarReceta(recetaId);
                
            } catch (SQLException ex) {
                Logger.getLogger(EliminarRecetaAdminServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            // Redirigir al feed o explorar
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/receta/feed");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    }
}
