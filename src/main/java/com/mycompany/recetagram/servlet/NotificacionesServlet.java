package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.NotificacionDAO;
import com.mycompany.recetagram.dao.UsuarioDAO;
import com.mycompany.recetagram.model.Notificacion;
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
import java.util.List;

@WebServlet("/notificaciones")
public class NotificacionesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
        int usuarioId = u.getId();

        NotificacionDAO ndao = new NotificacionDAO();
        UsuarioDAO udao = new UsuarioDAO();

        try (PrintWriter out = resp.getWriter()) {
            List<Notificacion> lista = ndao.listarPorUsuario(usuarioId);
            StringBuilder sb = new StringBuilder();
            sb.append('[');
            boolean first = true;
            for (Notificacion n : lista) {
                if (!first) sb.append(',');
                first = false;

                // origen info
                String origenName = "Usuario";
                String avatar = req.getContextPath() + "/img/default-avatar.png";
                try {
                    Usuario origen = udao.buscarPorId(n.getUsuarioOrigenId());
                    if (origen != null) {
                        origenName = origen.getUsername();
                        String foto = origen.getFotoPerfil();
                        if (foto != null && !foto.isEmpty()) {
                            if (foto.startsWith("/")) foto = foto.substring(1);
                            if (!foto.startsWith("img/")) foto = "img/" + foto;
                            avatar = req.getContextPath() + "/" + foto;
                        }
                    }
                } catch (Exception ex) {
                    // ignore, use defaults
                }

                sb.append('{')
                  .append("\"id\":").append(n.getId()).append(',')
                  .append("\"tipo\":\"").append(escapeJson(n.getTipo())).append("\",")
                  .append("\"leido\":").append(n.isLeido()).append(',')
                  .append("\"origen\":{")
                      .append("\"id\":").append(n.getUsuarioOrigenId()).append(',')
                      .append("\"username\":\"").append(escapeJson(origenName)).append("\",")
                      .append("\"avatar\":\"").append(escapeJson(avatar)).append("\"")
                  .append('}')
                .append('}');
            }
            sb.append(']');
            out.print(sb.toString());
        } catch (SQLException e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
