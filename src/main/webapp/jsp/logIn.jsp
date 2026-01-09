<%-- 
    Document   : logIn
    Created on : 30 dic 2025, 18:14:23
    Author     : Tester
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Iniciar sesión - Recetagram</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/general.css" />
</head>
<body>
    <main class="auth-container">
        <div class="auth-card">
            <img src="<%= request.getContextPath() %>/img/logo_texto.png" alt="Recetagram" class="auth-logo" />

            <h1>Iniciar sesión</h1>

            <%-- Bloque para mostrar errores del Servlet --%>
            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) { 
            %>
                <p style="color: #d9534f; background-color: #f2dede; padding: 10px; border-radius: 5px; text-align: center;">
                    <%= error %>
                </p>
            <% } %>

            <form id="formLogin" action="<%= request.getContextPath() %>/usu/login" method="POST">
                <label for="usuario">Correo o usuario</label>
                <input
                    type="text"
                    id="usuario"
                    name="username" <%-- IMPORTANTE: name para que el Servlet lo reciba --%>
                    placeholder="usuario@ejemplo.com"
                    required
                >

                <label for="password">Contraseña</label>
                <input
                    type="password"
                    id="password"
                    name="password" <%-- IMPORTANTE: name para que el Servlet lo reciba --%>
                    placeholder="********"
                    required
                >

                <button type="submit" id="btnLogin">Entrar</button>

                <p class="auth-text small-text">
                    <a href="#" id="linkOlvide">¿Olvidaste tu contraseña?</a>
                </p>
            </form>

            <form id="formRecuperar" class="oculto">
                <label for="correoRecuperar">Introduce tu correo electrónico</label>
                <input
                    type="email"
                    id="correoRecuperar"
                    placeholder="usuario@ejemplo.com"
                    required
                >
                <button type="submit" id="btnRecuperar">Restablecer contraseña</button>
                <p class="auth-text small-text">
                    <a href="#" id="linkVolver">Volver al inicio de sesión</a>
                </p>
            </form>

            <p class="auth-text">
                ¿No tienes cuenta? <a href="Registro.jsp">Regístrate aquí</a>
            </p>
        </div>
    </main>

    <script src="<%= request.getContextPath() %>/js/notificaciones.js"></script>
    <script src="<%= request.getContextPath() %>/js/login.js"></script>
    
    <%
        // Mostrar notificación de registro exitoso si existe
        String successMsg = request.getParameter("success");
        if (successMsg != null) {
    %>
    <script>
        window.addEventListener('load', function() {
            mostrarNotificacion('<%= successMsg %>', 'success');
        });
    </script>
    <% } %>
    
</body>
</html>