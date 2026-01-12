<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.recetagram.model.*" %>

<%
  Usuario yo = (Usuario) session.getAttribute("usuarioLogueado");
  if (yo == null) {
    response.sendRedirect(request.getContextPath() + "/jsp/logIn.jsp");
    return;
  }

  List<Usuario> contactos = (List<Usuario>) request.getAttribute("contactos");
  Usuario conUsuario = (Usuario) request.getAttribute("conUsuario");
  List<MensajePrivado> conversacion = (List<MensajePrivado>) request.getAttribute("conversacion");

  // Avatar del usuario logueado (misma lógica que ya usáis)
  String yoAvatar = request.getContextPath() + "/img/default-avatar.png";
  if (yo.getFotoPerfil() != null && !yo.getFotoPerfil().isEmpty()) {
    String fp = yo.getFotoPerfil();
    if (fp.startsWith("/")) fp = fp.substring(1);
    if (!fp.startsWith("img/")) fp = "img/" + fp;
    yoAvatar = request.getContextPath() + "/" + fp;
  }
%>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chats - Recetagram</title>

  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/chat.css">
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
      <a href="<%=request.getContextPath()%>/receta/feed"><i class="fa-solid fa-house"></i> <span>Inicio</span></a>
      <a href="<%=request.getContextPath()%>/social/chat" class="active"><i class="fa-solid fa-envelope"></i> <span>Chats</span></a>
      <a href="<%=request.getContextPath()%>/jsp/crear-receta.jsp"><i class="fa-solid fa-circle-plus"></i> <span>Crear receta</span></a>
      <a href="<%=request.getContextPath()%>/social/amigos"><i class="fa-solid fa-user-group"></i> <span>Amigos</span></a>
    </nav>

    <div class="logout-wrapper">
      <a href="<%=request.getContextPath()%>/usu/logout">
        <i class="fa-solid fa-right-from-bracket"></i>
        <span>Cerrar sesión</span>
      </a>
    </div>
  </aside>

  <main class="chat-container">

    <!-- Lista de chats -->
    <aside class="chat-list">
      <h2>Mensajes</h2>

      <div class="chat-section no-leidos">
        <h3>Conversaciones</h3>

        <%
          if (contactos == null || contactos.isEmpty()) {
        %>
            <p style="color:#777; font-size:14px; margin-top:10px;">
              Aún no tienes conversaciones. Entra en Amigos y pulsa el sobre para empezar.
            </p>
        <%
          } else {
            for (Usuario u : contactos) {
              String avatar = request.getContextPath() + "/img/default-avatar.png";
              if (u.getFotoPerfil() != null && !u.getFotoPerfil().isEmpty()) {
                String fp = u.getFotoPerfil();
                if (fp.startsWith("/")) fp = fp.substring(1);
                if (!fp.startsWith("img/")) fp = "img/" + fp;
                avatar = request.getContextPath() + "/" + fp;
              }

              boolean selected = (conUsuario != null && conUsuario.getId() == u.getId());
        %>

          <a href="<%=request.getContextPath()%>/social/chat?with=<%=u.getId()%>" style="text-decoration:none; color:inherit;">
            <div class="chat-card <%= selected ? "unread" : "" %>">
              <img src="<%=avatar%>" alt="<%=u.getUsername()%>" class="chat-avatar">
              <div>
                <p class="chat-name"><%=u.getUsername()%></p>
                <p class="chat-preview"><%= (u.getBiografia() != null && !u.getBiografia().isEmpty()) ? u.getBiografia() : "Pulsa para abrir chat" %></p>
              </div>
            </div>
          </a>

        <%
            }
          }
        %>
      </div>
    </aside>

    <!-- Vista del chat -->
    <section class="chat-view">

      <%
        if (conUsuario == null) {
      %>
        <div class="chat-placeholder">
          <img src="<%=request.getContextPath()%>/img/logo_texto.png" class="chat-logo-placeholder" alt="placeholder">
        </div>
      <%
        } else {
          String conAvatar = request.getContextPath() + "/img/default-avatar.png";
          if (conUsuario.getFotoPerfil() != null && !conUsuario.getFotoPerfil().isEmpty()) {
            String fp = conUsuario.getFotoPerfil();
            if (fp.startsWith("/")) fp = fp.substring(1);
            if (!fp.startsWith("img/")) fp = "img/" + fp;
            conAvatar = request.getContextPath() + "/" + fp;
          }
      %>

      <div class="chat-header">
        <img src="<%=conAvatar%>" class="chat-avatar" alt="avatar">
        <div>
          <strong class="chat-usuario-texto">@<%=conUsuario.getUsername()%></strong>
          <div style="font-size:12px; color:#777;"><%= (conUsuario.getBiografia() != null) ? conUsuario.getBiografia() : "" %></div>
        </div>
      </div>

      <div class="chat-messages">
        <%
          if (conversacion == null || conversacion.isEmpty()) {
        %>
            <p style="color:#777; font-size:14px;">No hay mensajes todavía. Escribe el primero 👇</p>
        <%
          } else {
            for (MensajePrivado m : conversacion) {
              boolean esMio = (m.getRemitenteId() == yo.getId());
        %>
              <div class="chat-bubble <%= esMio ? "user" : "other" %>">
                <%= m.getTexto() %>
              </div>
        <%
            }
          }
        %>
      </div>

      <form class="chat-input" action="<%=request.getContextPath()%>/social/chat" method="post">
        <input type="hidden" name="con" value="<%=conUsuario.getId()%>">
        <input type="text" name="texto" placeholder="Escribe un mensaje..." required>
        <button type="submit"><i class="fa-solid fa-paper-plane"></i></button>
      </form>

      <%
        }
      %>

    </section>

  </main>

</body>
</html>
