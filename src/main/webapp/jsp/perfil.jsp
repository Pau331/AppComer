<%@ page import="com.mycompany.recetagram.model.Usuario" %>
<%
    // 1. Recuperar la sesión
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");

    // 2. Seguridad
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
        return;
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Recetagram — Mi perfil</title>
    <link rel="stylesheet" href="../css/menu.css">
    <link rel="stylesheet" href="../css/perfil.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <aside class="sidebar">
        <div class="logo"><img src="../img/logo_texto.png" class="logo-full" alt="Recetagram"></div>
        <nav class="nav-links">
            <a href="menu.jsp"><i class="fa-solid fa-house"></i><span>Inicio</span></a>
            <a href="crear-receta.jsp"><i class="fa-solid fa-circle-plus"></i><span>Crear receta</span></a>
            <a href="amigos.jsp"><i class="fa-solid fa-user-group"></i><span>Amigos</span></a>
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
                    <img id="avatarYo" class="avatar-lg" 
                         src="<%= request.getContextPath() %>/<%= (u.getFotoPerfil() != null && !u.getFotoPerfil().isEmpty()) ? u.getFotoPerfil() : "img/default-avatar.png" %>" 
                         alt="Avatar">

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
                    <div id="misRecetas" class="lista">
                        <p>Cargando tus recetas desde la base de datos...</p>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <script src="../js/menu.js"></script>
    <script src="../js/perfil.js"></script>
</body>
</html>