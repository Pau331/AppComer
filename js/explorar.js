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
});
tabUsuarios.addEventListener('click', () => {
    tabUsuarios.classList.add('active');
    tabRecetas.classList.remove('active');
    usuarios.classList.remove('hidden');
    recetas.classList.add('hidden');
});


const filtersBtn = document.getElementById('filters-btn');
const filtersDropdown = document.getElementById('filters-dropdown');
const filters = document.querySelectorAll(".filter");

// Mostrar/ocultar dropdown al click en el botón

filtersBtn.addEventListener('click', () => {
  filtersDropdown.style.display = filtersDropdown.style.display === 'flex' ? 'none' : 'flex';
});

// Toggle clase active en cada filtro
filters.forEach(filter => {
  filter.addEventListener("click", () => {
    filter.classList.toggle("active");
    // Aquí podrías llamar a la función de filtrar resultados
    console.log("Filtros activos:", [...document.querySelectorAll(".filter.active")].map(f => f.dataset.filter));
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

    // Filtrar recetas
    recetaCards.forEach(card => {
        const title = card.querySelector('.recipe-title').textContent.toLowerCase();
        const username = card.querySelector('.recipe-user span').textContent.toLowerCase();
        if (title.includes(q) || username.includes(q)) {
            card.parentElement.style.display = 'block'; // Mostrar <a> que envuelve el card
        } else {
            card.parentElement.style.display = 'none';
        }
    });

    // Filtrar usuarios
    usuarioCards.forEach(card => {
        const username = card.querySelector('h4').textContent.toLowerCase();
        const desc = card.querySelector('p').textContent.toLowerCase();
        if (username.includes(q) || desc.includes(q)) {
            card.style.display = 'flex';
        } else {
            card.style.display = 'none';
        }
    });

    // Mostrar la pestaña correspondiente si hay resultados
    const anyRecetas = Array.from(recetaCards).some(card => card.parentElement.style.display !== 'none');
    const anyUsuarios = Array.from(usuarioCards).some(card => card.style.display !== 'none');

    if (anyRecetas) {
        tabRecetas.click();
    } else if (anyUsuarios) {
        tabUsuarios.click();
    }
}

// Buscar al presionar Enter
searchBar.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        e.preventDefault();
        filtrarResultados(searchBar.value);
    }
});
