package com.mycompany.recetagram.servlet;

import com.mycompany.recetagram.dao.UsuarioDAO;
import com.mycompany.recetagram.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;

@WebServlet("/usu/actualizarPerfil")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  
    maxFileSize = 1024 * 1024 * 10,       
    maxRequestSize = 1024 * 1024 * 15     
)
public class EditarPerfilServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario u = (Usuario) session.getAttribute("usuarioLogueado");

        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/html/login.html");
            return;
        }

        // 1. Recuperar parámetros de texto
        String nuevoUsername = request.getParameter("username");
        String nuevaBio = request.getParameter("bio");

        // 2. Manejo de la imagen con Persistencia Directa en el Proyecto
        Part filePart = request.getPart("avatar");
        if (filePart != null && filePart.getSize() > 0) {
            
            //debe ser ruta exacta
            String uploadPath = "C:/Users/Tester/Documents/NetBeansProjects/AppComer/src/main/webapp/img";
            
            // Creamos la carpeta si por algún motivo no existiera
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Nombre de archivo único
            String fileName = "avatar_" + u.getId() + "_" + System.currentTimeMillis() + ".jpg";
            File fileToSave = new File(uploadDir, fileName);

            // Guardar físicamente el archivo en la carpeta src/main/webapp/img
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, fileToSave.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            
            u.setFotoPerfil("img/" + fileName); 
        }

        // 3. Actualizar los datos en el objeto Usuario
        u.setUsername(nuevoUsername);
        u.setBiografia(nuevaBio);

        // 4. Persistencia en Base de Datos
        try {
            // Tu UsuarioDAO ya tiene 'username' en su sentencia SQL
            boolean exito = usuarioDAO.actualizar(u);
            
            if (exito) {
                session.setAttribute("usuarioLogueado", u);
                response.sendRedirect(request.getContextPath() + "/jsp/perfil.jsp?update=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/editarPerfil.jsp?error=update_failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp/editarPerfil.jsp?error=db");
        }
    }
}