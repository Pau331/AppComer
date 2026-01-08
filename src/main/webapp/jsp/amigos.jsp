<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.mycompany.recetagram.model.Usuario"%>
<%@page import="com.mycompany.recetagram.model.Amigo"%>

<%
  Usuario yo = (Usuario) session.getAttribute("usuarioLogueado");
  if (yo == null) {
    response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
    return;
  }

  String q = (String) request.getAttribute("q");
  if (q == null) q = "";

  List<Usuario> encontrados = (List<Usuario>) request.getAttribute("encontrados");
  List<Amigo> solicitudes = (List<Amigo>) request.getAttribute("solicitudes");
  List<Amigo> amigos = (List<Amigo>) request.getAttribute("amigos");
%>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Amigos - Recetagram</title>

  <!-- MISMO DISEÑO QUE TU HTML -->
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/explorar.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/menu.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <!-- Mantengo tu <style> inline (si quieres, lo puedo mover a CSS luego) -->
  <style>
    /* ----- Iconos superiores ----- */
    .top-right-icons {
      display: flex;
      gap: 20px;
      align-items: center;
    }
    .top-right-icons i {
      font-size: 20px;
      cursor: pointer;
      color: #333;
      transition: color 0.2s ease;
    }
    .top-right-icons i:hover { color: #e13b63; }

    /* Panel chat (tu diseño original) */
    .chat-panel {
      position: fixed;
      right: 25px;
      top: 120px;
      width: 280px;
      background: white;
      border-radius: 12px;
      box-shadow: 0 6px 20px rgba(0,0,0,0.15);
      padding: 15px;
      display: none;
      z-index: 2000;
    }
    .chat-panel h4 { margin-bottom: 10px; }
    .chat-panel textarea {
      width: 100%;
      height: 90px;
      border-radius: 10px;
      border: 1px solid #ddd;
      padding: 10px;
      resize: none;
      outline: none;
      margin-bottom: 10px;
    }
    .chat-panel .send-btn {
      width: 100%;
      background: #e13b63;
      color: white;
      border: none;
      padding: 10px;
      border-radius: 10px;
      font-weight: 600;
      cursor: pointer;
    }
    .chat-panel .send-btn:hover { opacity: 0.95; }

    .sent-msg {
      position: fixed;
      right: 25px;
      top: 90px;
      background: #2ecc71;
      color: white;
      padding: 10px 14px;
      border-radius: 10px;
      display: none;
      z-index: 2100;
      font-weight: 600;
    }

    /* Botones para solicitudes */
    .btn-row { display:flex; gap:10px; margin-left:auto; }
    .btn-action {
      border: none; border-radius: 10px; padding: 10px 12px;
      cursor: pointer; font-weight: 700;
    }
    .btn-accept { background:#2ecc71; color:white; }
    .btn-reject { background:#e74c3c; color:white; }
    .btn-add    { background:#3498db; color:white; }
    .section-title { margin: 20px 0 10px; font-size: 18px; font-weight: 800; }
    .muted { opacity: .75; }
  </style>
</head>

<body>

  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="logo">
      <img src="<%=request.getContextPath()%>/img/logo_texto.png" alt="Logo Recetagram" class="logo-full">
    </div>

    <nav class="nav-links">
      <a href="<%=request.getContextPath()%>/jsp/menu.jsp"><i class="fa-solid fa-house"></i> <span>Inicio</span></a>

      <!-- (si tienes notificaciones por JS, lo dejas igual; si no, puedes quitarlo) -->
      <div class="notification-wrapper-sidebar" id="notif-wrapper">
        <i class="fa-solid fa-bell" id="notif-icon-sidebar"></i>
        <span>Notificaciones</span>
        <span class="notif-badge" id="notif-badge">3</span>
      </div>

      <a href="<%=request.getContextPath()%>/html/crear-receta.html"><i class="fa-solid fa-circle-plus"></i> <span>Crear receta</span></a>
      <a href="<%=request.getContextPath()%>/social/explorar"><i class="fa-solid fa-compass"></i> <span>Explorar</span></a>
      <a href="<%=request.getContextPath()%>/social/amigos" class="active"><i class="fa-solid fa-user-group"></i> <span>Amigos</span></a>
    </nav>

    <div class="logout-wrapper">
      <a href="<%=request.getContextPath()%>/usu/logout">
        <i class="fa-solid fa-right-from-bracket"></i>
        <span>Cerrar sesión</span>
      </a>
    </div>
  </aside>

  <!-- Notificaciones (lo dejo tal cual estabas usando) -->
  <div class="notif-panel" id="notif-panel">
    <h3>Notificaciones</h3>
    <div class="notif-item">
      <img src="https://i.pravatar.cc/40?img=10" alt="chef_luisa" class="notif-avatar">
      <p><b>chef_luisa</b> le dio like a tu publicación</p>
    </div>
  </div>

  <!-- Topbar -->
  <div class="topbar">
    <div class="search-wrapper">
      <i class="fa-solid fa-magnifying-glass search-icon"></i>

      <!-- AHORA ES BUSQUEDA REAL (GET) -->
      <form method="get" action="<%=request.getContextPath()%>/social/amigos" style="width:100%;">
        <input type="text" name="q" value="<%=q%>" placeholder="Buscar amigos..." class="search-bar">
      </form>
    </div>

    <div class="top-right-icons">
      <a href="<%=request.getContextPath()%>/social/chat"><i class="fa-solid fa-envelope"></i></a>
      <a href="<%=request.getContextPath()%>/perfil"><i class="fa-solid fa-user"></i></a>
    </div>
  </div>

  <!-- Contenido principal -->
  <main class="explore-section">

    <!-- 1) Buscar usuarios -->
    <div class="section-title">Buscar usuarios</div>
    <div class="results usuarios" id="results-busqueda">

      <%
        if (encontrados == null || encontrados.isEmpty()) {
      %>
        <p class="muted">No hay resultados (prueba a buscar por username).</p>
      <%
        } else {
          for (Usuario u : encontrados) {
            if (u.getId() == yo.getId()) continue;
      %>
        <div class="user-card" data-username="@<%=u.getUsername()%>">
          <img src="<%=request.getContextPath()%>/<%=u.getFotoPerfil()%>" alt="Usuario" class="avatar-large">
          <div>
            <h4>@<%=u.getUsername()%></h4>
            <p><%= (u.getBiografia() == null || u.getBiografia().isBlank()) ? "" : u.getBiografia() %></p>
          </div>

          <div class="btn-row">
            <!-- abrir chat -->
            <a href="<%=request.getContextPath()%>/social/chat?con=<%=u.getId()%>" title="Enviar mensaje">
              <i class="fa-solid fa-envelope send-message"></i>
            </a>

            <!-- enviar solicitud -->
            <form method="post" action="<%=request.getContextPath()%>/social/amigos" style="margin:0;">
              <input type="hidden" name="accion" value="solicitar">
              <input type="hidden" name="targetId" value="<%=u.getId()%>">
              <button class="btn-action btn-add" type="submit">Añadir</button>
            </form>
          </div>
        </div>
      <%
          }
        }
      %>
    </div>

    <!-- 2) Solicitudes recibidas -->
    <div class="section-title">Solicitudes recibidas</div>
    <div class="results usuarios" id="results-solicitudes">

      <%
        if (solicitudes == null || solicitudes.isEmpty()) {
      %>
        <p class="muted">No tienes solicitudes pendientes.</p>
      <%
        } else {
          for (Amigo a : solicitudes) {
      %>
        <div class="user-card">
          <img src="<%=request.getContextPath()%>/img/default-avatar.png" alt="Usuario" class="avatar-large"> 

          <div>
            <h4>Solicitud</h4>
            <p>Usuario ID: <b><%=a.getUsuarioId()%></b> te ha enviado solicitud</p>
          </div>

          <div class="btn-row">
            <form method="post" action="<%=request.getContextPath()%>/social/amigos" style="margin:0;">
              <input type="hidden" name="accion" value="aceptar">
              <input type="hidden" name="amistadId" value="<%=a.getId()%>">
              <button class="btn-action btn-accept" type="submit">Aceptar</button>
            </form>

            <form method="post" action="<%=request.getContextPath()%>/social/amigos" style="margin:0;">
              <input type="hidden" name="accion" value="rechazar">
              <input type="hidden" name="amistadId" value="<%=a.getId()%>">
              <button class="btn-action btn-reject" type="submit">Rechazar</button>
            </form>
          </div>
        </div>
      <%
          }
        }
      %>
    </div>

    <!-- 3) Mis amigos -->
    <div class="section-title">Mis amigos</div>
    <div class="results usuarios" id="results-amigos">

      <%
        if (amigos == null || amigos.isEmpty()) {
      %>
        <p class="muted">Aún no tienes amigos aceptados.</p>
      <%
        } else {
          for (Amigo a : amigos) {
            int otroId = (a.getUsuarioId() == yo.getId()) ? a.getAmigoId() : a.getUsuarioId();
      %>
        <div class="user-card">
          <img src="<%=request.getContextPath()%>/img/default_avatar.png" alt="Usuario" class="avatar-large">
          <div>
            <h4>Amigo</h4>
            <p>ID usuario: <b><%=otroId%></b></p>
          </div>

          <a href="<%=request.getContextPath()%>/social/chat?con=<%=otroId%>" title="Enviar mensaje">
            <i class="fa-solid fa-envelope send-message"></i>
          </a>
        </div>
      <%
          }
        }
      %>
    </div>

  </main>

  <!-- (Tu panel chat original lo dejo, pero aquí realmente usamos /social/chat) -->
  <div class="chat-panel" id="chat-panel">
    <h4 id="chat-username">@usuario</h4>
    <textarea placeholder="Escribe tu mensaje..."></textarea>
    <button class="send-btn">Enviar</button>
  </div>

  <div class="sent-msg" id="sent-msg">Mensaje enviado</div>

  <script>
    // Mantengo tu JS de notificaciones si lo estabas usando
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
