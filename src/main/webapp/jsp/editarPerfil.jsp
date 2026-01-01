<%-- 
    Document   : editarPerfil
    Created on : 30 dic 2025, 17:50:55
    Author     : Tester
--%>

<%@ page import="com.mycompany.recetagram.model.Usuario" %>
<%
    // 1. Recuperar la sesión y el objeto de usuario
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");

    // 2. Control de Seguridad: Si no está logueado, fuera de aquí
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/html/login.html");
        return;
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recetagram — Editar perfil</title>

    <link rel="stylesheet" href="../css/menu.css">
    <link rel="stylesheet" href="../css/receta.css">
    <link rel="stylesheet" href="../css/editar-perfil.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <aside class="sidebar">
        <div class="logo"><img src="../img/logo_texto.png" class="logo-full" alt="Recetagram"></div>
        <nav class="nav-links">
            <a href="menu.jsp"><i class="fa-solid fa-house"></i><span>Inicio</span></a>
            <div class="notification-wrapper-sidebar" id="notif-wrapper">
                <i class="fa-solid fa-bell" id="notif-icon-sidebar"></i><span>Notificaciones</span>
                <span class="notif-badge">3</span>
            </div>
            <a href="crear-receta.jsp"><i class="fa-solid fa-circle-plus"></i><span>Crear receta</span></a>
            <a href="amigos.jsp"><i class="fa-solid fa-user-group"></i><span>Amigos</span></a>
        </nav>
        <div class="logout-wrapper">
            <a href="<%= request.getContextPath() %>/usu/logout"><i class="fa-solid fa-right-from-bracket"></i><span>Cerrar sesión</span></a>
        </div>
    </aside>
    
    <div class="topbar">
        <div class="topbar-actions">
            <a href="chat.jsp" class="icon-btn"><i class="fa-solid fa-envelope"></i></a>
            <a href="perfil.jsp" class="icon-btn"><i class="fa-solid fa-user"></i></a>
        </div>
    </div>

    <main class="page-wrap">
        <div class="center-col">
            <section class="card">
                <div class="card-body">
                    <h3 style="margin-top:0">Editar perfil</h3>

                    <form id="formPerfil" class="form" action="<%= request.getContextPath() %>/usu/actualizarPerfil" method="POST" enctype="multipart/form-data">
                        
                        <div class="form-row avatar-row">
                            <div class="image-drop small" id="dropAvatar">
                                <img id="prevAvatar" class="avatar-lg" src="<%= u.getFotoPerfil() %>" alt="Avatar">
                                <div class="placeholder" id="placeholderAvatar" style="display:none;">
                                    <i class="fa-solid fa-user"></i>
                                    <p>Sube tu foto</p>
                                </div>
                                <input id="avatarInput" name="avatar" type="file" accept="image/*" hidden>
                            </div>
                            
                            <div class="grow">
                                <label class="lbl">Nombre</label>
                                <input id="nombre" name="nombre" class="input" type="text" value="<%= u.getUsername() %>">
                                
                                <label class="lbl">@Usuario</label>
                                <input id="usuario" name="username" class="input" type="text" value="<%= u.getUsername() %>">
                            </div>
                        </div>

                        <label class="lbl">Bio</label>
                        <textarea id="bio" name="bio" class="textarea" rows="4"><%= (u.getBiografia() != null) ? u.getBiografia() : "" %></textarea>

                        <div class="form-actions">
                            <button type="submit" id="btnGuardarPerfil" class="btn-like save-btn">
                                <i class="fa-solid fa-floppy-disk"></i> Guardar
                            </button>
                            <a href="perfil.jsp" class="btn-sec">Cancelar</a>
                        </div>
                    </form>
                </div>
            </section>
        </div>
    </main>

    <script src="../js/menu.js"></script>
    <script src="../js/editar-perfil.js"></script>
</body>
</html>