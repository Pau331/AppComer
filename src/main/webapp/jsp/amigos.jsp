<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.recetagram.model.Usuario" %>
<%
  Usuario yo = (Usuario) session.getAttribute("usuarioLogueado");
  if (yo == null) {
    response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
    return;
  }

  List<Usuario> amigos = (List<Usuario>) request.getAttribute("amigos");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Amigos - Recetagram</title>

  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/explorar.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/menu.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    /* Copiado de tu amigos.html para los iconos arriba a la derecha */
    .top-right-icons {
      position: fixed;
      top: 15px;
      right: 20px;
      display: flex;
      gap: 15px;
      font-size: 22px;
      z-index: 2000;
    }
    .top-right-icons a {
      color: #555;
      text-decoration: none;
      transition: color .2s;
    }
    .top-right-icons a:hover { color: #e13b63; }
  </style>
</head>

<body>

  <!-- Sidebar (igual que en tus páginas) -->
  <aside class="sidebar">
    <div class="logo">
      <img src="<%= request.getContextPath() %>/img/logo_texto.png" alt="Logo Recetagram" class="logo-full">
    </div>

    <nav class="nav-links">
      <a href="<%= request.getContextPath() %>/feed"><i class="fa-solid fa-house"></i> <span>Inicio</span></a>

      <div class="notification-wrapper-sidebar" id="notif-wrapper">
        <i class="fa-solid fa-bell" id="notif-icon-sidebar"></i>
        <span>Notificaciones</span>
        <span class="notif-badge" id="notif-badge">0</span>
        <div class="notifications-dropdown-overlay" id="notif-dropdown-sidebar"></div>
      </div>

      <a href="<%= request.getContextPath() %>/jsp/crear-receta.jsp"><i class="fa-solid fa-circle-plus"></i> <span>Crear receta</span></a>
      <a href="<%= request.getContextPath() %>/social/amigos" class="active"><i class="fa-solid fa-user-group"></i> <span>Amigos</span></a>
      <% if (yo.isAdmin()) { %>
      <a href="<%= request.getContextPath() %>/admin/panel"><i class="fa-solid fa-shield-halved"></i> <span>Panel Admin</span></a>
      <% } %>
    </nav>

    <div class="logout-wrapper">
      <a href="<%= request.getContextPath() %>/usu/logout"><i class="fa-solid fa-right-from-bracket"></i><span>Cerrar sesión</span></a>
    </div>
  </aside>

  <!-- Topbar -->
  <div class="topbar">
    <div class="search-wrapper">
      <i class="fa-solid fa-magnifying-glass search-icon"></i>
      <input id="searchFriends" type="text" placeholder="Buscar amigos..." class="search-bar">
    </div>

    <div class="top-right-icons">
      <!-- si no tienes chat aún, esto no rompe nada si lo dejas en # -->
      <a href="#" title="Chat"><i class="fa-solid fa-envelope"></i></a>
      <a href="<%= request.getContextPath() %>/usu/perfil" title="Perfil"><i class="fa-solid fa-user"></i></a>
    </div>
  </div>

  <!-- Contenido principal -->
  <main class="explore-section">
    <div class="results usuarios" id="friendsList">

      <%
        if (amigos == null || amigos.isEmpty()) {
      %>
        <p style="padding: 18px; color:#666; text-align: center; width: 100%;">Aún no tienes amigos añadidos.</p>
      <%
        } else {
          for (Usuario u : amigos) {

            // avatar igual que en tus JSP: si viene vacío -> default
            String avatarUrl = request.getContextPath() + "/img/default-avatar.png";
            if (u.getFotoPerfil() != null && !u.getFotoPerfil().isEmpty()) {
              String fp = u.getFotoPerfil();
              if (fp.startsWith("/")) fp = fp.substring(1);
              if (!fp.startsWith("img/")) fp = "img/" + fp;
              avatarUrl = request.getContextPath() + "/" + fp;
            }

            String bio = (u.getBiografia() != null && !u.getBiografia().isEmpty())
                    ? u.getBiografia()
                    : "Sin biografía";
      %>

      <div class="user-card" data-username="@<%= u.getUsername() %>" style="position: relative; cursor: pointer;" onclick="window.location.href='<%= request.getContextPath() %>/usu/usuario?id=<%= u.getId() %>';">
        <img src="<%= avatarUrl %>" alt="Usuario" class="avatar-large">

        <div>
          <h4>@<%= u.getUsername() %></h4>
          <p><%= bio %></p>
        </div>

        <!-- Click en el sobre: por ahora lo dejamos visual -->
        <span class="send-message" title="Enviar mensaje" style="pointer-events: none;">
          <i class="fa-solid fa-envelope"></i>
        </span>
      </div>

      <%
          }
        }
      %>

    </div>
  </main>

  <!-- Scripts para notificaciones y menú -->
  <script>
    const CONTEXT_PATH = '<%= request.getContextPath() %>';
  </script>
  <script src="<%= request.getContextPath() %>/js/notificaciones.js"></script>
  <script src="<%= request.getContextPath() %>/js/menu.js"></script>

  <!-- Filtro simple sin archivo JS -->
  <script>
    (function () {
      const input = document.getElementById('searchFriends');
      const list  = document.getElementById('friendsList');
      if (!input || !list) return;

      input.addEventListener('input', function () {
        const q = input.value.toLowerCase().trim();
        const cards = list.querySelectorAll('.user-card');
        cards.forEach(card => {
          const name = (card.getAttribute('data-username') || '').toLowerCase();
          card.style.display = name.includes(q) ? '' : 'none';
        });
      });
    })();
  </script>

</body>
</html>
