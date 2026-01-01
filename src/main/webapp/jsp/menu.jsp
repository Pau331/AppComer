<%-- 
    Document   : menu
    Created on : 30 dic 2025, 18:09:52
    Author     : Tester
--%>


<%@ page import="com.mycompany.recetagram.model.Usuario" %>
<%
    // 1. Recuperar el usuario de la sesión
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");

    // 2. Control de Seguridad (Backend): Si no hay sesión, redirigir al login
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
    <title>Recetagram — Inicio</title>
    <link rel="stylesheet" href="../css/menu.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>

    <aside class="sidebar">
        <div class="logo">
            <img src="../img/logo_texto.png" alt="Logo Recetagram" class="logo-full">
        </div>

        <nav class="nav-links">
            <a href="menu.jsp"><i class="fa-solid fa-house"></i> <span>Inicio</span></a>

            <div class="notification-wrapper-sidebar" id="notif-wrapper">
                <i class="fa-solid fa-bell" id="notif-icon-sidebar"></i>
                <span>Notificaciones</span>
                <span class="notif-badge" id="notif-badge">3</span>
            </div>

            <a href="crear-receta.jsp"><i class="fa-solid fa-circle-plus"></i> <span>Crear receta</span></a>
            <a href="amigos.jsp"><i class="fa-solid fa-user-group"></i> <span>Amigos</span></a>
        </nav>
        
        <div class="logout-wrapper">
            <a href="<%= request.getContextPath() %>/usu/logout" id="logout-link">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Cerrar sesión</span>
            </a>
        </div>
    </aside>

    <div class="notifications-dropdown-overlay" id="notif-dropdown-sidebar"></div>

    <div class="topbar">
        <div class="search-wrapper">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input 
                type="text" 
                placeholder="Buscar recetas o usuarios..." 
                class="search-bar" 
                onclick="window.location.href='explorar.jsp'"
                readonly
            >
        </div>
    </div>

    <div class="top-right-icons">
        <a href="chat.jsp" class="icon"><i class="fa-solid fa-envelope"></i></a>
        <a href="perfil.jsp" class="icon">
            <% if (u.getFotoPerfil() != null && !u.getFotoPerfil().isEmpty()) { %>
                <%-- Usamos getContextPath para que la imagen cargue desde cualquier lugar --%>
                <img src="<%= request.getContextPath() %>/<%= u.getFotoPerfil() %>" 
                     alt="Perfil" 
                     style="width: 30px; height: 30px; border-radius: 50%; object-fit: cover;">
            <% } else { %>
                <i class="fa-solid fa-user"></i>
            <% } %>
        </a>
    </div>

    <main class="feed" id="feed">
        <h2 style="margin: 20px;">¡Hola, <%= u.getUsername() %>! Descubre nuevas recetas.</h2>
    </main>

    <script src="../js/menu.js"></script>
</body>
</html>