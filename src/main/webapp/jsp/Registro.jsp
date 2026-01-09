<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Registro - Recetagram</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/general.css" />
</head>
<body>
  <main class="auth-container">
    <div class="auth-card">
      <img src="<%= request.getContextPath() %>/img/logo_texto.png" alt="Recetagram" class="auth-logo" />
      <h1>Crear cuenta</h1>

      <% String error = request.getParameter("error"); %>
      <% if (error != null) { %>
          <div style="background-color: #ffebee; color: #c62828; padding: 10px; border-radius: 5px; margin-bottom: 15px; font-size: 0.9em; border: 1px solid #ef9a9a;">
              <i class="fa-solid fa-circle-exclamation"></i>
              <% if (error.equals("password")) { %> Las contraseñas no coinciden. <% } %>
              <% if (error.equals("db")) { %> El usuario o email ya están registrados. <% } %>
          </div>
      <% } %>

      <%-- Acción dirigida al Servlet usando el ContextPath dinámico --%>
      <form id="formRegistro" action="<%= request.getContextPath() %>/usu/registro" method="POST">
        <label for="nombre">Nombre de usuario</label>
        <input type="text" id="nombre" name="nombre_completo" placeholder="Elige tu @usuario" required>

        <label for="email">Correo electrónico</label>
        <input type="email" id="email" name="email" placeholder="usuario@ejemplo.com" required>

        <label for="password">Contraseña</label>
        <input type="password" id="password" name="password" placeholder="********" required>

        <label for="confirmar">Confirmar contraseña</label>
        <input type="password" id="confirmar" name="confirm_password" placeholder="********" required>

        <button type="submit" id="btnRegistrar">Registrarse</button>
      </form>

      <p class="auth-text">
        ¿Ya tienes cuenta? <a href="<%= request.getContextPath() %>/jsp/logIn.jsp">Inicia sesión aquí</a>
      </p>
    </div>
  </main>

  <script src="<%= request.getContextPath() %>/js/notificaciones.js"></script>
  <script src="<%= request.getContextPath() %>/js/Registro.js"></script>
</body>
</html>