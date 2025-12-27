// Ejemplo de notificaciones desde "base de datos"
let notificaciones = [
  {
    id: 1,
    usuario: "chef_luisa",
    foto: "https://i.pravatar.cc/40?img=10",
    texto: "le dio like a tu publicación"
  },
  {
    id: 2,
    usuario: "recetas_ana",
    foto: "https://i.pravatar.cc/40?img=25",
    texto: "te envió una solicitud de amistad"
  },
  {
    id: 3,
    usuario: "healthychef",
    foto: "https://i.pravatar.cc/40?img=30",
    texto: "le comentó a tu receta"
  }
];

const notifWrapper = document.getElementById('notif-wrapper');
const notifDropdown = document.getElementById('notif-dropdown-sidebar');
const notifBadge = document.getElementById('notif-badge');

// Función para pintar notificaciones
function pintarNotificaciones() {
  if(notificaciones.length === 0){
    notifDropdown.innerHTML = '<p>No tienes nuevas notificaciones</p>';
    notifBadge.style.display = 'none';
    return;
  }

  notifDropdown.innerHTML = notificaciones.map(n => `
    <div class="notif-item">
      <img src="${n.foto}" alt="${n.usuario}" class="notif-avatar">
      <p><b>${n.usuario}</b> ${n.texto}</p>
    </div>
  `).join("");

  // Mostrar badge con número de notificaciones
  notifBadge.textContent = notificaciones.length;
  notifBadge.style.display = 'inline-block';
}

// Pintar notificaciones al cargar
pintarNotificaciones();

// Abrir / cerrar dropdown al hacer clic
notifWrapper.addEventListener('click', e => {
  e.stopPropagation();
  if (notifDropdown.style.display === 'block') {
    notifDropdown.style.display = 'none';
  } else {
    notifDropdown.style.display = 'block';
    // Aquí podrías marcar todas como leídas
    // notificaciones = [];
    // pintarNotificaciones();
  }
});

// Cerrar dropdown al hacer clic fuera
document.addEventListener('click', e => {
  if (!notifWrapper.contains(e.target) && !notifDropdown.contains(e.target)) {
    notifDropdown.style.display = 'none';
  }
});

// Array de recetas (simula tu BBDD)
const recetas = [
  {
    id: 1,
    titulo: "Pasta Cremosa con Ajo",
    usuario: "chef_luisa",
    foto_usuario: "https://i.pravatar.cc/40?img=10",
    img_receta: "../img/pasta_ajo.jpg",
    dificultad: "Media",
    tiempo: "30 min",
    dietas: ["Vegetariano"]
  },
  {
    id: 2,
    titulo: "Brownies de Chocolate",
    usuario: "recetas_ana",
    foto_usuario: "https://i.pravatar.cc/40?img=25",
    img_receta: "../img/brownie.jpg",
    dificultad: "Baja",
    tiempo: "20 min",
    dietas: ["Sin gluten"]
  },
  {
    id: 3,
    titulo: "Ensalada de Quinoa y Aguacate",
    usuario: "healthychef",
    foto_usuario: "https://i.pravatar.cc/40?img=30",
    img_receta: "../img/ensalada_quinoa.jpg",
    dificultad: "Baja",
    tiempo: "15 min",
    dietas: ["Healthy"]
  }
];

const feed = document.getElementById('feed');

// Función para pintar las recetas
function pintarRecetas() {
  feed.innerHTML = recetas.map(r => {
    const dietasHTML = r.dietas.map(d => {
      let icon = "";
      let text = d;

      if(d.toLowerCase().includes("gluten")) {
        icon = `<img src="../img/sin-gluten.png" class="diet-icon" alt="Sin gluten">`;
        text = "Sin gluten";
      } else if(d.toLowerCase() === "healthy") {
        icon = `<i class="fa-solid fa-apple-whole"></i>`;
        text = "Healthy";
      } else if(d.toLowerCase() === "vegetariano") {
        icon = `<i class="fa-solid fa-leaf"></i>`;
        text = "Vegetariano";
      }

      return `<div class="detail">${icon} <span>${text}</span></div>`;
    }).join("");

    return `
      <a href="receta.html" class="recipe-link">
        <div class="recipe-card">
          <img src="${r.img_receta}" alt="${r.titulo}" class="recipe-img">

          <div class="recipe-info">
            <h2 class="recipe-title">${r.titulo}</h2>

            <div class="recipe-user">
              <img src="${r.foto_usuario}" alt="${r.usuario}" class="avatar">
              <span class="username">${r.usuario}</span>
            </div>

            <div class="recipe-details">
              <div class="detail">
                <i class="fa-solid fa-star"></i>
                <span>Dificultad: ${r.dificultad}</span>
              </div>
              <div class="detail">
                <i class="fa-solid fa-clock"></i>
                <span>Tiempo: ${r.tiempo}</span>
              </div>
              ${dietasHTML}
            </div>
          </div>
        </div>
      </a>
    `;
  }).join("");
}


// Pintar recetas al cargar la página
pintarRecetas();
