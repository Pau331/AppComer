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

  String yoAvatar = (yo.getFotoPerfil() == null || yo.getFotoPerfil().isBlank())
        ? (request.getContextPath() + "/img/default-avatar.png")
        : (request.getContextPath() + "/" + yo.getFotoPerfil());
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

  <aside class="sidebar">
    <div class="logo">
      <a href="<%=request.getContextPath()%>/feed">
        <img src="<%=request.getContextPath()%>/img/logo_texto.png" alt="Logo Recetagram" class="logo-full">
      </a>
    </div>

    <nav class="nav-links">
      <a href="<%=request.getContextPath()%>/feed"><i class="fa-solid fa-house"></i> <span>Inicio</span></a>
      <a href="<%=request.getContextPath()%>/social/chat" class="active"><i class="fa-solid fa-envelope"></i> <span>Chats</span></a>
      <a href="<%=request.getContextPath()%>/jsp/crear-receta.jsp"><i class="fa-solid fa-circle-plus"></i> <span>Crear receta</span></a>
      <a href="<%=request.getContextPath()%>/social/amigos"><i class="fa-solid fa-user-group"></i> <span>Amigos</span></a>
      <a href="<%=request.getContextPath()%>/social/explorar"><i class="fa-solid fa-compass"></i> <span>Explorar</span></a>
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

  <main class="chat-container">

    <aside class="chat-list">
      <h2>Mensajes</h2>

      <div class="chat-section leidos">
        <h3>Recientes</h3>

        <%
          if (contactos == null || contactos.isEmpty()) {
        %>
            <p style="padding:10px; opacity:.8;">Aún no tienes conversaciones.</p>
        <%
          } else {
            for (Usuario u : contactos) {
              String av = (u.getFotoPerfil() == null || u.getFotoPerfil().isBlank())
                    ? (request.getContextPath() + "/img/default-avatar.png")
                    : (request.getContextPath() + "/" + u.getFotoPerfil());
        %>
          <a href="<%=request.getContextPath()%>/social/chat?con=<%=u.getId()%>" style="text-decoration:none;">
            <div class="chat-card <%= (conUsuario!=null && conUsuario.getId()==u.getId()) ? "active" : "" %>">
              <img src="<%=av%>" alt="<%=u.getUsername()%>" class="chat-avatar">
              <div>
                <p class="chat-name"><%=u.getUsername()%></p>
                <p class="chat-preview">Abrir conversación</p>
              </div>
            </div>
          </a>
        <%
            }
          }
        %>

      </div>
    </aside>

    <section class="chat-window">
      <%
        if (conUsuario == null) {
      %>
        <div style="padding:20px; opacity:.8;">
          Selecciona un chat para ver mensajes.
        </div>
      <%
        } else {
          String conAv = (conUsuario.getFotoPerfil() == null || conUsuario.getFotoPerfil().isBlank())
                ? (request.getContextPath() + "/img/default-avatar.png")
                : (request.getContextPath() + "/" + conUsuario.getFotoPerfil());
      %>

      <header class="chat-header">
        <div class="chat-user">
          <img src="<%=conAv%>" class="chat-avatar" alt="avatar">
          <div>
            <h2><%=conUsuario.getUsername()%></h2>
          </div>
        </div>
        <a href="<%=request.getContextPath()%>/perfil" style="display:flex;align-items:center;gap:10px;text-decoration:none;">
          <img src="<%=yoAvatar%>" style="width:34px;height:34px;border-radius:50%;object-fit:cover;">
        </a>
      </header>

      <div class="chat-messages">
        <%
          if (conversacion == null || conversacion.isEmpty()) {
        %>
          <p style="padding:12px; opacity:.8;">No hay mensajes todav�a.</p>
        <%
          } else {
            for (MensajePrivado m : conversacion) {
              boolean mio = (m.getRemitenteId() == yo.getId());
        %>
          <div class="message <%=mio ? "sent" : "received"%>">
            <p><%=m.getTexto()%></p>
          </div>
        <%
            }
          }
        %>
      </div>

      <form class="chat-input" method="post" action="<%=request.getContextPath()%>/social/chat">
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
