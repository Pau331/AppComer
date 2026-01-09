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
import java.sql.SQLException;

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

            //Obtener pasos
            String pasosStr = request.getParameter("pasos");
            StringBuilder pasos = new StringBuilder();
            if (pasosStr != null && !pasosStr.isEmpty()) {
                String[] pasosArray = pasosStr.split("\\|");
                for (int i = 0; i < pasosArray.length; i++) {
                    pasos.append((i + 1)).append(". ").append(pasosArray[i]).append("\n");
                }
            }
            r.setPasos(pasos.toString());
            System.out.println("RecetaServlet: Pasos capturados = " + pasos.toString());

            // Subir foto y guardar ruta
            Part fotoPart = request.getPart("foto");
            String fotoPath = null;
            if (fotoPart != null && fotoPart.getSize() > 0 && fotoPart.getSubmittedFileName() != null) {
                String fileName = Paths.get(fotoPart.getSubmittedFileName()).getFileName().toString();
                String uploadDir = getServletContext().getRealPath("/img");
                if (uploadDir != null) {
                    File uploads = new File(uploadDir);
                    if (!uploads.exists()) uploads.mkdirs();
                    File file = new File(uploads, fileName);
                    try (InputStream input = fotoPart.getInputStream()) {
                        Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }
                    fotoPath = "img/" + fileName;
                    System.out.println("RecetaServlet: Foto guardada en = " + fotoPath);
                } else {
                    System.out.println("RecetaServlet: No se pudo obtener el directorio de subida para la foto");
                }
            }
            r.setFoto(fotoPath);

            // Guardar receta en DB
            RecetaDAO recetaDAO = new RecetaDAO();
            recetaDAO.crearReceta(r); // Inserta receta y actualiza r.id
            System.out.println("RecetaServlet: Receta creada con ID = " + r.getId());

            // Guardar dietas/características seleccionadas
            String[] dietas = request.getParameterValues("dietas");
            if (dietas != null && dietas.length > 0) {
                RecetaCaracteristicaDAO cDAO = new RecetaCaracteristicaDAO();
                for (String d : dietas) {
                    try {
                        int caracteristicaId = cDAO.obtenerIdPorNombre(d); // obtiene el ID de la característica
                        if (caracteristicaId > 0) {
                            RecetaCaracteristica cr = new RecetaCaracteristica();
                            cr.setRecetaId(r.getId());
                            cr.setCaracteristicaId(caracteristicaId);
                            cDAO.agregarCaracteristicaReceta(cr.getRecetaId(), caracteristicaId); // Inserta en receta_caracteristica
                            System.out.println("RecetaServlet: Característica " + d + " agregada a receta " + r.getId());
                        } else {
                            System.out.println("RecetaServlet: Característica '" + d + "' no encontrada en DB");
                        }
                    } catch (SQLException e) {
                        System.err.println("RecetaServlet: Error agregando característica " + d + ": " + e.getMessage());
                        // No lanzar, continuar
                    }
                }
            }

            System.out.println("RecetaServlet: Receta guardada exitosamente. Enviando respuesta JSON");
            // Enviar respuesta JSON de éxito
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"success\": true}");

        } catch (Exception e) {
            System.err.println("RecetaServlet ERROR: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Error al guardar la receta: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}