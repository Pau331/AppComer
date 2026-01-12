<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.recetagram.model.Receta" %>
<%@ page import="com.mycompany.recetagram.model.Comentario" %>
<%@ page import="com.mycompany.recetagram.model.Usuario" %>

<%
    Receta receta = (Receta) request.getAttribute("receta");
    List<Comentario> comentarios = (List<Comentario>) request.getAttribute("comentarios");
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
        return;
    }
    
    if (receta == null) {
        response.sendRedirect(request.getContextPath() + "/receta/feed");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= receta.getTitulo() %> - Recetagram</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/menu.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/receta.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <a href="<%= request.getContextPath() %>/receta/feed">
                <img src="<%= request.getContextPath() %>/img/logo_texto.png" alt="Logo Recetagram" class="logo-full">
            </a>
        </div>

        <nav class="nav-links">
            <a href="<%= request.getContextPath() %>/receta/feed"><i class="fa-solid fa-house"></i> <span>Inicio</span></a>
            <div class="notification-wrapper-sidebar" id="notif-wrapper">
                <i class="fa-solid fa-bell" id="notif-icon-sidebar"></i>
                <span>Notificaciones</span>
                <span class="notif-badge" id="notif-badge">3</span>
                <div class="notifications-dropdown-overlay" id="notif-dropdown-sidebar"></div>
            </div>
            <a href="<%= request.getContextPath() %>/jsp/crear-receta.jsp"><i class="fa-solid fa-circle-plus"></i> <span>Crear receta</span></a>
            <a href="<%= request.getContextPath() %>/jsp/amigos.jsp"><i class="fa-solid fa-user-group"></i> <span>Amigos</span></a>
            <% if (u.isAdmin()) { %>
            <a href="<%= request.getContextPath() %>/admin/panel"><i class="fa-solid fa-shield-halved"></i> <span>Panel Admin</span></a>
            <% } %>
        </nav>
        
        <div class="logout-wrapper">
            <a href="<%= request.getContextPath() %>/usu/logout">
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
                onclick="window.location.href='<%= request.getContextPath() %>/receta/explorar'"
                readonly
            >
        </div>
    </div>

    <!-- Top-right icons -->
    <div class="top-right-icons">
        <a href="<%= request.getContextPath() %>/social/chat" class="icon"><i class="fa-solid fa-envelope"></i></a>
        <a href="<%= request.getContextPath() %>/usu/perfil" class="icon">
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

    <!-- Contenido principal -->
    <main class="page-wrap">
        <div class="center-col">

<!-- ================= RECETA ================= -->
<section class="grid-2">
    <div class="card">
        <div class="card-body">
            <h2 class="recipe-title"><%= receta.getTitulo() %></h2>
            <div class="recipe-details">
                <div class="detail"><i class="fa-solid fa-fire"></i> <span><%= receta.getDificultad() %></span></div>
                <div class="detail"><i class="fa-solid fa-clock"></i> <span><%= receta.getTiempoPreparacion() %> min</span></div>
                <div class="detail"><i class="fa-solid fa-heart"></i> <span><%= receta.getLikes() %> likes</span></div>
            </div>

            <% if (receta.getPasos() != null && !receta.getPasos().isEmpty()) { %>
                <h3>Pasos</h3>
                <ol class="steps">
                <% 
                    String[] pasos = receta.getPasos().split("\n");
                    for (String paso : pasos) {
                        if (!paso.trim().isEmpty()) {
                %>
                    <li><%= paso.trim() %></li>
                <% 
                        }
                    }
                %>
                </ol>
            <% } %>

            <% boolean liked = Boolean.TRUE.equals(request.getAttribute("liked")); %>
            <form action="<%= request.getContextPath() %>/receta/like" method="post" class="like-area">
                <input type="hidden" name="recetaId" value="<%= receta.getId() %>">
                <button type="submit" class="btn-like" aria-label="Me gusta">
                    <i class="<%= liked ? "fa-solid fa-heart" : "fa-regular fa-heart" %>"></i>
                </button>
                <span class="count"><%= receta.getLikes() %></span>
            </form>
        </div>
    </div>

    <aside class="card">
        <div class="card-body">
            <% 
                String foto = receta.getFoto();
                String fotoUrl;
                if (foto != null && !foto.isBlank()) {
                    String f = foto;
                    if (f.startsWith("/")) f = f.substring(1);
                    if (!f.startsWith("img/")) f = "img/" + f;
                    fotoUrl = request.getContextPath() + "/" + f;
                } else {
                    fotoUrl = request.getContextPath() + "/img/photo-placeholder.png";
                }
            %>
            <img src="<%= fotoUrl %>" alt="Foto de la receta" class="photo">
        </div>
    </aside>
</section>

<!-- ================= COMENTARIOS ================= -->
<section class="card" id="comentarios-section">
    <div class="card-body">
        <h3>Comentarios</h3>

        <!-- FORMULARIO NUEVO COMENTARIO -->
        <% if (u != null) { %>
        <form class="add-comment" action="<%= request.getContextPath() %>/receta/comentario" method="post">
            <input type="hidden" name="recetaId" value="<%= receta.getId() %>">
            <textarea name="texto" placeholder="Escribe un comentario..." rows="2" required></textarea>
            <button type="submit" class="btn-like">Publicar</button>
        </form>
        <% } else { %>
            <p>Inicia sesión para comentar</p>
        <% } %>

        <!-- LISTA DE COMENTARIOS -->
        <div id="listaComentarios" class="comments-list">

        <% if (comentarios != null && !comentarios.isEmpty()) {
               for (Comentario c : comentarios) {
        %>
            <div class="comment">
                <%
                   String uFoto = c.getUsuarioFoto();
                   String avatarUrl;
                   if (uFoto != null && !uFoto.isBlank()) {
                       String f = uFoto;
                       if (f.startsWith("/")) f = f.substring(1);
                       if (!f.startsWith("img/")) f = "img/" + f;
                       avatarUrl = request.getContextPath() + "/" + f;
                   } else {
                       avatarUrl = request.getContextPath() + "/img/default-avatar.png";
                   }
                   String uName = (c.getUsuarioNombre() != null && !c.getUsuarioNombre().isBlank()) ? c.getUsuarioNombre() : ("usuario" + c.getUsuarioId());
                %>
                <img src="<%= avatarUrl %>" class="avatar" alt="avatar">

                <div class="content">
                    <div class="username">
                        @<%= uName %>
                        <span class="fecha" data-fecha="<%= c.getFecha().getTime() %>"></span>
                    </div>

                    <div class="texto">
                        <%= c.getTexto() %>
                    </div>
                </div>
                
                <% if (u.isAdmin()) { %>
                <form action="<%= request.getContextPath() %>/admin/delete" method="post" style="margin-left: auto;">
                    <input type="hidden" name="tipo" value="comentario">
                    <input type="hidden" name="id" value="<%= c.getId() %>">
                    <button type="submit" 
                            onclick="return confirm('¿Eliminar este comentario?');"
                            style="
                                background: #dc3545;
                                color: white;
                                border: none;
                                border-radius: 6px;
                                padding: 6px 12px;
                                font-size: 12px;
                                font-weight: 600;
                                cursor: pointer;
                                display: flex;
                                align-items: center;
                                gap: 5px;
                                transition: background 0.2s;
                            "
                            onmouseover="this.style.background='#c82333'" 
                            onmouseout="this.style.background='#dc3545'">
                        <i class="fa-solid fa-trash"></i>
                        Eliminar (Admin)
                    </button>
                </form>
                <% } %>
            </div>
        <% } } else { %>
            <p>No hay comentarios todavía.</p>
        <% } %>

        </div>
    </div>
</section>
        </div>
    </main>

<!-- ================= JS ================= -->
<script>
    const CONTEXT_PATH = '<%= request.getContextPath() %>';
</script>
<script src="<%= request.getContextPath() %>/js/menu.js"></script>
</body>
</html>
