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
    <title>Recetagram ? Inicio</title>

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
            </div>

            <a href="<%= request.getContextPath() %>/jsp/crear-receta.jsp"><i class="fa-solid fa-circle-plus"></i> <span>Crear receta</span></a>
            <a href="<%= request.getContextPath() %>/jsp/amigos.jsp"><i class="fa-solid fa-user-group"></i> <span>Amigos</span></a>
        </nav>
        
        <div class="logout-wrapper">
            <a href="<%= request.getContextPath() %>/usu/logout" id="logout-link">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Cerrar sesión</span>
            </a>
        </div>
    </aside>

    <!-- Overlay notificaciones -->
    <div class="notifications-dropdown-overlay" id="notif-dropdown-sidebar"></div>

    <!-- Topbar -->
    <div class="topbar">
        <div class="search-wrapper">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input 
                type="text" 
                placeholder="Buscar recetas o usuarios..." 
                class="search-bar" 
                onclick="window.location.href='<%= request.getContextPath() %>/jsp/explorar.jsp'"
                readonly
            >
        </div>
    </div>

    <!-- Top-right icons -->
    <div class="top-right-icons">
        <a href="<%= request.getContextPath() %>/jsp/chat.jsp" class="icon"><i class="fa-solid fa-envelope"></i></a>
        <a href="<%= request.getContextPath() %>/jsp/perfil.jsp" class="icon">
            <% 
                String avatar = request.getContextPath() + "/img/default-avatar.png";
                if (u.getFotoPerfil() != null && !u.getFotoPerfil().isEmpty()) {
                    String fotoPerfil = u.getFotoPerfil();
                    if (fotoPerfil.startsWith("/")) fotoPerfil = fotoPerfil.substring(1);
                    if (!fotoPerfil.startsWith("img/")) fotoPerfil = "img/" + fotoPerfil;
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
        <%-- Incluimos feed.jsp con recetas cargadas por FeedServlet --%>
        <jsp:include page="feed.jsp" />
    </main>

    <!-- JS -->
    <script>
        const CONTEXT_PATH = '<%= request.getContextPath() %>';
    </script>
    <script src="<%= request.getContextPath() %>/js/menu.js"></script>
</body>
</html>
