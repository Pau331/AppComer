package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.RecetaDAO;
import com.mycompany.recetagram.dao.RecetaCaracteristicaDAO;
import com.mycompany.recetagram.model.Receta;
import com.mycompany.recetagram.model.Usuario;
import com.mycompany.recetagram.model.RecetaCaracteristica;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@WebServlet("/receta")
@MultipartConfig
public class RecetaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Recuperar usuario logueado
        HttpSession session = request.getSession();
        Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/html/login.html");
            return;
        }

        try {
            // Crear objeto Receta
            Receta r = new Receta();
            r.setUsuarioId(u.getId());
            r.setTitulo(request.getParameter("titulo"));
            r.setDificultad(request.getParameter("dificultad"));

            String tiempoStr = request.getParameter("tiempo");
            try {
                r.setTiempoPreparacion(Integer.parseInt(tiempoStr.replaceAll("[^0-9]", "")));
            } catch (NumberFormatException e) {
                r.setTiempoPreparacion(0);
            }

            //Obtener pasos dinámicos
            StringBuilder pasos = new StringBuilder();
            int i = 0;
            while (true) {
                String paso = request.getParameter("paso" + i);
                if (paso == null) break;
                pasos.append((i + 1)).append(". ").append(paso).append("\n");
                i++;
            }
            r.setPasos(pasos.toString());

            // Subir foto y guardar ruta
            Part fotoPart = request.getPart("foto");
            String fotoPath = null;
            if (fotoPart != null && fotoPart.getSize() > 0) {
                String fileName = Paths.get(fotoPart.getSubmittedFileName()).getFileName().toString();
                String uploadDir = getServletContext().getRealPath("/img");
                File uploads = new File(uploadDir);
                if (!uploads.exists()) uploads.mkdirs();
                File file = new File(uploads, fileName);
                try (InputStream input = fotoPart.getInputStream()) {
                    Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                fotoPath = "img/" + fileName;
            }
            r.setFoto(fotoPath);

            // Guardar receta en DB
            RecetaDAO recetaDAO = new RecetaDAO();
            recetaDAO.crearReceta(r); // Inserta receta y actualiza r.id

            // Guardar dietas/características seleccionadas
            String[] dietas = request.getParameterValues("dietas");
            if (dietas != null && dietas.length > 0) {
                RecetaCaracteristicaDAO cDAO = new RecetaCaracteristicaDAO();
                for (String d : dietas) {
                    int caracteristicaId = cDAO.obtenerIdPorNombre(d); // obtiene el ID de la característica
                    if (caracteristicaId > 0) {
                        RecetaCaracteristica cr = new RecetaCaracteristica();
                        cr.setRecetaId(r.getId());
                        cr.setCaracteristicaId(caracteristicaId);
                        cDAO.agregarCaracteristicaReceta(cr.getRecetaId(), caracteristicaId); // Inserta en receta_caracteristica
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirigir al feed
        response.sendRedirect(request.getContextPath() + "/menu.jsp");
    }
}