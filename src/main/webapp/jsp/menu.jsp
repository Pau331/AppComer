<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.mycompany.recetagram.model.Usuario" %>
<%
    // Recuperar el usuario logueado
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/html/login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recetagram - Inicio</title>

    <!-- CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/menu.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/receta.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <img src="<%= request.getContextPath() %>/img/logo_texto.png" alt="Logo Recetagram" class="logo-full">
        </div>

        <nav class="nav-links">
            <a href="<%= request.getContextPath() %>/feed"><i class="fa-solid fa-house"></i> <span>Inicio</span></a>

            <div class="notification-wrapper-sidebar" id="notif-wrapper">
                <i class="fa-solid fa-bell" id="notif-icon-sidebar"></i>
                <span>Notificaciones</span>
                <span class="notif-badge" id="notif-badge">3</span>
                <div class="notifications-dropdown-overlay" id="notif-dropdown-sidebar"></div>
            </div>

            <a href="<%= request.getContextPath() %>/jsp/crear-receta.jsp"><i class="fa-solid fa-circle-plus"></i> <span>Crear receta</span></a>
            <a href="<%= request.getContextPath() %>/social/amigos"><i class="fa-solid fa-user-group"></i> <span>Amigos</span></a>
            <% if (u.isAdmin()) { %>
            <a href="<%= request.getContextPath() %>/admin/panel"><i class="fa-solid fa-shield-halved"></i> <span>Panel Admin</span></a>
            <% } %>
        </nav>
        
        <div class="logout-wrapper">
            <a href="<%= request.getContextPath() %>/usu/logout" id="logout-link">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Cerrar sesión</span>
            </a>
        </div>
    </aside>

    <!-- Topbar -->
    <div class="topbar">
        <div class="search-wrapper">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input 
                type="text" 
                placeholder="Buscar recetas o usuarios..." 
                class="search-bar" 
                onclick="window.location.href='<%= request.getContextPath() %>/social/explorar'"
                readonly
            >
        </div>
    </div>

    <!-- Top-right icons -->
    <div class="top-right-icons">
        <a href="<%= request.getContextPath() %>/social/chats" class="icon"><i class="fa-solid fa-envelope"></i></a>
        <a href="<%= request.getContextPath() %>/usu/perfil" class="icon">
            <% 
                String avatar = request.getContextPath() + "/img/default-avatar.png";
                if (u != null && u.getFotoPerfil() != null && !u.getFotoPerfil().isEmpty()) {
                    String fotoPerfil = u.getFotoPerfil();
                    // Limpiar barras iniciales
                    while (fotoPerfil.startsWith("/")) {
                        fotoPerfil = fotoPerfil.substring(1);
                    }
                    // Si ya tiene el prefijo img/, usarlo directamente, si no, agregarlo
                    if (!fotoPerfil.startsWith("img/")) {
                        fotoPerfil = "img/" + fotoPerfil;
                    }
                    avatar = request.getContextPath() + "/" + fotoPerfil;
                }
            %>
            <img src="<%= avatar %>" 
                 alt="Perfil" 
                 style="width: 30px; height: 30px; border-radius: 50%; object-fit: cover;">
        </a>
    </div>

    <!-- Feed -->
    <main class="feed" id="feed">
        <jsp:include page="/jsp/feed.jsp" />

    </main>

    <!-- JS -->
    <script>
        const CONTEXT_PATH = '<%= request.getContextPath() %>';
    </script>
    <script src="<%= request.getContextPath() %>/js/notificaciones.js"></script>
    <script src="<%= request.getContextPath() %>/js/menu.js"></script>
    
    <%
        // Mostrar notificación de bienvenida si existe
        String loginSuccess = (String) session.getAttribute("loginSuccess");
        if (loginSuccess != null) {
            session.removeAttribute("loginSuccess");
    %>
    <script>
        window.addEventListener('load', function() {
            mostrarNotificacion('<%= loginSuccess %>', 'success');
        });
    </script>
    <% } %>
    
</body>
</html>
