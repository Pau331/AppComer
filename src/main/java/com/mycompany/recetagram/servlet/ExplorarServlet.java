package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.RecetaDAO;
import com.mycompany.recetagram.dao.UsuarioDAO;
import com.mycompany.recetagram.model.Receta;
import com.mycompany.recetagram.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/social/explorar")
public class ExplorarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario log = (session == null) ? null : (Usuario) session.getAttribute("usuarioLogueado");
        if (log == null) {
            response.sendRedirect(request.getContextPath() + "/html/login.html");
            return;
        }

        String q = request.getParameter("q");
        String[] caracteristicas = request.getParameterValues("caracteristica");

        RecetaDAO recetaDAO = new RecetaDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();

        try {
            List<Receta> recetas;
            
            // Si hay filtros de características
            if (caracteristicas != null && caracteristicas.length > 0) {
                recetas = recetaDAO.buscarPorCaracteristicas(caracteristicas, q);
            } else {
                // Búsqueda normal
                recetas = (q == null || q.isBlank())
                        ? recetaDAO.listarTodas()
                        : recetaDAO.buscarPorTituloLike(q);
            }

            List<Usuario> usuarios = (q == null || q.isBlank())
                    ? usuarioDAO.listarTodos()
                    : usuarioDAO.buscarPorUsernameLike(q);

            // ✅ Autores por userId (para username/avatar en recetas)
            Map<Integer, Usuario> autores = new HashMap<>();
            for (Receta r : recetas) {
                int uid = r.getUsuarioId();
                if (!autores.containsKey(uid)) {
                    Usuario autor = usuarioDAO.buscarPorId(uid);
                    if (autor != null) autores.put(uid, autor);
                }
            }

            request.setAttribute("q", q == null ? "" : q);
            request.setAttribute("recetas", recetas);
            request.setAttribute("usuarios", usuarios);
            request.setAttribute("autores", autores);

            request.getRequestDispatcher("/jsp/explorar.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
