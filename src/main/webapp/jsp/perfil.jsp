<%@ page import="com.mycompany.recetagram.model.Usuario" %>
<%@ page import="com.mycompany.recetagram.model.Receta" %>
<%@ page import="com.mycompany.recetagram.dao.RecetaCaracteristicaDAO" %>
<%@ page import="java.util.List" %>
<%
    // 1. Recuperar la sesión
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");

    // 2. Seguridad
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
        return;
    }
    
    // 3. Obtener las recetas desde el servlet
    List<Receta> recetas = (List<Receta>) request.getAttribute("recetas");
    RecetaCaracteristicaDAO rcdao = new RecetaCaracteristicaDAO();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Recetagram — Mi perfil</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/menu.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/perfil.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <aside class="sidebar">
        <div class="logo"><img src="<%= request.getContextPath() %>/img/logo_texto.png" class="logo-full" alt="Recetagram"></div>
        <nav class="nav-links">
            <a href="<%= request.getContextPath() %>/feed"><i class="fa-solid fa-house"></i><span>Inicio</span></a>
            <a href="<%= request.getContextPath() %>/jsp/crear-receta.jsp"><i class="fa-solid fa-circle-plus"></i><span>Crear receta</span></a>
            <a href="<%= request.getContextPath() %>/jsp/amigos.jsp"><i class="fa-solid fa-user-group"></i><span>Amigos</span></a>
        </nav>
        <div class="logout-wrapper">
            <a href="<%= request.getContextPath() %>/usu/logout"><i class="fa-solid fa-right-from-bracket"></i><span>Cerrar sesión</span></a>
        </div>
    </aside>

    <main class="page-wrap">
        <div class="center-col">
            <section class="header">
                <div class="body">
                    <%-- Foto de perfil dinámica con ruta absoluta --%>
                    <%
                        String avatarUrl = request.getContextPath() + "/img/default-avatar.png";
                        if (u.getFotoPerfil() != null && !u.getFotoPerfil().isEmpty()) {
                            String fotoPerfil = u.getFotoPerfil();
                            if (fotoPerfil.startsWith("/")) fotoPerfil = fotoPerfil.substring(1);
                            if (!fotoPerfil.startsWith("img/")) fotoPerfil = "img/" + fotoPerfil;
                            avatarUrl = request.getContextPath() + "/" + fotoPerfil;
                        }
                    %>
                    <img id="avatarYo" class="avatar-lg" src="<%= avatarUrl %>" alt="Avatar">

                    <div style="flex:1">
                        <div class="row">
                            <h2 id="usernameYo" class="u">@<%= u.getUsername() %></h2>
                            <button id="btnEditarPerfil" class="btn">Editar perfil</button>
                            <button id="btnVerAmigos" class="btn">Ver amigos</button>
                        </div>
                        <div class="meta" id="nombreYo">
                            <%= (u.getBiografia() != null) ? u.getBiografia() : "¡Cuéntanos algo sobre ti!" %>
                        </div>
                    </div>
                </div>
            </section>

            <section class="card">
                <div class="card-body">
                    <h3 style="margin-top:0">Mis recetas</h3>
                    
                    <%
                    if (recetas == null || recetas.isEmpty()) {
                    %>
                        <p style="text-align: center; color: #666;">No tienes recetas publicadas todavía. ¡Crea tu primera receta!</p>
                    <%
                    } else {
                        for (Receta r : recetas) {
                    // Procesar la foto de la receta
                    String recetaFoto = request.getContextPath() + "/img/default-recipe.jpg";
                    if (r.getFoto() != null && !r.getFoto().isEmpty()) {
                        String foto = r.getFoto();
                        if (foto.startsWith("/")) foto = foto.substring(1);
                        if (!foto.startsWith("img/")) foto = "img/" + foto;
                        recetaFoto = request.getContextPath() + "/" + foto;
                    }
                    
                    // Obtener características/dietas de la receta
                    List<String> dietas = rcdao.listarCaracteristicasReceta(r.getId());
                    
                    // Foto de perfil del usuario (que es el mismo)
                    String avatar = request.getContextPath() + "/img/default-avatar.png";
                    if (u.getFotoPerfil() != null && !u.getFotoPerfil().isEmpty()) {
                        String fotoPerfil = u.getFotoPerfil();
                        if (fotoPerfil.startsWith("/")) fotoPerfil = fotoPerfil.substring(1);
                        if (!fotoPerfil.startsWith("img/")) fotoPerfil = "img/" + fotoPerfil;
                        avatar = request.getContextPath() + "/" + fotoPerfil;
                    }
            %>
            
            <a href="<%=request.getContextPath()%>/verReceta?id=<%= r.getId() %>" class="recipe-link">
                <div class="recipe-card">
                    <!-- Contenedor de imagen flexible -->
                    <div class="recipe-img-container">
                        <img src="<%= recetaFoto %>" alt="<%= r.getTitulo() %>">
                    </div>

                    <div class="recipe-info">
                        <h2 class="recipe-title"><%= r.getTitulo() %></h2>

                        <div class="recipe-user">
                            <img src="<%= avatar %>" alt="<%= u.getUsername() %>" class="avatar">
                            <span class="username"><%= u.getUsername() %></span>
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
                } // for recetas
            } // else
            %>
                </div>
            </section>
        </div>
    </main>

    <script src="<%= request.getContextPath() %>/js/menu.js"></script>
    <script src="<%= request.getContextPath() %>/js/perfil.js"></script>
</body>
</html>