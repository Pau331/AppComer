<%@ page import="com.mycompany.recetagram.model.Usuario" %>
<%@ page import="com.mycompany.recetagram.model.Receta" %>
<%@ page import="com.mycompany.recetagram.dao.RecetaCaracteristicaDAO" %>
<%@ page import="java.util.List" %>
<%
    // 1. Recuperar la sesión
    Usuario yo = (Usuario) session.getAttribute("usuarioLogueado");

    // 2. Seguridad
    if (yo == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
        return;
    }

    // 3. Usuario visitado + recetas + sonAmigos (del servlet)
    Usuario visitado = (Usuario) request.getAttribute("usuarioVisitado");
    if (visitado == null) {
        response.sendRedirect(request.getContextPath() + "/receta/explorar");
        return;
    }

    List<Receta> recetas = (List<Receta>) request.getAttribute("recetas");
    boolean sonAmigos = (request.getAttribute("sonAmigos") != null) ? (Boolean) request.getAttribute("sonAmigos") : false;
    String estadoRelacion = (String) request.getAttribute("estadoRelacion"); // null, "Pendiente", "Aceptado", "Solicitud recibida"

    RecetaCaracteristicaDAO rcdao = new RecetaCaracteristicaDAO();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Recetagram — Usuario</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/menu.css">
    <!-- IMPORTANTE: para que sea idéntico a perfil -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/perfil.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <aside class="sidebar">
        <div class="logo"><img src="<%= request.getContextPath() %>/img/logo_texto.png" class="logo-full" alt="Recetagram"></div>
        <nav class="nav-links">
            <a href="<%= request.getContextPath() %>/receta/feed"><i class="fa-solid fa-house"></i><span>Inicio</span></a>
            <div class="notification-wrapper-sidebar" id="notif-wrapper">
                <i class="fa-solid fa-bell" id="notif-icon-sidebar"></i><span>Notificaciones</span>
                <span class="notif-badge" id="notif-badge">0</span>
                <div class="notifications-dropdown-overlay" id="notif-dropdown-sidebar"></div>
            </div>
            <a href="<%= request.getContextPath() %>/jsp/crear-receta.jsp"><i class="fa-solid fa-circle-plus"></i><span>Crear receta</span></a>
            <a href="<%= request.getContextPath() %>/jsp/amigos.jsp"><i class="fa-solid fa-user-group"></i><span>Amigos</span></a>
            <% if (yo.isAdmin()) { %>
            <a href="<%= request.getContextPath() %>/admin/panel"><i class="fa-solid fa-shield-halved"></i><span>Panel Admin</span></a>
            <% } %>
        </nav>
        <div class="logout-wrapper">
            <a href="<%= request.getContextPath() %>/usu/logout"><i class="fa-solid fa-right-from-bracket"></i><span>Cerrar sesión</span></a>
        </div>
    </aside>

    <main class="page-wrap">
        <div class="center-col">
            <section class="header">
                <div class="body">
                    <%-- Foto de perfil dinámica con ruta absoluta (MISMA lógica que perfil.jsp) --%>
                    <%
                        String avatarUrl = request.getContextPath() + "/img/default-avatar.png";
                        if (visitado.getFotoPerfil() != null && !visitado.getFotoPerfil().isEmpty()) {
                            String fotoPerfil = visitado.getFotoPerfil();
                            if (fotoPerfil.startsWith("/")) fotoPerfil = fotoPerfil.substring(1);
                            if (!fotoPerfil.startsWith("img/")) fotoPerfil = "img/" + fotoPerfil;
                            avatarUrl = request.getContextPath() + "/" + fotoPerfil;
                        }
                    %>
                    <img class="avatar-lg" src="<%= avatarUrl %>" alt="Avatar">

                    <div style="flex:1">
                        <div class="row">
                            <h2 class="u">@<%= visitado.getUsername() %></h2>

                            <!-- BOTONES SEGÚN ESTADO DE AMISTAD -->
                            <%
                                if (estadoRelacion == null) {
                                    // Sin relación -> Enviar solicitud
                            %>
                                <form action="<%= request.getContextPath() %>/social/solicitarAmistad" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= visitado.getId() %>">
                                    <button class="btn" type="submit">Enviar solicitud</button>
                                </form>
                            <%
                                } else if ("Pendiente".equals(estadoRelacion)) {
                                    // Yo envié solicitud -> Cancelar
                            %>
                                <form action="<%= request.getContextPath() %>/social/solicitarAmistad" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= visitado.getId() %>">
                                    <button class="btn" type="submit">Cancelar solicitud</button>
                                </form>
                            <%
                                } else if ("Solicitud recibida".equals(estadoRelacion)) {
                                    // Recibí solicitud -> Aceptar o Rechazar
                            %>
                                <form action="<%= request.getContextPath() %>/social/aceptarSolicitud" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= visitado.getId() %>">
                                    <button class="btn" type="submit" style="background-color:#28a745;">Aceptar solicitud</button>
                                </form>
                                <form action="<%= request.getContextPath() %>/social/solicitarAmistad" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= visitado.getId() %>">
                                    <button class="btn" type="submit" style="background-color:#dc3545;">Rechazar</button>
                                </form>
                            <%
                                } else if ("Aceptado".equals(estadoRelacion)) {
                                    // Son amigos -> Dejar de ser amigos
                            %>
                                <form action="<%= request.getContextPath() %>/social/solicitarAmistad" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= visitado.getId() %>">
                                    <button class="btn" type="submit">Dejar de ser amigos</button>
                                </form>
                            <%
                                }
                            %>

                            <form action="<%= request.getContextPath() %>/social/amigos"
                                method="get"
                                style="display:inline;">
                                <input type="hidden" name="id" value="<%= visitado.getId() %>">
                                <button id="btnVerAmigos" class="btn" type="submit">
                                    Ver amigos
                                </button>
                            </form>

                        </div>
                        <div class="meta">
                            <button id="btnVerAmigos" class="btn">Ver amigos</button>
                            
                            <!-- Botones de administrador -->
                            <% if (yo.isAdmin()) { %>
                                <form action="<%= request.getContextPath() %><%= visitado.isBaneado() ? "/admin/desbanearUsuario" : "/admin/banearUsuario" %>" 
                                      method="post" 
                                      style="display:inline; margin-left: 10px;"
                                      onsubmit="return confirm('<%= visitado.isBaneado() ? "¿Desbanear a este usuario?" : "¿Estás seguro de que quieres banear a este usuario?" %>');">
                                    <input type="hidden" name="usuarioId" value="<%= visitado.getId() %>">
                                    <button class="btn" type="submit" style="background-color: <%= visitado.isBaneado() ? "#28a745" : "#dc3545" %>;">
                                        <i class="fa-solid fa-<%= visitado.isBaneado() ? "check" : "ban" %>"></i>
                                        <%= visitado.isBaneado() ? "Desbanear" : "Banear" %> (Admin)
                                    </button>
                                </form>
                            <% } %>
                        </div>
                        <div class="meta">
                            <%= visitado.isBaneado() ? "<span style='color: #dc3545; font-weight: bold;'>⚠️ Usuario baneado</span><br>" : "" %>
                            <%= (visitado.getBiografia() != null) ? visitado.getBiografia() : "¡Cuéntanos algo sobre ti!" %>
                        </div>
                    </div>
                </div>
            </section>

            <section class="card">
                <div class="card-body">
                    <h3 style="margin-top:0">Recetas de @<%= visitado.getUsername() %></h3>

                    <%
                    if (recetas == null || recetas.isEmpty()) {
                    %>
                        <p style="text-align: center; color: #666;">Este usuario no tiene recetas publicadas todavía.</p>
                    <%
                    } else {
                        for (Receta r : recetas) {

                            // Procesar la foto de la receta (MISMA lógica que perfil.jsp)
                            String recetaFoto = request.getContextPath() + "/img/default-recipe.jpg";
                            if (r.getFoto() != null && !r.getFoto().isEmpty()) {
                                String foto = r.getFoto();
                                if (foto.startsWith("/")) foto = foto.substring(1);
                                if (!foto.startsWith("img/")) foto = "img/" + foto;
                                recetaFoto = request.getContextPath() + "/" + foto;
                            }

                            // Obtener dietas/características (MISMA llamada)
                            List<String> dietas = rcdao.listarCaracteristicasReceta(r.getId());

                            // Avatar del usuario visitado (MISMA lógica)
                            String avatar = request.getContextPath() + "/img/default-avatar.png";
                            if (visitado.getFotoPerfil() != null && !visitado.getFotoPerfil().isEmpty()) {
                                String fp = visitado.getFotoPerfil();
                                if (fp.startsWith("/")) fp = fp.substring(1);
                                if (!fp.startsWith("img/")) fp = "img/" + fp;
                                avatar = request.getContextPath() + "/" + fp;
                            }
                    %>

                    <a href="<%=request.getContextPath()%>/receta/ver?id=<%= r.getId() %>" class="recipe-link">
                        <div class="recipe-card">
                            <div class="recipe-img-container">
                                <img src="<%= recetaFoto %>" alt="<%= r.getTitulo() %>">
                            </div>

                            <div class="recipe-info">
                                <h2 class="recipe-title"><%= r.getTitulo() %></h2>

                                <div class="recipe-user">
                                    <img src="<%= avatar %>" alt="<%= visitado.getUsername() %>" class="avatar">
                                    <span class="username"><%= visitado.getUsername() %></span>
                                </div>

                                <div class="recipe-details">
                                    <div class="detail">
                                        <i class="fa-solid fa-star"></i>
                                        <span>Dificultad: <%= r.getDificultad() %></span>
                                    </div>

                                    <div class="detail">
                                        <i class="fa-solid fa-clock"></i>
                                        <span>Tiempo: <%= r.getTiempoPreparacion() %> min</span>
                                    </div>

                                    <% for (String d : dietas) { %>
                                        <div class="detail">
                                            <% if (d.equalsIgnoreCase("Vegetariano")) { %>
                                                <i class="fa-solid fa-leaf"></i>
                                            <% } else if (d.equalsIgnoreCase("Vegano")) { %>
                                                <i class="fa-solid fa-seedling"></i>
                                            <% } else if (d.equalsIgnoreCase("Sin gluten")) { %>
                                                <img src="<%= request.getContextPath() %>/img/sin-gluten.png" class="diet-icon">
                                            <% } else if (d.equalsIgnoreCase("Healthy")) { %>
                                                <i class="fa-solid fa-apple-whole"></i>
                                            <% } %>
                                            <span><%= d %></span>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </a>

                    <%
                        } // for
                    } // else
                    %>
                </div>
            </section>
        </div>
    </main>

    <script>
        const CONTEXT_PATH = '<%= request.getContextPath() %>';
    </script>
    <script src="<%= request.getContextPath() %>/js/notificaciones.js"></script>
    <script src="<%= request.getContextPath() %>/js/menu.js"></script>
    <!-- puedes crear usuario.js si quieres, pero no hace falta para el toggle -->
</body>
</html>
