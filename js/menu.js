// ====== Notificaciones ======
const notifWrapper = document.getElementById('notif-wrapper');
const notifDropdown = document.getElementById('notif-dropdown-sidebar');
const notifBadge = document.getElementById('notif-badge');

// Número inicial de notificaciones
let notifCount = 3;

// Mostrar badge solo si hay notificaciones
if (notifCount > 0) {
    notifBadge.textContent = notifCount;
    notifBadge.style.display = 'inline-block';
} else {
    notifBadge.style.display = 'none';
}

// Abrir / cerrar dropdown al hacer clic en todo el contorno
notifWrapper.addEventListener('click', (e) => {
    e.stopPropagation();
    if (notifDropdown.style.display === 'block') {
        notifDropdown.style.display = 'none';
    } else {
        notifDropdown.style.display = 'block';
        // Marcar notificaciones como leídas
        notifCount = 0;
        notifBadge.style.display = 'none';
    }
});

// Cerrar dropdown al hacer clic fuera
document.addEventListener('click', (e) => {
    if (!notifWrapper.contains(e.target) && !notifDropdown.contains(e.target)) {
        notifDropdown.style.display = 'none';
    }
});

// ====== Iconos superiores ======
const topIcons = document.querySelectorAll('.top-right-icons .icon');
topIcons.forEach(icon => {
    icon.addEventListener('click', (e) => {
        e.preventDefault();
        window.location.href = icon.getAttribute('href');
    });
});

// ====== Menú lateral ======
const menuLinks = document.querySelectorAll('.nav-links a');
menuLinks.forEach(link => {
    link.addEventListener('click', (e) => {
        e.preventDefault();
        window.location.href = link.getAttribute('href');
    });
});

// ====== Cerrar Sesión ======
const logoutLink = document.getElementById('index-link');

logoutLink.addEventListener('click', (e) => {
    e.preventDefault();
    // Aquí puedes agregar lógica para cerrar sesión, borrar tokens, etc.
    // Luego redirigir
    window.location.href = logoutLink.getAttribute('href');
});
