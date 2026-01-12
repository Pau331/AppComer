<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.recetagram.model.Receta" %>
<%@ page import="com.mycompany.recetagram.model.Usuario" %>
<%@ page import="com.mycompany.recetagram.dao.UsuarioDAO" %>
<%@ page import="com.mycompany.recetagram.dao.RecetaCaracteristicaDAO" %>

<%
Usuario yo = (Usuario) session.getAttribute("usuarioLogueado");
List<Receta> recetas = (List<Receta>) request.getAttribute("recetas");
UsuarioDAO udao = new UsuarioDAO();
RecetaCaracteristicaDAO rcdao = new RecetaCaracteristicaDAO();

if (recetas == null) {
%>
    <p>No se pudieron cargar las recetas.</p>
<%
} else if (recetas.isEmpty()) {
%>
    <p>No hay recetas de tus amigos todav�a.</p>
<%
} else {
    for (Receta r : recetas) {

        /* =========================
           USUARIO AUTOR
        ========================== */
        Usuario autor = udao.buscarPorId(r.getUsuarioId());
        String username = "Desconocido";
        String avatar = request.getContextPath() + "/img/default-avatar.png";

        if (autor != null) {
            username = autor.getUsername();

            if (autor.getFotoPerfil() != null && !autor.getFotoPerfil().isEmpty()) {
                String fotoPerfil = autor.getFotoPerfil();
                if (fotoPerfil.startsWith("/")) fotoPerfil = fotoPerfil.substring(1);
                if (!fotoPerfil.startsWith("img/")) fotoPerfil = "img/" + fotoPerfil;
                avatar = request.getContextPath() + "/" + fotoPerfil;
            }
        }

        /* =========================
           FOTO RECETA
        ========================== */
        String recetaFoto = request.getContextPath() + "/img/default-recipe.jpg";

        if (r.getFoto() != null && !r.getFoto().isEmpty()) {
            String foto = r.getFoto();
            if (foto.startsWith("/")) foto = foto.substring(1);
            if (!foto.startsWith("img/")) foto = "img/" + foto;
            recetaFoto = request.getContextPath() + "/" + foto;
        }

        /* =========================
           DIETAS / CARACTER�STICAS
        ========================== */
        List<String> dietas = rcdao.listarCaracteristicasReceta(r.getId());
%>

<div style="position: relative;">
    <a href="<%=request.getContextPath()%>/verReceta?id=<%= r.getId() %>" class="recipe-link">
        <div class="recipe-card">

            <!-- Contenedor de imagen flexible -->
            <div class="recipe-img-container">
                <img src="<%= recetaFoto %>" alt="<%= r.getTitulo() %>">
            </div>

            <div class="recipe-info">

                <h2 class="recipe-title"><%= r.getTitulo() %></h2>

                <div class="recipe-user">
                    <img src="<%= avatar %>" alt="<%= username %>" class="avatar">
                    <span class="username"><%= username %></span>
                </div>

                <div class="recipe-details">

                    <div class="detail">
                        <i class="fa-solid fa-star"></i>
                        <span>Dificultad: <%= r.getDificultad() %></span>
                    </div>

                    <div class="detail">
                        <i class="fa-solid fa-clock"></i>
                        <span>Tiempo: <%= r.getTiempoPreparacion() %> min</span>
                    </div>

                    <% for (String d : dietas) { %>
                        <div class="detail">
                            <% if (d.equalsIgnoreCase("Vegetariano")) { %>
                                <i class="fa-solid fa-leaf"></i>
                            <% } else if (d.equalsIgnoreCase("Vegano")) { %>
                                <i class="fa-solid fa-seedling"></i>
                            <% } else if (d.equalsIgnoreCase("Sin gluten")) { %>
                                <img src="<%= request.getContextPath() %>/img/sin-gluten.png" class="diet-icon">
                            <% } else if (d.equalsIgnoreCase("Healthy")) { %>
                                <i class="fa-solid fa-apple-whole"></i>
                            <% } %>
                            <span><%= d %></span>
                        </div>
                    <% } %>

                </div>
            </div>
        </div>
    </a>
    
    <% if (yo.isAdmin()) { %>
        <form method="post" action="<%=request.getContextPath()%>/admin/eliminarReceta" 
              style="margin-top: 15px;" 
              onsubmit="return confirm('¿Estás seguro de que quieres eliminar esta receta?');">
            <input type="hidden" name="recetaId" value="<%= r.getId() %>">
            <button type="submit" style="
                background: #dc3545;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 16px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 6px;
                transition: background 0.2s;
            " onmouseover="this.style.background='#c82333'" onmouseout="this.style.background='#dc3545'">
                <i class="fa-solid fa-trash"></i>
                Eliminar receta (Admin)
            </button>
        </form>
    <% } %>
</div>

<%
    } // for recetas
} // else
%>
