package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.UsuarioDAO;
import com.mycompany.recetagram.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/banearUsuario")
public class BanearUsuarioServlet extends HttpServlet {

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
        
        String idStr = request.getParameter("usuarioId");
        if (idStr == null || idStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de usuario requerido");
            return;
        }
        
        try {
            int usuarioId = Integer.parseInt(idStr);
            
            // No permitir que el admin se banee a sí mismo
            if (usuarioId == admin.getId()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No puedes banearte a ti mismo");
                return;
            }
            
            UsuarioDAO dao = new UsuarioDAO();
            dao.banearUsuario(usuarioId);
            
            // Redirigir a explorar o la página anterior
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/receta/explorar");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        } catch (SQLException ex) {
            Logger.getLogger(BanearUsuarioServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
