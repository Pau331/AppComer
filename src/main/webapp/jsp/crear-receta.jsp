<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.mycompany.recetagram.model.Usuario" %>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if(u == null) {
        response.sendRedirect(request.getContextPath() + "/html/login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Recetagram - Crear receta</title>

  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/menu.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/receta.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/crear-receta.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="logo">
      <img src="<%= request.getContextPath() %>/img/logo_texto.png" alt="Logo Recetagram" class="logo-full">
    </div>

    <nav class="nav-links">
      <a href="<%= request.getContextPath() %>/feed"><i class="fa-solid fa-house"></i> <span>Inicio</span></a>

      <div class="notification-wrapper-sidebar" id="notif-wrapper">
        <i class="fa-solid fa-bell" id="notif-icon-sidebar"></i>
        <span>Notificaciones</span>
        <span class="notif-badge" id="notif-badge">3</span>
      </div>

      <a href="<%= request.getContextPath() %>/jsp/crear-receta.jsp" class="active"><i class="fa-solid fa-circle-plus"></i> <span>Crear receta</span></a>
      <a href="<%= request.getContextPath() %>/jsp/amigos.jsp"><i class="fa-solid fa-user-group"></i> <span>Amigos</span></a>
    </nav>
    
    <div class="logout-wrapper">
      <a href="<%= request.getContextPath() %>/usu/logout" id="logout-link">
        <i class="fa-solid fa-right-from-bracket"></i>
        <span>Cerrar sesión</span>
      </a>
    </div>
  </aside>

  <!-- Overlay notificaciones -->
  <div class="notifications-dropdown-overlay" id="notif-dropdown-sidebar"></div>

  <!-- Topbar -->
  <div class="topbar">
    <div class="search-wrapper">
      <i class="fa-solid fa-magnifying-glass search-icon"></i>
      <input 
        type="text" 
        placeholder="Buscar recetas o usuarios..." 
        class="search-bar" 
        onclick="window.location.href='<%= request.getContextPath() %>/jsp/explorar.jsp'"
        readonly
      >
    </div>
  </div>

  <!-- Top-right icons -->
  <div class="top-right-icons">
    <a href="<%= request.getContextPath() %>/jsp/chat.jsp" class="icon"><i class="fa-solid fa-envelope"></i></a>
    <a href="<%= request.getContextPath() %>/jsp/perfil.jsp" class="icon">
      <% 
        String avatar = request.getContextPath() + "/img/default-avatar.png";
        if (u.getFotoPerfil() != null && !u.getFotoPerfil().isEmpty()) {
          String fotoPerfil = u.getFotoPerfil();
          if (fotoPerfil.startsWith("/")) fotoPerfil = fotoPerfil.substring(1);
          if (!fotoPerfil.startsWith("img/")) fotoPerfil = "img/" + fotoPerfil;
          avatar = request.getContextPath() + "/" + fotoPerfil;
        }
      %>
      <img src="<%= avatar %>" 
           alt="Perfil" 
           style="width: 30px; height: 30px; border-radius: 50%; object-fit: cover;">
    </a>
  </div>

  <!-- CONTENIDO -->
  <main class="page-wrap">
    <div class="center-col">
      <form action="<%= request.getContextPath() %>/receta" method="post" enctype="multipart/form-data">
        <div class="recipe-header">
          <input name="titulo" id="tituloInput" class="input-title" type="text" placeholder="Título de la receta" required>
        </div>

        <div class="recipe-details form-details">
          <div class="detail">
            <i class="fa-solid fa-star"></i>
            <select name="dificultad" id="dificultad" class="select">
              <option value="Facil">Fácil</option>
              <option value="Media">Media</option>
              <option value="Dificil">Difícil</option>
            </select>
          </div>
          <div class="detail">
            <i class="fa-solid fa-clock"></i>
            <input name="tiempo" id="tiempo" class="input" type="text" placeholder="Tiempo (ej. 20 min)" required>
          </div>
          <div class="detail dietas-select">
            <label class="chk"><input type="checkbox" name="dietas" value="Sin gluten"> Sin gluten</label>
            <label class="chk"><input type="checkbox" name="dietas" value="Healthy"> Healthy</label>
            <label class="chk"><input type="checkbox" name="dietas" value="Vegetariano"> Vegetariano</label>
          </div>
        </div>

        <div class="grid-2">
          <!-- PASOS -->
          <section class="card">
            <div class="card-body">
              <div class="row-space">
                <h3>Pasos</h3>
                <button id="btnAddPaso" class="btn-sec" type="button">+ Añadir paso</button>
              </div>
              <ol id="listaPasosEdit" class="steps-edit"></ol>
            </div>
          </section>

          <!-- FOTO + GUARDAR -->
          <aside class="card">
            <div class="card-body">
              <div class="image-drop" id="dropFoto">
                <img id="prevFoto" class="photo" src="<%= request.getContextPath() %>/img/photo-placeholder.png" alt="Previsualization">
                <div class="placeholder" id="placeholderFoto">
                  <i class="fa-solid fa-image"></i>
                  <p>Arrastra una imagen o pulsa para seleccionar</p>
                </div>
                <input id="fotoInput" type="file" accept="image/*" hidden name="foto">
              </div>

              <div class="actions">
                <button type="submit" id="btnGuardar" class="btn-like save-btn">
                  <i class="fa-solid fa-floppy-disk"></i> Guardar
                </button>
              </div>
            </div>
          </aside>
        </div>
      </form>
    </div>
  </main>

  <script>
    const CONTEXT_PATH = '<%= request.getContextPath() %>';
  </script>
  <script src="<%= request.getContextPath() %>/js/menu.js"></script>
  <script src="<%= request.getContextPath() %>/js/crear-receta.js"></script>
</body>
</html>
