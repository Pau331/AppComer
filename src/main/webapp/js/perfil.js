const $ = s => document.querySelector(s);

const btnEditar = $("#btnEditarPerfil");
if (btnEditar) {
    btnEditar.addEventListener("click", () => { 
        location.href = "../jsp/editarPerfil.jsp"; 
    });
}

const btnAmigos = $("#btnVerAmigos");
if (btnAmigos) {
    btnAmigos.addEventListener("click", () => { 
        location.href = "../jsp/amigos.jsp"; 
    });
}

function dietasHTML(d) {
    return d.map(x => {
        const t = (x || "").toLowerCase();
        if (["sin gluten", "singluten", "sin-gluten"].includes(t))
            return `<div class="detail"><img src="../img/sin-gluten.png" class="diet-icon" alt="Sin gluten"><span>Sin gluten</span></div>`;
        if (t === "vegano")
            return `<div class="detail"><i class="fa-solid fa-leaf"></i><span>Vegano</span></div>`;
        if (t === "vegetariano")
            return `<div class="detail"><i class="fa-solid fa-carrot"></i><span>Vegetariano</span></div>`;
        if (t === "healthy")
            return `<div class="detail"><i class="fa-solid fa-heart-pulse"></i><span>Healthy</span></div>`;
        return "";
    }).join("");
}

const listaRecetas = $("#misRecetas");
if (listaRecetas && listaRecetas.innerHTML.includes("Cargando")) {
    listaRecetas.innerHTML = "<p style='padding:20px;'>Pronto verás aquí tus recetas de la base de datos...</p>";
}

// Navegación
document.querySelectorAll(".recipe-link").forEach(a=>{
  a.addEventListener("click", e=>{
    e.preventDefault();
    location.href = a.getAttribute("href");
  });
});
