// ---------------------- PESTAÑAS ----------------------
const tabRecetas = document.getElementById('tab-recetas');
const tabUsuarios = document.getElementById('tab-usuarios');
const recetas = document.querySelector('.results.recetas');
const usuarios = document.querySelector('.results.usuarios');

tabRecetas.addEventListener('click', () => {
    tabRecetas.classList.add('active');
    tabUsuarios.classList.remove('active');
    recetas.classList.remove('hidden');
    usuarios.classList.add('hidden');

    filtersBtn.style.display = "flex";
});

tabUsuarios.addEventListener('click', () => {
    tabUsuarios.classList.add('active');
    tabRecetas.classList.remove('active');
    usuarios.classList.remove('hidden');
    recetas.classList.add('hidden');

    filtersBtn.style.display = "none";
    filtersDropdown.style.display = "none";
});

// ---------------------- FILTROS ----------------------
const filtersBtn = document.getElementById('filters-btn');
const filtersDropdown = document.getElementById('filters-dropdown');
const filters = document.querySelectorAll(".filter");

filtersBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    filtersDropdown.style.display =
        filtersDropdown.style.display === 'flex' ? 'none' : 'flex';
});

filters.forEach(filter => {
    filter.addEventListener("click", () => {
        filter.classList.toggle("active");
        filtrarResultados(searchBar.value);
    });
});

// Cerrar dropdown al hacer click fuera
document.addEventListener("click", (e) => {
    if (!filtersBtn.contains(e.target) && !filtersDropdown.contains(e.target)) {
        filtersDropdown.style.display = "none";
    }
});

function obtenerFiltrosActivos() {
    return Array.from(filters)
        .filter(f => f.classList.contains("active"))
        .map(f => f.dataset.filter);
}

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

function filtrarResultados(query) {
    const q = query.toLowerCase();
    const filtrosActivos = obtenerFiltrosActivos();

    recetaCards.forEach(card => {
        const title = card.querySelector('.recipe-title').textContent.toLowerCase();
        const username = card.querySelector('.recipe-user span').textContent.toLowerCase();
        const coincideTexto = title.includes(q) || username.includes(q);
        const coincideFiltros = recetaCoincideFiltros(card, filtrosActivos);
        card.parentElement.style.display =
            (coincideTexto && coincideFiltros) ? 'block' : 'none';
    });

    usuarioCards.forEach(card => {
        const username = card.querySelector('h4').textContent.toLowerCase();
        const desc = card.querySelector('p').textContent.toLowerCase();
        card.style.display =
            (username.includes(q) || desc.includes(q)) ? 'flex' : 'none';
    });
}

// ---------------------- BARRA DE BÚSQUEDA ----------------------
const searchBar = document.querySelector('.search-bar');
const recetasContainer = document.querySelector('.results.recetas');
const usuariosContainer = document.querySelector('.results.usuarios');

const recetaCards = recetasContainer.querySelectorAll('.recipe-card');
const usuarioCards = usuariosContainer.querySelectorAll('.user-card');

searchBar.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        e.preventDefault();
        filtrarResultados(searchBar.value);
    }
});

// ---------------------- CLICK EN USUARIOS ----------------------
document.querySelectorAll('.user-card').forEach(card => {
    card.addEventListener('click', e => {
        if (!e.target.closest('.send-message')) {
            const username = card.dataset.username;
            window.location.href =
                `perfil.jsp?user=${encodeURIComponent(username)}`;
        }
    });
});
