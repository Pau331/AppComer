package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.AmigoDAO;
import com.mycompany.recetagram.dao.RecetaDAO;
import com.mycompany.recetagram.model.Receta;
import com.mycompany.recetagram.model.Usuario;
import com.mycompany.recetagram.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.List;

@WebServlet("/usu/usuario")
public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Seguridad: debe haber usuario logueado
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
            return;
        }

        Usuario yo = (Usuario) session.getAttribute("usuarioLogueado");

        // id del usuario visitado
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/receta/explorar");
            return;
        }

        int idVisitado;
        try {
            idVisitado = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
            return;
        }

        // Si intenta verse a sí mismo -> perfil propio
        if (idVisitado == yo.getId()) {
            response.sendRedirect(request.getContextPath() + "/usu/perfil");
            return;
        }

        try {
            Usuario visitado = obtenerUsuarioPorId(idVisitado);
            if (visitado == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Usuario no encontrado");
                return;
            }

            // Recetas del usuario visitado
            RecetaDAO recetaDAO = new RecetaDAO();
            List<Receta> recetas = recetaDAO.obtenerRecetasPorUsuario(idVisitado);

            // Estado de la relación de amistad
            AmigoDAO amigoDAO = new AmigoDAO();
            boolean sonAmigos = amigoDAO.sonAmigos(yo.getId(), idVisitado);
            String estadoRelacion = amigoDAO.getEstadoRelacion(yo.getId(), idVisitado);

            request.setAttribute("usuarioVisitado", visitado);
            request.setAttribute("recetas", recetas);
            request.setAttribute("sonAmigos", sonAmigos);
            request.setAttribute("estadoRelacion", estadoRelacion);

            request.getRequestDispatcher("/jsp/usuario.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error al cargar el usuario");
        }
    }

    private Usuario obtenerUsuarioPorId(int id) throws SQLException {
        // OJO: en tu schema la columna es foto_perfil, y en el modelo es fotoPerfil
        String sql = "SELECT id, username, email, password, foto_perfil, biografia, isAdmin FROM APP.usuarios WHERE id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) return null;

                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setPassword(rs.getString("password"));
                u.setFotoPerfil(rs.getString("foto_perfil"));
                u.setBiografia(rs.getString("biografia"));
                u.setAdmin(rs.getBoolean("isAdmin"));
                return u;
            }
        }
    }
}
