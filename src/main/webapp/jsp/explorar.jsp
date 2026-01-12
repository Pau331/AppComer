<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.mycompany.recetagram.model.Usuario"%>
<%@page import="com.mycompany.recetagram.model.Receta"%>
<%@page import="com.mycompany.recetagram.dao.RecetaCaracteristicaDAO"%>

<%
    Usuario yo = (Usuario) session.getAttribute("usuarioLogueado");
    if (yo == null) {
        response.sendRedirect(request.getContextPath() + "/html/login.html");
        return;
    }

    String q = (String) request.getAttribute("q");
    if (q == null) q = "";

    List<Receta> recetas = (List<Receta>) request.getAttribute("recetas");
    if (recetas == null) recetas = new ArrayList<>();

    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    if (usuarios == null) usuarios = new ArrayList<>();

    Map<Integer, Usuario> autores = (Map<Integer, Usuario>) request.getAttribute("autores");
    if (autores == null) autores = new HashMap<>();

    // ✅ Avatar YO (misma lógica que menu.jsp)
    String avatarYo = request.getContextPath() + "/img/default-avatar.png";
    if (yo != null && yo.getFotoPerfil() != null && !yo.getFotoPerfil().isEmpty()) {
        String fotoPerfil = yo.getFotoPerfil();
        // Limpiar barras iniciales
        while (fotoPerfil.startsWith("/")) {
            fotoPerfil = fotoPerfil.substring(1);
        }
        // Si ya tiene el prefijo img/, usarlo directamente, si no, agregarlo
        if (!fotoPerfil.startsWith("img/")) {
            fotoPerfil = "img/" + fotoPerfil;
        }
        avatarYo = request.getContextPath() + "/" + fotoPerfil;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Explorar - Recetagram</title>

    <!-- ✅ primero menu.css (estructura), luego explorar.css -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/menu.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/explorar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>

<body>

<!-- Sidebar (igual que menu.jsp) -->
<aside class="sidebar">
    <div class="logo">
        <img src="<%= request.getContextPath() %>/img/logo_texto.png" alt="Logo Recetagram" class="logo-full">
    </div>

    <nav class="nav-links">
        <a href="<%= request.getContextPath() %>/feed">
            <i class="fa-solid fa-house"></i> <span>Inicio</span>
        </a>

        <!-- ✅ Notificaciones (igual que menu.jsp) -->
        <div class="notification-wrapper-sidebar" id="notif-wrapper">
            <i class="fa-solid fa-bell" id="notif-icon-sidebar"></i>
            <span>Notificaciones</span>
            <span class="notif-badge" id="notif-badge">3</span>
            <div class="notifications-dropdown-overlay" id="notif-dropdown-sidebar"></div>
        </div>

        <a href="<%= request.getContextPath() %>/jsp/crear-receta.jsp">
            <i class="fa-solid fa-circle-plus"></i> <span>Crear receta</span>
        </a>

        <a href="<%= request.getContextPath() %>/social/amigos">
            <i class="fa-solid fa-user-group"></i> <span>Amigos</span>
        </a>
        <% if (yo.isAdmin()) { %>
        <a href="<%=request.getContextPath()%>/admin/panel">
            <i class="fa-solid fa-shield-halved"></i> <span>Panel Admin</span>
        </a>
        <% } %>
    </nav>

    <div class="logout-wrapper">
        <a href="<%= request.getContextPath() %>/usu/logout">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Cerrar sesión</span>
        </a>
    </div>
</aside>

<!-- Topbar (igual idea que menu.jsp, pero aquí sí buscamos) -->
<div class="topbar" style="justify-content: flex-start; gap: 15px;">
    <div class="search-wrapper">
        <i class="fa-solid fa-magnifying-glass search-icon"></i>
        <form method="get" action="<%=request.getContextPath()%>/social/explorar" style="width:100%;" id="search-form">
            <input
                type="text"
                name="q"
                value="<%= q %>"
                placeholder="Buscar recetas o usuarios..."
                class="search-bar"
                onkeypress="if(event.key === 'Enter') { document.getElementById('search-form').submit(); }"
            >
        </form>
    </div>
    
    <!-- Botón de filtros -->
    <button id="btn-filtros" type="button" style="
        background: #e13b63;
        color: white;
        border: none;
        border-radius: 8px;
        padding: 10px 20px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: background 0.2s;
        flex-shrink: 0;
    " onmouseover="this.style.background='#c12c54'" onmouseout="this.style.background='#e13b63'">
        <i class="fa-solid fa-filter"></i>
        <span>Filtros</span>
        <% if (request.getParameter("caracteristica") != null) { %>
            <span style="background: white; color: #e13b63; border-radius: 50%; width: 20px; height: 20px; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700;">
                <%= request.getParameterValues("caracteristica").length %>
            </span>
        <% } %>
    </button>
    
    <!-- Dropdown de filtros -->
    <div id="filtros-dropdown" style="
        display: none;
        position: absolute;
        top: 50px;
        left: 570px;
        background: white;
        border: 1px solid #dbdbdb;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        padding: 20px;
        width: 320px;
        z-index: 1000;
    ">
        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px;">
            <h4 style="margin: 0; font-size: 17px; color: #262626; font-weight: 700;">
                <i class="fa-solid fa-sliders" style="color: #e13b63; margin-right: 8px;"></i>
                Filtros
            </h4>
            <i class="fa-solid fa-times" id="close-filtros" style="cursor: pointer; color: #999; font-size: 18px; transition: color 0.2s;" 
               onmouseover="this.style.color='#262626'" onmouseout="this.style.color='#999'"></i>
        </div>
        
        <form method="get" action="<%=request.getContextPath()%>/social/explorar" id="filter-form">
            <input type="hidden" name="q" value="<%= q %>">
            
            <%
                String[] caracteristicasActivas = request.getParameterValues("caracteristica");
                boolean tieneVegetariano = caracteristicasActivas != null && java.util.Arrays.asList(caracteristicasActivas).contains("Vegetariano");
                boolean tieneVegano = caracteristicasActivas != null && java.util.Arrays.asList(caracteristicasActivas).contains("Vegano");
                boolean tieneSinGluten = caracteristicasActivas != null && java.util.Arrays.asList(caracteristicasActivas).contains("Sin gluten");
                boolean tieneHealthy = caracteristicasActivas != null && java.util.Arrays.asList(caracteristicasActivas).contains("Healthy");
            %>
            <div style="display: flex; flex-direction: column; gap: 14px; margin-bottom: 18px;">
                <label class="filtro-label" data-caracteristica="Vegetariano" style="
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    cursor: pointer;
                    font-size: 15px;
                    padding: 12px;
                    border-radius: 8px;
                    transition: background 0.2s, border 0.2s;
                    <%= tieneVegetariano ? "background: #e13b63; border: 2px solid #e13b63;" : "background: #f9f9f9; border: 2px solid transparent;" %>
                ">
                    <input type="checkbox" name="caracteristica" value="Vegetariano" 
                           <%= tieneVegetariano ? "checked" : "" %>
                           style="cursor: pointer; width: 20px; height: 20px; accent-color: #fff;">
                    <i class="fa-solid fa-leaf filtro-icon" style="font-size: 20px; color: <%= tieneVegetariano ? "#fff" : "#999" %>; width: 24px; text-align: center; transition: color 0.2s;"></i>
                    <span class="filtro-text" style="font-weight: 600; color: <%= tieneVegetariano ? "#fff" : "#262626" %>; transition: color 0.2s;">Vegetariano</span>
                </label>
                
                <label class="filtro-label" data-caracteristica="Vegano" style="
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    cursor: pointer;
                    font-size: 15px;
                    padding: 12px;
                    border-radius: 8px;
                    transition: background 0.2s, border 0.2s;
                    <%= tieneVegano ? "background: #e13b63; border: 2px solid #e13b63;" : "background: #f9f9f9; border: 2px solid transparent;" %>
                ">
                    <input type="checkbox" name="caracteristica" value="Vegano"
                           <%= tieneVegano ? "checked" : "" %>
                           style="cursor: pointer; width: 20px; height: 20px; accent-color: #fff;">
                    <i class="fa-solid fa-seedling filtro-icon" style="font-size: 20px; color: <%= tieneVegano ? "#fff" : "#999" %>; width: 24px; text-align: center; transition: color 0.2s;"></i>
                    <span class="filtro-text" style="font-weight: 600; color: <%= tieneVegano ? "#fff" : "#262626" %>; transition: color 0.2s;">Vegano</span>
                </label>
                
                <label class="filtro-label" data-caracteristica="Sin gluten" style="
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    cursor: pointer;
                    font-size: 15px;
                    padding: 12px;
                    border-radius: 8px;
                    transition: background 0.2s, border 0.2s;
                    <%= tieneSinGluten ? "background: #e13b63; border: 2px solid #e13b63;" : "background: #f9f9f9; border: 2px solid transparent;" %>
                ">
                    <input type="checkbox" name="caracteristica" value="Sin gluten"
                           <%= tieneSinGluten ? "checked" : "" %>
                           style="cursor: pointer; width: 20px; height: 20px; accent-color: #fff;">
                    <img src="<%= request.getContextPath() %>/img/sin-gluten.png" class="filtro-img" style="width: 24px; height: 24px; object-fit: contain; <%= tieneSinGluten ? "filter: brightness(0) invert(1); opacity: 1;" : "opacity: 0.5;" %> transition: filter 0.2s, opacity 0.2s;">
                    <span class="filtro-text" style="font-weight: 600; color: <%= tieneSinGluten ? "#fff" : "#262626" %>; transition: color 0.2s;">Sin gluten</span>
                </label>
                
                <label class="filtro-label" data-caracteristica="Healthy" style="
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    cursor: pointer;
                    font-size: 15px;
                    padding: 12px;
                    border-radius: 8px;
                    transition: background 0.2s, border 0.2s;
                    <%= tieneHealthy ? "background: #e13b63; border: 2px solid #e13b63;" : "background: #f9f9f9; border: 2px solid transparent;" %>
                ">
                    <input type="checkbox" name="caracteristica" value="Healthy"
                           <%= tieneHealthy ? "checked" : "" %>
                           style="cursor: pointer; width: 20px; height: 20px; accent-color: #fff;">
                    <i class="fa-solid fa-apple-whole filtro-icon" style="font-size: 20px; color: <%= tieneHealthy ? "#fff" : "#999" %>; width: 24px; text-align: center; transition: color 0.2s;"></i>
                    <span class="filtro-text" style="font-weight: 600; color: <%= tieneHealthy ? "#fff" : "#262626" %>; transition: color 0.2s;">Healthy</span>
                </label>
            </div>
            
            <div style="display: flex; gap: 10px;">
                <button type="submit" style="
                    flex: 1;
                    background: #e13b63;
                    color: white;
                    border: none;
                    border-radius: 6px;
                    padding: 10px;
                    font-size: 14px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: background 0.2s;
                " onmouseover="this.style.background='#c12c54'" onmouseout="this.style.background='#e13b63'">
                    Aplicar filtros
                </button>
                
                <% if (request.getParameter("caracteristica") != null) { %>
                    <a href="<%=request.getContextPath()%>/social/explorar<%= q != null && !q.isEmpty() ? "?q=" + q : "" %>" 
                       style="
                        flex: 1;
                        background: #f0f0f0;
                        color: #262626;
                        border: none;
                        border-radius: 6px;
                        padding: 10px;
                        font-size: 14px;
                        font-weight: 600;
                        cursor: pointer;
                        text-decoration: none;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        transition: background 0.2s;
                    " onmouseover="this.style.background='#e0e0e0'" onmouseout="this.style.background='#f0f0f0'">
                        Limpiar
                    </a>
                <% } %>
            </div>
        </form>
    </div>
</div>

<!-- ✅ Top-right icons (OBLIGATORIO fuera de topbar por tu CSS position:fixed) -->
<div class="top-right-icons" style="top: 18px; right: 20px;">
    <a href="<%= request.getContextPath() %>/jsp/chat.jsp" class="icon">
        <i class="fa-solid fa-envelope"></i>
    </a>
    <a href="<%= request.getContextPath() %>/usu/perfil" class="icon">
        <img src="<%= avatarYo %>"
             alt="Perfil"
             style="width:30px;height:30px;border-radius:50%;object-fit:cover;">
    </a>
</div>

<!-- Contenido -->
<main class="explore-section">
    <div class="tabs">
        <button class="tab active" id="tab-recetas" type="button">Recetas</button>
        <button class="tab" id="tab-usuarios" type="button">Usuarios</button>
    </div>

    <!-- RECETAS -->
    <div class="results recetas">
        <%
            if (recetas.isEmpty()) {
        %>
            <p style="opacity:.75;">No hay recetas para mostrar.</p>
        <%
            } else {
                for (Receta r : recetas) {

                    // ✅ Foto receta (arregla rutas)
                    String fotoReceta = request.getContextPath() + "/img/default-recipe.jpg";
                    if (r.getFoto() != null && !r.getFoto().isEmpty()) {
                        String fr = r.getFoto();
                        if (fr.startsWith("/")) fr = fr.substring(1);
                        if (!fr.startsWith("img/")) fr = "img/" + fr;
                        fotoReceta = request.getContextPath() + "/" + fr;
                    }

                    // ✅ Autor
                    Usuario autor = autores.get(r.getUsuarioId());
                    String username = (autor != null && autor.getUsername() != null) ? autor.getUsername() : "autor";

                    String avatarAutor = request.getContextPath() + "/img/default-avatar.png";
                    if (autor != null && autor.getFotoPerfil() != null && !autor.getFotoPerfil().isEmpty()) {
                        String fp = autor.getFotoPerfil();
                        if (fp.startsWith("/")) fp = fp.substring(1);
                        if (!fp.startsWith("img/")) fp = "img/" + fp;
                        avatarAutor = request.getContextPath() + "/" + fp;
                    }
        %>
            <a href="<%= request.getContextPath() %>/verReceta?id=<%= r.getId() %>" class="recipe-link">
                <article class="recipe-card">
                    <img src="<%= fotoReceta %>" alt="<%= r.getTitulo() %>" class="recipe-img">
                    <div class="recipe-info">
                        <h3 class="recipe-title"><%= r.getTitulo() %></h3>

                        <div class="recipe-user">
                            <img src="<%= avatarAutor %>" class="avatar" alt="Perfil">
                            <span>@<%= username %></span>
                        </div>

                        <div class="recipe-details" style="display: flex; flex-wrap: wrap; gap: 12px; margin-top: 8px;">
                            <div class="detail" style="display: flex; align-items: center; gap: 6px; font-size: 13px; color: #666;">
                                <i class="fa-solid fa-star" style="color: #e13b63;"></i>
                                <span>Dificultad: <%= r.getDificultad() %></span>
                            </div>
                            
                            <div class="detail" style="display: flex; align-items: center; gap: 6px; font-size: 13px; color: #666;">
                                <i class="fa-solid fa-clock" style="color: #e13b63;"></i>
                                <span>Tiempo: <%= r.getTiempoPreparacion() %> min</span>
                            </div>
                            
                            <%
                                // Obtener características de la receta
                                RecetaCaracteristicaDAO rcDAO = new RecetaCaracteristicaDAO();
                                List<String> caracteristicas = rcDAO.listarCaracteristicasReceta(r.getId());
                                if (caracteristicas != null && !caracteristicas.isEmpty()) {
                                    for (String caract : caracteristicas) {
                            %>
                                        <div class="detail" style="display: flex; align-items: center; gap: 6px; font-size: 13px; color: #666;">
                                            <% if (caract.equalsIgnoreCase("Vegetariano")) { %>
                                                <i class="fa-solid fa-leaf" style="color: #e13b63;"></i>
                                            <% } else if (caract.equalsIgnoreCase("Vegano")) { %>
                                                <i class="fa-solid fa-seedling" style="color: #e13b63;"></i>
                                            <% } else if (caract.equalsIgnoreCase("Sin gluten")) { %>
                                                <img src="<%= request.getContextPath() %>/img/sin-gluten.png" class="diet-icon" style="width: 16px; height: 16px; object-fit: contain;">
                                            <% } else if (caract.equalsIgnoreCase("Healthy")) { %>
                                                <i class="fa-solid fa-apple-whole" style="color: #e13b63;"></i>
                                            <% } %>
                                            <span><%= caract %></span>
                                        </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                        
                        <% if (yo.isAdmin()) { %>
                            <form method="post" action="<%=request.getContextPath()%>/admin/eliminarReceta" 
                                  style="margin-top: 12px;" 
                                  onsubmit="return confirm('¿Estás seguro de que quieres eliminar esta receta?');">
                                <input type="hidden" name="recetaId" value="<%= r.getId() %>">
                                <button type="submit" style="
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
                                " onmouseover="this.style.background='#c82333'" onmouseout="this.style.background='#dc3545'">
                                    <i class="fa-solid fa-trash"></i>
                                    Eliminar (Admin)
                                </button>
                            </form>
                        <% } %>
                    </div>
                </article>
            </a>
        <%
                }
            }
        %>
    </div>

    <!-- USUARIOS -->
    <div class="results usuarios hidden">
        <ul>
            <%
                boolean alguno = false;
                for (Usuario u : usuarios) {
                    if (u.getId() == yo.getId()) continue;
                    alguno = true;

                    String av = request.getContextPath() + "/img/default-avatar.png";
                    if (u.getFotoPerfil() != null && !u.getFotoPerfil().isEmpty()) {
                        String fp = u.getFotoPerfil();
                        if (fp.startsWith("/")) fp = fp.substring(1);
                        if (!fp.startsWith("img/")) fp = "img/" + fp;
                        av = request.getContextPath() + "/" + fp;
                    }
            %>
                <li class="user-card" data-user-id="<%=u.getId()%>" style="position: relative; cursor: pointer;">
                    <div onclick="window.location.href='<%= request.getContextPath() %>/usu/usuario?id=<%= u.getId() %>';" style="display: flex; align-items: center; gap: 15px; flex: 1;">
                        <img src="<%= av %>" alt="Perfil" class="avatar-large">
                        <div>
                            <h4>@<%= u.getUsername() %> <%= u.isBaneado() ? "<span style='color: #dc3545; font-size: 12px;'>(Baneado)</span>" : "" %></h4>
                            <p><%= (u.getBiografia() == null) ? "" : u.getBiografia() %></p>
                        </div>
                    </div>
                    
                    <% if (yo.isAdmin()) { %>
                        <form method="post" 
                              action="<%=request.getContextPath()%><%= u.isBaneado() ? "/admin/desbanearUsuario" : "/admin/banearUsuario" %>" 
                              style="margin-left: auto;"
                              onsubmit="return confirm('<%= u.isBaneado() ? "¿Desbanear a este usuario?" : "¿Estás seguro de que quieres banear a este usuario?" %>');"
                              onclick="event.stopPropagation();">
                            <input type="hidden" name="usuarioId" value="<%= u.getId() %>">
                            <button type="submit" style="
                                background: <%= u.isBaneado() ? "#28a745" : "#dc3545" %>;
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
                            " onmouseover="this.style.background='<%= u.isBaneado() ? "#218838" : "#c82333" %>'" 
                               onmouseout="this.style.background='<%= u.isBaneado() ? "#28a745" : "#dc3545" %>'">
                                <i class="fa-solid fa-<%= u.isBaneado() ? "check" : "ban" %>"></i>
                                <%= u.isBaneado() ? "Desbanear" : "Banear" %> (Admin)
                            </button>
                        </form>
                    <% } %>
                </li>
            <%
                }
                if (!alguno) {
            %>
                <li style="opacity:.75;">No hay usuarios para mostrar.</li>
            <%
                }
            %>
        </ul>
    </div>
</main>

<!-- JS igual que menu.jsp -->
<script>
    const CONTEXT_PATH = '<%= request.getContextPath() %>';
</script>
<script src="<%= request.getContextPath() %>/js/notificaciones.js"></script>
<script src="<%= request.getContextPath() %>/js/menu.js"></script>
<script src="<%= request.getContextPath() %>/js/explorar.js"></script>

</body>
</html>
