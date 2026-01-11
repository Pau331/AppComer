<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.mycompany.recetagram.model.Usuario"%>
<%@page import="com.mycompany.recetagram.model.Receta"%>

<%
  Usuario yo = (Usuario) session.getAttribute("usuarioLogueado");
  if (yo == null) {
    response.sendRedirect(request.getContextPath() + "/html/login.html");
    return;
  }

  Usuario u = (Usuario) request.getAttribute("u");
  List<Receta> recetas = (List<Receta>) request.getAttribute("recetas");
  Boolean esAmigo = (Boolean) request.getAttribute("esAmigo");
  if (esAmigo == null) esAmigo = false;

  String avatar = (u.getFotoPerfil() == null || u.getFotoPerfil().isBlank())
        ? (request.getContextPath() + "/img/default-avatar.png")
        : (request.getContextPath() + "/" + u.getFotoPerfil());
%>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Recetagram — Usuario</title>

  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/menu.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/usuario.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

  <!-- SIDEBAR -->
  <aside class="sidebar">
    <div class="logo"><img src="<%=request.getContextPath()%>/img/logo_texto.png" class="logo-full" alt="Recetagram"></div>
    <nav class="nav-links">
      <a href="<%=request.getContextPath()%>/jsp/menu.jsp"><i class="fa-solid fa-house"></i><span>Inicio</span></a>

      <div class="notification-wrapper-sidebar" id="notif-wrapper">
        <i class="fa-solid fa-bell" id="notif-icon-sidebar"></i><span>Notificaciones</span>
        <span class="notif-badge" id="notif-badge">3</span>
      </div>

      <a href="<%=request.getContextPath()%>/html/crear-receta.html"><i class="fa-solid fa-circle-plus"></i><span>Crear receta</span></a>
      <a href="<%=request.getContextPath()%>/social/explorar"><i class="fa-solid fa-compass"></i><span>Explorar</span></a>
      <a href="<%=request.getContextPath()%>/social/amigos"><i class="fa-solid fa-user-group"></i><span>Amigos</span></a>
      <a href="<%=request.getContextPath()%>/social/chat"><i class="fa-solid fa-envelope"></i><span>Chats</span></a>
    </nav>

    <div class="logout-wrapper">
      <a href="<%=request.getContextPath()%>/usu/logout" id="index-link">
        <i class="fa-solid fa-right-from-bracket"></i><span>Cerrar sesión</span>
      </a>
    </div>
  </aside>

  <!-- TOPBAR -->
  <div class="topbar">
    <div class="topbar-actions">
      <a href="<%=request.getContextPath()%>/social/chat" class="icon-btn" aria-label="Mensajes"><i class="fa-solid fa-envelope"></i></a>
      <a href="<%=request.getContextPath()%>/usu/perfil" class="icon-btn" aria-label="Perfil"><i class="fa-solid fa-user"></i></a>
    </div>
  </div>

  <!-- CONTENIDO CENTRADO -->
  <main class="page-wrap">
    <div class="center-col">

      <!-- Cabecera del usuario -->
      <section class="header">
        <div class="body">
          <img class="avatar-lg" src="<%=avatar%>" alt="Avatar del usuario">
          <div style="flex:1">
            <div class="row">
              <h2 class="u">@<%=u.getUsername()%></h2>

              <a class="btn" href="<%=request.getContextPath()%>/social/chat?con=<%=u.getId()%>" style="text-decoration:none;">
                Mensaje
              </a>

              <form method="post" action="<%=request.getContextPath()%>/social/amigos" style="margin:0;">
                <input type="hidden" name="accion" value="toggle">
                <input type="hidden" name="targetId" value="<%=u.getId()%>">
                <button class="btn" type="submit">
                  <%= esAmigo ? "Dejar de ser amigos" : "Ser amigos" %>
                </button>
              </form>
            </div>

            <div class="meta">
              <%= (u.getBiografia() == null) ? "" : u.getBiografia() %>
            </div>
          </div>
        </div>
      </section>

      <!-- Lista de recetas de este usuario -->
      <section class="card">
        <div class="card-body">
          <h3 style="margin-top:0">Recetas de este usuario</h3>

          <div class="lista">
            <%
              if (recetas == null || recetas.isEmpty()) {
            %>
              <p style="opacity:.75;">Este usuario aún no ha subido recetas.</p>
            <%
              } else {
                for (Receta r : recetas) {
                  String desc = (r.getPasos() == null) ? "" : r.getPasos();
                  if (desc.length() > 120) desc = desc.substring(0, 120) + "...";
            %>
              <a class="recipe-link" href="<%=request.getContextPath()%>/html/receta.html?id=<%=r.getId()%>" style="text-decoration:none;">
                <div class="recipe-card" style="margin-bottom:12px;">
                  <div class="recipe-info">
                    <h3 class="recipe-title"><%=r.getTitulo()%></h3>
                    <div class="recipe-details">
                      <div class="detail"><i class="fa-solid fa-star"></i><span>Dificultad: <%=r.getDificultad()%></span></div>
                      <div class="detail"><i class="fa-solid fa-clock"></i><span>Tiempo: <%=r.getTiempoPreparacion()%> min</span></div>
                    </div>
                    <p style="opacity:.85; margin:8px 0 0;"><%=desc%></p>
                  </div>
                </div>
              </a>
            <%
                }
              }
            %>
          </div>

        </div>
      </section>

    </div>
  </main>

  <div class="notifications-dropdown-overlay" id="notif-dropdown-sidebar"></div>
  <script src="<%=request.getContextPath()%>/js/menu.js"></script>
</body>
</html>
