const $ = s => document.querySelector(s);

// Perfil demo
const me = {
  username: "chef_luisa",
  nombre: "Luisa Fernández",
  avatar: "https://i.pravatar.cc/72?img=10",
  recetas: [
    { id:"mr1", titulo:"Brownies de Chocolate", img:"../img/brownie.jpg",         dificultad:"Baja",  tiempo:"20 min", dietas:["Sin gluten"] },
    { id:"mr2", titulo:"Ensalada de Quinoa",   img:"../img/ensalada_quinoa.jpg",  dificultad:"Baja",  tiempo:"15 min", dietas:["Healthy","Vegetariano"] },
    { id:"mr3", titulo:"Pasta Cremosa con Ajo",img:"../img/pasta_ajo.jpg",        dificultad:"Media", tiempo:"30 min", dietas:["Vegetariano"] }
  ]
};

// Cabecera
$("#avatarYo").src = me.avatar;
$("#usernameYo").textContent = "@"+me.username;
$("#nombreYo").textContent = me.nombre;

// Botones
$("#btnEditarPerfil").addEventListener("click", ()=>{ location.href = "./editar-perfil.html"; });
$("#btnVerAmigos").addEventListener("click", ()=>{ location.href = "./amigos.html"; });

// Helpers de dietas
function dietasHTML(d){
  return d.map(x=>{
    const t=(x||"").toLowerCase();
    if(["sin gluten","singluten","sin-gluten"].includes(t))
      return `<div class="detail"><img src="../img/sin-gluten.png" class="diet-icon" alt="Sin gluten"><span>Sin gluten</span></div>`;
    if(t==="vegano")
      return `<div class="detail"><i class="fa-solid fa-leaf"></i><span>Vegano</span></div>`;
    if(t==="vegetariano")
      return `<div class="detail"><i class="fa-solid fa-carrot"></i><span>Vegetariano</span></div>`;
    if(t==="healthy")
      return `<div class="detail"><i class="fa-solid fa-heart-pulse"></i><span>Healthy</span></div>`;
    return "";
  }).join("");
}

// Render de tarjetas reutilizando el estilo del feed
$("#misRecetas").innerHTML = me.recetas.map(r => `
  <a class="recipe-link" href="./receta.html?id=${r.id}" title="${r.titulo}">
    <div class="recipe-card">
      <img src="${r.img}" alt="${r.titulo}" class="recipe-img">
      <div class="recipe-info">
        <h3 class="recipe-title">${r.titulo}</h3>
        <div class="recipe-details">
          <div class="detail"><i class="fa-solid fa-star"></i><span>Dificultad: ${r.dificultad}</span></div>
          <div class="detail"><i class="fa-solid fa-clock"></i><span>Tiempo: ${r.tiempo}</span></div>
          ${dietasHTML(r.dietas)}
        </div>
      </div>
    </div>
  </a>
`).join("");

// Navegación (opcional)
document.querySelectorAll(".recipe-link").forEach(a=>{
  a.addEventListener("click", e=>{
    e.preventDefault();
    location.href = a.getAttribute("href");
  });
});
