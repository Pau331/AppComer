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

