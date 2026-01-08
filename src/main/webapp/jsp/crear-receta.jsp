<%@ page import="com.mycompany.recetagram.model.Usuario" %>
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
  <title>Recetagram ? Crear receta</title>

  <link rel="stylesheet" href="../css/menu.css">
  <link rel="stylesheet" href="../css/receta.css">
  <link rel="stylesheet" href="../css/crear-receta.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

  <!-- Sidebar y Topbar (igual que tu menú) -->
  <aside class="sidebar">
    <!-- tu código sidebar -->
  </aside>

  <div class="topbar">
    <!-- tu código topbar -->
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
              <option value="Facil">Facil</option>
              <option value="Media">Media</option>
              <option value="Dificil">Dificil</option>
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
                <img id="prevFoto" class="photo" src="../img/photo-placeholder.png" alt="Previsualización">
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

  <script src="../js/menu.js"></script>
  <script src="../js/crear-receta.js"></script>
</body>
</html>
