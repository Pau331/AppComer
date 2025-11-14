// Script para pestañas
const tabRecetas = document.getElementById('tab-recetas');
const tabUsuarios = document.getElementById('tab-usuarios');
const recetas = document.querySelector('.results.recetas');
const usuarios = document.querySelector('.results.usuarios');

tabRecetas.addEventListener('click', () => {
    tabRecetas.classList.add('active');
    tabUsuarios.classList.remove('active');
    recetas.classList.remove('hidden');
    usuarios.classList.add('hidden');

    // Mostrar botón de filtros
    filtersBtn.style.display = "flex";
});
tabUsuarios.addEventListener('click', () => {
    tabUsuarios.classList.add('active');
    tabRecetas.classList.remove('active');
    usuarios.classList.remove('hidden');
    recetas.classList.add('hidden');

    // Ocultar botón y dropdown de filtros
    filtersBtn.style.display = "none";
    filtersDropdown.style.display = "none";
});


const filtersBtn = document.getElementById('filters-btn');
const filtersDropdown = document.getElementById('filters-dropdown');
const filters = document.querySelectorAll(".filter");

// Mostrar/ocultar dropdown al click en el botón

filtersBtn.addEventListener('click', () => {
  filtersDropdown.style.display = filtersDropdown.style.display === 'flex' ? 'none' : 'flex';
});

function obtenerFiltrosActivos() {
  const activos = [];
  filters.forEach(f => {
    if (f.classList.contains("active")) {
      activos.push(f.dataset.filter);
    }
  });
  return activos;
}

// --- COMPROBAR SI UNA RECETA COINCIDE CON LOS FILTROS ---
function recetaCoincideFiltros(card, filtros) {
  const desc = card.querySelector(".recipe-desc")?.textContent.toLowerCase() || "";

  return filtros.every(filtro => {
    if (filtro === "sin-gluten") return desc.includes("sin gluten");
    if (filtro === "vegano") return desc.includes("vegano");
    if (filtro === "vegetariano") return desc.includes("vegetariano");
    if (filtro === "healthy") return desc.includes("healthy");
    return true;
  });
}

// --- APLICAR FILTROS A LAS RECETAS ---
function aplicarFiltros() {
  const filtrosActivos = obtenerFiltrosActivos();

  recetaCards.forEach(card => {
    const desc = card.querySelector(".recipe-desc").textContent.toLowerCase();

    const coincide = recetaCoincideFiltros(card, filtrosActivos);

    card.parentElement.style.display = coincide ? "block" : "none";
  });
}

// --- ACTIVAR FILTRO AL HACER CLICK ---
filters.forEach(filter => {
  filter.addEventListener("click", () => {
    filter.classList.toggle("active");
    filtrarResultados(searchBar.value); // FILTRA con texto + filtros
  });
});
// Cerrar dropdown al hacer click fuera
document.addEventListener("click", (e) => {
  if (!filtersBtn.contains(e.target) && !filtersDropdown.contains(e.target)) {
    filtersDropdown.style.display = "none";
  }
});


document.querySelectorAll('.user-card').forEach(card => {
      card.addEventListener('click', e => {
        // Evitar que se active al hacer clic en el botón de enviar mensaje
        if (!e.target.closest('.send-message')) {
          const username = card.dataset.username; // opcional si quieres pasar info
          window.location.href = `perfil.html?user=${encodeURIComponent(username)}`;
        }
      });
});

// Barra de búsqueda
const searchBar = document.querySelector('.search-bar');
const recetasContainer = document.querySelector('.results.recetas');
const usuariosContainer = document.querySelector('.results.usuarios');

// Tomamos todas las tarjetas
const recetaCards = recetasContainer.querySelectorAll('.recipe-card');
const usuarioCards = usuariosContainer.querySelectorAll('.user-card');

// Función de búsqueda
function filtrarResultados(query) {
    const q = query.toLowerCase();
    const filtrosActivos = obtenerFiltrosActivos();

    // --- RECETAS ---
    recetaCards.forEach(card => {
        const title = card.querySelector('.recipe-title').textContent.toLowerCase();
        const username = card.querySelector('.recipe-user span').textContent.toLowerCase();
        const desc = card.querySelector('.recipe-desc').textContent.toLowerCase();

        // Coincidencia por texto
        const coincideTexto = title.includes(q) || username.includes(q);

        // Coincidencia por filtros
        const coincideFiltros = recetaCoincideFiltros(card, filtrosActivos);

        // Solo mostrar si cumple ambas condiciones
        if (coincideTexto && coincideFiltros) {
            card.parentElement.style.display = 'block';
        } else {
            card.parentElement.style.display = 'none';
        }
    });

    // --- USUARIOS (no usan filtros, solo búsqueda) ---
    usuarioCards.forEach(card => {
        const username = card.querySelector('h4').textContent.toLowerCase();
        const desc = card.querySelector('p').textContent.toLowerCase();

        if (username.includes(q) || desc.includes(q)) {
            card.style.display = 'flex';
        } else {
            card.style.display = 'none';
        }
    });

    const anyResults =
        Array.from(recetaCards).some(card => card.parentElement.style.display !== 'none') ||
        Array.from(usuarioCards).some(card => card.style.display !== 'none');

    // Si no se encuentra nada, mostrar mensaje
    if (!anyResults) {
        noResultsMsg.style.display = "block";
    } else {
        noResultsMsg.style.display = "none";
    }
    
}


// Buscar al presionar Enter
searchBar.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        e.preventDefault();
        filtrarResultados(searchBar.value);
    }
});
