const notifWrapper = document.getElementById('notif-wrapper');
const notifDropdown = document.getElementById('notif-dropdown-sidebar');
const notifBadge = document.getElementById('notif-badge');

/* ============================
   MENÚ NOTIFICACIONES (UX)
   ============================ */

// Abrir / cerrar dropdown
notifWrapper?.addEventListener('click', e => {
  e.stopPropagation();
  notifDropdown.style.display =
    notifDropdown.style.display === 'block' ? 'none' : 'block';
});

// Cerrar al hacer click fuera
document.addEventListener('click', e => {
  if (!notifWrapper?.contains(e.target) &&
      !notifDropdown?.contains(e.target)) {
    notifDropdown.style.display = 'none';
  }
});
