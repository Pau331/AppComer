<%@ page import="com.mycompany.recetagram.model.Usuario" %>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/html/login.html");
        return;
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Crear receta</title>
<link rel="stylesheet" href="../css/menu.css">
</head>
<body>
    <h2>Crear nueva receta</h2>
    <form action="<%= request.getContextPath() %>/receta" method="post">
        <label>Título:</label>
        <input type="text" name="titulo" required><br><br>

        <label>Pasos:</label>
        <textarea name="pasos" rows="5" required></textarea><br><br>

        <label>Tiempo de preparación (min):</label>
        <input type="number" name="tiempo" required><br><br>

        <label>Dificultad:</label>
        <select name="dificultad" required>
            <option value="Facil">Fácil</option>
            <option value="Media">Media</option>
            <option value="Dificil">Difícil</option>
        </select><br><br>

        <button type="submit">Crear</button>
    </form>
</body>
</html>
