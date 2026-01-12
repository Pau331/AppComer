package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.*;
import com.mycompany.recetagram.model.Usuario;
import com.mycompany.recetagram.model.Comentario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/delete")
public class AdminDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario log = (session == null) ? null : (Usuario) session.getAttribute("usuarioLogueado");

        if (log == null || !log.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String tipo = request.getParameter("tipo"); // usuario|receta|comentario
        int id = Integer.parseInt(request.getParameter("id"));
        String redirectUrl = request.getContextPath() + "/admin/panel"; // default

        try {
            if ("usuario".equals(tipo)) new UsuarioDAO().eliminarPorId(id);
            if ("receta".equals(tipo)) new RecetaDAO().eliminarPorId(id);
            if ("comentario".equals(tipo)) {
                // Obtener información del comentario antes de eliminarlo
                ComentarioDAO comentarioDAO = new ComentarioDAO();
                Comentario comentario = comentarioDAO.obtenerPorId(id);
                
                if (comentario != null) {
                    int recetaId = comentario.getRecetaId();
                    
                    // Eliminar el comentario
                    comentarioDAO.eliminarPorId(id);
                    
                    // Enviar notificación del sistema al usuario
                    NotificacionDAO notifDAO = new NotificacionDAO();
                    String mensaje = "Tu comentario ha sido eliminado por el administrador.";
                    notifDAO.insertarNotificacionSistema(
                        comentario.getUsuarioId(),
                        "Comentario eliminado",
                        mensaje
                    );
                    
                    // Redirigir siempre a la receta
                    redirectUrl = request.getContextPath() + "/receta/ver?id=" + recetaId;
                }
            }

            response.sendRedirect(redirectUrl);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}

