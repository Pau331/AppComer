<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.mycompany.recetagram.model.Usuario"%>
<%@page import="com.mycompany.recetagram.model.Receta"%>

<%
  Usuario yo = (Usuario) session.getAttribute("usuarioLogueado");
  if (yo == null) {
    response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
    return;
  }

  String q = (String) request.getAttribute("q");
  if (q == null) q = "";

  List<Receta> recetas = (List<Receta>) request.getAttribute("recetas");
  List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");

  String avatarYo = (yo.getFotoPerfil() == null || yo.getFotoPerfil().isBlank())
        ? (request.getContextPath() + "/img/default-avatar.png")
        : (request.getContextPath() + "/" + yo.getFotoPerfil());
%>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Explorar - Recetagram</title>

  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/explorar.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/menu.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>

<body>

  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="logo">
      <img src="<%=request.getContextPath()%>/img/logo_texto.png" alt="Logo Recetagram" class="logo-full">
    </div>

    <nav class="nav-links">
      <a href="<%=request.getContextPath()%>/jsp/menu.jsp"><i class="fa-solid fa-house"></i> <span>Inicio</span></a>

      <div class="notification-wrapper-sidebar" id="notif-wrapper">
        <i class="fa-solid fa-bell" id="notif-icon-sidebar"></i>
        <span>Notificaciones</span>
        <span class="notif-badge" id="notif-badge">3</span>
      </div>

      <a href="<%=request.getContextPath()%>/html/crear-receta.html"><i class="fa-solid fa-circle-plus"></i> <span>Crear receta</span></a>
      <a href="<%=request.getContextPath()%>/social/explorar" class="active"><i class="fa-solid fa-compass"></i> <span>Explorar</span></a>
      <a href="<%=request.getContextPath()%>/social/amigos"><i class="fa-solid fa-user-group"></i> <span>Amigos</span></a>
      <a href="<%=request.getContextPath()%>/social/chat"><i class="fa-solid fa-envelope"></i> <span>Chats</span></a>
      <% if (yo.isAdmin()) { %>
        <a href="<%=request.getContextPath()%>/admin/panel"><i class="fa-solid fa-shield"></i> <span>Admin</span></a>
      <% } %>
    </nav>

    <div class="logout-wrapper">
      <a href="<%=request.getContextPath()%>/usu/logout">
        <i class="fa-solid fa-right-from-bracket"></i>
        <span>Cerrar sesión</span>
      </a>
    </div>
  </aside>

  <!-- Notificaciones (si tu CSS/JS ya lo usa) -->
  <div class="notif-panel" id="notif-panel">
    <h3>Notificaciones</h3>
    <div class="notif-item">
      <img src="https://i.pravatar.cc/40?img=10" alt="notif" class="notif-avatar">
      <p><b>chef_luisa</b> le dio like a tu publicación</p>
    </div>
  </div>

  <!-- Topbar -->
  <div class="topbar">
    <div class="search-wrapper">
      <i class="fa-solid fa-magnifying-glass search-icon"></i>

      <!-- búsqueda REAL -->
      <form method="get" action="<%=request.getContextPath()%>/social/explorar" style="width:100%;">
        <input type="text" name="q" value="<%=q%>" placeholder="Buscar recetas o usuarios..." class="search-bar">
      </form>
    </div>

    <div class="top-right-icons" style="display:flex; gap:18px; align-items:center;">
      <a href="<%=request.getContextPath()%>/social/chat"><i class="fa-solid fa-envelope"></i></a>
      <a href="<%=request.getContextPath()%>/perfil"><img src="<%=avatarYo%>" alt="yo" style="width:34px;height:34px;border-radius:50%;object-fit:cover;"></a>
    </div>
  </div>

  <!-- Contenido -->
  <main class="explore-section">

    <!-- RECETAS -->
    <h2 style="margin-bottom:10px;">Recetas</h2>
    <div class="results recetas" id="results-recetas">
      <%
        if (recetas == null || recetas.isEmpty()) {
      %>
        <p style="opacity:.75;">No hay recetas para mostrar.</p>
      <%
        } else {
          for (Receta r : recetas) {
      %>
        <!-- respeta el layout que suele venir en explorar.css -->
        <div class="recipe-card">
          <div class="recipe-card-top">
            <h3><%=r.getTitulo()%></h3>
            <p style="opacity:.8;">Dificultad: <b><%=r.getDificultad()%></b> · Tiempo: <b><%=r.getTiempoPreparacion()%> min</b></p>
          </div>

          <div class="recipe-card-bottom">
            <p style="opacity:.85;">
              <%= (r.getPasos() == null) ? "" : (r.getPasos().length() > 120 ? r.getPasos().substring(0, 120) + "..." : r.getPasos()) %>
            </p>

            <!-- si tu app tiene "ver receta", cambia esta ruta a la tuya -->
            <a class="btn-ver" href="<%=request.getContextPath()%>/html/receta.html?id=<%=r.getId()%>">Ver</a>
          </div>
        </div>
      <%
          }
        }
      %>
    </div>

    <hr style="margin:22px 0; opacity:.25;">

    <!-- USUARIOS -->
    <h2 style="margin-bottom:10px;">Usuarios</h2>
    <div class="results usuarios" id="results-usuarios">
      <%
        if (usuarios == null || usuarios.isEmpty()) {
      %>
        <p style="opacity:.75;">No hay usuarios para mostrar.</p>
      <%
        } else {
          for (Usuario u : usuarios) {
            if (u.getId() == yo.getId()) continue;

            String av = (u.getFotoPerfil() == null || u.getFotoPerfil().isBlank())
                ? (request.getContextPath() + "/img/default-avatar.png")
                : (request.getContextPath() + "/" + u.getFotoPerfil());
      %>
        <div class="user-card" data-username="@<%=u.getUsername()%>">
          <img src="<%=av%>" alt="Usuario" class="avatar-large">
          <div>
            <h4>@<%=u.getUsername()%></h4>
            <p><%= (u.getBiografia() == null) ? "" : u.getBiografia() %></p>
          </div>

          <!-- acciones -->
          <div style="margin-left:auto; display:flex; gap:12px; align-items:center;">
            <a href="<%=request.getContextPath()%>/social/chat?con=<%=u.getId()%>" title="Mensaje">
              <i class="fa-solid fa-envelope send-message"></i>
            </a>

            <form method="post" action="<%=request.getContextPath()%>/social/amigos" style="margin:0;">
              <input type="hidden" name="accion" value="solicitar">
              <input type="hidden" name="targetId" value="<%=u.getId()%>">
              <button type="submit" style="border:none;border-radius:10px;padding:10px 12px;cursor:pointer;font-weight:700;background:#3498db;color:white;">
                Añadir
              </button>
            </form>
          </div>
        </div>
      <%
          }
        }
      %>
    </div>

  </main>

  <script>
    const notifWrapper = document.getElementById('notif-wrapper');
    const notifPanel = document.getElementById('notif-panel');
    const notifBadge = document.getElementById('notif-badge');

    if (notifWrapper && notifPanel) {
      notifWrapper.addEventListener('click', () => {
        notifPanel.classList.toggle('open');
        if (notifBadge) notifBadge.style.display = 'none';
      });
      document.addEventListener('click', (e) => {
        if (!notifPanel.contains(e.target) && !notifWrapper.contains(e.target)) {
          notifPanel.classList.remove('open');
        }
      });
    }
  </script>

</body>
</html>

