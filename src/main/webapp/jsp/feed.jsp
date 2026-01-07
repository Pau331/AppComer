<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.recetagram.model.Receta" %>

<h1>Feed de Recetas</h1>

<%
    List<Receta> recetas = (List<Receta>) request.getAttribute("recetas");
    if (recetas != null) {
        for (Receta r : recetas) {
%>
    <div class="receta-card">
        <h3><%= r.getTitulo() %></h3>
        <p>Dificultad: <%= r.getDificultad() %></p>
        <p>Likes: <%= r.getLikes() %></p>
        <a href="verReceta?id=<%= r.getId() %>">Ver receta</a>
    </div>
<%
        }
    }
%>
