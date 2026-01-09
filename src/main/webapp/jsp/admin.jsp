<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.mycompany.recetagram.model.*"%>

<%
  Usuario yo = (Usuario) session.getAttribute("usuarioLogueado");
  if (yo == null || !yo.isAdmin()) {
    response.sendError(403);
    return;
  }

  List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
  List<Receta> recetas = (List<Receta>) request.getAttribute("recetas");
  List<Comentario> comentarios = (List<Comentario>) request.getAttribute("comentarios");
%>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin - Recetagram</title>

  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/menu.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/explorar.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    .admin-wrap { padding: 20px; }
    .admin-card { background: white; border-radius: 14px; padding: 16px; margin-bottom: 16px; box-shadow: 0 6px 16px rgba(0,0,0,.08); }
    table { width: 100%; border-collapse: collapse; }
    th, td { padding: 10px; border-bottom: 1px solid rgba(0,0,0,.08); text-align:left; }
    .btn-del { border:none; padding:8px 10px; border-radius:10px; cursor:pointer; background:#e74c3c; color:white; font-weight:700; }
    .pill { display:inline-block; padding:4px 10px; border-radius:999px; background:rgba(0,0,0,.06); font-weight:700; }
  </style>
</head>

<body>

  <aside class="sidebar">
    <div class="logo">
      <img src="<%=request.getContextPath()%>/img/logo_texto.png" alt="Logo Recetagram" class="logo-full">
    </div>

    <nav class="nav-links">
      <a href="<%=request.getContextPath()%>/jsp/menu.jsp"><i class="fa-solid fa-house"></i> <span>Inicio</span></a>
      <a href="<%=request.getContextPath()%>/social/explorar"><i class="fa-solid fa-compass"></i> <span>Explorar</span></a>
      <a href="<%=request.getContextPath()%>/social/amigos"><i class="fa-solid fa-user-group"></i> <span>Amigos</span></a>
      <a href="<%=request.getContextPath()%>/social/chat"><i class="fa-solid fa-envelope"></i> <span>Chats</span></a>
      <a href="<%=request.getContextPath()%>/admin/panel" class="active"><i class="fa-solid fa-shield"></i> <span>Admin</span></a>
    </nav>

    <div class="logout-wrapper">
      <a href="<%=request.getContextPath()%>/usu/logout">
        <i class="fa-solid fa-right-from-bracket"></i>
        <span>Cerrar sesión</span>
      </a>
    </div>
  </aside>

  <main class="explore-section admin-wrap">
    <h2>Panel de administración</h2>
    <p style="opacity:.8;">Puedes eliminar usuarios, recetas y comentarios.</p>

    <!-- Usuarios -->
    <div class="admin-card">
      <h3>Usuarios</h3>
      <table>
        <tr><th>ID</th><th>Username</th><th>Email</th><th>Rol</th><th>Acción</th></tr>
        <%
          if (usuarios != null) {
            for (Usuario u : usuarios) {
        %>
        <tr>
          <td><span class="pill"><%=u.getId()%></span></td>
          <td>@<%=u.getUsername()%></td>
          <td><%=u.getEmail()%></td>
          <td><%=u.isAdmin() ? "ADMIN" : "USER"%></td>
          <td>
            <form method="post" action="<%=request.getContextPath()%>/admin/delete" style="margin:0;">
              <input type="hidden" name="tipo" value="usuario">
              <input type="hidden" name="id" value="<%=u.getId()%>">
              <button class="btn-del" type="submit">Eliminar</button>
            </form>
          </td>
        </tr>
        <%
            }
          }
        %>
      </table>
    </div>

    <!-- Recetas -->
    <div class="admin-card">
      <h3>Recetas</h3>
      <table>
        <tr><th>ID</th><th>Título</th><th>Usuario</th><th>Acción</th></tr>
        <%
          if (recetas != null) {
            for (Receta r : recetas) {
        %>
        <tr>
          <td><span class="pill"><%=r.getId()%></span></td>
          <td><%=r.getTitulo()%></td>
          <td><%=r.getUsuarioId()%></td>
          <td>
            <form method="post" action="<%=request.getContextPath()%>/admin/delete" style="margin:0;">
              <input type="hidden" name="tipo" value="receta">
              <input type="hidden" name="id" value="<%=r.getId()%>">
              <button class="btn-del" type="submit">Eliminar</button>
            </form>
          </td>
        </tr>
        <%
            }
          }
        %>
      </table>
    </div>

    <!-- Comentarios -->
    <div class="admin-card">
      <h3>Comentarios</h3>
      <table>
        <tr><th>ID</th><th>Receta</th><th>Usuario</th><th>Texto</th><th>Acción</th></tr>
        <%
          if (comentarios != null) {
            for (Comentario c : comentarios) {
        %>
        <tr>
          <td><span class="pill"><%=c.getId()%></span></td>
          <td><%=c.getRecetaId()%></td>
          <td><%=c.getUsuarioId()%></td>
          <td><%=c.getTexto()%></td>
          <td>
            <form method="post" action="<%=request.getContextPath()%>/admin/delete" style="margin:0;">
              <input type="hidden" name="tipo" value="comentario">
              <input type="hidden" name="id" value="<%=c.getId()%>">
              <button class="btn-del" type="submit">Eliminar</button>
            </form>
          </td>
        </tr>
        <%
            }
          }
        %>
      </table>
    </div>

  </main>

</body>
</html>

