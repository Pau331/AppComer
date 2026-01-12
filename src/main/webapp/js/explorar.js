// ---------------------- PESTAÑAS ----------------------
const tabRecetas = document.getElementById('tab-recetas');
const tabUsuarios = document.getElementById('tab-usuarios');
const recetas = document.querySelector('.results.recetas');
const usuarios = document.querySelector('.results.usuarios');

// ---------------------- FILTROS ----------------------
const btnFiltros = document.getElementById('btn-filtros');
const filtrosDropdown = document.getElementById('filtros-dropdown');

tabRecetas.addEventListener('click', () => {
  tabRecetas.classList.add('active');
  tabUsuarios.classList.remove('active');
  recetas.classList.remove('hidden');
  usuarios.classList.add('hidden');

  if (btnFiltros) btnFiltros.style.display = "flex";
});

tabUsuarios.addEventListener('click', () => {
  tabUsuarios.classList.add('active');
  tabRecetas.classList.remove('active');
  usuarios.classList.remove('hidden');
  recetas.classList.add('hidden');

  if (btnFiltros) btnFiltros.style.display = "none";
  if (filtrosDropdown) filtrosDropdown.style.display = "none";
});

// Abrir/cerrar dropdown de filtros
if (btnFiltros && filtrosDropdown) {
  btnFiltros.addEventListener('click', (e) => {
    e.stopPropagation();
    filtrosDropdown.style.display =
      filtrosDropdown.style.display === 'block' ? 'none' : 'block';
  });

  // Botón de cerrar
  const closeFiltros = document.getElementById('close-filtros');
  if (closeFiltros) {
    closeFiltros.addEventListener('click', (e) => {
      e.stopPropagation();
      filtrosDropdown.style.display = 'none';
    });
  }

  // Cerrar al hacer click fuera
  document.addEventListener("click", (e) => {
    if (!btnFiltros.contains(e.target) && !filtrosDropdown.contains(e.target)) {
      filtrosDropdown.style.display = "none";
    }
  });

  // Manejar cambios en los checkboxes de filtros
  const filtroLabels = document.querySelectorAll('.filtro-label');
  
  filtroLabels.forEach(label => {
    const checkbox = label.querySelector('input[type="checkbox"]');
    const icon = label.querySelector('.filtro-icon');
    const img = label.querySelector('.filtro-img');
    const text = label.querySelector('.filtro-text');
    
    // Función para actualizar estilos
    const updateStyles = (isChecked) => {
      if (isChecked) {
        // Activado - fondo rosa, texto e iconos blancos
        label.style.background = '#e13b63';
        label.style.border = '2px solid #e13b63';
        if (text) text.style.color = '#fff';
        if (icon) icon.style.color = '#fff';
        if (img) {
          img.style.filter = 'brightness(0) invert(1)';
          img.style.opacity = '1';
        }
      } else {
        // Desactivado - fondo gris claro, texto e iconos grises
        label.style.background = '#f9f9f9';
        label.style.border = '2px solid transparent';
        if (text) text.style.color = '#262626';
        if (icon) icon.style.color = '#999';
        if (img) {
          img.style.filter = 'none';
          img.style.opacity = '0.5';
        }
      }
    };
    
    if (checkbox) {
      // Actualizar estilos cuando cambia el checkbox
      checkbox.addEventListener('change', () => {
        updateStyles(checkbox.checked);
      });
      
      // También manejar el click en el label completo
      label.addEventListener('click', (e) => {
        // Pequeño delay para que el checkbox se actualice primero
        setTimeout(() => {
          updateStyles(checkbox.checked);
        }, 10);
      });
      
      // Hover effects
      label.addEventListener('mouseenter', () => {
        if (!checkbox.checked) {
          label.style.background = '#f5f5f5';
        }
      });
      
      label.addEventListener('mouseleave', () => {
        if (!checkbox.checked) {
          label.style.background = '#f9f9f9';
        }
      });
    }
  });
}

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
  const q = (query || "").toLowerCase();
  const filtrosActivos = obtenerFiltrosActivos();

  const recetasContainer = document.querySelector('.results.recetas');
  const usuariosContainer = document.querySelector('.results.usuarios');
  if (!recetasContainer || !usuariosContainer) return;

  const recetaCards = recetasContainer.querySelectorAll('.recipe-card');
  const usuarioCards = usuariosContainer.querySelectorAll('.user-card');

  recetaCards.forEach(card => {
    const title = card.querySelector('.recipe-title')?.textContent.toLowerCase() || "";
    const username = card.querySelector('.recipe-user span')?.textContent.toLowerCase() || "";
    const coincideTexto = title.includes(q) || username.includes(q);
    const coincideFiltros = recetaCoincideFiltros(card, filtrosActivos);

    const link = card.closest('.recipe-link');
    if (link) link.style.display = (coincideTexto && coincideFiltros) ? 'block' : 'none';
  });

  usuarioCards.forEach(card => {
    const username = card.querySelector('h4')?.textContent.toLowerCase() || "";
    const desc = card.querySelector('p')?.textContent.toLowerCase() || "";
    card.style.display = (username.includes(q) || desc.includes(q)) ? 'flex' : 'none';
  });
}

// ---------------------- BARRA DE BÚSQUEDA ----------------------
const searchBar = document.querySelector('.search-bar');

if (searchBar) {
  searchBar.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      filtrarResultados(searchBar.value);
    }
  });
}

// ---------------------- CLICK EN USUARIOS ----------------------
document.querySelectorAll('.user-card').forEach(card => {
  card.addEventListener('click', e => {
    if (!e.target.closest('.send-message')) {
      const id = card.dataset.userId;
      if (!id) return;
      window.location.href = `${contextPath}/social/usuario?id=${encodeURIComponent(id)}`;
    }
  });
});

// ---------------------- CLICK EN MENSAJE ----------------------
document.querySelectorAll('.send-message').forEach(btn => {
  btn.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();
    const card = e.target.closest('.user-card');
    const id = card?.dataset.userId;
    if (!id) return;
    window.location.href = `${contextPath}/jsp/chat.jsp?to=${encodeURIComponent(id)}`;
  });
});
