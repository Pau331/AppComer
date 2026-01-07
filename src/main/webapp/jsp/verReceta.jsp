<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.recetagram.model.Receta" %>
<%@ page import="com.mycompany.recetagram.model.Comentario" %>

<%
    Receta receta = (Receta) request.getAttribute("receta");
    List<Comentario> comentarios = (List<Comentario>) request.getAttribute("comentarios");
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= receta.getTitulo() %></title>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>

<!-- ================= RECETA ================= -->
<section class="card receta">
    <h2><%= receta.getTitulo() %></h2>
    <p><strong>Dificultad:</strong> <%= receta.getDificultad() %></p>
    <p><strong>Tiempo:</strong> <%= receta.getTiempoPreparacion() %> min</p>
    <p><strong>Likes:</strong> <%= receta.getLikes() %></p>

    <form action="like" method="post">
        <input type="hidden" name="recetaId" value="<%= receta.getId() %>">
        <button type="submit">❤️ Me gusta</button>
    </form>
</section>

<!-- ================= COMENTARIOS ================= -->
<section class="card" id="comentarios-section">
    <div class="card-body">
        <h3>Comentarios</h3>

        <!-- FORMULARIO NUEVO COMENTARIO -->
        <% if (usuarioId != null) { %>
        <form class="add-comment" action="comentario" method="post">
            <input type="hidden" name="recetaId" value="<%= receta.getId() %>">
            <textarea name="texto" placeholder="Escribe un comentario..." rows="2" required></textarea>
            <button type="submit">Publicar</button>
        </form>
        <% } else { %>
            <p>Inicia sesión para comentar</p>
        <% } %>

        <!-- LISTA DE COMENTARIOS -->
        <div id="listaComentarios" class="comments-list">

        <% if (comentarios != null && !comentarios.isEmpty()) {
               for (Comentario c : comentarios) {
        %>
            <div class="comment">
                <img src="img/default-avatar.png" class="avatar" alt="avatar">

                <div class="content">
                    <div class="username">
                        @usuario<%= c.getUsuarioId() %>
                        <span class="fecha"
                              data-fecha="<%= c.getFecha().getTime() %>"></span>
                    </div>

                    <div class="texto">
                        <%= c.getTexto() %>
                    </div>
                </div>
            </div>
        <% } } else { %>
            <p>No hay comentarios todavía.</p>
        <% } %>

        </div>
    </div>
</section>

<!-- ================= JS ================= -->
<script src="js/registro.js"></script>

</body>
</html>
